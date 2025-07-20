package pt.isel.ps.zcap.repository.dto.persons.personSupportNeeded

import java.time.LocalDate
import java.time.LocalDateTime

data class PersonSupportNeededInputModel(
    val personId: Long,
    val supportNeededId: Long,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)