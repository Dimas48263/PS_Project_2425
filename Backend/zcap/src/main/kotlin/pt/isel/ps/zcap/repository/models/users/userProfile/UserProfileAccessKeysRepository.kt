package pt.isel.ps.zcap.repository.models.users.userProfile

import org.springframework.data.jpa.repository.JpaRepository
import pt.isel.ps.zcap.domain.users.userProfile.UserProfileAccessKeys

interface UserProfileAccessKeysRepository : JpaRepository<UserProfileAccessKeys, Long>