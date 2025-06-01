package pt.isel.ps.zcap.repository.models.trees

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import java.time.LocalDate

@Repository
interface TreeRecordDetailRepository : JpaRepository<TreeRecordDetail, Long> {

    fun findByDetailType_DetailTypeId(detailTypeId: Long): List<TreeRecordDetail>

    @Query(
        """
    SELECT trd FROM TreeRecordDetail trd
    WHERE trd.startDate <= :targetDate
      AND (trd.endDate IS NULL OR trd.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<TreeRecordDetail>
}