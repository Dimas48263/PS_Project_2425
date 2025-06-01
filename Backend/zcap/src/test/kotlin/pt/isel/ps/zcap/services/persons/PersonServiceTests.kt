package pt.isel.ps.zcap.services.persons

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.persons.Person
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.repository.dto.persons.person.PersonInputModel
import pt.isel.ps.zcap.repository.dto.persons.person.PersonOutputModel
import pt.isel.ps.zcap.repository.models.persons.DepartureDestinationRepository
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import java.sql.Timestamp
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertIs

@ActiveProfiles("test")
@DataJpaTest
class PersonServiceTests {
    @Autowired
    lateinit var repository: PersonRepository

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

    lateinit var servicesTests: PersonService

    var currentPlaceOdResidenceId by Delegates.notNull<Long>()
    var currentCountryCodeId by Delegates.notNull<Long>()
    var currentSavedId by Delegates.notNull<Long>()

    @BeforeEach
    fun setup() {
        repository.deleteAll()
        treeRecordDetailRepository.deleteAll()
        treeRepository.deleteAll()
        treeLevelRepository.deleteAll()
        treeRecordDetailTypeRepository.deleteAll()

        servicesTests = PersonService(
            repository,
            treeRecordDetailRepository,
            treeRepository,
            departureDestinationRepository
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
        currentPlaceOdResidenceId = saveTree.treeRecordId

        val treeRecordDetailType = TreeRecordDetailType(
            name = "Tree Record Detail Type test",
            unit = "string",
            startDate = LocalDate.now()
        )
        val saveTreeRecordDetailType = treeRecordDetailTypeRepository.save(treeRecordDetailType)

        val countryCode = TreeRecordDetail(
            treeRecord = saveTree,
            detailType = saveTreeRecordDetailType,
            valueCol = "country code test",
            startDate = LocalDate.now()
        )
        val saveCountryCode = treeRecordDetailRepository.save(countryCode)
        currentCountryCodeId = saveCountryCode.detailId

        val person = Person(
            name = "Person test",
            age = 20,
            contact = "987654321",
            countryCode = saveCountryCode,
            placeOfResidence = saveTree,
            entryDatetime = LocalDateTime.now()
        )
        val savePerson = repository.save(person)
        currentSavedId = savePerson.personId
    }

    @Test
    fun `get all persons`() {
        val persons = servicesTests.getAllPersons()
        assertEquals(1, persons.size)
        assertEquals("Person test", persons.first().name)
    }

    @Test
    fun `Get person by id`() {
        val person = servicesTests.getPersonById(currentSavedId)
        assertIs<Success<PersonOutputModel>>(person)
        assertEquals("Person test", person.value.name)
    }

    @Test
    fun `Failed get person by id with invalid id`() {
        val person = servicesTests.getPersonById(99)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.RecordNotFound>(person.value)
    }

    @Test
    fun `Save person`() {
        val newPerson = PersonInputModel(
            "New Person",
            18,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.savePerson(newPerson)
        assertIs<Success<PersonOutputModel>>(person)
        assertEquals("New Person", person.value.name)
        assertEquals("123456789", person.value.contact)
        assertEquals("country code test", person.value.countryCode.valueCol)
    }

    @Test
    fun `Failed save person with invalid name`() {
        val newPerson = PersonInputModel(
            "",
            18,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.savePerson(newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.InvalidDataInput>(person.value)
    }

    @Test
    fun `Failed save person with invalid country code`() {
        val newPerson = PersonInputModel(
            "New Person",
            18,
            "123456789",
            99,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.savePerson(newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.CountryCodeNotFound>(person.value)
    }

    @Test
    fun `Failed save person with invalid place of residence`() {
        val newPerson = PersonInputModel(
            "New Person",
            18,
            "123456789",
            currentCountryCodeId,
            99,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.savePerson(newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.TreeNotFound>(person.value)
    }

    @Test
    fun `Failed save person with invalid nationality`() {
        val newPerson = PersonInputModel(
            "New Person",
            18,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            99,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.savePerson(newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.NationalityNotFound>(person.value)
    }

    @Test
    fun `Failed save person with invalid departure destination`() {
        val newPerson = PersonInputModel(
            "",
            18,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            99,
            null
        )
        val person = servicesTests.savePerson(newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.DepartureDestinationNotFound>(person.value)
    }

    @Test
    fun `Update person by id`() {
        val newPerson = PersonInputModel(
            "Updated",
            18,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.updatePersonById(currentSavedId, newPerson)
        assertIs<Success<PersonOutputModel>>(person)
        assertEquals("Updated", person.value.name)
    }

    @Test
    fun `Failed update person by id with invalid name`() {
        val newPerson = PersonInputModel(
            "",
            21,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.updatePersonById(currentSavedId, newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.InvalidDataInput>(person.value)
    }

    @Test
    fun `Failed update person by id with invalid person id`() {
        val newPerson = PersonInputModel(
            "Updated",
            18,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.updatePersonById(99, newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.RecordNotFound>(person.value)
    }

    @Test
    fun `Failed update person by id with invalid country code`() {
        val newPerson = PersonInputModel(
            "Updated",
            18,
            "123456789",
            99,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.updatePersonById(currentSavedId, newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.CountryCodeNotFound>(person.value)
    }

    @Test
    fun `Failed update person by id with invalid place of residence`() {
        val newPerson = PersonInputModel(
            "Updated",
            18,
            "123456789",
            currentCountryCodeId,
            99,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.updatePersonById(currentSavedId, newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.TreeNotFound>(person.value)
    }

    @Test
    fun `Failed update person by id with invalid nationality`() {
        val newPerson = PersonInputModel(
            "Updated",
            18,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            99,
            null,
            null,
            null,
            null
        )
        val person = servicesTests.updatePersonById(currentSavedId, newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.NationalityNotFound>(person.value)
    }

    @Test
    fun `Failed update person by id with invalid departure destination`() {
        val newPerson = PersonInputModel(
            "Updated",
            18,
            "123456789",
            currentCountryCodeId,
            currentPlaceOdResidenceId,
            LocalDateTime.now(),
            null,
            null,
            null,
            null,
            null,
            99,
            null
        )
        val person = servicesTests.updatePersonById(currentSavedId, newPerson)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.DepartureDestinationNotFound>(person.value)
    }

    @Test
    fun `Delete person by id`() {
        val person = servicesTests.deletePersonById(currentSavedId)
        assertIs<Success<Unit>>(person)
    }

    @Test
    fun `Failed delete person by id with invalid id`() {
        val person = servicesTests.deletePersonById(99)
        assertIs<Failure<ServiceErrors>>(person)
        assertIs<ServiceErrors.RecordNotFound>(person.value)
    }
}