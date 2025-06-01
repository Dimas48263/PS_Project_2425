package pt.isel.ps.zcap.domain.incidents

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "incidents")
data class Incident(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val incidentId: Long = 0,

    @ManyToOne
    @JoinColumn(name = "incidentTypeId")
    val incidentType: IncidentType = IncidentType(),

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)