package pt.isel.ps.zcap.domain.users

import jakarta.persistence.*

@Entity //NOT IMPLEMENTED YET: missing relation with UserProfile
@Table(name = "userProfileDetails")
data class UserProfileDetail(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val userProfileDetailId: Long = 0,
    val name: String = "User Profile detail",
    val accessValue: Int = 0,
    val accessType: Int = 0,
)