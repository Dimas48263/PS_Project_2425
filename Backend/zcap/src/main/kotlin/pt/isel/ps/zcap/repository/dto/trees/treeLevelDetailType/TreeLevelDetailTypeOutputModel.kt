package pt.isel.ps.zcap.repository.dto.trees.treeLevelDetailType

import pt.isel.ps.zcap.repository.dto.trees.treeLevel.TreeLevelOutputModel
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType.TreeRecordDetailTypeOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class TreeLevelDetailTypeOutputModel(
    val treeLevelDetailTypeId: Long,
    val treeLevel: TreeLevelOutputModel,
    val detailType: TreeRecordDetailTypeOutputModel,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)