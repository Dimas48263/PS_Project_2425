package pt.isel.ps.zcap.services.persons

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.persons.DepartureDestination
import pt.isel.ps.zcap.repository.dto.persons.departureDestination.DepartureDestinationInputModel
import pt.isel.ps.zcap.repository.models.persons.DepartureDestinationRepository
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import java.time.LocalDate
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@ActiveProfiles("test")
@DataJpaTest
class DepartureDestinationServiceTests {
    @Autowired
    lateinit var repository: DepartureDestinationRepository

    lateinit var servicesTests: DepartureDestinationService

    var currentSavedId by Delegates.notNull<Long>()

    @BeforeEach
    fun setUp() {
        servicesTests = DepartureDestinationService(repository)
        val departureDestination = DepartureDestination(
            name = "departure destination test",
            startDate = LocalDate.now()
        )
        val save = repository.save(departureDestination)
        currentSavedId = save.departureDestinationId
    }

    @Test
    fun `should get all DepartureDestinations`() {
        val list = servicesTests.getAllDepartureDestinations()
        assertTrue(list.size == 1)
        val first = list.first()
        assertEquals("departure destination test", first.name)
    }

    @Test
    fun `should get DepartureDestination by id`() {
        val departureDestination = servicesTests.getDepartureDestinationById(currentSavedId)
        assertTrue(departureDestination is Success)
        assertEquals("departure destination test", departureDestination.value.name)
    }

    @Test
    fun `should fail to get DepartureDestination by id with invalid id`() {
        val departureDestination = servicesTests.getDepartureDestinationById(99)
        assertTrue(departureDestination is Failure)
        assertTrue(departureDestination.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `should save DepartureDestination`() {
        val newDepartureDestination = DepartureDestinationInputModel(
            "Test 2",
            LocalDate.now(),
            null
        )
        val save = servicesTests.saveDepartureDestination(newDepartureDestination)
        assertTrue(save is Success)
        assertEquals("Test 2", save.value.name)
    }

    @Test
    fun `should fail save DepartureDestination by invalid name`() {
        val newDepartureDestination = DepartureDestinationInputModel(
            "",
            LocalDate.now(),
            null
        )
        val save = servicesTests.saveDepartureDestination(newDepartureDestination)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `should fail save DepartureDestination by invalid dates`() {
        val newDepartureDestination = DepartureDestinationInputModel(
            "",
            LocalDate.parse("2025-01-01"),
            LocalDate.parse("2024-01-01")
        )
        val save = servicesTests.saveDepartureDestination(newDepartureDestination)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `should update DepartureDestination by id`() {
        val newDepartureDestination = DepartureDestinationInputModel(
            "Updated",
            LocalDate.now(),
            null
        )
        val save = servicesTests.updateDepartureDestinationById(currentSavedId, newDepartureDestination)
        assertTrue(save is Success)
        assertEquals("Updated", save.value.name)
        assertEquals(currentSavedId, save.value.departureDestinationId)
    }

    @Test
    fun `should fail update DepartureDestination by id by invalid id`() {
        val newDepartureDestination = DepartureDestinationInputModel(
            "Updated",
            LocalDate.now(),
            null
        )
        val save = servicesTests.updateDepartureDestinationById(99, newDepartureDestination)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.RecordNotFound)
    }

    @Test
    fun `should fail update DepartureDestination by id by invalid name`() {
        val newDepartureDestination = DepartureDestinationInputModel(
            "",
            LocalDate.now(),
            null
        )
        val save = servicesTests.updateDepartureDestinationById(currentSavedId, newDepartureDestination)
        assertTrue(save is Failure)
        assertTrue(save.value is ServiceErrors.InvalidDataInput)
    }

    @Test
    fun `should delete DepartureDestination by id`() {
        val deleted = servicesTests.deleteDepartureDestinationById(currentSavedId)
        assertTrue(deleted is Success)
    }

    @Test
    fun `should fail delete DepartureDestination by id by invalid id`() {
        val deleted = servicesTests.deleteDepartureDestinationById(99)
        assertTrue(deleted is Failure)
        assertTrue(deleted.value is ServiceErrors.RecordNotFound)
    }
}