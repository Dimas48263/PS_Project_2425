package pt.isel.ps.zcap.services.trees

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType.TreeRecordDetailTypeInputModel
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeRecordDetailTypeService
import java.time.LocalDate
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertTrue
@ActiveProfiles("test")

@DataJpaTest
class TreeRecordDetailTypeServiceTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: TreeRecordDetailTypeRepository

    lateinit var servicesTests: TreeRecordDetailTypeService

    var currentSavedId by Delegates.notNull<Long>()

    @BeforeEach
    fun setUp() {
        servicesTests = TreeRecordDetailTypeService(repository)
        val testTreeRecordDetailType = TreeRecordDetailType(
            name = "TRDT1",
            unit = "string",
            startDate = LocalDate.now(),
        )
        entityManager.persistAndFlush(testTreeRecordDetailType)
        currentSavedId = testTreeRecordDetailType.detailTypeId
    }

    @Test
    fun `get all Tree Record Detail Types`() {
        val treeRecordDetailTypes = servicesTests.getAllTreeRecordTypes()
        assertTrue(treeRecordDetailTypes.size == 1)
        assertEquals("TRDT1", treeRecordDetailTypes.first().name)
        val anotherTreeRecordDetailType = TreeRecordDetailType(
            name = "TRDT2",
            unit = "int",
            startDate = LocalDate.now(),
        )
        entityManager.persistAndFlush(anotherTreeRecordDetailType)
        val updatedTreeRecordDetailTypes = servicesTests.getAllTreeRecordTypes()
        assertTrue(updatedTreeRecordDetailTypes.size == 2)
        assertTrue(updatedTreeRecordDetailTypes.any { it.name == "TRDT2" })
    }

    @Test
    fun `get Tree Record Detail Type by id`() {
        val treeRecordDetailType = servicesTests.getTreeRecordDetailTypeById(currentSavedId)
        assertTrue(treeRecordDetailType is Success)
        assertEquals("TRDT1", treeRecordDetailType.value.name)
    }

    @Test
    fun `get Tree Record Detail Type by wrong id`() {
        val treeRecordDetailType = servicesTests.getTreeRecordDetailTypeById(99)
        assertTrue(treeRecordDetailType is Failure)
        assertTrue(treeRecordDetailType.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `save Tree Record Detail Type`() {
        val treeRecordDetailTypeInput = TreeRecordDetailTypeInputModel("nameTest", "unitTest", LocalDate.now(), null)
        val save = servicesTests.saveTreeRecordDetailType(treeRecordDetailTypeInput)
        assertTrue(save is Success)
        assertEquals("nameTest", save.value.name)
        assertEquals("unitTest", save.value.unit)
    }

    @Test
    fun `Failed to save Tree Record Detail Type by name`() {
        val treeRecordDetailTypeInput = TreeRecordDetailTypeInputModel("", "unitTest", LocalDate.now(), null)
        val save = servicesTests.saveTreeRecordDetailType(treeRecordDetailTypeInput)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `update Tree Record Detail Type`() {
        val treeRecordDetailTypeUpdate = TreeRecordDetailTypeInputModel(
            "UpdatedName",
            "UpdatedUnit",
            LocalDate.now(),
            null
        )
        val update = servicesTests.updateTreeRecordDetailTypeById(currentSavedId, treeRecordDetailTypeUpdate)
        assertTrue(update is Success)
        assertEquals("UpdatedName", update.value.name)
        assertEquals("UpdatedUnit", update.value.unit)
    }

    @Test
    fun `update Tree Record Detail Type with wrong date`() {
        val treeRecordDetailTypeUpdate = TreeRecordDetailTypeInputModel(
            "UpdatedName",
            "UpdatedUnit",
            LocalDate.MAX,
            LocalDate.MIN
        )
        val update = servicesTests.updateTreeRecordDetailTypeById(currentSavedId, treeRecordDetailTypeUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `update Tree Record Detail Type with wrong id`() {
        val treeRecordDetailTypeUpdate = TreeRecordDetailTypeInputModel(
            "UpdatedName",
            "UpdatedUnit",
            LocalDate.now(),
            null
        )
        val update = servicesTests.updateTreeRecordDetailTypeById(99, treeRecordDetailTypeUpdate)
        assertTrue(update is Failure)
        assertTrue(update.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `delete by id`() {
        val delete = servicesTests.deleteTreeRecordDetailTypeById(currentSavedId)
        assertTrue(delete is Success)
        val deleted = servicesTests.getTreeRecordDetailTypeById(currentSavedId)
        assertTrue(deleted is Failure)
        assertTrue(deleted.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `delete by the wrong id`() {
        val delete = servicesTests.deleteTreeRecordDetailTypeById(99)
        assertTrue(delete is Failure)
        assertTrue(delete.value is ServiceErrors.RecordNotFound)
    }

}