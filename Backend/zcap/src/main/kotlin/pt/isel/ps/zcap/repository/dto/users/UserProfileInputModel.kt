package pt.isel.ps.zcap.repository.dto.users

import java.time.LocalDate

class UserProfileInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
)