package pt.isel.ps.zcap.repository.dto.persons.departureDestination

import java.time.LocalDate
import java.time.LocalDateTime

data class DepartureDestinationOutputModel(
    val departureDestinationId: Long,
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)