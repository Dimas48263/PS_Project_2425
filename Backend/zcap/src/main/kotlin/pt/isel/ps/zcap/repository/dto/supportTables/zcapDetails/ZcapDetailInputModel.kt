package pt.isel.ps.zcap.repository.dto.supportTables.zcapDetails

import java.time.LocalDate

data class ZcapDetailInputModel(
    val zcapId: Long,
    val zcapDetailTypeId: Long,
    val valueCol: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)