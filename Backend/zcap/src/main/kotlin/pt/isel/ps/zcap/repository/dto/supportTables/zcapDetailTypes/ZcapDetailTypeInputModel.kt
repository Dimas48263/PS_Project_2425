package pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes

import pt.isel.ps.zcap.domain.supportTables.DataTypes
import java.time.LocalDate

data class ZcapDetailTypeInputModel(
    val name: String,
    val detailTypeCategoryId: Long,
    val dataType: DataTypes,
    val isMandatory: Boolean,
    val startDate: LocalDate,
    val endDate: LocalDate?
)