package pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail

import java.time.LocalDate
import java.time.LocalDateTime

data class TreeRecordDetailInputModel(
    val treeRecordId: Long,
    val detailTypeId: Long,
    val valueCol: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)