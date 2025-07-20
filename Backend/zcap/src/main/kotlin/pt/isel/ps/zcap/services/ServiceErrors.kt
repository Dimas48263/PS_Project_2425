package pt.isel.ps.zcap.services

import org.springframework.http.HttpStatus
import pt.isel.ps.zcap.repository.dto.ErrorResponse


sealed class ServiceErrors(val httpStatus: HttpStatus, val errorResponse: ErrorResponse) {
    data object InvalidUserNameOrPassword : ServiceErrors(
        HttpStatus.BAD_REQUEST,
        ErrorResponse(
            errorCode = "INVALID_DATA",
            errorMessage = "Invalid data input.",
            details = "Invalid username or password."
        )
    )
    data object InvalidPasswordComplexity : ServiceErrors(
        HttpStatus.BAD_REQUEST,
        ErrorResponse(
            errorCode = "INVALID_DATA",
            errorMessage = "Invalid data input.",
            details = "Invalid password complexity."
        )
    )
    data object InvalidDataInput : ServiceErrors(
        HttpStatus.BAD_REQUEST,
        ErrorResponse(
            errorCode = "INVALID_DATA",
            errorMessage = "Invalid data input."
        )
    )

    data object RecordAlreadyExists : ServiceErrors(
        HttpStatus.BAD_REQUEST,
        ErrorResponse(
            errorCode = "INVALID_DATA",
            errorMessage = "Invalid data input.",
            details = "Record already exists."
        )
    )

    data object InsertFailed : ServiceErrors(
        HttpStatus.INTERNAL_SERVER_ERROR,
        ErrorResponse(
            errorCode = "INSERT_FAILED",
            errorMessage = "Failed to insert record on database."
        )
    )
    data object UpdateFailed : ServiceErrors(
        HttpStatus.INTERNAL_SERVER_ERROR,
        ErrorResponse(
            errorCode = "INSERT_FAILED",
            errorMessage = "Failed to insert record on database.",
            details = "Failed to update record on database."
        )
    )
    data object DeleteFailed : ServiceErrors(
        HttpStatus.INTERNAL_SERVER_ERROR,
        ErrorResponse(
            errorCode = "INSERT_FAILED",
            errorMessage = "Failed to insert record on database.",
            details = "Failed to delete record on database."
        )
    )

    data class RecordNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Record with id $id not found."
        )
    )
    data class TreeNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Tree with id $id not found."
        )
    )
    data class TreeLevelNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Tree Level with id $id not found."
        )
    )
    data class ParentNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Parent with id $id not found."
        )
    )
    data class TreeRecordDetailTypeNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Tree Record Detail Type with id $id not found."
        )
    )
    data class TreeRecordDetailNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Tree Record Detail with id $id not found."
        )
    )
    data class NationalityNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Nationality with id $id not found."
        )
    )
    data class DepartureDestinationNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Departure Destination with id $id not found."
        )
    )
    data class PersonNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Person with id $id not found."
        )
    )
    data class SpecialNeedNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Special Need with id $id not found."
        )
    )
    data class SupportNeededNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Support Needed with id $id not found."
        )
    )
    data class RelationTypeNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Relation Type with id $id not found."
        )
    )
    data class IncidentTypeNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Incident Type with id $id not found."
        )
    )
    data class BuildingTypeNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Building Type with id $id not found."
        )
    )
    data class EntityNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Entity with id $id not found."
        )
    )
    data class IncidentNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Incident with id $id not found."
        )
    )
    data class ZcapNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "ZCAP with id $id not found."
        )
    )
    data class IncidentZcapNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Incident ZCAP with id $id not found."
        )
    )
    data class DetailTypeCategoryNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "Detail Type Category with id $id not found."
        )
    )
    data class ZcapDetailTypeNotFound(val id: Long) : ServiceErrors(
        HttpStatus.NOT_FOUND,
        ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = "ZCAP Detail Type with id $id not found."
        )
    )
}