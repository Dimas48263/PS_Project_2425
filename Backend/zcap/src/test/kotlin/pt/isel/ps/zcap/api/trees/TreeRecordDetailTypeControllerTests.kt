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
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import pt.isel.ps.zcap.api.invalidDataErrorMessage
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.domain.users.User
import pt.isel.ps.zcap.domain.users.UserDataProfile
import pt.isel.ps.zcap.domain.users.UserProfile
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
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
class TreeRecordDetailTypeControllerTests(
    @Autowired private val mockMvc: MockMvc,
    @Autowired private val repository: TreeRecordDetailTypeRepository,
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
        val treeRecordDetailType = TreeRecordDetailType(
            name = "TreeRecordDetailType1",
            unit = "string",
            startDate = LocalDate.now()
        )
        val saved = repository.save(treeRecordDetailType)
        currentSavedId = saved.detailTypeId
        login()
    }

    @Test
    fun `GET all tree record detail types`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/tree-record-detail-types").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].name").value("TreeRecordDetailType1"))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].unit").value("string"))
    }

    @Test
    fun `GET tree record detail type by id`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/tree-record-detail-types/$currentSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("TreeRecordDetailType1"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.unit").value("string"))
    }

    @Test
    fun `Failed GET tree record detail type by id with invalid id`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/tree-record-detail-types/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Record Detail Type with ID 99 not found."))
    }

    @Test
    fun `Save (POST) tree record detail type`() {
        val jsonBody = """
        {
            "name": "TreeRecordDetailType2",
            "unit": "unit Test",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/tree-record-detail-types")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isCreated)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("TreeRecordDetailType2"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.unit").value("unit Test"))
    }

    @Test
    fun `Failed save (POST) tree record detail  with invalid name`() {
        val jsonBody = """
        {
            "name": "",
            "unit": "unit Test",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/tree-record-detail-types")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value(null))
    }

    @Test
    fun `Failed save (POST) tree record detail with invalid unit`() {
        val jsonBody = """
        {
            "name": "TreeRecordDetailType2",
            "unit": "",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/tree-record-detail-types")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value(null))
    }

    @Test
    fun `Update (PUT) tree record detail type by id`() {
        val jsonBody = """
        {
            "name": "Updated Name",
            "unit": "Updated unit",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/tree-record-detail-types/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("Updated Name"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.unit").value("Updated unit"))
    }

    @Test
    fun `Failed update (PUT) tree record detail type by id with invalid id`() {
        val jsonBody = """
        {
            "name": "Updated Name",
            "unit": "Updated unit",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/tree-record-detail-types/${99}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Record Detail Type with ID 99 not found."))
    }

    @Test
    fun `Failed update (PUT) tree record detail type by id with invalid dates`() {
        val jsonBody = """
        {
            "name": "Updated Name",
            "unit": "Updated unit",
            "startDate": "2025-01-01",
            "endDate": "2024-01-01"
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/tree-record-detail-types/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value(null))
    }

    @Test
    fun `DELETE tree record detail type by id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/tree-record-detail-types/$currentSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNoContent)
            .andExpect(MockMvcResultMatchers.content().string(""))
    }

    @Test
    fun `Failed DELETE tree record detail type by id with invalid id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/tree-record-detail-types/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Record Detail Type with ID 99 not found."))
    }
}