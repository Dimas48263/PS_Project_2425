package pt.isel.ps.zcap.repository.models.incidents

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.incidents.IncidentZcap
import java.time.LocalDate

@Repository
interface IncidentZcapRepository: JpaRepository<IncidentZcap, Long> {
    @Query(
        """
    SELECT iz FROM IncidentZcap iz
    WHERE iz.startDate <= :targetDate
      AND (iz.endDate IS NULL OR iz.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<IncidentZcap>

    fun findByIncident_incidentId(id: Long): List<IncidentZcap>
    fun findByZcap_zcapId(id: Long): List<IncidentZcap>
    fun findByEntity_entityId(id: Long): List<IncidentZcap>
}