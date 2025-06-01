package pt.isel.ps.zcap.repository.models.trees

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.tree.Tree
import java.time.LocalDate

@Repository
interface TreeRepository : JpaRepository<Tree, Long> {
    @Query("SELECT t FROM Tree t WHERE t.treeLevel.treeLevelId = :id")
    fun findByTreeLevelId(@Param("id") id: Long): List<Tree>
    fun findByNameContaining(namePart: String): List<Tree>
    fun findByName(name: String): List<Tree>
    @Query(
        """
    SELECT t FROM Tree t
    WHERE t.startDate <= :targetDate
      AND (t.endDate IS NULL OR t.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<Tree>
    fun findByParent_TreeRecordId(parentId: Long): List<Tree>
}