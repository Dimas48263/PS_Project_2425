package pt.isel.ps.zcap.repository.dto.persons.relationType

import java.time.LocalDate
import java.time.LocalDateTime

data class RelationTypeOutputModel(
    val relationTypeId: Long,
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)