package pt.isel.ps.zcap.repository.models.incidents

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.incidents.IncidentType
import java.time.LocalDate

@Repository
interface IncidentTypeRepository: JpaRepository<IncidentType, Long> {
    @Query(
        """
    SELECT it FROM IncidentType it
    WHERE it.startDate <= :targetDate
      AND (it.endDate IS NULL OR it.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<IncidentType>
}