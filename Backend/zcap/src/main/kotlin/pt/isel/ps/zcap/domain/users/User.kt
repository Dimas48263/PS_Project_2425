package pt.isel.ps.zcap.domain.users

import jakarta.persistence.*
import org.springframework.security.core.userdetails.UserDetails
import java.sql.Timestamp
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "users")
data class User (
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val userId: Long = 0,
    val userName: String = "",
    val name: String = "",
    val password: String = "",

    @ManyToOne
    @JoinColumn(name = "userProfileId")
    val userProfile: UserProfile = UserProfile(),

    @ManyToOne
    @JoinColumn(name = "userDataProfileId")
    val userDataProfile: UserDataProfile = UserDataProfile(),

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,

    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now(),
)
