package pt.isel.ps.zcap.repository.dto.users

import java.time.LocalDate
import java.time.LocalDateTime

data class UserOutputModel(
    val userId: Long,
    val userName: String,
    val name: String,
    val userProfile: UserProfileOutputModel,
    val userDataProfile: UserDataProfileOutputModel,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)