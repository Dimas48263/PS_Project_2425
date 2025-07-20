package pt.isel.ps.zcap.repository.dto.users.userProfile

import java.time.LocalDateTime

data class UserProfileAccessAllowanceInputModel(
    val userProfileAccessKeyId: Long,
    val accessType: Int,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)