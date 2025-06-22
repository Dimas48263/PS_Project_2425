package pt.isel.ps.zcap.services.users.userProfile

import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.users.userProfile.UserProfileAccessKeys
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileAccessKeyInputModel
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileAccessKeyOutputModel
import pt.isel.ps.zcap.repository.models.users.userProfile.UserProfileAccessKeysRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Service
class UserProfileAccessKeysService(
    private val userProfileAccessKeysRepository: UserProfileAccessKeysRepository
) {

    fun getAllAccessKeys(): List<UserProfileAccessKeyOutputModel> {
        val keys = userProfileAccessKeysRepository.findAll()
        return keys.map { toOutputModel(it) }
    }

    fun getAccessKeyById(accessKeyId: Long): Either<ServiceErrors, UserProfileAccessKeyOutputModel> {
        val accessKey = userProfileAccessKeysRepository.findById(accessKeyId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        return success(toOutputModel(accessKey))
    }

    fun addAccessKey(newKey: UserProfileAccessKeyInputModel): Either<ServiceErrors, UserProfileAccessKeyOutputModel> {
        if (newKey.accessKey.isBlank() || newKey.description.isBlank()) {
            return failure(ServiceErrors.InvalidDataInput)
        }

        return try {
            val accessKey = userProfileAccessKeysRepository.save(
                UserProfileAccessKeys(
                    accessKey = newKey.accessKey,
                    description = newKey.description
                )
            )
            success(toOutputModel(accessKey))
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun updateAccessKey(
        userProfileAccessKeyId: Long,
        updatedKey: UserProfileAccessKeyInputModel
    ): Either<ServiceErrors, UserProfileAccessKeyOutputModel> {
        val oldKey = userProfileAccessKeysRepository.findById(userProfileAccessKeyId).orElse(null)
            ?: return failure(ServiceErrors.RecordNotFound)

        return try {
            val accessKey = userProfileAccessKeysRepository.save(
                oldKey.copy(
                    accessKey = updatedKey.accessKey,
                    description = updatedKey.description,
                    lastUpdatedAt = LocalDateTime.now(),
                )
            )
            success(toOutputModel(accessKey))

        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    private fun toOutputModel(accessKey: UserProfileAccessKeys) = UserProfileAccessKeyOutputModel(
        userProfileAccessKeyId = accessKey.userProfileAccessKeyId,
        accessKey = accessKey.accessKey,
        description = accessKey.description,
        createdAt = accessKey.createdAt,
        lastUpdatedAt = accessKey.lastUpdatedAt,
    )
}