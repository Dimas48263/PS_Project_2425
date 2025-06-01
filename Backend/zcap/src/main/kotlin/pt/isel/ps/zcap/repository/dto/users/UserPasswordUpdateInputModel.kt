package pt.isel.ps.zcap.repository.dto.users

data class UserPasswordUpdateInputModel(
    val currentPassword: String,
    val newPassword: String,
)