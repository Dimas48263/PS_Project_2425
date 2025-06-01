package pt.isel.ps.zcap.repository.dto.persons.departureDestination

import java.time.LocalDate

data class DepartureDestinationInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?
)