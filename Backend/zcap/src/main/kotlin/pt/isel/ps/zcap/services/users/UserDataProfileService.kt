package pt.isel.ps.zcap.services.users

import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.users.UserDataProfile
import pt.isel.ps.zcap.repository.dto.users.*
import pt.isel.ps.zcap.repository.models.users.UserDataProfileRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Service
class UserDataProfileService(private val userDataProfileRepository: UserDataProfileRepository) {

    fun getAllUserDataProfiles(): List<UserDataProfileOutputModel> {
        val userDataProfiles = userDataProfileRepository.findAll()
        return userDataProfiles.map { toOutputModel(it) }
    }

    fun getUserDataProfilesValidOn(date: LocalDate): List<UserDataProfileOutputModel> {
        val validDataProfiles = userDataProfileRepository.findValidOnDate(date)
        return validDataProfiles.map { toOutputModel(it) }
    }

    fun getUserDataProfileById(userDataProfileId: Long): Either<ServiceErrors, UserDataProfileOutputModel> {
        val dataProfile = userDataProfileRepository.findById(userDataProfileId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        return success(toOutputModel(dataProfile))
    }

    fun addUserDataProfile(newDataProfile: UserDataProfileInputModel): Either<ServiceErrors, UserDataProfileOutputModel> {
        if (newDataProfile.name.isBlank()
            || newDataProfile.startDate.isAfter(newDataProfile.endDate ?: newDataProfile.startDate)
        )
            return failure(ServiceErrors.InvalidDataInput)

        val dataProfile = toUserDataProfile(newDataProfile)
        return try {
            success(toOutputModel(userDataProfileRepository.save(dataProfile)))
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun updateUserDataProfile(
        userDataProfileId: Long,
        updatedDataProfile: UserDataProfileInputModel
    ): Either<ServiceErrors, UserDataProfileOutputModel> {

        val oldDataProfile =
            userDataProfileRepository.findById(userDataProfileId).getOrNull()
                ?: return failure(ServiceErrors.RecordNotFound)

        if (updatedDataProfile.name.isBlank()
            || updatedDataProfile.startDate.isAfter(updatedDataProfile.endDate ?: updatedDataProfile.startDate)
        )
            return failure(ServiceErrors.InvalidDataInput)

        val newDataProfile = oldDataProfile.copy(
            name = updatedDataProfile.name,
            startDate = updatedDataProfile.startDate,
            endDate = updatedDataProfile.endDate,
            updatedAt = LocalDateTime.now()
        )

        return try {
            success(toOutputModel(userDataProfileRepository.save(newDataProfile)))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun internalGetUserDataProfileById(userDataProfileId: Long): UserDataProfile? = userDataProfileRepository.findById(userDataProfileId).getOrNull()

    // Conversion from InputModel to domain Model
    private fun toUserDataProfile(inputData: UserDataProfileInputModel): UserDataProfile = UserDataProfile(
        name = inputData.name,
        startDate = inputData.startDate,
        endDate = inputData.endDate,
        updatedAt = LocalDateTime.now()
    )

    // Conversion from domain Model to OutputModel
    fun toOutputModel(profile: UserDataProfile): UserDataProfileOutputModel {

        val details = profile.details.map {
            UserDataProfileDetailOutputModel(
                userDataProfileId = it.userDataProfile.userDataProfileId,
                treeRecordId = it.treeRecord.treeRecordId,
                treeLevelName = it.treeRecord.treeLevel.name,
                treeName = it.treeRecord.name,
            )
        }
        return UserDataProfileOutputModel(
            userDataProfileId = profile.userDataProfileId,
            name = profile.name,
            userDataProfileDetail = details,
            startDate = profile.startDate,
            endDate = profile.endDate,
            createdAt = profile.createdAt,
            updatedAt = profile.updatedAt,
        )
    }
}