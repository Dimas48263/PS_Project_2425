package pt.isel.ps.zcap.repository.dto.users.userProfile

data class UserProfileAccessAllowanceInputModel(
    val userProfileAccessKeyId: Long,
    val accessType: Int,
)