package pt.isel.ps.zcap.repository.dto.persons.supportNeeded

import java.time.LocalDate
import java.time.LocalDateTime

class SupportNeededOutputModel(
    val supportNeededId: Long,
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val lastUpdatedAt: LocalDateTime,
    val createdAt: LocalDateTime
)