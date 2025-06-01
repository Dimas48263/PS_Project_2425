package pt.isel.ps.zcap.domain.incidents

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "incidentTypes")
data class IncidentType(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val incidentTypeId: Long = 0,

    val name: String = "",
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)