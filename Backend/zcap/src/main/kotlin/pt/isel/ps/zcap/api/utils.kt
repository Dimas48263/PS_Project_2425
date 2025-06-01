package pt.isel.ps.zcap.api

const val insertionFailedErrorMessage = "Failed to insert record into the database."
const val invalidDataErrorMessage = "Invalid data provided."
fun notFoundMessage(obj: String, id: Long?) = "$obj with ID $id not found."
fun alreadyExistsMessage(table: String) = "Already exists in table $table the given object."