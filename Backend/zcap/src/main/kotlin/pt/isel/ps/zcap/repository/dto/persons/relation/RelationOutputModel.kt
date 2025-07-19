package pt.isel.ps.zcap.repository.dto.persons.relation

import pt.isel.ps.zcap.repository.dto.persons.person.PersonOutputModel
import pt.isel.ps.zcap.repository.dto.persons.relationType.RelationTypeOutputModel
import java.time.LocalDateTime

data class RelationOutputModel(
    val relationId: Long,
    val person1: PersonOutputModel,
    val person2: PersonOutputModel,
    val relationType: RelationTypeOutputModel,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)