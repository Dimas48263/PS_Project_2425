package pt.isel.ps.zcap.repository.dto.users

import java.sql.Timestamp
import java.time.LocalDate

class UserProfileDetailInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val timestamp: Timestamp
)