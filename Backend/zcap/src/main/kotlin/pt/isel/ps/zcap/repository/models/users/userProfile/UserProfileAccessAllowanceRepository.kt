package pt.isel.ps.zcap.repository.models.users.userProfile

import org.springframework.data.jpa.repository.JpaRepository
import pt.isel.ps.zcap.domain.users.userProfile.UserProfile
import pt.isel.ps.zcap.domain.users.userProfile.UserProfileAccessAllowance

//TODO: review need to add fun
interface UserProfileAccessAllowanceRepository : JpaRepository<UserProfileAccessAllowance, Long> {
    fun findByUserProfile(userProfile: UserProfile): List<UserProfileAccessAllowance>
    fun deleteByUserProfile(userProfile: UserProfile)
}