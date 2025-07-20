package pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType

import pt.isel.ps.zcap.domain.supportTables.DataTypes
import java.time.LocalDate
import java.time.LocalDateTime

data class TreeRecordDetailTypeInputModel(
    val name: String,
    val unit: DataTypes,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)