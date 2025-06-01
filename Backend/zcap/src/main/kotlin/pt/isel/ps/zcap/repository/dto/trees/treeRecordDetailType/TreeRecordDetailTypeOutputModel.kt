package pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType

import java.time.LocalDate
import java.time.LocalDateTime

data class TreeRecordDetailTypeOutputModel(
    val detailTypeId: Long,
    val name: String,
    val unit: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createAt: LocalDateTime,
    val timestamp: LocalDateTime
)