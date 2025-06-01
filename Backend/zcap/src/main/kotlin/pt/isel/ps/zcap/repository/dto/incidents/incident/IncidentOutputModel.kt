package pt.isel.ps.zcap.repository.dto.incidents.incident

import pt.isel.ps.zcap.domain.incidents.Incident
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.IncidentTypeOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.toOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class IncidentOutputModel(
    val incidentId: Long,
    val incidentType: IncidentTypeOutputModel,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createAt: LocalDateTime,
    val updatedAt: LocalDateTime,
)

fun Incident.toOutputModel(): IncidentOutputModel =
    IncidentOutputModel(
        incidentId,
        incidentType.toOutputModel(),
        startDate,
        endDate,
        createdAt,
        updatedAt
    )