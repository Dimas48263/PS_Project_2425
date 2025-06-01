package pt.isel.ps.zcap.repository.models.supportTables

import jakarta.transaction.Transactional
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.supportTables.BuildingType
import java.time.LocalDate

@Repository
@Transactional
interface BuildingTypeRepository : JpaRepository<BuildingType, Long> {
    @Query(
        """
    SELECT u FROM BuildingType u
    WHERE u.startDate <= :targetDate
      AND (u.endDate IS NULL OR u.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<BuildingType>
}
