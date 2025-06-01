package pt.isel.ps.zcap.repository.dto.supportTables

import java.time.LocalDate
data class ZcapInputModel(
    val name: String,
    val buildingTypeId: Long,
    val address: String,
    val treeRecordId: Long?,
    val latitude: Float?,
    val longitude: Float?,
    val entityId: Long,
    val startDate: LocalDate,
    val endDate: LocalDate?
)