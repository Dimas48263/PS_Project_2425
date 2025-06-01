package pt.isel.ps.zcap.repository.dto.persons.personSupportNeeded

import pt.isel.ps.zcap.repository.dto.persons.person.PersonOutputModel
import pt.isel.ps.zcap.repository.dto.persons.supportNeeded.SupportNeededOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class PersonSupportNeededOutputModel(
    val personSupportNeededId: Long,
    val person: PersonOutputModel,
    val supportNeeded: SupportNeededOutputModel,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val updatedAt: LocalDateTime,
    val createdAt: LocalDateTime
)

data class PersonSupportNeededWithoutPersonOutputModel(
    val personSupportNeededId: Long,
    val supportNeeded: SupportNeededOutputModel,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val updatedAt: LocalDateTime,
    val createdAt: LocalDateTime
)