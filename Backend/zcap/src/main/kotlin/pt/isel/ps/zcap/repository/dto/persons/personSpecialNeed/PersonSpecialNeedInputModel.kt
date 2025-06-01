package pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed

import java.time.LocalDate

data class PersonSpecialNeedInputModel(
    val personId: Long,
    val specialNeedId: Long,
    val description: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?
)