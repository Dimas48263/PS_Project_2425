package pt.isel.ps.zcap.repository.models.incidents

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import pt.isel.ps.zcap.domain.incidents.IncidentZcapPerson
import java.time.LocalDate

interface IncidentZcapPersonRepository: JpaRepository<IncidentZcapPerson, Long> {
    @Query(
        """
    SELECT izp FROM IncidentZcapPerson izp
    WHERE izp.startDate <= :targetDate
      AND (izp.endDate IS NULL OR izp.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<IncidentZcapPerson>

    fun findByIncidentZcap_incidentZcapId(id: Long): List<IncidentZcapPerson>
    fun findByPerson_personId(id: Long): List<IncidentZcapPerson>
}