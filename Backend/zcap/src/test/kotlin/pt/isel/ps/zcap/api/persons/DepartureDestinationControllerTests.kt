package pt.isel.ps.zcap.api.persons

import jakarta.servlet.http.Cookie
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.MediaType
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import pt.isel.ps.zcap.domain.persons.DepartureDestination
import pt.isel.ps.zcap.domain.users.User
import pt.isel.ps.zcap.domain.users.UserDataProfile
import pt.isel.ps.zcap.domain.users.UserProfile
import pt.isel.ps.zcap.repository.models.persons.DepartureDestinationRepository
import pt.isel.ps.zcap.repository.models.users.UserDataProfileRepository
import pt.isel.ps.zcap.repository.models.users.UserProfileRepository
import pt.isel.ps.zcap.repository.models.users.UserRepository
import pt.isel.ps.zcap.utils.PasswordEncoder
import java.time.LocalDate
import kotlin.properties.Delegates
import kotlin.test.assertNotNull

@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureTestDatabase
@ActiveProfiles("test")
class DepartureDestinationControllerTests(
    @Autowired private val mockMvc: MockMvc,
    @Autowired private val repository: DepartureDestinationRepository,
    @Autowired private val userRepository: UserRepository,
    @Autowired private val userProfileRepository: UserProfileRepository,
    @Autowired private val userDataProfileRepository: UserDataProfileRepository
) {
    var currentSavedId by Delegates.notNull<Long>()
    var cookie by Delegates.notNull<Cookie>()


    private fun login() {
        val userDataProfile = UserDataProfile(
            name = "Test Region"
        )
        val saveUserDataProfile = userDataProfileRepository.save(userDataProfile)

        val userProfile = UserProfile(
            name = "admin"
        )
        val saveUserProfile = userProfileRepository.save(userProfile)

        val user = User(
            userName = "admin",
            name = "administration",
            password = PasswordEncoder().encrypt("admin"),
            userProfile = saveUserProfile,
            userDataProfile = saveUserDataProfile
        )
        val saveUser = userRepository.save(user)

        val loginPayload = """
        {
            "userName": "admin",
            "password": "admin"
        }
    """.trimIndent()

        val loginResult = mockMvc.perform(
            MockMvcRequestBuilders.post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(loginPayload)
        ).andExpect(MockMvcResultMatchers.status().isOk)
            .andReturn()

        val jwtCookie = loginResult.response.cookies.firstOrNull { it.name == "jwt" }
        assertNotNull(jwtCookie) { "JWT cookie not found in login response" }
        cookie = jwtCookie
    }

    @AfterEach
    fun clean() {
        repository.deleteAll()
        userRepository.deleteAll()
        userProfileRepository.deleteAll()
        userDataProfileRepository.deleteAll()
    }

    @BeforeEach
    fun setUp() {
        clean()
        val departureDestination = DepartureDestination(
            name = "departure destination test",
            startDate = LocalDate.now()
        )
        val save = repository.save(departureDestination)
        currentSavedId = save.departureDestinationId
        login()
    }

    @Test
    fun `GET all DepartureDestinations`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/departure-destinations").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].name").value("departure destination test"))
    }

    @Test
    fun `GET DepartureDestination by id`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/departure-destinations/$currentSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("departure destination test"))
    }

    @Test
    fun `Failed GET DepartureDestination by id with invalid id`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/departure-destinations/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Save (POST) DepartureDestination`() {
        val jsonBody = """
        {
            "name": "New departure destination",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/departure-destinations")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isCreated)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("New departure destination"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.startDate").value("2025-01-01"))
    }

    @Test
    fun `Failed save (POST) DepartureDestination with invalid name`() {
        val jsonBody = """
        {
            "name": "",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/departure-destinations")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided."))
    }

    @Test
    fun `Failed save (POST) DepartureDestination with invalid dates`() {
        val jsonBody = """
        {
            "name": "New departure destination",
            "startDate": "2025-01-01",
            "endDate": "2024-01-01"
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/departure-destinations")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided."))
    }

    @Test
    fun `Update (PUT) DepartureDestination by id`() {
        val jsonBody = """
        {
            "name": "Updated departure destination",
            "startDate": "2025-01-01",
            "endDate": "2025-12-25"
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/departure-destinations/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("Updated departure destination"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.startDate").value("2025-01-01"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.endDate").value("2025-12-25"))
    }

    @Test
    fun `Failed update (PUT) DepartureDestination by id with invalid name`() {
        val jsonBody = """
        {
            "name": "",
            "startDate": "2025-01-01",
            "endDate": "2025-12-25"
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/departure-destinations/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided."))
    }

    @Test
    fun `Failed update (PUT) DepartureDestination by id with invalid departure destination id`() {
        val jsonBody = """
        {
            "name": "Updated departure destination",
            "startDate": "2025-01-01",
            "endDate": "2025-12-25"
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/departure-destinations/${99}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `DELETE DepartureDestination by id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/departure-destinations/$currentSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNoContent)
            .andExpect(MockMvcResultMatchers.content().string(""))
    }

    @Test
    fun `Failed DELETE DepartureDestination by id with invalid departure destination id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/departure-destinations/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }
}