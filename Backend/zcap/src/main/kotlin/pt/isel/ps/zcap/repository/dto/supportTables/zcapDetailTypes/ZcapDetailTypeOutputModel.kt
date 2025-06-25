package pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes

import pt.isel.ps.zcap.domain.supportTables.DataTypes
import pt.isel.ps.zcap.domain.supportTables.ZcapDetailType
import pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories.DetailTypeCategoryOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories.toOutputModel
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

fun ZcapDetailType.toOutputModel(): ZcapDetailTypeOutputModel =
    ZcapDetailTypeOutputModel(
        zcapDetailTypeId,
        name,
        detailTypeCategory.toOutputModel(),
        dataType,
        isMandatory,
        startDate,
        endDate,
        createdAt,
        lastUpdatedAt
    )