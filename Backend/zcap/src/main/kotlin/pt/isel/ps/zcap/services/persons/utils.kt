package pt.isel.ps.zcap.services.persons

import pt.isel.ps.zcap.domain.persons.*
import pt.isel.ps.zcap.repository.dto.persons.departureDestination.DepartureDestinationOutputModel
import pt.isel.ps.zcap.repository.dto.persons.person.PersonOutputModel
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedOutputModel
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedWithoutPersonOutputModel
import pt.isel.ps.zcap.repository.dto.persons.personSupportNeeded.PersonSupportNeededWithoutPersonOutputModel
import pt.isel.ps.zcap.repository.dto.persons.relationType.RelationTypeOutputModel
import pt.isel.ps.zcap.repository.dto.persons.specialNeed.SpecialNeedOutputModel
import pt.isel.ps.zcap.repository.dto.persons.supportNeeded.SupportNeededOutputModel
import pt.isel.ps.zcap.services.tree.toOutputModel
import java.util.*

fun DepartureDestination.toOutputModel(): DepartureDestinationOutputModel =
    DepartureDestinationOutputModel(
        departureDestinationId,
        name,
        startDate,
        endDate,
        createdAt,
        updatedAt
    )

fun Person.toOutputModel(): PersonOutputModel =
    PersonOutputModel(
        personId,
        name,
        age,
        contact,
        countryCode.toOutputModel(),
        placeOfResidence.toOutputModel(),
        entryDatetime,
        departureDatetime,
        birthDate,
        nationality?.toOutputModel(),
        address,
        niss,
        departureDestination?.toOutputModel(),
        destinationContact,
        specialNeeds.map { it.toOutputModelWithoutPerson() },
        supportNeeded.map { it.toOutputModelWithoutPerson() },
        createdAt,
        updatedAt
    )


fun SpecialNeed.toOutputModel(): SpecialNeedOutputModel =
    SpecialNeedOutputModel(
        specialNeedId,
        name,
        startDate,
        endDate,
        updatedAt,
        createdAt
    )

fun PersonSpecialNeed.toOutputModel(): PersonSpecialNeedOutputModel =
    PersonSpecialNeedOutputModel(
        personSpecialNeedId,
        person.toOutputModel(),
        specialNeed.toOutputModel(),
        description,
        startDate,
        endDate,
        updatedAt,
        createdAt
    )


fun PersonSpecialNeed.toOutputModelWithoutPerson(): PersonSpecialNeedWithoutPersonOutputModel =
    PersonSpecialNeedWithoutPersonOutputModel(
        personSpecialNeedId,
        specialNeed.toOutputModel(),
        description,
        startDate,
        endDate,
        createdAt,
        updatedAt
    )

fun SupportNeeded.toOutputModel(): SupportNeededOutputModel =
    SupportNeededOutputModel(
        supportNeededId,
        name,
        startDate,
        endDate,
        updatedAt,
        createdAt
    )

fun PersonSupportNeeded.toOutputModelWithoutPerson(): PersonSupportNeededWithoutPersonOutputModel =
    PersonSupportNeededWithoutPersonOutputModel(
        personSupportNeededId,
        supportNeeded.toOutputModel(),
        description,
        startDate,
        endDate,
        createdAt,
        updatedAt
    )

fun RelationType.toOutputModel(): RelationTypeOutputModel =
    RelationTypeOutputModel(
        relationTypeId,
        name,
        startDate,
        endDate,
        createdAt,
        updatedAt
    )