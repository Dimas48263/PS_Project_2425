package pt.isel.ps.zcap.api.exceptions

import jakarta.persistence.EntityNotFoundException
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException
import pt.isel.ps.zcap.repository.dto.ErrorResponse


@RestControllerAdvice
class GlobalExceptionHandler {

    @ExceptionHandler(Exception::class)
    fun handleGenericException(ex: Exception): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            errorCode = "GENERAL_ERROR",
            errorMessage = "An unexpected error occurred.",
            details = ex.message,
        )
        return ResponseEntity(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR)
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException::class)
    fun handleInvalidData(ex: MethodArgumentTypeMismatchException): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            errorCode = "INVALID_ARGUMENT_TYPE",
            errorMessage = "Invalid argument type. Expected ${ex.requiredType?.simpleName} but received ${ex.value?.javaClass?.simpleName}."
        )
        return ResponseEntity(errorResponse, HttpStatus.BAD_REQUEST)
//            .body("Invalid date format or value: ${ex.value}. Use valid ISO date (yyyy-MM-dd).")
    }

    @ExceptionHandler(EntityNotFoundException::class)
    fun handleEntityNotFoundException(ex: EntityNotFoundException): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            errorCode = "ENTITY_NOT_FOUND",
            errorMessage = "The entity with the given ID was not found.",
            details = ex.message,
        )
        return ResponseEntity(errorResponse, HttpStatus.NOT_FOUND)
    }

    @ExceptionHandler(NoSuchElementException::class)
    fun handleNoSuchElementException(ex: NoSuchElementException): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            errorCode = "ELEMENT_NOT_FOUND",
            errorMessage = "Requested element was not found.",
            details = ex.message,
        )
        return ResponseEntity(errorResponse, HttpStatus.NOT_FOUND)
    }

    @ExceptionHandler(InvalidDataException::class)
    fun handleInvalidDataException(ex: InvalidDataException): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            errorCode = "INVALID_DATA",
            errorMessage = ex.message ?: "Invalid data provided",
        )
        return ResponseEntity(errorResponse, HttpStatus.BAD_REQUEST)
    }

    @ExceptionHandler(DatabaseInsertException::class)
    fun handleDatabaseInsertException(ex: DatabaseInsertException): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            errorCode = "INSERT_FAILED",
            errorMessage = ex.message ?: "Failed to insert record on database",
        )
        return ResponseEntity(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR)
    }

    @ExceptionHandler(InvalidTokenException::class)
    fun handleInvalidTokenException(ex: InvalidTokenException): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            errorCode = "INVALID_TOKEN",
            errorMessage = "Invalid or expired Token.",
            details = ex.message,
        )
        return ResponseEntity(errorResponse, HttpStatus.UNAUTHORIZED)
    }

    @ExceptionHandler(AlreadyExistsException::class)
    fun handleAlreadyExistsException(ex: AlreadyExistsException): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            errorCode = "ALREADY_EXISTS",
            errorMessage = "Entity already exists.",
            details = ex.message
        )
        return ResponseEntity(errorResponse, HttpStatus.CONFLICT)
    }
}
