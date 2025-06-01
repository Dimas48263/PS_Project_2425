package pt.isel.ps.zcap.api.login

import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.servlet.http.Cookie
import jakarta.servlet.http.HttpServletResponse
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.http.ResponseEntity.status
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.api.exceptions.InvalidTokenException
import pt.isel.ps.zcap.repository.dto.users.LoginInputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.users.UserService

@Tag(name = "0 - Authentication", description = "Operações de autenticação")
@RestController
@RequestMapping("api/auth")
class AuthController(
    private val userService: UserService
) {

    @GetMapping
    fun ping() = ResponseEntity.ok("pong")

    @PostMapping("login")
    fun login(@RequestBody userLogin: LoginInputModel, response: HttpServletResponse): ResponseEntity<Any> {

        return try {
            val validLogin = userService.login(userLogin)

            val cookie = Cookie("jwt", validLogin.token)
            cookie.path = "/"
            cookie.isHttpOnly = true //TODO:only used by backend, maybe will need to change for offline support

            response.addCookie(cookie)

            val responseBody = mapOf(
                "token" to validLogin.token,
                "user" to mapOf("name" to validLogin.user.name),
                "message" to "Welcome, ${validLogin.user.name}!"
            )

            ResponseEntity.ok(responseBody)

        } catch (ex: Exception) {
            status(401).body(mapOf("error" to ex.message))
        }
    }

    @PostMapping("logout")
    fun logout(response: HttpServletResponse): ResponseEntity<String> {
        val cookie = Cookie("jwt", null)
        cookie.maxAge = 0
        cookie.path = "/"
        cookie.isHttpOnly = true

        response.addCookie(cookie)
        return ResponseEntity.ok("Logout successful")
    }

    @GetMapping("user")
    fun getAuthenticatedUser(@CookieValue("jwt") jwt: String?): ResponseEntity<Any> {
        if (jwt.isNullOrBlank()) {
            throw InvalidTokenException("Token not found")
        }

        return try {
            when (val user = userService.getAuthenticatedUser(jwt)) {
                is Success -> status(HttpStatus.OK)
                    .body(user.value)

                is Failure -> throw InvalidTokenException("Invalid or expired token")
            }
        } catch (ex: Exception) {
            status(HttpStatus.UNAUTHORIZED).body("Invalid or expired Token")
        }
    }
}