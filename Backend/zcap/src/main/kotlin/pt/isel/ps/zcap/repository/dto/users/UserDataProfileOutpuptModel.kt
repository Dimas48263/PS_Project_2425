package pt.isel.ps.zcap.repository.dto.users

import java.time.LocalDate
import java.time.LocalDateTime

class UserDataProfileOutputModel(
    val userDataProfileId: Long,
    val name: String,
    val userDataProfileDetail: List<UserDataProfileDetailOutputModel>,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)