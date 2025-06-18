package pt.isel.ps.zcap.repository.models.trees

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.tree.TreeLevelDetailType
import java.time.LocalDate

@Repository
interface TreeLevelDetailTypeRepository: JpaRepository<TreeLevelDetailType, Long> {
    @Query(
        """
    SELECT tldt FROM TreeLevelDetailType tldt
    WHERE tldt.startDate <= :targetDate
      AND (tldt.endDate IS NULL OR tldt.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<TreeLevelDetailType>

    fun findByTreeLevel_TreeLevelId(treeLevelId: Long): List<TreeLevelDetailType>
    fun findByDetailType_DetailTypeId(detailTypeId: Long): List<TreeLevelDetailType>
}