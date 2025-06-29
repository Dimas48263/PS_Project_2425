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
            toOutputModel(it)
        }
    }

    fun getUserProfilesValidOn(date: LocalDate): List<UserProfileOutputModel> {
        val validProfiles = userProfileRepository.findValidOnDate(date)
        return validProfiles.map {
            toOutputModel(it)
        }
    }

    fun getUserProfileById(userProfileId: Long): Either<ServiceErrors, UserProfileOutputModel> {
        val profile =
            userProfileRepository.findById(userProfileId).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)

        val userProfileAllowances = userProfileAccessAllowanceRepository.findByUserProfile(profile)
        return success(toOutputModel(profile))
    }

    fun addUserProfile(newProfile: UserProfileInputModel): Either<ServiceErrors, UserProfileOutputModel> {
        if (newProfile.name.isBlank() || newProfile.startDate.isAfter(
                newProfile.endDate ?: newProfile.startDate
            )
        ) return failure(ServiceErrors.InvalidDataInput)

        return try {
            val savedProfile = userProfileRepository.save(
                UserProfile(
                    name = newProfile.name,
                    startDate = newProfile.startDate,
                    endDate = newProfile.endDate
                )
            )

            val allAccessKeys = userProfileAccessKeysRepository.findAll()

            val accessAllowances = allAccessKeys.map { accessKey ->
                UserProfileAccessAllowance(
                    userProfile = savedProfile,
                    userProfileAccessKey = accessKey,
                    accessType = AccessType.READ_WRITE.value
                )
            }

            userProfileAccessAllowanceRepository.saveAll(accessAllowances)

            success(toOutputModel(savedProfile))

        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun updateUserProfile(
        userProfileId: Long, updatedProfile: UserProfileInputModel
    ): Either<ServiceErrors, UserProfileOutputModel> {

        if (updatedProfile.name.isBlank() || updatedProfile.startDate.isAfter(
                updatedProfile.endDate ?: updatedProfile.startDate
            )
        ) return failure(ServiceErrors.InvalidDataInput)

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

            val allAccessKeys = userProfileAccessKeysRepository.findAll()

            val existingAllowances = userProfileAccessAllowanceRepository.findByUserProfile(savedProfile)
                .associateBy { it.userProfileAccessKey.userProfileAccessKeyId }

            val existingAllowancesById = existingAllowances.values.associateBy { it.userProfileAccessAllowanceId }

            val toSave = allAccessKeys.map { accessKey ->
                val existing = existingAllowances.values.find {
                    it.userProfileAccessKey.userProfileAccessKeyId == accessKey.userProfileAccessKeyId
                }

                val input = updatedProfile.accessAllowances.find {
                    it.userProfileAccessKeyId == existing?.userProfileAccessAllowanceId
                }

                when {
                    existing != null -> {
                        existing.accessType = input?.accessType ?: existing.accessType
                        existing.lastUpdatedAt = LocalDateTime.now()
                        existing
                    }

                    else -> {
                        UserProfileAccessAllowance(
                            userProfile = savedProfile,
                            userProfileAccessKey = accessKey,
                            accessType = 0 // ou outro valor default
                        )
                    }
                }
            }

            userProfileAccessAllowanceRepository.saveAll(toSave)
            success(toOutputModel(savedProfile))

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
    fun toOutputModel(profile: UserProfile): UserProfileOutputModel {
        return UserProfileOutputModel(
            userProfileId = profile.userProfileId,
            name = profile.name,
            startDate = profile.startDate,
            endDate = profile.endDate,
            createdAt = profile.createdAt,
            lastUpdatedAt = profile.lastUpdatedAt,
        )
    }
}