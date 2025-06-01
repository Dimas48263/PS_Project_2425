package pt.isel.ps.zcap.repository.trees

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import java.time.LocalDate
import kotlin.jvm.optionals.getOrNull
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ActiveProfiles("test")

@DataJpaTest
class TreeRepositoryTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: TreeRepository

    @Test
    fun `should save and get a Tree`() {
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "Tree Level Test",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTreeLevel)
        val testTree = Tree(
            name = "Test1",
            treeLevel = testTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTree)
        val tree = repository.findById(testTree.treeRecordId).getOrNull()
        assertNotNull(tree)
        assertEquals("Test1", tree.name)
    }

    @Test
    fun `should update a Tree`() {
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "Tree Level Test",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTreeLevel)
        val testTree = Tree(
            name = "Test1",
            treeLevel = testTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTree)
        val newTree = testTree.copy(
            name = "Updated"
        )
        val tree = repository.save(newTree)
        assertEquals("Updated", tree.name)
        assertEquals("Tree Level Test", tree.treeLevel.name)
    }

    @Test
    fun `should delete a Tree`() {
        val testTreeLevel = TreeLevel(
            levelId = 1,
            name = "Tree Level Test",
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTreeLevel)
        val testTree = Tree(
            name = "Test1",
            treeLevel = testTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        entityManager.persistAndFlush(testTree)

        repository.deleteById(testTree.treeRecordId)
        val deleted = repository.findById(testTree.treeRecordId).getOrNull()
        assertNull(deleted)
    }
}