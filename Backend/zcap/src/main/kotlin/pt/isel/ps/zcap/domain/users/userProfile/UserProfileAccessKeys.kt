package pt.isel.ps.zcap.domain.users.userProfile

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "userProfileAccessKeys")
data class UserProfileAccessKeys(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val userProfileAccessKeyId: Long = 0,
    val accessKey: String = "",
    val description: String = "",
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)