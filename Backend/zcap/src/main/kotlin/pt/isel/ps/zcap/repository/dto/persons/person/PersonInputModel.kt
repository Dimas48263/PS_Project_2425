package pt.isel.ps.zcap.repository.dto.persons.person

import java.time.LocalDate
import java.time.LocalDateTime

data class PersonInputModel(
    val name: String,
    val age: Int,
    val contact: String,
    val countryCodeId: Long,
    val placeOfResidenceId: Long,
    val entryDateTime: LocalDateTime,
    val departureDateTime: LocalDateTime?,
    val birthDate: LocalDate?,
    val nationalityId: Long?,
    val address: String?,
    val niss: Int?,
    val departureDestinationId: Long?,
    val destinationContact: Int?
)
