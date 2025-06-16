package pt.isel.ps.zcap.domain.persons

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "departureDestination")
data class DepartureDestination(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val departureDestinationId: Long = 0,

    val name: String = "",
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)