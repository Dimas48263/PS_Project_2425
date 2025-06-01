package pt.isel.ps.zcap.domain.persons

import jakarta.persistence.*
import java.sql.Timestamp
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "personSpecialNeeds")
data class PersonSpecialNeed(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val personSpecialNeedId: Long = 0,

    @ManyToOne
    @JoinColumn(name = "personId")
    val person: Person = Person(),

    @ManyToOne
    @JoinColumn(name = "specialNeedId")
    val specialNeed: SpecialNeed = SpecialNeed(),

    val description: String? = null,
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)