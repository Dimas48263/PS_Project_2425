package pt.isel.ps.zcap.services

import org.springframework.http.HttpStatus


sealed class ServiceErrors(val httpStatus: HttpStatus) {
    data object InvalidUserNameOrPassword : ServiceErrors(HttpStatus.BAD_REQUEST)
    data object InvalidPasswordComplexity : ServiceErrors(HttpStatus.BAD_REQUEST)
    data object InvalidDataInput : ServiceErrors(HttpStatus.BAD_REQUEST)
    data object RecordAlreadyExists : ServiceErrors(HttpStatus.BAD_REQUEST)

    data object InsertFailed : ServiceErrors(HttpStatus.INTERNAL_SERVER_ERROR)
    data object UpdateFailed : ServiceErrors(HttpStatus.INTERNAL_SERVER_ERROR)
    data object DeleteFailed : ServiceErrors(HttpStatus.INTERNAL_SERVER_ERROR)

    data object RecordNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object TreeNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object TreeLevelNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object ParentNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object TreeRecordDetailTypeNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object TreeRecordDetailNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object CountryCodeNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object NationalityNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object DepartureDestinationNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object PersonNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object SpecialNeedNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object SupportNeededNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object RelationTypeNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object IncidentTypeNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object BuildingTypeNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object EntityNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object IncidentNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object ZcapNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object IncidentZcapNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object DetailTypeCategoryNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
    data object ZcapDetailTypeNotFound : ServiceErrors(HttpStatus.NOT_FOUND)
}