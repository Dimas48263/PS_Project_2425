package pt.isel.ps.zcap.repository.dto.supportTables.buildingTypes

import java.time.LocalDate

data class BuildingTypeInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
)