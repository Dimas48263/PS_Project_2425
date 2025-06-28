package pt.isel.ps.zcap.repository.dto.users.userProfile

import pt.isel.ps.zcap.domain.users.userProfile.UserProfile
import java.time.LocalDateTime

data class UserProfileAccessAllowanceOutputModel(
    val userProfileAccessKeyId: Long,
    val userProfile: UserProfile,
    val key: String,
    val description: String,
    val accessType: Int,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)