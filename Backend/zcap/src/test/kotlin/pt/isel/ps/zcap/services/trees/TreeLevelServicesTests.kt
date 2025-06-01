package pt.isel.ps.zcap.services.trees

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.repository.dto.trees.treeLevel.TreeLevelInputModel
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeLevelService
import java.time.LocalDate
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@ActiveProfiles("test")

@DataJpaTest
class TreeLevelServicesTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: TreeLevelRepository

    lateinit var servicesTests: TreeLevelService

    var currentSavedId by Delegates.notNull<Long>()

    @BeforeEach
    fun setUp() {
        servicesTests = TreeLevelService(repository)
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "Test1"
        )
        entityManager.persistAndFlush(testTreeLevel)
        currentSavedId = testTreeLevel.treeLevelId
    }

    @Test
    fun `get all Tree levels`() {
        val treeLevels = servicesTests.getAllTreeLevels()
        assertTrue(treeLevels.size == 1)
        assertEquals("Test1", treeLevels.first().name)
        val anotherTreeLevel = TreeLevel(
            levelId = 2,
            name = "Test2"
        )
        entityManager.persistAndFlush(anotherTreeLevel)
        val updatedTreeLevels = servicesTests.getAllTreeLevels()
        assertTrue(updatedTreeLevels.size == 2)
        assertTrue(updatedTreeLevels.any { it.name == "Test2" })
    }

    @Test
    fun `get Tree Level by id`() {
        val treeLevel = servicesTests.getTreeLevelById(currentSavedId)
        assertTrue(treeLevel is Success)
        assertEquals("Test1", treeLevel.value.name)
    }

    @Test
    fun `get Tree Level by wrong id`() {
        val treeLevel = servicesTests.getTreeLevelById(99)
        assertTrue(treeLevel is Failure)
        assertTrue(treeLevel.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `save Tree Level`() {
        val treeLevelInput = TreeLevelInputModel(3, "Test2", null, LocalDate.now(), null)
        val save = servicesTests.saveTreeLevel(treeLevelInput)
        assertTrue(save is Success)
        assertEquals("Test2", save.value.name)
    }

    @Test
    fun `Failed to save Tree Level by name`() {
        val treeLevelInput = TreeLevelInputModel(3, "", null, LocalDate.now(), null)
        val save = servicesTests.saveTreeLevel(treeLevelInput)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `update Tree Level`() {
        val treeLevelUpdate = TreeLevelInputModel(1, "Updated", null, LocalDate.now(), null)
        val update = servicesTests.updateTreeLevel(currentSavedId, treeLevelUpdate)
        assertTrue(update is Success)
        assertEquals("Updated", update.value.name)
    }

    @Test
    fun `update Tree Level with wrong date`() {
        val treeLevelUpdate = TreeLevelInputModel(1, "Updated", null, LocalDate.MAX, LocalDate.MIN)
        val update = servicesTests.updateTreeLevel(currentSavedId, treeLevelUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `update Tree Level with wrong id`() {
        val treeLevelUpdate = TreeLevelInputModel(1, "Updated", null, LocalDate.now(), null)
        val update = servicesTests.updateTreeLevel(99, treeLevelUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `delete by id`() {
        val treeLevel = servicesTests.getTreeLevelById(currentSavedId)
        assertTrue(treeLevel is Success)
        val delete = servicesTests.deleteTreeLevelById(currentSavedId)
        assertTrue(delete is Success)
        val deleted = servicesTests.getTreeLevelById(currentSavedId)
        assertTrue(deleted is Failure)
        assertTrue(deleted.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `delete by the wrong id`() {
        val treeLevel = servicesTests.getTreeLevelById(currentSavedId)
        assertTrue(treeLevel is Success)
        val delete = servicesTests.deleteTreeLevelById(99)
        assertTrue(delete is Failure)
        assertTrue(delete.value is ServiceErrors.RecordNotFound)
    }

}