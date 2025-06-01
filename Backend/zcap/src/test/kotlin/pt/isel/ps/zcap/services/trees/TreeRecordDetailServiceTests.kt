package pt.isel.ps.zcap.services.trees

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
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail.TreeRecordDetailInputModel
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeRecordDetailService
import java.time.LocalDate
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@ActiveProfiles("test")

@DataJpaTest
class TreeRecordDetailServiceTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: TreeRecordDetailRepository

    @Autowired
    lateinit var treeRepository: TreeRepository

    @Autowired
    lateinit var treeRecordDetailTypeRepository: TreeRecordDetailTypeRepository

    lateinit var servicesTests: TreeRecordDetailService

    var currentSavedId by Delegates.notNull<Long>()
    var currentTreeLevelSavedId by Delegates.notNull<Long>()
    var currentTreeSavedId by Delegates.notNull<Long>()
    var currentTreeRecordDetailTypeSavedId by Delegates.notNull<Long>()

    @BeforeEach
    fun setup() {
        servicesTests = TreeRecordDetailService(repository, treeRepository, treeRecordDetailTypeRepository)
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "TreeLevel1"
        )
        entityManager.persistAndFlush(testTreeLevel)
        currentTreeLevelSavedId = testTreeLevel.treeLevelId

        val testTree = Tree(
            name = "Tree1",
            treeLevel = testTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTree)
        currentTreeSavedId = testTree.treeRecordId

        val testTreeRecordDetailType = TreeRecordDetailType(
            name = "TRDT1",
            unit = "string",
            startDate = LocalDate.now(),
        )
        entityManager.persistAndFlush(testTreeRecordDetailType)
        currentTreeRecordDetailTypeSavedId = testTreeRecordDetailType.detailTypeId

        val testTreeRecordDetail = TreeRecordDetail(
            treeRecord = testTree,
            detailType = testTreeRecordDetailType,
            valueCol = "value1",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTreeRecordDetail)
        currentSavedId = testTreeRecordDetail.detailId
    }

    @Test
    fun `get all Tree Record Details`() {
        val trees = servicesTests.getAllTreeRecordDetails()
        assertTrue(trees.size == 1)
        val first = trees.first()
        assertEquals("value1", first.valueCol)
        assertEquals("TRDT1", first.detailType.name)
        assertEquals("Tree1", first.treeRecord.name)
    }

    @Test
    fun `get Tree Record Detail by id`() {
        val treeRecordDetail = servicesTests.getTreeRecordDetailById(currentSavedId)
        assertTrue(treeRecordDetail is Success)
        assertEquals("value1", treeRecordDetail.value.valueCol)
    }

    @Test
    fun `get Tree Record Detail by wrong id`() {
        val treeRecordDetail = servicesTests.getTreeRecordDetailById(99)
        assertTrue(treeRecordDetail is Failure)
        assertTrue(treeRecordDetail.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `save Tree Record Detail`() {
        val treeRecordDetailInput = TreeRecordDetailInputModel(
            currentTreeSavedId,
            currentTreeRecordDetailTypeSavedId,
            "value2",
            LocalDate.now(),
            null
        )
        val save = servicesTests.saveTreeRecordDetail(treeRecordDetailInput)
        assertTrue(save is Success)
        assertEquals("value2", save.value.valueCol)
    }

    @Test
    fun `Failed to save Tree Record Detail by value`() {
        val treeRecordDetailInput = TreeRecordDetailInputModel(
            currentTreeSavedId,
            currentTreeRecordDetailTypeSavedId,
            "",
            LocalDate.now(),
            null
        )
        val save = servicesTests.saveTreeRecordDetail(treeRecordDetailInput)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `Failed to save Tree Record Detail by Tree Id`() {
        val treeRecordDetailInput = TreeRecordDetailInputModel(
            99,
            currentTreeRecordDetailTypeSavedId,
            "value2",
            LocalDate.now(),
            null
        )
        val save = servicesTests.saveTreeRecordDetail(treeRecordDetailInput)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.TreeNotFound)
    }

    @Test
    fun `Failed to save Tree Record Detail by tree record detail type`() {
        val treeRecordDetailInput = TreeRecordDetailInputModel(
            currentTreeSavedId,
            99,
            "value2",
            LocalDate.now(),
            null
        )
        val save = servicesTests.saveTreeRecordDetail(treeRecordDetailInput)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.TreeRecordDetailTypeNotFound)
    }

    @Test
    fun `update Tree Record Detail`() {
        val treeRecordDetailUpdate = TreeRecordDetailInputModel(
            currentTreeSavedId,
            currentTreeRecordDetailTypeSavedId,
            "Updated",
            LocalDate.now(),
            null
        )
        val update = servicesTests.updateTreeRecordDetailById(currentSavedId, treeRecordDetailUpdate)
        assertTrue(update is Success)
        assertEquals("Updated", update.value.valueCol)
    }

    @Test
    fun `update Tree Record Detail with wrong date`() {
        val treeRecordDetailUpdate = TreeRecordDetailInputModel(
            currentTreeSavedId,
            currentTreeRecordDetailTypeSavedId,
            "Updated",
            LocalDate.MAX,
            LocalDate.MIN
        )
        val update = servicesTests.updateTreeRecordDetailById(currentSavedId, treeRecordDetailUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `update Tree Record Detail with wrong id`() {
        val treeRecordDetailUpdate = TreeRecordDetailInputModel(
            currentTreeSavedId,
            currentTreeRecordDetailTypeSavedId,
            "Updated",
            LocalDate.now(),
            null
        )
        val update = servicesTests.updateTreeRecordDetailById(99, treeRecordDetailUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.TreeRecordDetailNotFound)
    }

    @Test
    fun `update Tree with wrong Tree Id`() {
        val treeRecordDetailUpdate = TreeRecordDetailInputModel(
            99,
            currentTreeRecordDetailTypeSavedId,
            "Updated",
            LocalDate.now(),
            null
        )
        val update = servicesTests.updateTreeRecordDetailById(currentSavedId, treeRecordDetailUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.TreeNotFound)
    }

    @Test
    fun `update Tree with wrong Tree Record Detail Type Id`() {
        val treeRecordDetailUpdate = TreeRecordDetailInputModel(
            currentTreeSavedId,
            99,
            "Updated",
            LocalDate.now(),
            null
        )
        val update = servicesTests.updateTreeRecordDetailById(currentSavedId, treeRecordDetailUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.TreeRecordDetailTypeNotFound)
    }

    @Test
    fun `delete by id`() {
        val delete = servicesTests.deleteTreeRecordDetailById(currentSavedId)
        assertTrue(delete is Success)
        val deleted = servicesTests.getTreeRecordDetailById(currentSavedId)
        assertTrue(deleted is Failure)
        assertTrue(deleted.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `delete by the wrong id`() {
        val delete = servicesTests.deleteTreeRecordDetailById(99)
        assertTrue(delete is Failure)
        assertTrue(delete.value is ServiceErrors.RecordNotFound)
    }
}