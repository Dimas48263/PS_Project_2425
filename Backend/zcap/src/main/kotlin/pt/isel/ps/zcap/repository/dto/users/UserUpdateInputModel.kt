package pt.isel.ps.zcap.repository.dto.users

import java.time.LocalDate

data class UserUpdateInputModel(
    val userName: String,
    val name: String,
    val userProfileId: Long,
    val userDataProfileId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate? = null
)