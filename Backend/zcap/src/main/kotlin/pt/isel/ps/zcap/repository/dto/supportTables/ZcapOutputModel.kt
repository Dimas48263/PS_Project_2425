package pt.isel.ps.zcap.repository.dto.supportTables

import pt.isel.ps.zcap.domain.supportTables.Zcap
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeOutputModel
import pt.isel.ps.zcap.services.tree.toOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class ZcapOutputModel(
    val zcapId: Long,
    val name: String,
    val buildingType: BuildingTypeOutputModel,
    val address: String,
    val treeRecordId: TreeOutputModel?,
    val latitude: Float?,
    val longitude: Float?,
    val entityId: EntitiesOutputModel,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)

fun Zcap.toOutputModel(): ZcapOutputModel =
    ZcapOutputModel(
        zcapId,
        name,
        buildingType.toOutputModel(),
        address,
        tree?.toOutputModel(),
        latitude,
        longitude,
        entity.toOutputModel(),
        startDate,
        endDate,
        createdAt,
        lastUpdatedAt
    )