package pt.isel.ps.zcap.domain.persons

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "relationType")
data class RelationType(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val relationTypeId: Long = 0,

    val name: String = "",
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)