package pt.isel.ps.zcap.services.persons

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.persons.Person
import pt.isel.ps.zcap.domain.persons.PersonSpecialNeed
import pt.isel.ps.zcap.domain.persons.SpecialNeed
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedInputModel
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedOutputModel
import pt.isel.ps.zcap.repository.models.persons.DepartureDestinationRepository
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import pt.isel.ps.zcap.repository.models.persons.PersonSpecialNeedRepository
import pt.isel.ps.zcap.repository.models.persons.SpecialNeedRepository
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.Month
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertIs

@ActiveProfiles("test")
@DataJpaTest
class PersonSpecialNeedServiceTests {
    @Autowired
    lateinit var repository: PersonSpecialNeedRepository

    @Autowired
    lateinit var specialNeedRepository: SpecialNeedRepository

    @Autowired
    lateinit var personRepository: PersonRepository

    @Autowired
    lateinit var treeRecordDetailRepository: TreeRecordDetailRepository

    @Autowired
    lateinit var treeRepository: TreeRepository

    @Autowired
    lateinit var departureDestinationRepository: DepartureDestinationRepository

    @Autowired
    lateinit var treeLevelRepository: TreeLevelRepository

    @Autowired
    lateinit var treeRecordDetailTypeRepository: TreeRecordDetailTypeRepository

    lateinit var servicesTests: PersonSpecialNeedService

    var currentPersonId by Delegates.notNull<Long>()
    var currentSpecialNeedId by Delegates.notNull<Long>()
    var currentSavedId by Delegates.notNull<Long>()

