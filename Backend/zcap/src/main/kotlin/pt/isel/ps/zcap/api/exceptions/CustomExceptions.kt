package pt.isel.ps.zcap.api.exceptions

class InvalidTokenException(message: String) : RuntimeException(message)
class DatabaseInsertException(message: String) : RuntimeException(message)
class InvalidDataException(message: String) : RuntimeException(message)
class AlreadyExistsException(message: String) : RuntimeException(message)