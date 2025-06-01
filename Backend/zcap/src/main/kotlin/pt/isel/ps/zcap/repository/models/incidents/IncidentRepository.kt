package pt.isel.ps.zcap.repository.models.incidents

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.incidents.Incident
import java.time.LocalDate

@Repository
interface IncidentRepository: JpaRepository<Incident, Long> {
    @Query("SELECT i FROM Incident i WHERE i.incidentType.incidentTypeId = :id")
    fun findByIncidentTypeId(@Param("id") id: Long): List<Incident>
    @Query(
        """
    SELECT i FROM Incident i
    WHERE i.startDate <= :targetDate
      AND (i.endDate IS NULL OR i.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<Incident>
}