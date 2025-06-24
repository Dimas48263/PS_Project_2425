package pt.isel.ps.zcap.repository.dto.incidents.incidentZcap

import pt.isel.ps.zcap.domain.incidents.IncidentZcap
import pt.isel.ps.zcap.repository.dto.incidents.incident.IncidentOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incident.toOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.entities.EntitiesOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcap.ZcapOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.buildingTypes.toOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.entities.toOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcap.toOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class  IncidentZcapOutputModel(
    val incidentZcapId: Long,
    val incident: IncidentOutputModel,
    val zcap: ZcapOutputModel,
    val entity: EntitiesOutputModel,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)

fun IncidentZcap.toOutputModel(): IncidentZcapOutputModel =
    IncidentZcapOutputModel(
        incidentZcapId,
        incident.toOutputModel(),
        zcap.toOutputModel(),
        entity.toOutputModel(),
        startDate,
        endDate,
        createdAt,
        lastUpdatedAt
    )