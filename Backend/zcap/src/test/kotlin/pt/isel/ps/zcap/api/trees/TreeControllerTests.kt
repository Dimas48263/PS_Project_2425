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
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.users.User
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfile
import pt.isel.ps.zcap.domain.users.userProfile.UserProfile
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileRepository
import pt.isel.ps.zcap.repository.models.users.userProfile.UserProfileRepository
import pt.isel.ps.zcap.repository.models.users.UserRepository
import pt.isel.ps.zcap.utils.PasswordEncoder
import java.time.LocalDate
import kotlin.properties.Delegates
import kotlin.test.assertNotNull

@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureTestDatabase
@ActiveProfiles("test")
class TreeControllerTests(
    @Autowired private val mockMvc: MockMvc,
    @Autowired private val treeRepository: TreeRepository,
    @Autowired private val treeLevelRepository: TreeLevelRepository,
    @Autowired private val userRepository: UserRepository,
    @Autowired private val userProfileRepository: UserProfileRepository,
    @Autowired private val userDataProfileRepository: UserDataProfileRepository
){
    var currentTreeSavedId by Delegates.notNull<Long>()
    var currentTreeLevelSavedId by Delegates.notNull<Long>()
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
        treeRepository.deleteAll()
        treeLevelRepository.deleteAll()
        userRepository.deleteAll()
        userProfileRepository.deleteAll()
        userDataProfileRepository.deleteAll()
    }

    @BeforeEach
    fun setup() {
        clean()

        val treeLevel = TreeLevel(
            levelId = 1,
            name = "TreeLevel1",
            description = null,
            startDate = LocalDate.now()
        )
        val treeLevelSave = treeLevelRepository.save(treeLevel)
        currentTreeLevelSavedId= treeLevelSave.treeLevelId

        val tree = Tree(
            name = "Tree1",
            treeLevel = treeLevel,
            parent = null,
            startDate = LocalDate.now()
        )

        val saved = treeRepository.save(tree)
        currentTreeSavedId = saved.treeRecordId
        login()
    }

    @Test
    fun `GET all trees`() {
        mockMvc.perform(get("/api/trees").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].name").value("Tree1"))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].treeLevel.name").value("TreeLevel1"))
    }

    @Test
    fun `GET tree by id`() {
        mockMvc.perform(get("/api/trees/$currentTreeSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("Tree1"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.treeLevel.name").value("TreeLevel1"))
    }

    @Test
    fun `Failed GET tree by id with wrong id`() {
        mockMvc.perform(get("/api/trees/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree with ID 99 not found."))
    }

    @Test
    fun `Save (POST) tree`() {
        val jsonBody = """
        {
            "name": "Tree2",
            "treeLevelId": $currentTreeLevelSavedId,
            "parentId": null,
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            post("/api/trees")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isCreated)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("Tree2"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.treeLevel.name").value("TreeLevel1"))
    }

    @Test
    fun `Failed save (POST) tree with invalid name`() {
        val jsonBody = """
        {
            "name": "",
            "treeLevelId": $currentTreeLevelSavedId,
            "parentId": null,
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            post("/api/trees")
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
    fun `Failed save (POST) tree with invalid tree level id`() {
        val jsonBody = """
        {
            "name": "Tree2",
            "treeLevelId": ${99},
            "parentId": null,
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            post("/api/trees")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Level with ID 99 not found."))
    }

    @Test
    fun `Failed save (POST) tree with invalid parent id`() {
        val jsonBody = """
        {
            "name": "Tree2",
            "treeLevelId": $currentTreeLevelSavedId,
            "parentId": ${99},
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            post("/api/trees")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Parent with ID 99 not found."))
    }

    @Test
    fun `Update (Put) tree by id`() {
        val jsonBody = """
        {
            "name": "UpdatedName",
            "treeLevelId": $currentTreeLevelSavedId,
            "parentId": null,
            "startDate": "2025-02-27",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/trees/$currentTreeSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("UpdatedName"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.startDate").value("2025-02-27"))
    }

    @Test
    fun `Failed update (Put) tree by id with invalid id`() {
        val jsonBody = """
        {
            "name": "UpdatedName",
            "treeLevelId": $currentTreeLevelSavedId,
            "parentId": null,
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/trees/${99}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree with ID 99 not found."))
    }

    @Test
    fun `Failed update (Put) tree by id with invalid parent id`() {
        val jsonBody = """
        {
            "name": "UpdatedName",
            "treeLevelId": $currentTreeLevelSavedId,
            "parentId": ${99},
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/trees/$currentTreeSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Parent with ID 99 not found."))
    }

    @Test
    fun `Failed update (Put) tree by id with invalid tree level id`() {
        val jsonBody = """
        {
            "name": "UpdatedName",
            "treeLevelId": ${99},
            "parentId": null,
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/trees/$currentTreeSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Level with ID 99 not found."))
    }

    @Test
    fun `Failed update (Put) tree by id with invalid name`() {
        val jsonBody = """
        {
            "name": "",
            "treeLevelId": $currentTreeLevelSavedId,
            "parentId": null,
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/trees/$currentTreeSavedId")
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
    fun `DELETE tree by id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/trees/$currentTreeSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNoContent)
            .andExpect(MockMvcResultMatchers.content().string(""))
    }

    @Test
    fun `Failed DELETE tree by id with invalid id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/trees/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree with ID 99 not found."))
    }
}