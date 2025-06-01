package pt.isel.ps.zcap.repository.models.trees

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import java.time.LocalDate

@Repository
interface TreeRecordDetailTypeRepository : JpaRepository<TreeRecordDetailType, Long> {
    @Query(
        """
    SELECT trdt FROM TreeRecordDetailType trdt
    WHERE trdt.startDate <= :targetDate
      AND (trdt.endDate IS NULL OR trdt.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<TreeRecordDetailType>
}