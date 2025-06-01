package pt.isel.ps.zcap.repository.dto.users

data class UserProfileDetailOutputModel(
    val userProfileDetailId: Int,
    val name: String,
    val value: Int,
    val accessType: Int,
)
