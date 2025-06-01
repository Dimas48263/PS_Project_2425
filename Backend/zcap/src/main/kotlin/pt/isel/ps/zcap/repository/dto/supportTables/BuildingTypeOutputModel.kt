package pt.isel.ps.zcap.repository.dto.supportTables

import pt.isel.ps.zcap.domain.supportTables.BuildingType
import java.time.LocalDate
import java.time.LocalDateTime

class BuildingTypeOutputModel(
    val buildingTypeId: Long,
    val name: String,

    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime,
)

fun BuildingType.toOutputModel(): BuildingTypeOutputModel {
    return BuildingTypeOutputModel(
        buildingTypeId = buildingTypeId,
        name = name,
        startDate = startDate,
        endDate = endDate,
        createdAt = createdAt,
        updatedAt = updatedAt,
    )
}