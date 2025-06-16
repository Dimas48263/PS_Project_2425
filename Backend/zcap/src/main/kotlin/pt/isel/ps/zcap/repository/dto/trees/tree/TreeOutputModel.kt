package pt.isel.ps.zcap.repository.dto.trees.tree

import pt.isel.ps.zcap.repository.dto.trees.treeLevel.TreeLevelOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class TreeOutputModel(
    val treeRecordId: Long,
    val name: String,
    val treeLevel: TreeLevelOutputModel,
    val parent: TreeOutputModel?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)