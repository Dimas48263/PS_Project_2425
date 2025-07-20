package pt.isel.ps.zcap.repository.dto.persons.departureDestination

import java.time.LocalDate
import java.time.LocalDateTime

data class DepartureDestinationInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)