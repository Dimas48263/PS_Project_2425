package pt.isel.ps.zcap.repository.users

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.BeforeEach
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.users.*
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfile
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfileDetail
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfileDetailId
import pt.isel.ps.zcap.domain.users.userProfile.UserProfile
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileDetailRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileRepository
import pt.isel.ps.zcap.repository.models.users.userProfile.UserProfileRepository
import pt.isel.ps.zcap.repository.models.users.UserRepository
import java.time.LocalDate
import kotlin.test.Test


@ActiveProfiles("test")

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) //Test with the real Database
class UserRepositoryTests(
//    @Autowired val testEntityManager: TestEntityManager //Using memory database instead
    @Autowired val repository: UserRepository,
    @Autowired val userProfileRepository: UserProfileRepository,
    @Autowired val dataProfileDetailRepository: UserDataProfileDetailRepository,
    @Autowired val dataProfileRepository: UserDataProfileRepository,
    @Autowired val treeRepository: TreeRepository,
    @Autowired val treeLevelRepository: TreeLevelRepository,
) {

//            |------------------------------------------------------>    User 1
//                    |-------------------|                               User 2
//    |-----------------------------------------------|                   User 3

    lateinit var treeLevel1: TreeLevel
    lateinit var treeLevel2: TreeLevel

    lateinit var tree1: Tree
    lateinit var tree2: Tree
    lateinit var tree3: Tree

    lateinit var userProfile: UserProfile

    lateinit var profile1: UserDataProfile
    lateinit var profile2: UserDataProfile

    lateinit var detail1: UserDataProfileDetail
    lateinit var detail2: UserDataProfileDetail
    lateinit var detail3: UserDataProfileDetail

    lateinit var user1: User
    lateinit var user2: User
    lateinit var user3: User

    @BeforeEach
    fun setup() {

        treeLevel1 = treeLevelRepository.save(TreeLevel(levelId = 1, name = "Pais"))
        treeLevel2 = treeLevelRepository.save(TreeLevel(levelId = 2, name = "Distrito"))

        tree1 = treeRepository.save(Tree(name = "Portugal", treeLevel = treeLevel1))
        tree2 = treeRepository.save(Tree(name = "Lisboa", treeLevel = treeLevel2, parent = tree1))
        tree3 = treeRepository.save(Tree(name = "Baixo Alentejo", treeLevel = treeLevel2, parent = tree1))

        profile1 = dataProfileRepository.save(UserDataProfile(name = "Test Profile 1"))
        profile2 = dataProfileRepository.save(UserDataProfile(name = "Test Profile 2"))

        detail1 = UserDataProfileDetail(
            userDataProfileDetailId = UserDataProfileDetailId(profile1.userDataProfileId, tree1.treeRecordId),
            userDataProfile = profile1,
            treeRecord = tree1
        )


        detail2 = UserDataProfileDetail(
            userDataProfileDetailId = UserDataProfileDetailId(profile2.userDataProfileId, tree2.treeRecordId),
            userDataProfile = profile2,
            treeRecord = tree2
        )

        detail3 = UserDataProfileDetail(
            userDataProfileDetailId = UserDataProfileDetailId(profile2.userDataProfileId, tree3.treeRecordId),
            userDataProfile = profile2,
            treeRecord = tree3
        )

        dataProfileDetailRepository.saveAll(listOf(detail1, detail2, detail3))

        userProfile = UserProfile(
            name = "Admin",
            startDate = LocalDate.now(),
        )
        userProfileRepository.saveAll(listOf(userProfile))

        user1 = User(
            userName = "user1",
            name = "User 1",
            password = "user1",
            userProfile = userProfile,
            userDataProfile = profile1,
            startDate = LocalDate.parse("2020-01-01"),
            endDate = null,
        )
        user2 = User(
            userName = "user2",
            name = "User 2",
            password = "user2",
            userProfile = userProfile,
            userDataProfile = profile2,
            startDate = LocalDate.parse("2021-01-01"),
            endDate = LocalDate.parse("2021-12-31"),
        )
        user3 = User(
            userName = "user3",
            name = "User 3",
            password = "user3",
            userProfile = userProfile,
            userDataProfile = profile2,
            startDate = LocalDate.parse("2010-01-01"),
            endDate = LocalDate.parse("2025-01-01"),
        )

        repository.saveAll(listOf(user1, user2, user3))
    }

    @Test
    fun `Should find 0 users at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2000-01-01"))

        assertEquals(0, results.size)
    }

    @Test
    fun `Should find only user3 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2019-01-01"))

        assertTrue(results.contains(user3))
        assertEquals(1, results.size)
    }

    @Test
    fun `Should find user1 and user3 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2020-01-01"))
        assertTrue(results.containsAll(listOf(user1, user3)))
        assertEquals(2, results.size)

        val otherResults = repository.findValidOnDate(LocalDate.parse("2024-01-01"))
        assertTrue(otherResults.containsAll(listOf(user1, user3)))
        assertEquals(2, otherResults.size)
    }

    @Test
    fun `Should find all 3 users at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2021-05-01"))

        assertTrue(results.containsAll(listOf(user1, user2, user3)))
    }

    @Test
    fun `Should find only user1 at the given date`() {

        val results = repository.findValidOnDate(LocalDate.parse("2028-05-01"))

        assertTrue(results.contains(user1))
        assertEquals(1, results.size)
    }
}