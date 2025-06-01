package pt.isel.ps.zcap.repository.models.persons

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import pt.isel.ps.zcap.domain.persons.PersonSpecialNeed
import java.time.LocalDate

interface PersonSpecialNeedRepository: JpaRepository<PersonSpecialNeed, Long> {
    @Query(
        """
    SELECT psn FROM PersonSpecialNeed psn
    WHERE psn.startDate <= :targetDate
      AND (psn.endDate IS NULL OR psn.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<PersonSpecialNeed>

    fun findByPerson_PersonId(id: Long): List<PersonSpecialNeed>
}