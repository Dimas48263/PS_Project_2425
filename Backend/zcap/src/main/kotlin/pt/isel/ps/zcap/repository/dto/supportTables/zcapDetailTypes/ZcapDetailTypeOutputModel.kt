package pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes

import pt.isel.ps.zcap.domain.supportTables.DataTypes
import pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories.DetailTypeCategoryOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class ZcapDetailTypeOutputModel(
    val zcapDetailTypeId: Long,
    val name: String,
    val detailTypeCategory: DetailTypeCategoryOutputModel,
    val dataType: DataTypes,
    val isMandatory: Boolean,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)