package pt.isel.ps.zcap.repository.dto.incidents.incidentType

import java.time.LocalDate
import java.time.LocalDateTime

data class IncidentTypeInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)