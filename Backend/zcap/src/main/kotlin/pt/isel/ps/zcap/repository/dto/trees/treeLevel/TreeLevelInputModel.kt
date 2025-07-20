package pt.isel.ps.zcap.repository.dto.trees.treeLevel

import java.time.LocalDate
import java.time.LocalDateTime

data class TreeLevelInputModel(
    val levelId: Int,
    val name: String,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)