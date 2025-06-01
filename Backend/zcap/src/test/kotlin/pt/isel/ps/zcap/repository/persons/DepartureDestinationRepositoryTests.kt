package pt.isel.ps.zcap.repository.persons

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.persons.DepartureDestination
import pt.isel.ps.zcap.repository.models.persons.DepartureDestinationRepository
import java.time.LocalDate
import kotlin.jvm.optionals.getOrNull
import kotlin.properties.Delegates
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull
import kotlin.test.assertTrue

@ActiveProfiles("test")

@DataJpaTest
class DepartureDestinationRepositoryTests {
    @Autowired
    lateinit var entityManager: TestEntityManager

    @Autowired
    lateinit var repository: DepartureDestinationRepository

    var currentSavedId by Delegates.notNull<Long>()
    @BeforeEach
    fun setup() {
        repository.deleteAll()
        val departureDestination = DepartureDestination(
            name = "departure destination test",
            startDate = LocalDate.now()
        )
        val persisted = entityManager.persistAndFlush(departureDestination)
        currentSavedId = persisted.departureDestinationId
    }
    @Test
    fun `should get all DepartureDestinations`() {
        val list = repository.findAll()
        assertTrue(list.size == 1)
        val first = list.first()
        assertEquals("departure destination test", first.name)
    }

    @Test
    fun `should get DepartureDestination by id`() {
        val departureDestination = repository.findById(currentSavedId).getOrNull()
        assertNotNull(departureDestination)
        assertEquals("departure destination test", departureDestination.name)
    }

    @Test
    fun `should save DepartureDestination`() {
        val newDepartureDestination = DepartureDestination(
            name = "Test 2",
            startDate = LocalDate.now()
        )
        val save = repository.save(newDepartureDestination)
        assertEquals("Test 2", save.name)
    }

    @Test
    fun `should delete DepartureDestination`() {
        repository.deleteById(currentSavedId)
        val deleted = repository.findById(currentSavedId).getOrNull()
        assertNull(deleted)
    }
}