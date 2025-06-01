package pt.isel.ps.zcap.config

import org.springframework.boot.test.context.TestConfiguration
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Profile
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.web.SecurityFilterChain

//@TestConfiguration
//@Profile("test")
//class TestSecurityConfig {
//
//    @Bean
//    fun testSecurityFilterChain(http: HttpSecurity): SecurityFilterChain {
//        return http
//            .securityMatcher { true }
//            .authorizeHttpRequests { auth ->
//                auth.anyRequest().permitAll()
//            }
//            .csrf { csrf -> csrf.disable() }
//            .headers { headers -> headers.frameOptions { it.disable() } }
//            .build()
//    }
//}