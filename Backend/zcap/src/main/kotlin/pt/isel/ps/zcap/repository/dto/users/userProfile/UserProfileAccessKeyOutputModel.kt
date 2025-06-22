package pt.isel.ps.zcap.repository.dto.users.userProfile

import java.time.LocalDateTime

data class UserProfileAccessKeyOutputModel(
    val userProfileAccessKeyId: Long,
    val accessKey: String,
    val description: String,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
    )