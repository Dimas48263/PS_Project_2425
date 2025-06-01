package pt.isel.ps.zcap.repository.models.trees

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.tree.TreeLevel
import java.time.LocalDate

@Repository
interface TreeLevelRepository : JpaRepository<TreeLevel, Long> {
    @Query(
        """
    SELECT tl FROM TreeLevel tl
    WHERE tl.startDate <= :targetDate
      AND (tl.endDate IS NULL OR tl.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<TreeLevel>
}