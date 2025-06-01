package pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed

import pt.isel.ps.zcap.repository.dto.persons.person.PersonOutputModel
import pt.isel.ps.zcap.repository.dto.persons.specialNeed.SpecialNeedOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class PersonSpecialNeedOutputModel(
    val personSpecialNeedId: Long,
    val person: PersonOutputModel,
    val specialNeed: SpecialNeedOutputModel,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)

data class PersonSpecialNeedWithoutPersonOutputModel(
    val personSpecialNeedId: Long,
    val specialNeed: SpecialNeedOutputModel,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)