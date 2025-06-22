package pt.isel.ps.zcap.domain.users.userDataProfile

import jakarta.persistence.*
import pt.isel.ps.zcap.domain.tree.Tree
import java.io.Serializable

@Entity
@Table(name = "userDataProfileDetails")
data class UserDataProfileDetail(

    @EmbeddedId
    val userDataProfileDetailId: UserDataProfileDetailId = UserDataProfileDetailId(),

    @ManyToOne
    @JoinColumn(name = "userDataProfileId", insertable = false, updatable = false)
    val userDataProfile: UserDataProfile = UserDataProfile(),

    @ManyToOne
    @JoinColumn(name = "treeRecordId", insertable = false, updatable = false)
    val treeRecord: Tree = Tree()
)

@Embeddable
data class UserDataProfileDetailId(
    @Column(name = "userDataProfileId")
    val userDataProfileId: Long = 0,

    @Column(name = "treeRecordId")
    val treeRecordId: Long = 0
) : Serializable