    @BeforeEach
    fun setup() {
        repository.deleteAll()
        specialNeedRepository.deleteAll()
        personRepository.deleteAll()
        treeRecordDetailRepository.deleteAll()
        treeRepository.deleteAll()
        treeLevelRepository.deleteAll()
        treeRecordDetailTypeRepository.deleteAll()

        servicesTests = PersonSpecialNeedService(
            repository,
            personRepository,
            specialNeedRepository,
        )
        val treeLevel = TreeLevel(
            levelId = 1,
            name = "Tree Level test",
            description = "Description tree level",
            startDate = LocalDate.now()
        )
        val saveTreeLevel = treeLevelRepository.save(treeLevel)

        val tree = Tree(
            name = "Tree Test",
            treeLevel = saveTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        val saveTree = treeRepository.save(tree)

        val person = Person(
            name = "Person test",
            age = 20,
            contact = "987654321",
            placeOfResidence = saveTree,
            entryDatetime = LocalDateTime.now()
        )
        val savePerson = personRepository.save(person)
        currentPersonId = savePerson.personId

        val specialNeed = SpecialNeed(
            name = "Special Need test",
        )
        val saveSpecialNeed = specialNeedRepository.save(specialNeed)
        currentSpecialNeedId = saveSpecialNeed.specialNeedId

        val personSpecialNeed = PersonSpecialNeed(
            person = person,
            specialNeed = specialNeed,
            description = "Some description",
        )
        val savePersonSpecialNeed = repository.save(personSpecialNeed)
        currentSavedId = savePersonSpecialNeed.personSpecialNeedId
    }
    @Test
    fun `get all person special needs`() {
        val psn = servicesTests.getAllPersonSpecialNeeds()
        assertEquals(1, psn.size)
        assertEquals("Person test", psn.first().person.name)
        assertEquals("Some description", psn.first().description)
        assertEquals("Special Need test", psn.first().specialNeed.name)
    }

    @Test
    fun `Get person special need by id`() {
        val psn = servicesTests.getPersonSpecialNeedById(currentSavedId)
        assertIs<Success<PersonSpecialNeedOutputModel>>(psn)
        assertEquals("Person test", psn.value.person.name)
        assertEquals("Some description", psn.value.description)
        assertEquals("Special Need test", psn.value.specialNeed.name)
    }

    @Test
    fun `Failed get person special need by id with invalid id`() {
        val psn = servicesTests.getPersonSpecialNeedById(99)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.RecordNotFound>(psn.value)
    }

    @Test
    fun `Save person special need`() {
        val newPsn = PersonSpecialNeedInputModel(
            currentPersonId,
            currentSpecialNeedId,
            "Some description test 2",
            LocalDate.now(),
            null,
            LocalDateTime.now(),
            LocalDateTime.now()
        )
        val psn = servicesTests.savePersonSpecialNeed(newPsn)
        assertIs<Success<PersonSpecialNeedOutputModel>>(psn)
        assertEquals("Person test", psn.value.person.name)
        assertEquals("Some description test 2", psn.value.description)
        assertEquals("Special Need test", psn.value.specialNeed.name)
    }

    @Test
    fun `Failed save person special need with invalid person id`() {
        val newPsn = PersonSpecialNeedInputModel(
            99,
            currentSpecialNeedId,
            "Some description test 2",
            LocalDate.now(),
            null,
            LocalDateTime.now(),
            LocalDateTime.now()
        )
        val psn = servicesTests.savePersonSpecialNeed(newPsn)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.PersonNotFound>(psn.value)
    }

    @Test
    fun `Failed save person special need with invalid special need id`() {
        val newPsn = PersonSpecialNeedInputModel(
            currentPersonId,
            99,
            "Some description test 2",
            LocalDate.now(),
            null,
            LocalDateTime.now(),
            LocalDateTime.now()
        )
        val psn = servicesTests.savePersonSpecialNeed(newPsn)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.SpecialNeedNotFound>(psn.value)
    }

    @Test
    fun `Failed save person special need with invalid dates`() {
        val newPsn = PersonSpecialNeedInputModel(
            currentPersonId,
            currentSpecialNeedId,
            "Some description test 2",
            LocalDate.of(2025,Month.JANUARY,1),
            LocalDate.of(2024,Month.JANUARY,1),
            LocalDateTime.now(),
            LocalDateTime.now()
        )
        val psn = servicesTests.savePersonSpecialNeed(newPsn)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.InvalidDataInput>(psn.value)
    }
    @Test
    fun `Update person by id`() {
        val newPsn = PersonSpecialNeedInputModel(
            currentPersonId,
            currentSpecialNeedId,
            "updated description",
            LocalDate.now(),
            null,
            LocalDateTime.now(),
            LocalDateTime.now()
        )
        val psn = servicesTests.updatePersonSpecialNeedById(currentSavedId, newPsn)
        assertIs<Success<PersonSpecialNeedOutputModel>>(psn)
        assertEquals("updated description", psn.value.description)
    }

    @Test
    fun `Failed update person special need by id with invalid id`() {
        val newPsn = PersonSpecialNeedInputModel(
            currentPersonId,
            currentSpecialNeedId,
            "updated description",
            LocalDate.now(),
            null,
            LocalDateTime.now(),
            LocalDateTime.now()
        )
        val psn = servicesTests.updatePersonSpecialNeedById(99, newPsn)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.RecordNotFound>(psn.value)
    }

    @Test
    fun `Failed update person special need by id with invalid person id`() {
        val newPsn = PersonSpecialNeedInputModel(
            99,
            currentSpecialNeedId,
            "updated description",
            LocalDate.now(),
            null,
            LocalDateTime.now(),
            LocalDateTime.now()
        )
        val psn = servicesTests.updatePersonSpecialNeedById(currentSavedId, newPsn)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.PersonNotFound>(psn.value)
    }

    @Test
    fun `Failed update person special need by id with invalid special need id`() {
        val newPsn = PersonSpecialNeedInputModel(
            currentPersonId,
            99,
            "updated description",
            LocalDate.now(),
            null,
            LocalDateTime.now(),
            LocalDateTime.now()
        )
        val psn = servicesTests.updatePersonSpecialNeedById(currentSavedId, newPsn)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.SpecialNeedNotFound>(psn.value)
    }

    @Test
    fun `Failed update person special need by id with invalid updated updated date`() {
        val newPsn = PersonSpecialNeedInputModel(
            currentPersonId,
            currentSpecialNeedId,
            "updated description",
            LocalDate.now(),
            null,
            LocalDateTime.now(),
            LocalDateTime.of(2024, Month.JANUARY, 1, 0, 0)
        )
        val psn = servicesTests.updatePersonSpecialNeedById(currentSavedId, newPsn)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.InvalidDataInput>(psn.value)
    }


    @Test
    fun `Delete person by id`() {
        val psn = servicesTests.deletePersonSpecialNeedById(currentSavedId)
        assertIs<Success<Unit>>(psn)
    }

    @Test
    fun `Failed delete person by id with invalid id`() {
        val psn = servicesTests.deletePersonSpecialNeedById(99)
        assertIs<Failure<ServiceErrors>>(psn)
        assertIs<ServiceErrors.RecordNotFound>(psn.value)
    }
}