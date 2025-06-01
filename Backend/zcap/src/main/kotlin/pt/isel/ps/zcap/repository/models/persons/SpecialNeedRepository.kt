package pt.isel.ps.zcap.repository.models.persons

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import pt.isel.ps.zcap.domain.persons.SpecialNeed
import java.time.LocalDate

interface SpecialNeedRepository: JpaRepository<SpecialNeed, Long> {
    @Query(
        """
    SELECT sn FROM SpecialNeed sn
    WHERE sn.startDate <= :targetDate
      AND (sn.endDate IS NULL OR sn.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<SpecialNeed>
}