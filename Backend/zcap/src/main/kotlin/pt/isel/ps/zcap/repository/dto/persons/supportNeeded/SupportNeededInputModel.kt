package pt.isel.ps.zcap.repository.dto.persons.supportNeeded

import java.time.LocalDate

data class SupportNeededInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)