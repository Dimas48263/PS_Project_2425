package pt.isel.ps.zcap.api.trees

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
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.*
import pt.isel.ps.zcap.api.invalidDataErrorMessage
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.users.User
import pt.isel.ps.zcap.domain.users.UserDataProfile
import pt.isel.ps.zcap.domain.users.UserProfile
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
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
class TreeLevelControllerTests(
    @Autowired private val mockMvc: MockMvc,
    @Autowired private val repository: TreeLevelRepository,
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
    fun setup() {
        clean()
        repository.deleteAll()
        val treeLevel = TreeLevel(
            levelId = 1,
            name = "TreeLevel1",
            description = null,
            startDate = LocalDate.now()
        )
        val saved = repository.save(treeLevel)
        currentSavedId = saved.treeLevelId
        login()
    }

    @Test
    fun `GET all tree levels`() {
        mockMvc.perform(get("/api/tree-levels").cookie(cookie))
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.length()").value(1))
            .andExpect(jsonPath("$[0].name").value("TreeLevel1"))
    }

    @Test
    fun `GET tree level by id`() {
        mockMvc.perform(get("/api/tree-levels/$currentSavedId").cookie(cookie))
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.name").value("TreeLevel1"))
    }

    @Test
    fun `Failed GET tree level by wrong id`() {
        mockMvc.perform(get("/api/tree-levels/${99}").cookie(cookie))
            .andExpect(status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Level with ID 99 not found"))
    }

    @Test
    fun `Save (POST) tree level`() {
        val jsonBody = """
        {
            "levelId": 2,
            "name": "TreeLevel2",
            "description": "Some Description",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            post("/api/tree-levels")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(status().isCreated)
            .andExpect(jsonPath("$.name").value("TreeLevel2"))
            .andExpect(jsonPath("$.levelId").value(2))
    }

    @Test
    fun `Failed save (POST) tree level with invalid name`() {
        val jsonBody = """
        {
            "levelId": 2,
            "name": "",
            "description": "Some Description",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            post("/api/tree-levels")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value(null))
    }

    @Test
    fun `Failed save (POST) tree level with invalid dates`() {
        val jsonBody = """
        {
            "levelId": 2,
            "name": "TreeLevel2",
            "description": "Some Description",
            "startDate": "2025-01-01",
            "endDate": "2024-01-01"
        }
    """.trimIndent()
        mockMvc.perform(
            post("/api/tree-levels")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value(null))
    }

    @Test
    fun `Update (Put) tree level by id`() {
        val jsonBody = """
        {
            "levelId": 3,
            "name": "UpdatedName",
            "description": "Add some description",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            put("/api/tree-levels/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.name").value("UpdatedName"))
            .andExpect(jsonPath("$.levelId").value(3))
            .andExpect(jsonPath("$.description").value("Add some description"))
    }

    @Test
    fun `Failed Update (Put) tree level by id with wrong id`() {
        val jsonBody = """
        {
            "levelId": 3,
            "name": "UpdatedName",
            "description": "Add some description",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            put("/api/tree-levels/${99}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Level with ID 99 not found"))
    }

    @Test
    fun `Failed Update (Put) tree level by id with wrong name`() {
        val jsonBody = """
        {
            "levelId": 3,
            "name": "",
            "description": "Add some description",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            put("/api/tree-levels/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value(null))
    }

    @Test
    fun `DELETE tree level by id`() {
        mockMvc.perform(delete("/api/tree-levels/$currentSavedId").cookie(cookie))
            .andExpect(status().isNoContent)
            .andExpect(content().string(""))
    }

    @Test
    fun `Failed DELETE tree level by id with wrong id`() {
        mockMvc.perform(delete("/api/tree-levels/${99}").cookie(cookie))
            .andExpect(status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Level with ID 99 not found"))
    }
}
