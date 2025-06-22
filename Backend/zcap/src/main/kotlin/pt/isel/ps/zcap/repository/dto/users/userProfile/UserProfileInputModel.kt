package pt.isel.ps.zcap.repository.dto.users.userProfile

import java.time.LocalDate

class UserProfileInputModel(
    val name: String,
    val accessAllowances: List<UserProfileAccessAllowanceInputModel>,
    val startDate: LocalDate,
    val endDate: LocalDate?,
)