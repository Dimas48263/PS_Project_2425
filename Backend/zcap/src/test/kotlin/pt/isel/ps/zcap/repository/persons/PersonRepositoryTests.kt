package pt.isel.ps.zcap.repository.persons

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.persons.Person
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import java.sql.Timestamp
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ActiveProfiles("test")
@DataJpaTest
class PersonRepositoryTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: PersonRepository

    var currentPersonSavedId by Delegates.notNull<Long>()
    var currentPlaceOdResidence by Delegates.notNull<Tree>()
    var currentCountryCode by Delegates.notNull<TreeRecordDetail>()
    @BeforeEach
    fun setup() {
        val treeLevel = TreeLevel(
            levelId = 1,
            name = "Tree Level test",
            description = "Description tree level",
            startDate = LocalDate.now()
        )
        val saveTreeLevel = entityManager.persistAndFlush(treeLevel)

        val tree = Tree(
            name = "Tree Test",
            treeLevel = saveTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        val saveTree = entityManager.persistAndFlush(tree)
        currentPlaceOdResidence = saveTree

        val treeRecordDetailType = TreeRecordDetailType(
            name = "Tree Record Detail Type test",
            unit = "string",
            startDate = LocalDate.now()
        )
        val saveTreeRecordDetailType = entityManager.persistAndFlush(treeRecordDetailType)

        val countryCode = TreeRecordDetail(
            treeRecord = saveTree,
            detailType = saveTreeRecordDetailType,
            valueCol = "country code test",
            startDate = LocalDate.now()
        )
        val saveCountryCode = entityManager.persistAndFlush(countryCode)
        currentCountryCode = saveCountryCode

        val person = Person(
            name = "Person test",
            age = 20,
            contact = "987654321",
            countryCode = saveCountryCode,
            placeOfResidence = saveTree,
            entryDatetime = LocalDateTime.now()
        )
        val savePerson = entityManager.persistAndFlush(person)
        currentPersonSavedId = savePerson.personId
    }

    @Test
    fun `Get a person by id`() {
        val person = repository.findById(currentPersonSavedId).getOrNull()
        assertNotNull(person)
        assertEquals("Person test", person.name)
    }

    @Test
    fun `Save a person`() {
        val newPerson = Person(
            name = "New person",
            age = 20,
            contact = "987654321",
            countryCode = currentCountryCode,
            placeOfResidence = currentPlaceOdResidence,
            entryDatetime = LocalDateTime.now()
        )
        val save = repository.save(newPerson)
        assertEquals("New person", save.name)
    }

    @Test
    fun `Update person by id`() {
        val person = repository.findById(currentPersonSavedId).getOrNull()
        assertNotNull(person)
        val newPerson = person.copy(
            name = "Updated person",
            contact = "123456789"
        )
        val update = repository.save(newPerson)
        assertEquals("Updated person", update.name)
        assertEquals("123456789", update.contact)
    }

    @Test
    fun `Delete person by id`() {
        repository.deleteById(currentPersonSavedId)
        val deleted = repository.findById(currentPersonSavedId).getOrNull()
        assertNull(deleted)
    }
}