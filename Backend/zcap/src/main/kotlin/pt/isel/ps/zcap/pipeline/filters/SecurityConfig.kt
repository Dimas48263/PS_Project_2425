package pt.isel.ps.zcap.pipeline.filters

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.Customizer
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.web.SecurityFilterChain
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter
import javax.crypto.SecretKey


@Configuration
@EnableWebSecurity
class SecurityConfig(
    private val jwtSecretKey: SecretKey
) {

    @Bean
    fun securityFilterChain(http: HttpSecurity): SecurityFilterChain {

        return http
            .csrf { it.disable() }
            .sessionManagement { it.sessionCreationPolicy(SessionCreationPolicy.STATELESS) }
            .authorizeHttpRequests {
                it
                    .requestMatchers( "/api/ping", "/api/auth", "/api/auth/login", "/swagger-ui.html", "/swagger-ui/**", "/v3/api-docs/**")
                    .permitAll()
                    .anyRequest().authenticated()
            }
            .addFilterAfter(JwtAuthenticationFilter(jwtSecretKey), BasicAuthenticationFilter::class.java)
//            .addFilterBefore(JwtAuthenticationFilter(jwtSecretKey), UsernamePasswordAuthenticationFilter::class.java)
            .build()
    }
}

/* Configuration pre authorization implementation. REMOVE after implementation*/
//@Configuration
//class SecurityConfig {
//
//    @Bean
//    fun filterChain(http: HttpSecurity): SecurityFilterChain {
//        http.csrf().disable()
//            .authorizeHttpRequests()
//            .anyRequest().permitAll()
//        return http.build()
//    }
//}