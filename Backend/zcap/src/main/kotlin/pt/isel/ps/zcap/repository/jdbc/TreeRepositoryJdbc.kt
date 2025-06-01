package pt.isel.ps.zcap.repository.jdbc

import jakarta.persistence.EntityManager
//import org.springframework.stereotype.Repository
//import pt.isel.ps.zcap.domain.OldTree
//import pt.isel.ps.zcap.domain.OldTreeLevel
//import pt.isel.ps.zcap.repository.models.TreeRepository
//import java.time.LocalDate
//
//@Repository
//class TreeRepositoryJdbc(private val em: EntityManager) : TreeRepository {
//
//    override fun getTreeById(id :Int) : OldTree? {
//        val query = em.createQuery("SELECT t FROM Tree t WHERE t.id = :id", OldTree::class.java)
//        query.setParameter("id", id)
//        return query.resultList.firstOrNull()
//    }
//
//    override fun getAllTrees(): List<OldTree> {
//        val query = em.createNativeQuery("SELECT * FROM tree", OldTree::class.java)
//        return query.resultList as List<OldTree>
//    }
//
//    override fun getAllChildrenTree(id: Int): List<OldTree> {
//        val query = em.createNativeQuery("""
//            WITH TreeHierarchy AS (
//                SELECT
//                    t.treeRecordId,
//                    t.name,
//                    t.treeLevelId,
//                    t.parentId,
//                    t.startDate,
//                    t.endDate,
//                    t.timestamp
//                FROM tree t
//                WHERE t.parentId = :parentId
//
//                UNION ALL
//
//                SELECT
//                    t.treeRecordId,
//                    t.name,
//                    t.treeLevelId,
//                    t.parentId,
//                    t.startDate,
//                    t.endDate,
//                    t.timestamp
//                FROM tree t
//                INNER JOIN TreeHierarchy th ON t.parentId = th.treeRecordId
//            )
//            SELECT * FROM TreeHierarchy
//        """, OldTree::class.java)
//        return query.resultList as List<OldTree>
//    }
//
//    override fun getTreesByLevel(levelId: Int): List<OldTree> {
//        val query = em.createQuery("SELECT t FROM tree t WHERE t.levelId = :levelId ")
//        query.setParameter("levelId", levelId)
//        return query.resultList as List<OldTree>
//    }
//
//    override fun saveTree(  //TODO Return the right id
//        name: String,
//        levelId: Int,
//        parentId: Int?,
//        startDate: LocalDate,
//        endDate: LocalDate?,
//        timestamp: LocalDate
//    ): OldTree {
//        val query = em.createNativeQuery(
//            """
//        DECLARE @Inserted TABLE (treeRecordId INT, name VARCHAR(255), treeLevelId INT, parentId INT NULL, startDate DATE, endDate DATE NULL, timestamp DATE);
//
//        INSERT INTO tree (name, treeLevelId, parentId, startDate, endDate, timestamp)
//        OUTPUT INSERTED.treeRecordId, INSERTED.name, INSERTED.treeLevelId, INSERTED.parentId, INSERTED.startDate, INSERTED.endDate, INSERTED.timestamp INTO @Inserted
//        VALUES (:name, :levelId, :parentId, :startDate, :endDate, :timestamp);
//
//        SELECT * FROM @Inserted;
//        """.trimIndent(), OldTree::class.java
//        )
//        query.setParameter("name", name)
//        query.setParameter("levelId", levelId)
//        query.setParameter("parentId", parentId)
//        query.setParameter("startDate", startDate)
//        query.setParameter("endDate", endDate)
//        query.setParameter("timestamp", timestamp)
//
//        return query.singleResult as OldTree
//    }
//
//    override fun getTreeLevelById(treeLevelId: Int): OldTreeLevel? {
//        val query = em.createQuery("SELECT t FROM treeLevel t WHERE t.id = :id", OldTreeLevel::class.java)
//        query.setParameter("id", treeLevelId)
//        return query.resultList.firstOrNull()
//    }
//}