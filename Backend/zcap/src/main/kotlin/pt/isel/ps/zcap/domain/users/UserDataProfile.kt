package pt.isel.ps.zcap.domain.users

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "userDataProfiles")
data class UserDataProfile(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val userDataProfileId: Long = 0,
    val name: String = "",
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,

    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now(),

    @OneToMany(mappedBy = "userDataProfile", fetch = FetchType.LAZY)
    val details: List<UserDataProfileDetail> = emptyList()
)