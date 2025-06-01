package pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType

import java.time.LocalDate

data class TreeRecordDetailTypeInputModel(
    val name: String,
    val unit: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)