package pt.isel.ps.zcap.services.users

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.Mock
import org.mockito.junit.jupiter.MockitoExtension
import org.mockito.kotlin.any
import org.mockito.kotlin.whenever
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.users.UserDataProfile
import pt.isel.ps.zcap.domain.users.UserDataProfileDetail
import pt.isel.ps.zcap.domain.users.UserDataProfileDetailId
import pt.isel.ps.zcap.repository.dto.users.UserDataProfileDetailInputModel
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.repository.models.users.UserDataProfileDetailRepository
import pt.isel.ps.zcap.repository.models.users.UserDataProfileRepository
import pt.isel.ps.zcap.services.Success
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.*

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