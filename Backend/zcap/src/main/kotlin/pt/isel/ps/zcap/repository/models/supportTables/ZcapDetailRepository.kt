package pt.isel.ps.zcap.repository.models.supportTables

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.supportTables.ZcapDetail
import java.time.LocalDate

@Repository
interface ZcapDetailRepository: JpaRepository<ZcapDetail, Long> {
    @Query(
        """
    SELECT z FROM Zcap z
    WHERE z.startDate <= :targetDate
      AND (z.endDate IS NULL OR z.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<ZcapDetail>
}