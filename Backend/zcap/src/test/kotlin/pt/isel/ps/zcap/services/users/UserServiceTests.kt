package pt.isel.ps.zcap.services.users

import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles


@SpringBootTest
@ActiveProfiles("test")
class UserServiceTests {

    @Test
    fun `just an empty test`() {
    }
}
//    @Autowired
//    lateinit var userService: UserService
//    @MockitoBean
//    lateinit var userRepository: UserRepository
//    @MockitoBean
//    lateinit var userProfileService: UserProfileService
//    @MockitoBean
//    lateinit var userDataProfileService: UserDataProfileService
//    @MockitoBean
//    lateinit var passwordEncoder: PasswordEncoder
//    @MockitoBean
//    lateinit var jwtConfig: JwtConfig
//
//
//    lateinit var user1: User
//    lateinit var user1Out: UserOutputModel
//    lateinit var profile1: UserProfile
//    lateinit var dataProfile1: UserDataProfile
//    lateinit var dataProfileDetail1: UserDataProfileDetail
//    lateinit var tree1: Tree
//    lateinit var treeLevel1: TreeLevel
//
//    @BeforeEach
//    fun setup() {
//        profile1 = UserProfile(name = "Admin", startDate = LocalDate.now())
//
//        treeLevel1 = TreeLevel(levelId = 1, name = "Pais")
//        tree1 = Tree(name = "Portugal", treeLevel = treeLevel1)
//        dataProfile1 = UserDataProfile(name = "Test Profile 1")
//        dataProfileDetail1 = UserDataProfileDetail(
//            userDataProfileDetailId = UserDataProfileDetailId(dataProfile1.userDataProfileId, tree1.treeRecordId),
//            userDataProfile = dataProfile1,
//            treeRecord = tree1
//        )
//
//        val userProfileOutput = UserProfileOutputModel(
//            userProfileId = profile1.userProfileId,
//            name = profile1.name,
//            userProfileDetail = emptyList(),
//            startDate = profile1.startDate,
//            endDate = profile1.endDate,
//            createdAt = profile1.createdAt,
//            updatedAt = profile1.updatedAt,
//        )
//        val userDataProfileOutput = UserDataProfileOutputModel(
//            userDataProfileId = dataProfile1.userDataProfileId,
//            name = dataProfile1.name,
//            userDataProfileDetail = emptyList(),
//            startDate = dataProfile1.startDate,
//            endDate = dataProfile1.endDate,
//            createdAt = dataProfile1.createdAt,
//            updatedAt = dataProfile1.updatedAt,
//        )
//
//        whenever(userProfileService.toOutputModel(profile1)).thenReturn(userProfileOutput)
//        whenever(userDataProfileService.toOutputModel(dataProfile1)).thenReturn(userDataProfileOutput)
//
//        user1 = User(
//            userId = 1L,
//            userName = "testUser",
//            name = "Test User",
//            password = "TestPassword",
//            userProfile = profile1,
//            userDataProfile = dataProfile1,
//            startDate = LocalDate.now(),
//            endDate = null
//        )
//
//        whenever(userRepository.findAll()).thenReturn(listOf(user1))
//
//        user1Out = UserOutputModel(
//            userId = 1L,
//            userName = "testUser",
//            name = "Test User",
//            userProfile = userProfileService.toOutputModel(user1.userProfile),
//            userDataProfile = userDataProfileService.toOutputModel(user1.userDataProfile),
//            startDate = user1.startDate,
//            endDate = user1.endDate,
//            createdAt = user1.createdAt,
//            updatedAt = user1.updatedAt
//        )
//    }
//
//    @Test
//    fun `returns list of all users`() {
//        // Arrange(Mocking):
//
//
//        // Act:
//        val result = userService.getAllUsers()
//
//        // Assert:
//        assertNotNull(result)
//        assertEquals(1, result.size)
//        assertEquals(user1Out, result[0])
//
//        verify(userRepository).findAll()
//    }
//}
