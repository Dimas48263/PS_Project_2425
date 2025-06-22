package pt.isel.ps.zcap.repository.dto.users.userProfile

import java.time.LocalDateTime

data class UserProfileAccessAllowanceOutputModel(
    val userProfileAccessKeyId: Long,
    val key: String,
    val description: String,
    val accessType: Int,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)