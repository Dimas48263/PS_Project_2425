package pt.isel.ps.zcap.repository.dto.trees.tree

import java.time.LocalDate
import java.time.LocalDateTime

data class TreeInputModel(
    val name: String,
    val treeLevelId: Long,
    val parentId: Long?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)