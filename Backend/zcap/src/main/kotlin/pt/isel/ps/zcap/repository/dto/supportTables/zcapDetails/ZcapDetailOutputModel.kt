package pt.isel.ps.zcap.repository.dto.supportTables.zcapDetails

import pt.isel.ps.zcap.repository.dto.supportTables.zcap.ZcapOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes.ZcapDetailTypeOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class ZcapDetailOutputModel(
    val zcapDetailId: Long,
    val zcap: ZcapOutputModel,
    val zcapDetailType: ZcapDetailTypeOutputModel,
    val valueCol: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)