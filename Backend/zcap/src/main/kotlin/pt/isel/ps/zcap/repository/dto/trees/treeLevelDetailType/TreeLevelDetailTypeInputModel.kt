package pt.isel.ps.zcap.repository.dto.trees.treeLevelDetailType

import java.time.LocalDate

data class TreeLevelDetailTypeInputModel(
    val treeLevelId: Long,
    val detailTypeId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate?
)