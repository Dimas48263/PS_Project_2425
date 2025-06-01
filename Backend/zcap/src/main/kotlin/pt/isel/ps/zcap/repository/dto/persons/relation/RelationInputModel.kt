package pt.isel.ps.zcap.repository.dto.persons.relation

data class RelationInputModel(
    val personId1: Long,
    val personId2: Long,
    val relationTypeId: Long
)