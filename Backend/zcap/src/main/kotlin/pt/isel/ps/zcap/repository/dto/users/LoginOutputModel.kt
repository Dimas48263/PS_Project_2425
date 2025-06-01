package pt.isel.ps.zcap.repository.dto.users

import pt.isel.ps.zcap.domain.users.User

data class LoginOutputModel(
    val user: User,
    val token: String,
)