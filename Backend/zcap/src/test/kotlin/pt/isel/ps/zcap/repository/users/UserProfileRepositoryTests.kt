package pt.isel.ps.zcap.repository.users

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.users.UserProfile
import pt.isel.ps.zcap.repository.models.users.UserProfileRepository
import java.time.LocalDate
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@ActiveProfiles("test")

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) //Test with the real Database
class UserProfileRepositoryTests(
//    @Autowired val testEntityManager: TestEntityManager //Using memory database instead
    @Autowired val repository: UserProfileRepository, //Dependency
) {

//            |------------------------------------------------------>    Profile 1
//                    |-------------------|                               Profile 2
//    |-----------------------------------------------|                   Profile 3

    val profile1 = UserProfile(
        name = "Profile 1",
        startDate = LocalDate.parse("2020-01-01"),
        endDate = null,
    )
    val profile2 = UserProfile(
        name = "Profile 2",
        startDate = LocalDate.parse("2021-01-01"),
        endDate = LocalDate.parse("2021-12-31"),
    )
    val profile3 = UserProfile(
        name = "Profile 3",
        startDate = LocalDate.parse("2010-01-01"),
        endDate = LocalDate.parse("2025-01-01"),
    )

    @BeforeEach
    fun setup() {
        repository.deleteAll()
        repository.saveAll(listOf(profile1, profile2, profile3))
    }

    @Test
    fun `should save and retrieve a user profile`() {
        val testProfile = UserProfile(
            name = "User profile",
            startDate = LocalDate.now()
        )

        repository.save(testProfile)
//        entityManager.persistAndFlush(testTreeLevel)

        val profile = repository.findById(testProfile.userProfileId)
        assertTrue { profile.isPresent }
        assertEquals("User profile", profile.get().name)
    }


    @Test
    fun `Should find 0 profiles at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2000-01-01"))

        assertEquals(0, results.size)
    }

    @Test
    fun `Should find only profile3 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2019-01-01"))

        assertTrue(results.contains(profile3))
        assertEquals(1, results.size)
    }

    @Test
    fun `Should find profile1 and profile3 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2020-01-01"))
        assertTrue(results.containsAll(listOf(profile1, profile3)))
        assertEquals(2, results.size)

        val otherResults = repository.findValidOnDate(LocalDate.parse("2024-01-01"))
        assertTrue(otherResults.containsAll(listOf(profile1, profile3)))
        assertEquals(2, otherResults.size)
    }

    @Test
    fun `Should find all 3 profiles at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2021-05-01"))

        assertTrue(results.containsAll(listOf(profile1, profile2, profile3)))
    }

    @Test
    fun `Should find only profile1 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2028-05-01"))

        assertTrue(results.contains(profile1))
        assertEquals(1, results.size)
    }
}