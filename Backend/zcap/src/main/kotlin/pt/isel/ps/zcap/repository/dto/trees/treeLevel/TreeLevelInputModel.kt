package pt.isel.ps.zcap.repository.dto.trees.treeLevel

import java.time.LocalDate

data class TreeLevelInputModel(
    val levelId: Int,
    val name: String,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
)