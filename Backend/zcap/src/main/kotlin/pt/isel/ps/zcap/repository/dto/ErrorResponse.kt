package pt.isel.ps.zcap.repository.dto

data class ErrorResponse(
    val errorCode: String,
    val errorMessage: String,
    val details: String? = null
)