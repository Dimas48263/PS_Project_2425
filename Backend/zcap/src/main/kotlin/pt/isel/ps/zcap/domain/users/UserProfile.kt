package pt.isel.ps.zcap.domain.users


import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "userProfiles")
data class UserProfile(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val userProfileId: Long = 0,
    val name: String = "",
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,

    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)