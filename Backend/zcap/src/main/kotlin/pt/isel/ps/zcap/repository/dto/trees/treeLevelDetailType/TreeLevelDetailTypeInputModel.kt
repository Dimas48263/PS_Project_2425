package pt.isel.ps.zcap.repository.dto.trees.treeLevelDetailType

import java.time.LocalDate
import java.time.LocalDateTime

data class TreeLevelDetailTypeInputModel(
    val treeLevelId: Long,
    val detailTypeId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)