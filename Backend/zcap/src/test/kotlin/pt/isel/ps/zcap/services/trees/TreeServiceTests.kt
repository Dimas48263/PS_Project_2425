package pt.isel.ps.zcap.services.trees

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeInputModel
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeService
import java.time.LocalDate
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@ActiveProfiles("test")

@DataJpaTest
class TreeServiceTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: TreeRepository

    @Autowired
    lateinit var treeLevelRepository: TreeLevelRepository

    lateinit var servicesTests: TreeService

    var currentSavedId by Delegates.notNull<Long>()

    var currentTreeLevelSavedId by Delegates.notNull<Long>()

    @BeforeEach
    fun setUp() {
        servicesTests = TreeService(treeLevelRepository, repository)
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "TreeLevel1"
        )
        entityManager.persistAndFlush(testTreeLevel)
        val testTree = Tree(
            name = "Tree1",
            treeLevel = testTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTree)
        currentTreeLevelSavedId = testTreeLevel.treeLevelId
        currentSavedId = testTree.treeRecordId
    }

    @Test
    fun `get all Trees`() {
        val trees = servicesTests.getAllTrees()
        assertTrue(trees.size == 1)
        assertEquals("Tree1", trees.first().name)
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "TreeLevel2"
        )
        entityManager.persistAndFlush(testTreeLevel)
        val anotherTree = Tree(
            name = "Tree2",
            treeLevel = testTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(anotherTree)
        val updatedTreeLevels = servicesTests.getAllTrees()
        assertTrue(updatedTreeLevels.size == 2)
        assertTrue(updatedTreeLevels.any { it.name == "Tree2" })
    }

    @Test
    fun `get Tree by id`() {
        val tree = servicesTests.getTreeById(currentSavedId)
        assertTrue(tree is Success)
        assertEquals("Tree1", tree.value.name)
    }

    @Test
    fun `get Tree by wrong id`() {
        val tree = servicesTests.getTreeById(99)
        assertTrue(tree is Failure)
        assertTrue(tree.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `save Tree`() {
        val treeInput = TreeInputModel("Tree2", currentTreeLevelSavedId, null, LocalDate.now(), null )
        val save = servicesTests.saveTree(treeInput)
        assertTrue(save is Success)
        assertEquals("Tree2", save.value.name)
    }

    @Test
    fun `Failed to save Tree by name`() {
        val treeInput = TreeInputModel("", currentTreeLevelSavedId, null, LocalDate.now(), null )
        val save = servicesTests.saveTree(treeInput)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `Failed to save Tree by parent`() {
        val treeInput = TreeInputModel("Tree2", currentTreeLevelSavedId, 99, LocalDate.now(), null )
        val save = servicesTests.saveTree(treeInput)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.ParentNotFound)
    }

    @Test
    fun `Failed to save Tree by tree Level`() {
        val treeInput = TreeInputModel("Tree2", 99, null, LocalDate.now(), null )
        val save = servicesTests.saveTree(treeInput)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.TreeLevelNotFound)
    }

    @Test
    fun `update Tree`() {
        val treeUpdate = TreeInputModel("Updated", currentTreeLevelSavedId, null, LocalDate.now(), null )
        val update = servicesTests.updateTreeById(currentSavedId, treeUpdate)
        assertTrue(update is Success)
        assertEquals("Updated", update.value.name)
    }

    @Test
    fun `update Tree with wrong date`() {
        val treeUpdate = TreeInputModel("Updated", currentTreeLevelSavedId, null, LocalDate.MAX, LocalDate.MIN)
        val update = servicesTests.updateTreeById(currentSavedId, treeUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `update Tree with wrong id`() {
        val treeUpdate = TreeInputModel("Updated",currentTreeLevelSavedId, null, LocalDate.now(), null)
        val update = servicesTests.updateTreeById(99, treeUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.TreeNotFound)
    }

    @Test
    fun `update Tree with wrong Tree Level Id`() {
        val treeUpdate = TreeInputModel("Updated", 99, null, LocalDate.now(), null)
        val update = servicesTests.updateTreeById(currentSavedId, treeUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.TreeLevelNotFound)
    }

    @Test
    fun `update Tree with wrong Parent Id`() {
        val treeUpdate = TreeInputModel("Updated", currentTreeLevelSavedId, 99, LocalDate.now(), null)
        val update = servicesTests.updateTreeById(currentSavedId, treeUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.ParentNotFound)
    }

    @Test
    fun `delete by id`() {
        val delete = servicesTests.deleteTreeById(currentSavedId)
        assertTrue(delete is Success)
        val deleted = servicesTests.getTreeById(currentSavedId)
        assertTrue(deleted is Failure)
        assertTrue(deleted.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `delete by the wrong id`() {
        val delete = servicesTests.deleteTreeById(99)
        assertTrue(delete is Failure)
        assertTrue(delete.value is ServiceErrors.RecordNotFound)
    }

}