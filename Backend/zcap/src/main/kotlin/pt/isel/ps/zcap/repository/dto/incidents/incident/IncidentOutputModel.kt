package pt.isel.ps.zcap.repository.dto.incidents.incident

import pt.isel.ps.zcap.domain.incidents.Incident
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.IncidentTypeOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.toOutputModel
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeOutputModel
import pt.isel.ps.zcap.services.tree.toOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class IncidentOutputModel(
    val incidentId: Long,
    val incidentType: IncidentTypeOutputModel,
    val treeRecord: TreeOutputModel,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)

fun Incident.toOutputModel(): IncidentOutputModel =
    IncidentOutputModel(
        incidentId,
        incidentType.toOutputModel(),
        treeRecord.toOutputModel(),
        startDate,
        endDate,
        createdAt,
        lastUpdatedAt
    )