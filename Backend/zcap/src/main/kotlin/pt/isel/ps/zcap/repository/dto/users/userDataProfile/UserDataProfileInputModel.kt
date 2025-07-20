package pt.isel.ps.zcap.repository.dto.users.userDataProfile

import java.time.LocalDate
import java.time.LocalDateTime

class UserDataProfileInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)