package pt.isel.ps.zcap.services.users.userProfile

import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.users.userProfile.UserProfileAccessAllowance
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileAccessAllowanceOutputModel
import pt.isel.ps.zcap.repository.models.users.userProfile.UserProfileAccessAllowanceRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import kotlin.jvm.optionals.getOrNull

@Service
class UserProfileAccessAllowanceService(
    private val userProfileAccessAllowanceRepository: UserProfileAccessAllowanceRepository,
) {

    fun getAllAllowances(): List<UserProfileAccessAllowanceOutputModel> {
        val userProfileAllowances = userProfileAccessAllowanceRepository.findAll()
        return userProfileAllowances.map {
            toOutputModel(it)
        }
    }

    fun getAllAllowancesById(userAccessAllowanceId: Long): Either<ServiceErrors, UserProfileAccessAllowanceOutputModel> {
        val allowances = userProfileAccessAllowanceRepository.findById(userAccessAllowanceId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        return success(toOutputModel(allowances))
    }

    private fun toOutputModel(allowance: UserProfileAccessAllowance): UserProfileAccessAllowanceOutputModel {
        return UserProfileAccessAllowanceOutputModel(
            userProfileAccessKeyId = allowance.userProfileAccessAllowanceId,
            userProfile = allowance.userProfile,
            key = allowance.userProfileAccessKey.accessKey,
            description = allowance.userProfileAccessKey.description,
            accessType = allowance.accessType,
            createdAt = allowance.createdAt,
            lastUpdatedAt = allowance.lastUpdatedAt,
        )
    }
}