package pt.isel.ps.zcap.utils

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.stereotype.Component

@Component
class PasswordEncoder {
    private val encoder = BCryptPasswordEncoder()

    fun encrypt(password: String): String = encoder.encode(password)

    fun verifyPassword(password: String, encryptedPassword: String): Boolean =
        encoder.matches(password, encryptedPassword)
}