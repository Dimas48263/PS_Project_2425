package pt.isel.ps.zcap.repository.models.persons

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import pt.isel.ps.zcap.domain.persons.RelationType
import java.time.LocalDate

interface RelationTypeRepository: JpaRepository<RelationType, Long> {
    @Query(
        """
    SELECT rt FROM RelationType rt
    WHERE rt.startDate <= :targetDate
      AND (rt.endDate IS NULL OR rt.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<RelationType>
}