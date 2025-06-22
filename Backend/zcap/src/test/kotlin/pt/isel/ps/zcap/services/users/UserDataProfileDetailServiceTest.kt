package pt.isel.ps.zcap.services.users

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.Mock
import org.mockito.junit.jupiter.MockitoExtension
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileDetailRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileRepository
import pt.isel.ps.zcap.services.users.userDataProfile.UserDataProfileDetailService

@ExtendWith(MockitoExtension::class)
@ActiveProfiles("test")
class UserDataProfileDetailServiceTest {

    @Mock
    lateinit var userDataProfileDetailRepository: UserDataProfileDetailRepository

    @Mock
    lateinit var profileRepo: UserDataProfileRepository

    @Mock
    lateinit var treeLevelRepo: TreeLevelRepository

    @Mock
    lateinit var treeRepo: TreeRepository

    private lateinit var service: UserDataProfileDetailService

    @BeforeEach
    fun setup() {
        service = UserDataProfileDetailService(userDataProfileDetailRepository, profileRepo, treeRepo)
    }
    /*
    @Test
    fun `add detail successfully`() {
        val treeLevel = TreeLevel(
            1, 0, "Pais",
            startDate = LocalDate.now(),
            createdAt = LocalDateTime.now(),
            updatedAt = LocalDateTime.now(),
        )
        val tree = Tree(
            2, "Portugal", treeLevel,
            startDate = LocalDate.now(),
            createdAt = LocalDateTime.now(),
            updatedAt = LocalDateTime.now(),
        )
        val profile = UserDataProfile(
            userDataProfileId = 1,
            name = "User Profile",
            startDate = LocalDate.now(),
            createdAt = LocalDateTime.now(),
            updatedAt = LocalDateTime.now(),
            details = emptyList()
        )
        val input = UserDataProfileDetailInputModel(1, 2)

        whenever(profileRepo.findById(1L)).thenReturn(Optional.of(profile))
        whenever(treeLevelRepo.findById(1L)).thenReturn(Optional.of(treeLevel))
        whenever(treeRepo.findById(2L)).thenReturn(Optional.of(tree))

        val result = service.addDetail(input)


        assertTrue(result is Success)
        val detail = (result as Success).value
        assertEquals(1L, detail.userDataProfileId)
        assertEquals(2L, detail.treeRecordId)
        assertEquals("Portugal", detail.treeName)
        assertEquals("Pais", detail.treeLevelName)
    }
     */
}