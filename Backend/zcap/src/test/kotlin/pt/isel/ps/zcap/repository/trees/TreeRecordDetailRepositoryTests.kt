package pt.isel.ps.zcap.repository.trees

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailRepository
import java.time.LocalDate
import kotlin.jvm.optionals.getOrNull
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ActiveProfiles("test")

@DataJpaTest
class TreeRecordDetailRepositoryTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: TreeRecordDetailRepository


    lateinit var testTree: Tree
    lateinit var testTrdt: TreeRecordDetailType
    @BeforeEach
    fun setup() {
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "Tree Level Test",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTreeLevel)
        testTree = Tree(
            name = "Test1",
            treeLevel = testTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTree)
        testTrdt = TreeRecordDetailType(
            name = "Test1",
            unit = "string",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTrdt)
    }
    @Test
    fun `should save and get a Tree Record Detail`() {
        val testTreeRecordDetail = TreeRecordDetail(
            treeRecord = testTree,
            detailType = testTrdt,
            valueCol = "Test1",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTreeRecordDetail)
        val treeRecordDetail = repository.findById(testTreeRecordDetail.detailId).getOrNull()
        assertNotNull(treeRecordDetail)
        assertEquals("Test1", treeRecordDetail.valueCol)
    }

    @Test
    fun `should update a Tree Record Detail`() {
        val testTreeRecordDetail = TreeRecordDetail(
            treeRecord = testTree,
            detailType = testTrdt,
            valueCol = "Test1",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTreeRecordDetail)

        val newTreeRecordDetail = testTreeRecordDetail.copy(
            valueCol = "Updated"
        )
        val treeRecordDetail = repository.save(newTreeRecordDetail)
        assertEquals("Updated", treeRecordDetail.valueCol)
        assertEquals("Tree Level Test", treeRecordDetail.treeRecord.treeLevel.name)
    }

    @Test
    fun `should delete a Tree Record Detail Type`() {
        val testTreeRecordDetail = TreeRecordDetail(
            treeRecord = testTree,
            detailType = testTrdt,
            valueCol = "Test1",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTreeRecordDetail)

        repository.deleteById(testTreeRecordDetail.detailId)
        val deleted = repository.findById(testTreeRecordDetail.detailId).getOrNull()
        assertNull(deleted)
    }
}