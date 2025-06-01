package pt.isel.ps.zcap.repository.dto.persons.relationType

import java.time.LocalDate

data class RelationTypeInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)