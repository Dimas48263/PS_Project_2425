package pt.isel.ps.zcap.repository.dto.incidents.incident

import java.time.LocalDate

data class IncidentInputModel(
    val incidentTypeId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate?
)