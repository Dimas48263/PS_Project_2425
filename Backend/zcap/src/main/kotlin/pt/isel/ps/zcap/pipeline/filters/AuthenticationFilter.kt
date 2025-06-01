package pt.isel.ps.zcap.pipeline.filters

import io.jsonwebtoken.Jwts
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.filter.OncePerRequestFilter
import javax.crypto.SecretKey


class JwtAuthenticationFilter(
    private val jwtSecretKey: SecretKey
) : OncePerRequestFilter() {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {

        var token: String? = null
        val authHeader = request.getHeader("Authorization")

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.removePrefix("Bearer ").trim()
        }

        if (token == null) {
            val cookie = request.cookies?.find { it.name == "jwt" }
            token = cookie?.value
            logger.info("Token found in Cookie: $token")
        }

        if (token != null) {
            try {
                val claims = Jwts.parserBuilder()
                    .setSigningKey(jwtSecretKey)
                    .build()
                    .parseClaimsJws(token)
                    .body

                val username = claims.subject
                val authorities = listOf(SimpleGrantedAuthority("USER")) // ou do token, se for incluido

                val auth = UsernamePasswordAuthenticationToken(username, null, authorities)
                SecurityContextHolder.getContext().authentication = auth

            } catch (ex: Exception) {
//                logger.info("${ex.message}")
//                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid token")
//                return
            }
        }

        filterChain.doFilter(request, response)
    }
}
