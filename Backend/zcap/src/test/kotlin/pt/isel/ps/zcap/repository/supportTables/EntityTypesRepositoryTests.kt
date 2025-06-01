package pt.isel.ps.zcap.repository.supportTables

import org.junit.jupiter.api.BeforeEach
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.supportTables.EntityType
import pt.isel.ps.zcap.repository.models.supportTables.EntityTypeRepository
import java.time.LocalDate
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@ActiveProfiles("test")
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) //Test with the real Database
class EntityTypesRepositoryTests(
    @Autowired val repository: EntityTypeRepository
) {
//            |------------------------------------------------------> EntityType 1
//                    |-------------------|                            EntityType 2
//    |-----------------------------------------------|                EntityType 3

    val entityType1 = EntityType(
        name = "Entity type 1",
        startDate = LocalDate.parse("2020-01-01"),
        endDate = null,
    )
    val entityType2 = EntityType(
        name = "Entity type 2",
        startDate = LocalDate.parse("2021-01-01"),
        endDate = LocalDate.parse("2021-12-31"),
    )
    var entityType3 = EntityType(
        name = "Entity type 3",
        startDate = LocalDate.parse("2010-01-01"),
        endDate = LocalDate.parse("2025-01-01"),
    )

    @BeforeEach
    fun setup() {
        repository.deleteAll()
        repository.saveAll(listOf(entityType1, entityType2, entityType3))
    }

    @Test
    fun `should find 0 on date before any of the records`() {
        val results = repository.findValidOnDate(LocalDate.parse("2009-12-31"))

        assertEquals(0, results.size)
    }

    @Test
    fun `Should find only profile3 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2019-01-01"))

        assertTrue(results.contains(entityType3))
        assertEquals(1, results.size)
    }

    @Test
    fun `Should find profile1 and profile3 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2020-01-01"))
        assertTrue(results.containsAll(listOf(entityType1, entityType3)))
        assertEquals(2, results.size)

        val otherResults = repository.findValidOnDate(LocalDate.parse("2024-01-01"))
        assertTrue(otherResults.containsAll(listOf(entityType1, entityType3)))
        assertEquals(2, otherResults.size)
    }

    @Test
    fun `Should find all 3 profiles at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2021-05-01"))

        assertTrue(results.containsAll(listOf(entityType1, entityType2, entityType3)))
    }

    @Test
    fun `Should find only profile1 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2028-05-01"))

        assertTrue(results.contains(entityType1))
        assertEquals(1, results.size)
    }
}