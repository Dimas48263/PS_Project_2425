package pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories

import java.time.LocalDate

data class DetailTypeCategoryInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)