package pt.isel.ps.zcap.services.tree

import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeOutputModel
import pt.isel.ps.zcap.repository.dto.trees.treeLevel.TreeLevelOutputModel
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail.TreeRecordDetailOutputModel
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType.TreeRecordDetailTypeOutputModel

fun TreeLevel.toOutputModel() = TreeLevelOutputModel(
    treeLevelId = treeLevelId,
    levelId = levelId,
    name = name,
    description = description,
    startDate = startDate,
    endDate = endDate,
    createAt = createdAt,
    lastUpdatedAt = lastUpdatedAt,
)

fun TreeRecordDetail.toOutputModel(): TreeRecordDetailOutputModel =
    TreeRecordDetailOutputModel(
        detailId,
        treeRecord,
        detailType,
        valueCol,
        startDate,
        endDate,
        createdAt,
        lastUpdatedAt
    )

fun Tree.toOutputModel(visited: Set<Long> = emptySet()): TreeOutputModel {
    val currentId = treeRecordId

    return TreeOutputModel(
        treeRecordId = currentId,
        name = name,
        treeLevel = treeLevel.toOutputModel(),
        parent = if (parent != null && (parent.treeRecordId) !in visited)
            parent.toOutputModel(visited + currentId)
        else null,
        startDate = startDate,
        endDate = endDate,
        createAt = createdAt,
        lastUpdatedAt = lastUpdatedAt,
    )
}

fun TreeRecordDetailType.toOutputModel(): TreeRecordDetailTypeOutputModel =
    TreeRecordDetailTypeOutputModel(
        this.detailTypeId,
        this.name,
        this.unit,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.lastUpdatedAt
    )