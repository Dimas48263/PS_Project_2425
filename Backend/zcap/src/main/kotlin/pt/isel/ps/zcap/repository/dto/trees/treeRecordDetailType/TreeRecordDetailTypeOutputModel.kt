package pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType

import pt.isel.ps.zcap.domain.supportTables.DataTypes
import java.time.LocalDate
import java.time.LocalDateTime

data class TreeRecordDetailTypeOutputModel(
    val detailTypeId: Long,
    val name: String,
    val unit: DataTypes,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)