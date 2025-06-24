package pt.isel.ps.zcap.services.users.userProfile

import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.users.userProfile.AccessType
import pt.isel.ps.zcap.domain.users.userProfile.UserProfile
import pt.isel.ps.zcap.domain.users.userProfile.UserProfileAccessAllowance
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileAccessAllowanceOutputModel
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileInputModel
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileOutputModel
import pt.isel.ps.zcap.repository.models.users.userProfile.UserProfileAccessAllowanceRepository
import pt.isel.ps.zcap.repository.models.users.userProfile.UserProfileAccessKeysRepository
import pt.isel.ps.zcap.repository.models.users.userProfile.UserProfileRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Service
class UserProfileService(
    private val userProfileRepository: UserProfileRepository,
    private val userProfileAccessAllowanceRepository: UserProfileAccessAllowanceRepository,
    private val userProfileAccessKeysRepository: UserProfileAccessKeysRepository,
) {

    fun getAllUserProfiles(): List<UserProfileOutputModel> {
        val userProfiles = userProfileRepository.findAll()
        return userProfiles.map {
            val userProfileAllowances = userProfileAccessAllowanceRepository.findByUserProfile(it)
            toOutputModel(it, userProfileAllowances)
        }
    }

    fun getUserProfilesValidOn(date: LocalDate): List<UserProfileOutputModel> {
        val validProfiles = userProfileRepository.findValidOnDate(date)
        return validProfiles.map {
            val userProfileAllowances = userProfileAccessAllowanceRepository.findByUserProfile(it)
            toOutputModel(it, userProfileAllowances)
        }
    }

    fun getUserProfileById(userProfileId: Long): Either<ServiceErrors, UserProfileOutputModel> {
        val profile = userProfileRepository.findById(userProfileId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        val userProfileAllowances = userProfileAccessAllowanceRepository.findByUserProfile(profile)
        return success(toOutputModel(profile, userProfileAllowances))
    }

    fun addUserProfile(newProfile: UserProfileInputModel): Either<ServiceErrors, UserProfileOutputModel> {
        if (newProfile.name.isBlank()
            || newProfile.startDate.isAfter(newProfile.endDate ?: newProfile.startDate)
        )
            return failure(ServiceErrors.InvalidDataInput)

        val tempProfile = UserProfile(
            name = newProfile.name,
            startDate = newProfile.startDate,
            endDate = newProfile.endDate,
        )


        return try {
            val profile = userProfileRepository.save(tempProfile)
            val accessAllowances = newProfile.accessAllowances.mapNotNull {
                if (it.accessType !in 0 until AccessType.entries.size) return@mapNotNull null
                val accessKey = userProfileAccessKeysRepository.findById(it.userProfileAccessKeyId).getOrNull()
                    ?: return@mapNotNull null

                UserProfileAccessAllowance(
                    userProfile = profile,
                    userProfileAccessKey = accessKey,
                    accessType = it.accessType
                )
            }

            userProfileAccessAllowanceRepository.saveAll(accessAllowances)

            success(toOutputModel(profile, accessAllowances))
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun updateUserProfile(
        userProfileId: Long,
        updatedProfile: UserProfileInputModel
    ): Either<ServiceErrors, UserProfileOutputModel> {

        if (updatedProfile.name.isBlank()
            || updatedProfile.startDate.isAfter(updatedProfile.endDate ?: updatedProfile.startDate)
        )
            return failure(ServiceErrors.InvalidDataInput)

        val oldProfile =
            userProfileRepository.findById(userProfileId).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)

        val newProfile = oldProfile.copy(
            name = updatedProfile.name,
            startDate = updatedProfile.startDate,
            endDate = updatedProfile.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )

        return try {
            val savedProfile = userProfileRepository.save(newProfile)

            val existingAllowances = userProfileAccessAllowanceRepository.findByUserProfile(savedProfile)

            for (existing in existingAllowances) {
                val updated = updatedProfile.accessAllowances
                    .find { it.userProfileAccessKeyId == existing.userProfileAccessKey.userProfileAccessKeyId }

                if (updated != null) {
                    existing.accessType = updated.accessType
                    existing.lastUpdatedAt = LocalDateTime.now()
                }
            }

            userProfileAccessAllowanceRepository.saveAll(existingAllowances)

            success(toOutputModel(savedProfile, existingAllowances))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun internalGetUserProfileById(userProfileId: Long): UserProfile? =
        userProfileRepository.findById(userProfileId).getOrNull()

    // Conversion from InputModel to domain Model
    private fun toUserProfile(inputData: UserProfileInputModel): UserProfile = UserProfile(
        name = inputData.name,
        startDate = inputData.startDate,
        endDate = inputData.endDate,
        lastUpdatedAt = LocalDateTime.now()
    )

    // Conversion from domain Model to OutputModel
    fun toOutputModel(profile: UserProfile, allowances: List<UserProfileAccessAllowance>): UserProfileOutputModel {
        return UserProfileOutputModel(
            userProfileId = profile.userProfileId,
            name = profile.name,
            accessAllowances = allowances.map {
                UserProfileAccessAllowanceOutputModel(
                    userProfileAccessKeyId = it.userProfileAccessKey.userProfileAccessKeyId,
                    key = it.userProfileAccessKey.accessKey,
                    description = it.userProfileAccessKey.description,
                    accessType = it.accessType,
                    createdAt = it.userProfileAccessKey.createdAt,
                    lastUpdatedAt = it.userProfileAccessKey.lastUpdatedAt,
                )
            },
            startDate = profile.startDate,
            endDate = profile.endDate,
            createdAt = profile.createdAt,
            lastUpdatedAt = profile.lastUpdatedAt,
        )
    }
}