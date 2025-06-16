package pt.isel.ps.zcap.repository.dto.incidents.incidentZcapPerson

import pt.isel.ps.zcap.domain.incidents.IncidentZcapPerson
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcap.IncidentZcapOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcap.toOutputModel
import pt.isel.ps.zcap.repository.dto.persons.person.PersonOutputModel
import pt.isel.ps.zcap.services.persons.toOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class IncidentZcapPersonOutputModel(
    val incidentZcapPersonId: Long,
    val incidentZcap: IncidentZcapOutputModel,
    val person: PersonOutputModel,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)

fun IncidentZcapPerson.toOutputModel(): IncidentZcapPersonOutputModel =
    IncidentZcapPersonOutputModel(
        incidentPersonId,
        incidentZcap.toOutputModel(),
        person.toOutputModel(),
        startDate,
        endDate,
        createdAt,
        lastUpdatedAt
    )