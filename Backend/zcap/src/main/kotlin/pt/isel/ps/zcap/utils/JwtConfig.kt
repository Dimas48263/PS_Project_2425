package pt.isel.ps.zcap.utils

import io.jsonwebtoken.security.Keys
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.env.Environment
import javax.crypto.SecretKey

@Configuration
class JwtConfig(private val env: Environment) {
    @Bean
    fun jwtSecretKey(): SecretKey {
        val secret = env.getProperty("ZCAPWEB_SECRET")
        return if (!secret.isNullOrBlank()) {
            Keys.hmacShaKeyFor(secret.toByteArray())
            //Key example to add on .env file and placed on same level as build.gradle:
            //ZCAPWEB_SECRET=e13dorj9843r................209rcirg34rhnc
        } else {
//            Keys.secretKeyFor(SignatureAlgorithm.HS256)
            val errorMessage = "WARNING: The secret key does not exist on an environment variable."
            println(errorMessage)
            throw IllegalStateException(errorMessage)
        }
    }
}


