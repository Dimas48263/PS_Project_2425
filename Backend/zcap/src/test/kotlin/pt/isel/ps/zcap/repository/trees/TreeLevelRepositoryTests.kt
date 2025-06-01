package pt.isel.ps.zcap.repository.trees

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import kotlin.jvm.optionals.getOrNull
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ActiveProfiles("test")

@DataJpaTest
class TreeLevelRepositoryTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: TreeLevelRepository

    @Test
    fun `should save and get a TreeLevel`() {
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "Test1"
        )
        entityManager.persistAndFlush(testTreeLevel)

        val treeLevel = repository.findById(testTreeLevel.treeLevelId).getOrNull()
        assertNotNull(treeLevel)
        assertEquals("Test1", treeLevel.name)
    }

    @Test
    fun `should update a TreeLevel`() {
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "Test1"
        )
        entityManager.persistAndFlush(testTreeLevel)

        val newTreeLevel = testTreeLevel.copy(
            name = "Updated"
        )
        val treeLevel = repository.save(newTreeLevel)
        assertEquals("Updated", treeLevel.name)
    }

    @Test
    fun `should delete a TreeLevel`() {
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "Test1"
        )
        entityManager.persistAndFlush(testTreeLevel)

        repository.deleteById(testTreeLevel.treeLevelId)
        val deleted = repository.findById(testTreeLevel.treeLevelId).getOrNull()
        assertNull(deleted)
    }
}