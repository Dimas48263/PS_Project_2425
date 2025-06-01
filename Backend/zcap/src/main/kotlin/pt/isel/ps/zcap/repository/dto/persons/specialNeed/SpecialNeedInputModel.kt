package pt.isel.ps.zcap.repository.dto.persons.specialNeed

import java.time.LocalDate

data class SpecialNeedInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)