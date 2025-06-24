package pt.isel.ps.zcap.repository.dto.supportTables

import java.time.LocalDate
import java.time.LocalDateTime

class DetailTypeCategoryOutputModel(
    val detailTypeCategoryId: Long,
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)