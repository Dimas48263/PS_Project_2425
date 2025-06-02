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
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.domain.users.User
import pt.isel.ps.zcap.domain.users.UserDataProfile
import pt.isel.ps.zcap.domain.users.UserProfile
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
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
class TreeRecordDetailControllerTests(
    @Autowired private val mockMvc: MockMvc,
    @Autowired private val treeRepository: TreeRepository,
    @Autowired private val treeLevelRepository: TreeLevelRepository,
    @Autowired private val treeRecordDetailTypeRepository: TreeRecordDetailTypeRepository,
    @Autowired private val treeRecordDetailRepository: TreeRecordDetailRepository,
    @Autowired private val userRepository: UserRepository,
    @Autowired private val userProfileRepository: UserProfileRepository,
    @Autowired private val userDataProfileRepository: UserDataProfileRepository
) {
    var currentTreeSavedId by Delegates.notNull<Long>()
    var currentTreeLevelSavedId by Delegates.notNull<Long>()
    var currentTreeRecordDetailTypeSavedId by Delegates.notNull<Long>()
    var currentTreeRecordDetailSavedId by Delegates.notNull<Long>()
    var cookie by Delegates.notNull<Cookie>()

    private fun login() {
        userRepository.deleteAll()
        userProfileRepository.deleteAll()
        userDataProfileRepository.deleteAll()
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
        treeRecordDetailRepository.deleteAll()
        treeRecordDetailTypeRepository.deleteAll()
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
            treeLevel = treeLevelSave,
            parent = null,
            startDate = LocalDate.now()
        )
        val treeSave = treeRepository.save(tree)
        currentTreeSavedId = treeSave.treeRecordId

        val treeRecordDetailType = TreeRecordDetailType(
            name = "TreeRecordDetailType1",
            unit = "string",
            startDate = LocalDate.now()
        )
        val treeRecordDetailTypeSave = treeRecordDetailTypeRepository.save(treeRecordDetailType)
        currentTreeRecordDetailTypeSavedId = treeRecordDetailTypeSave.detailTypeId

        val treeRecordDetail = TreeRecordDetail(
            treeRecord = treeSave,
            detailType = treeRecordDetailTypeSave,
            valueCol = "test value",
            startDate = LocalDate.now()
        )
        val treeRecordDetailSave = treeRecordDetailRepository.save(treeRecordDetail)
        currentTreeRecordDetailSavedId = treeRecordDetailSave.detailId
        login()
    }

    @Test
    fun `GET all tree record details`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/tree-record-details").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].valueCol").value("test value"))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].detailType.name").value("TreeRecordDetailType1"))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].treeRecord.name").value("Tree1"))
    }

    @Test
    fun `GET tree record details by id`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/tree-record-details/$currentTreeRecordDetailSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.valueCol").value("test value"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.detailType.name").value("TreeRecordDetailType1"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.treeRecord.name").value("Tree1"))
    }

    @Test
    fun `Failed GET tree record details by id with invalid id`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/tree-record-details/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Record Detail with ID 99 not found."))
    }

    @Test
    fun `Save (POST) tree record details`() {
        val jsonBody = """
        {
            "treeRecordId": $currentTreeSavedId,
            "detailTypeId": $currentTreeRecordDetailTypeSavedId,
            "valueCol": "test value 2",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/tree-record-details")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isCreated)
            .andExpect(MockMvcResultMatchers.jsonPath("$.valueCol").value("test value 2"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.detailType.name").value("TreeRecordDetailType1"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.treeRecord.name").value("Tree1"))
    }

    @Test
    fun `Failed save (POST) tree record details with invalid tree id`() {
        val jsonBody = """
        {
            "treeRecordId": ${99},
            "detailTypeId": $currentTreeRecordDetailTypeSavedId,
            "valueCol": "test value 2",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/tree-record-details")
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
    fun `Failed save (POST) tree record details with invalid tree record detail type id`() {
        val jsonBody = """
        {
            "treeRecordId": $currentTreeSavedId,
            "detailTypeId": ${99},
            "valueCol": "test value 2",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/tree-record-details")
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
    fun `Failed save (POST) tree record details with invalid valueCol`() {
        val jsonBody = """
        {
            "treeRecordId": $currentTreeSavedId,
            "detailTypeId": $currentTreeRecordDetailTypeSavedId,
            "valueCol": "",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/tree-record-details")
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
    fun `Update (PUT) tree record detail by id`() {
        val jsonBody = """
        {
            "treeRecordId": $currentTreeSavedId,
            "detailTypeId": $currentTreeRecordDetailTypeSavedId,
            "valueCol": "Updated value",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/tree-record-details/$currentTreeRecordDetailSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.valueCol").value("Updated value"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.detailType.name").value("TreeRecordDetailType1"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.treeRecord.name").value("Tree1"))
    }

    @Test
    fun `Failed update (PUT) tree record details with invalid id`() {
        val jsonBody = """
        {
            "treeRecordId": $currentTreeSavedId,
            "detailTypeId": $currentTreeRecordDetailTypeSavedId,
            "valueCol": "Updated value",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/tree-record-details/${99}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Record Detail with ID 99 not found."))
    }
    @Test
    fun `Failed update (PUT) tree record details with invalid tree id`() {
        val jsonBody = """
        {
            "treeRecordId": ${99},
            "detailTypeId": $currentTreeRecordDetailTypeSavedId,
            "valueCol": "Updated value",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/tree-record-details/$currentTreeRecordDetailSavedId")
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
    fun `Failed update (PUT) tree record details with invalid tree record detail type id`() {
        val jsonBody = """
        {
            "treeRecordId": $currentTreeSavedId,
            "detailTypeId": ${99},
            "valueCol": "Updated value",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/tree-record-details/$currentTreeRecordDetailSavedId")
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
    fun `Failed update (PUT) tree record details with invalid valueCol`() {
        val jsonBody = """
        {
            "treeRecordId": $currentTreeSavedId,
            "detailTypeId": $currentTreeRecordDetailTypeSavedId,
            "valueCol": "",
            "startDate": "2025-01-01",
            "endDate": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/tree-record-details/$currentTreeRecordDetailSavedId")
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
    fun `DELETE tree record details by id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/tree-record-details/$currentTreeRecordDetailSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNoContent)
            .andExpect(MockMvcResultMatchers.content().string(""))
    }

    @Test
    fun `Failed DELETE tree record details by id with invalid id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/tree-record-details/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
            .andExpect(MockMvcResultMatchers.jsonPath("$.details").value("Tree Record Detail with ID 99 not found."))
    }
}
