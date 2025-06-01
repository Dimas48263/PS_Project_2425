package pt.isel.ps.zcap.domain.incidents

import jakarta.persistence.*
import pt.isel.ps.zcap.domain.persons.Person
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "incidentZcapPersons")
data class IncidentZcapPerson(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val incidentPersonId: Long = 0,

    @ManyToOne
    @JoinColumn(name = "incidentZcapId")
    val incidentZcap: IncidentZcap = IncidentZcap(),

    @ManyToOne
    @JoinColumn(name = "personId")
    val person: Person = Person(),

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)