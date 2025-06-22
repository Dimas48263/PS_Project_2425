package pt.isel.ps.zcap.repository.dto.users.userProfile

import java.time.LocalDate
import java.time.LocalDateTime

class UserProfileOutputModel(
    val userProfileId: Long,
    val name: String,
    val accessAllowances: List<UserProfileAccessAllowanceOutputModel>, //list of all detail records per profileId
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)