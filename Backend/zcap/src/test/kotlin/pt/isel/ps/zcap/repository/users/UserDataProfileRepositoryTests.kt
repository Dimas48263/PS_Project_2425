package pt.isel.ps.zcap.repository.users

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfile
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileRepository
import java.time.LocalDate
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@ActiveProfiles("test")

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) //Test with the real Database
class UserDataProfileRepositoryTests(
//    @Autowired val testEntityManager: TestEntityManager //Using memory database instead
    @Autowired val repository: UserDataProfileRepository, //Dependency
) {

//            |------------------------------------------------------>    DataProfile 1
//                    |-------------------|                               DataProfile 2
//    |-----------------------------------------------|                   DataProfile 3

    val dataProfile1 = UserDataProfile(
        name = "Profile 1",
        startDate = LocalDate.parse("2020-01-01"),
        endDate = null,
    )
    val dataProfile2 = UserDataProfile(
        name = "Profile 2",
        startDate = LocalDate.parse("2021-01-01"),
        endDate = LocalDate.parse("2021-12-31"),
    )
    val dataProfile3 = UserDataProfile(
        name = "Profile 3",
        startDate = LocalDate.parse("2010-01-01"),
        endDate = LocalDate.parse("2025-01-01"),
    )

    @BeforeEach
    fun setup() {
        repository.deleteAll()
        repository.saveAll(listOf(dataProfile1, dataProfile2, dataProfile3))
    }

    @Test
    fun `Should find 0 profiles at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2000-01-01"))

        assertEquals(0, results.size)
    }

    @Test
    fun `Should find only profile3 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2019-01-01"))

        assertTrue(results.contains(dataProfile3))
        assertEquals(1, results.size)
    }

    @Test
    fun `Should find profile1 and profile3 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2020-01-01"))
        assertTrue(results.containsAll(listOf(dataProfile1, dataProfile3)))
        assertEquals(2, results.size)

        val otherResults = repository.findValidOnDate(LocalDate.parse("2024-01-01"))
        assertTrue(otherResults.containsAll(listOf(dataProfile1, dataProfile3)))
        assertEquals(2, otherResults.size)
    }

    @Test
    fun `Should find all 3 profiles at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2021-05-01"))

        assertTrue(results.containsAll(listOf(dataProfile1, dataProfile2, dataProfile3)))
    }

    @Test
    fun `Should find only profile1 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2028-05-01"))

        assertTrue(results.contains(dataProfile1))
        assertEquals(1, results.size)
    }
}