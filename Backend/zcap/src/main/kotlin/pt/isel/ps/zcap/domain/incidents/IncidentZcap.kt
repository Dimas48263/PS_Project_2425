package pt.isel.ps.zcap.domain.incidents

import jakarta.persistence.*
import pt.isel.ps.zcap.domain.supportTables.Entities
import pt.isel.ps.zcap.domain.supportTables.Zcap
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "incidentZcaps")
data class IncidentZcap(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val incidentZcapId: Long = 0,

    @ManyToOne
    @JoinColumn(name = "incidentId")
    val incident: Incident = Incident(),


    @ManyToOne
    @JoinColumn(name = "zcapId")
    val zcap: Zcap = Zcap(),

    @ManyToOne
    @JoinColumn(name = "entityId")
    val entity: Entities = Entities(),

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)