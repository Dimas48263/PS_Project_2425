package pt.isel.ps.zcap.repository.dto.trees.treeLevel

import java.time.LocalDate
import java.time.LocalDateTime

class TreeLevelOutputModel(
    val treeLevelId: Long,
    val levelId: Int,
    val name: String,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)
