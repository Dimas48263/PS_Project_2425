package pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail

import java.time.LocalDate

data class TreeRecordDetailInputModel(
    val treeRecordId: Long,
    val detailTypeId: Long,
    val valueCol: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)