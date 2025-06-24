package pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories

import pt.isel.ps.zcap.domain.supportTables.DetailTypeCategory
import java.time.LocalDate
import java.time.LocalDateTime

class DetailTypeCategoryOutputModel(
    val detailTypeCategoryId: Long,
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)

fun DetailTypeCategory.toOutputModel(): DetailTypeCategoryOutputModel =
    DetailTypeCategoryOutputModel(
        detailTypeCategoryId,
        name,
        startDate,
        endDate,
        createdAt,
        lastUpdatedAt
    )