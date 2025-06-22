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
import pt.isel.ps.zcap.domain.persons.Person
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.domain.users.User
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfile
import pt.isel.ps.zcap.domain.users.userProfile.UserProfile
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileRepository
import pt.isel.ps.zcap.repository.models.users.userProfile.UserProfileRepository
import pt.isel.ps.zcap.repository.models.users.UserRepository
import pt.isel.ps.zcap.utils.PasswordEncoder
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.properties.Delegates
import kotlin.test.assertNotNull

@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureTestDatabase
@ActiveProfiles("test")
class PersonControllerTests(
    @Autowired private val mockMvc: MockMvc,
    @Autowired private val repository: PersonRepository,
    @Autowired private val treeRecordDetailRepository: TreeRecordDetailRepository,
    @Autowired private val treeRepository: TreeRepository,
    @Autowired private val treeLevelRepository: TreeLevelRepository,
    @Autowired private val treeRecordDetailTypeRepository: TreeRecordDetailTypeRepository,
    @Autowired private val userRepository: UserRepository,
    @Autowired private val userProfileRepository: UserProfileRepository,
    @Autowired private val userDataProfileRepository: UserDataProfileRepository
) {
    var currentPlaceOdResidenceId by Delegates.notNull<Long>()
    var currentCountryCodeId by Delegates.notNull<Long>()
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
            name = "Tree Level test",
            description = "Description tree level",
            startDate = LocalDate.now()
        )
        val saveTreeLevel = treeLevelRepository.save(treeLevel)

        val tree = Tree(
            name = "Tree Test",
            treeLevel = saveTreeLevel,
            parent = null,
            startDate = LocalDate.now()
        )
        val saveTree = treeRepository.save(tree)
        currentPlaceOdResidenceId = saveTree.treeRecordId

        val treeRecordDetailType = TreeRecordDetailType(
            name = "Tree Record Detail Type test",
            unit = "string",
            startDate = LocalDate.now()
        )
        val saveTreeRecordDetailType = treeRecordDetailTypeRepository.save(treeRecordDetailType)

        val countryCode = TreeRecordDetail(
            treeRecord = saveTree,
            detailType = saveTreeRecordDetailType,
            valueCol = "country code test",
            startDate = LocalDate.now()
        )
        val saveCountryCode = treeRecordDetailRepository.save(countryCode)
        currentCountryCodeId = saveCountryCode.detailId

        val person = Person(
            name = "Person test",
            age = 20,
            contact = "987654321",
            countryCode = saveCountryCode,
            placeOfResidence = saveTree,
            entryDatetime = LocalDateTime.now()
        )
        val savePerson = repository.save(person)
        currentSavedId = savePerson.personId
        login()
    }

    @Test
    fun `GET all persons`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/persons").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].name").value("Person test"))
    }

    @Test
    fun `GET Person by id`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/persons/$currentSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("Person test"))
    }

    @Test
    fun `Failed GET Person by id with invalid id`() {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/persons/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Save (POST) Person`() {
        val jsonBody = """
        {
            "name": "New person",
            "age": 18,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/persons")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isCreated)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("New person"))
    }

    @Test
    fun `Failed save (POST) Person with invalid name`() {
        val jsonBody = """
        {
            "name": "",
            "age": 18,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/persons")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided."))
    }

    @Test
    fun `Failed save (POST) Person with invalid country code id`() {
        val jsonBody = """
        {
            "name": "New person",
            "age": 18,
            "contact": 123456789,
            "countryCodeId": 99,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/persons").cookie(cookie)
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Failed save (POST) Person with invalid place of residence id`() {
        val jsonBody = """
        {
            "name": "New person",
            "age": 18,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": 99,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/persons")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Failed save (POST) Person with invalid nationality id`() {
        val jsonBody = """
        {
            "name": "New person",
            "age": 18,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": 99,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/persons")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Failed save (POST) Person with invalid departure destination id`() {
        val jsonBody = """
        {
            "name": "New person",
            "age": 18,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": 99,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.post("/api/persons")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Update (POST) Person by id`() {
        val jsonBody = """
        {
            "name": "Updated person",
            "age": 21,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/persons/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("Updated person"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.age").value(21))
    }

    @Test
    fun `Failed update (POST) Person by id with invalid id`() {
        val jsonBody = """
        {
            "name": "Updated person",
            "age": 21,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/persons/${99}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Failed update (POST) Person by id with invalid country code id`() {
        val jsonBody = """
        {
            "name": "Updated person",
            "age": 21,
            "contact": 123456789,
            "countryCodeId": ${99},
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/persons/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Failed update (POST) Person by id with invalid place of residence id`() {
        val jsonBody = """
        {
            "name": "Updated person",
            "age": 21,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": 99,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/persons/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Failed update (POST) Person by id with invalid nationality id`() {
        val jsonBody = """
        {
            "name": "Updated person",
            "age": 21,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": 99,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/persons/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Failed update (POST) Person by id with invalid departure destinationid`() {
        val jsonBody = """
        {
            "name": "Updated person",
            "age": 21,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": 99,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/persons/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }

    @Test
    fun `Failed update (POST) Person by id with invalid name`() {
        val jsonBody = """
        {
            "name": "",
            "age": 21,
            "contact": 123456789,
            "countryCodeId": $currentCountryCodeId,
            "placeOfResidenceId": $currentPlaceOdResidenceId,
            "entryDateTime": "2025-01-01T10:15:30",
            "departureDestinationTime": null,
            "birthDate": null,
            "nationalityId": null,
            "address": null,
            "niss": null,
            "departureDestinationId": null,
            "destinationContact": null
        }
    """.trimIndent()
        mockMvc.perform(
            MockMvcRequestBuilders.put("/api/persons/$currentSavedId")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody)
                .cookie(cookie)
        )
            .andExpect(MockMvcResultMatchers.status().isBadRequest)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("INVALID_DATA"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("Invalid data provided."))
    }

    @Test
    fun `DELETE person by id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/persons/$currentSavedId").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNoContent)
            .andExpect(MockMvcResultMatchers.content().string("{}"))
    }

    @Test
    fun `Failed DELETE Person by id with invalid id`() {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/persons/${99}").cookie(cookie))
            .andExpect(MockMvcResultMatchers.status().isNotFound)
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorCode").value("ENTITY_NOT_FOUND"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.errorMessage").value("The entity with the given ID was not found."))
    }
}