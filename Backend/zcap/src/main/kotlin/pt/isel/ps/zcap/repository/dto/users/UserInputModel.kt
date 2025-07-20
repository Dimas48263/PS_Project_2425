package pt.isel.ps.zcap.repository.dto.users

import java.time.LocalDate
import java.time.LocalDateTime

data class UserInputModel(
    val userName: String,
    val name: String,
    val password: String,
    val userProfileId: Long,
    val userDataProfileId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)