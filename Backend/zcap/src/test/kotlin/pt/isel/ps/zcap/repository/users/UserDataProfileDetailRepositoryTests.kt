package pt.isel.ps.zcap.repository.users

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfile
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfileDetail
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfileDetailId
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileDetailRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileRepository
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@ActiveProfiles("test")

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) //Test with the real Database
class UserDataProfileDetailRepositoryTests(
//    @Autowired val testEntityManager: TestEntityManager //Using memory database instead
    @Autowired val dataProfileDetailRepository: UserDataProfileDetailRepository,
    @Autowired val dataProfileRepository: UserDataProfileRepository,
    @Autowired val treeRepository: TreeRepository,
    @Autowired val treeLevelRepository: TreeLevelRepository,
) {

    lateinit var treeLevel1: TreeLevel
    lateinit var treeLevel2: TreeLevel

    lateinit var tree1: Tree
    lateinit var tree2: Tree
    lateinit var tree3: Tree

    lateinit var profile1: UserDataProfile
    lateinit var profile2: UserDataProfile

    lateinit var detail1: UserDataProfileDetail
    lateinit var detail2: UserDataProfileDetail
    lateinit var detail3: UserDataProfileDetail

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
    }

    @Test
    fun `return details by userDataProfileId`() {
        val results = dataProfileDetailRepository.findByUserDataProfileId(profile2.userDataProfileId)

        assertEquals(2, results.size)
        assertTrue(results.containsAll(listOf(detail2, detail3)))
    }

    @Test
    fun `return empty list for non-existent profileId`() {
        val results = dataProfileDetailRepository.findByUserDataProfileId(999)
        assertTrue(results.isEmpty())
    }
}
