package pt.isel.ps.zcap.repository.dto.incidents.incident

import java.time.LocalDate
import java.time.LocalDateTime

data class IncidentInputModel(
    val incidentTypeId: Long,
    val treeRecordId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)