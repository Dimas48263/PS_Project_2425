package pt.isel.ps.zcap.repository.trees

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import java.time.LocalDate
import kotlin.jvm.optionals.getOrNull
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ActiveProfiles("test")

@DataJpaTest
class TreeRecordDetailTypeRepositoryTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: TreeRecordDetailTypeRepository

    @Test
    fun `should save and get a Tree Record Detail Type`() {
        val testTrdt = TreeRecordDetailType(
            name = "Test1",
            unit = "string",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTrdt)
        val trdt = repository.findById(testTrdt.detailTypeId).getOrNull()
        assertNotNull(trdt)
        assertEquals("Test1", trdt.name)
    }

    @Test
    fun `should update a Tree Record Detail Type`() {
        val testTrdt = TreeRecordDetailType(
            name = "Test1",
            unit = "string",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTrdt)

        val newTrdt = testTrdt.copy(
            name = "Updated"
        )
        val trdt = repository.save(newTrdt)
        assertEquals("Updated", trdt.name)
        assertEquals("string", newTrdt.unit)
    }

    @Test
    fun `should delete a Tree Record Detail Type`() {
        val testTrdt = TreeRecordDetailType(
            name = "Test1",
            unit = "string",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTrdt)

        repository.deleteById(testTrdt.detailTypeId)
        val deleted = repository.findById(testTrdt.detailTypeId).getOrNull()
        assertNull(deleted)
    }
}