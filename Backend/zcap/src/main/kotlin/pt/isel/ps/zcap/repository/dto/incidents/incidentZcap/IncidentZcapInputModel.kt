package pt.isel.ps.zcap.repository.dto.incidents.incidentZcap

import java.time.LocalDate

data class IncidentZcapInputModel(
    val incidentId: Long,
    val zcapId: Long,
    val entityId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate?
)