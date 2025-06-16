package pt.isel.ps.zcap.repository.dto.persons.person

import pt.isel.ps.zcap.repository.dto.persons.departureDestination.DepartureDestinationOutputModel
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedWithoutPersonOutputModel
import pt.isel.ps.zcap.repository.dto.persons.personSupportNeeded.PersonSupportNeededWithoutPersonOutputModel
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeOutputModel
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail.TreeRecordDetailOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class PersonOutputModel(
    val personId: Long,
    val name: String,
    val age: Int,
    val contact: String,
    val countryCode: TreeRecordDetailOutputModel,
    val placeOfResidence: TreeOutputModel,
    val entryDateTime: LocalDateTime,
    val departureDateTime: LocalDateTime?,
    val birthDate: LocalDate?,
    val nationality: TreeRecordDetailOutputModel?,
    val address: String?,
    val niss: Int?,
    val departureDestination: DepartureDestinationOutputModel?,
    val destinationContact: Int?,
    val specialNeeds: List<PersonSpecialNeedWithoutPersonOutputModel>,
    val supportNeeded: List<PersonSupportNeededWithoutPersonOutputModel>,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime
)