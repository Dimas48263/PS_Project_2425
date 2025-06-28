package pt.isel.ps.zcap.repository.dto.users.userProfile

import java.time.LocalDate
import java.time.LocalDateTime

class UserProfileOutputModel(
    val userProfileId: Long,
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)