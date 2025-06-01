package pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail

import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import java.time.LocalDate
import java.time.LocalDateTime

data class TreeRecordDetailOutputModel(
    val detailId: Long,
    val treeRecord: Tree,
    val detailType: TreeRecordDetailType,
    val valueCol: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)