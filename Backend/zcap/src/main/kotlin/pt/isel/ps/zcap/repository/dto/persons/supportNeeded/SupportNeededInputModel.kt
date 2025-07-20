package pt.isel.ps.zcap.repository.dto.persons.supportNeeded

import java.time.LocalDate
import java.time.LocalDateTime

data class SupportNeededInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)