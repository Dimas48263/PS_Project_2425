package pt.isel.ps.zcap.repository.dto.supportTables.buildingTypes

import java.time.LocalDate
import java.time.LocalDateTime

data class BuildingTypeInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)