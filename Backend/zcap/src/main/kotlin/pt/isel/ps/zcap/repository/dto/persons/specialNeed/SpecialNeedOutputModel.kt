package pt.isel.ps.zcap.repository.dto.persons.specialNeed

import java.time.LocalDate
import java.time.LocalDateTime

data class SpecialNeedOutputModel(
    val specialNeedId: Long,
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val updatedAt: LocalDateTime,
    val createdAt: LocalDateTime
)