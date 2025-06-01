package pt.isel.ps.zcap.repository.models.persons

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import pt.isel.ps.zcap.domain.persons.Relation

interface RelationRepository: JpaRepository<Relation, Long> {
    @Query("""
        SELECT r FROM Relation r 
        WHERE r.person1.id = :personId
    """)
    fun findAllByPerson1Id(@Param("personId") personId: Long): List<Relation>

    @Query("""
    SELECT COUNT(r) > 0 FROM Relation r
    WHERE r.person1.id = :person1Id 
      AND r.person2.id = :person2Id 
      AND r.relationType.id = :relationTypeId
""")
    fun existsByPersonsAndType(
        @Param("person1Id") person1Id: Long,
        @Param("person2Id") person2Id: Long,
        @Param("relationTypeId") relationTypeId: Long
    ): Boolean
}