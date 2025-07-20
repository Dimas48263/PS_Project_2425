package pt.isel.ps.zcap.repository.dto.persons.relation

import java.time.LocalDateTime

data class RelationInputModel(
    val personId1: Long,
    val personId2: Long,
    val relationTypeId: Long,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)