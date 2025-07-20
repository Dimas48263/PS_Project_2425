package pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories

import java.time.LocalDate
import java.time.LocalDateTime

data class DetailTypeCategoryInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)