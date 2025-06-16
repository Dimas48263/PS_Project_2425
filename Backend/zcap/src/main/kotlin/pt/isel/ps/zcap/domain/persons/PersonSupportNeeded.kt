package pt.isel.ps.zcap.domain.persons

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "personSupportNeeded")
data class PersonSupportNeeded(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val personSupportNeededId: Long = 0,

    @ManyToOne
    @JoinColumn(name = "personId")
    val person: Person = Person(),

    @ManyToOne
    @JoinColumn(name = "supportNeededId")
    val supportNeeded: SupportNeeded = SupportNeeded(),

    val description: String? = null,
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)

