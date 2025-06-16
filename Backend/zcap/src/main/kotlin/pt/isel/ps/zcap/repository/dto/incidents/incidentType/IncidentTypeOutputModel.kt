package pt.isel.ps.zcap.repository.dto.incidents.incidentType

import pt.isel.ps.zcap.domain.incidents.IncidentType
import java.time.LocalDate
import java.time.LocalDateTime

data class IncidentTypeOutputModel(
    val incidentTypeId: Long,
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)

fun IncidentType.toOutputModel() : IncidentTypeOutputModel =
    IncidentTypeOutputModel(
        incidentTypeId,
        name,
        startDate,
        endDate,
        createdAt,
        lastUpdatedAt
    )