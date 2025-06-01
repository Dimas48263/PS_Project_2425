package pt.isel.ps.zcap.repository.models.persons

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.persons.DepartureDestination
import java.time.LocalDate

@Repository
interface DepartureDestinationRepository: JpaRepository<DepartureDestination, Long> {
    @Query(
        """
    SELECT d FROM DepartureDestination d
    WHERE d.startDate <= :targetDate
      AND (d.endDate IS NULL OR d.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<DepartureDestination>
}