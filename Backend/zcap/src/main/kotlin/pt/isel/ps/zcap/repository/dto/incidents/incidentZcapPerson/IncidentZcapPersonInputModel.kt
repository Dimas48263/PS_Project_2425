package pt.isel.ps.zcap.repository.dto.incidents.incidentZcapPerson

import java.time.LocalDate

data class IncidentZcapPersonInputModel(
    val incidentZcapId: Long,
    val personId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate?
)