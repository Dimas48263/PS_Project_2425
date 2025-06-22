package pt.isel.ps.zcap.domain.users.userProfile

import jakarta.persistence.*

@Entity
@Table(name = "userProfileAccessAllowance")
class UserProfileAccessAllowance(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    var userProfileAccessAllowanceId: Long = 0,
) {

    @ManyToOne
    @JoinColumn(name = "userProfileId")
    lateinit var userProfile: UserProfile

    @ManyToOne
    @JoinColumn(name = "userProfileAccessKeyId")
    lateinit var userProfileAccessKey: UserProfileAccessKeys

    /* enum AccessType: 0 = NO_ACCESS, 1 = READ_ONLY, 2 = READ_WRITE */
    var accessType: Int = 0

    constructor(userProfile: UserProfile, userProfileAccessKey: UserProfileAccessKeys, accessType: Int) : this() {
        this.userProfile = userProfile
        this.userProfileAccessKey = userProfileAccessKey
        this.accessType = accessType
    }
}