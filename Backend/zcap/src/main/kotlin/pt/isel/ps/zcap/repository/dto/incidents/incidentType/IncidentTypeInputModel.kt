package pt.isel.ps.zcap.repository.dto.incidents.incidentType

import java.time.LocalDate

data class IncidentTypeInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)