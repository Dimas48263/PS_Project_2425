package pt.isel.ps.zcap.api.persons

import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.media.ArraySchema
import io.swagger.v3.oas.annotations.media.Content
import io.swagger.v3.oas.annotations.media.Schema
import io.swagger.v3.oas.annotations.responses.ApiResponse
import jakarta.persistence.EntityNotFoundException
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.api.exceptions.DatabaseInsertException
import pt.isel.ps.zcap.api.exceptions.InvalidDataException
import pt.isel.ps.zcap.api.insertionFailedErrorMessage
import pt.isel.ps.zcap.api.invalidDataErrorMessage
import pt.isel.ps.zcap.api.notFoundMessage
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.persons.personSupportNeeded.PersonSupportNeededInputModel
import pt.isel.ps.zcap.repository.dto.persons.personSupportNeeded.PersonSupportNeededOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.persons.PersonSupportNeededService
import java.time.LocalDate

@RestController
@RequestMapping("api/person-support-needed")
class PersonSupportNeededController(
    val service: PersonSupportNeededService
) {
    @Operation(
        summary = "Obter uma lista de todos suportes necessários de qualquer pessoa.",
        description = "Obter uma lista de todos suportes necessários de qualquer pessoa na tabela PersonSupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de todos suportes necessários de qualquer pessoa encontradas.",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = PersonSupportNeededOutputModel::class)
                    ),
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllPersonSupportNeeded(): ResponseEntity<List<PersonSupportNeededOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllPersonSupportNeeded())

    @Operation(
        summary = "Obter um suporte necessário de uma pessoa pelo ID.",
        description = "Obter um suporte necessário de uma pessoa pelo ID na tabela PersonSupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Suporte necessário de uma pessoa encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonSupportNeededOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Suporte necessário de uma pessoa com id ### nao encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getPersonSupportNeededById(@PathVariable id: Long): ResponseEntity<*> =
        when (val personSupportNeeded = service.getPersonSupportNeededById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(personSupportNeeded.value)
            is Failure -> when(personSupportNeeded.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person Support Needed", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Inserir um suporte necessário de uma pessoa.",
        description = "Inserir um suporte necessário de uma pessoa na tabela PersonSupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Suporte necessário de uma pessoa guardado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonSupportNeededOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400", description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao inserir registo na base de dados.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PostMapping
    fun savePersonSupportNeeded(
        @RequestBody personSupportNeededInput: PersonSupportNeededInputModel
    ): ResponseEntity<*> =
        when (val personSupportNeeded = service.savePersonSupportNeeded(personSupportNeededInput)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(personSupportNeeded.value)
            is Failure -> when(personSupportNeeded.value) {
                is ServiceErrors.PersonNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person", personSupportNeededInput.personId))
                is ServiceErrors.SupportNeededNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Support Needed", personSupportNeededInput.supportNeededId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualizar um suporte necessário de uma pessoa, pelo ID.",
        description = "Atualizar um suporte necessário de uma pessoa, pelo ID, na tabela PersonSupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Suporte necessário de uma pessoa atualizado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonSupportNeededOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400", description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
            ApiResponse(
                responseCode = "404", description = "Suporte necessário de uma pessoa com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao atualizar registo na base de dados.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PutMapping("/{id}")
    fun updatePersonSupportNeeded(
        @PathVariable id: Long,
        @RequestBody personSupportNeededInput: PersonSupportNeededInputModel
    ): ResponseEntity<*> =
        when (val personSupportNeeded = service.updatePersonSupportNeededById(id, personSupportNeededInput)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(personSupportNeeded.value)
            is Failure -> when(personSupportNeeded.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person Support Needed", id))
                is ServiceErrors.PersonNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person", personSupportNeededInput.personId))
                is ServiceErrors.SupportNeededNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Support Needed", personSupportNeededInput.supportNeededId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Apaga um suporte necessário de uma pessoa, pelo ID.",
        description = "Apaga um registo de um suporte necessário de uma pessoa, pelo ID, na tabela PersonSupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "204", description = "Suporte necessário de uma pessoa apagado com sucesso.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonSupportNeededOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Suporte necessário de uma pessoa com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao apagar registo na base de dados.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @DeleteMapping("/{id}")
    fun deletePersonSupportNeededById(@PathVariable id: Long): ResponseEntity<*> =
        when (val delete = service.deletePersonSupportNeededById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(delete.value)
            is Failure -> when(delete.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person Support Nedded", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter uma lista de suportes necessários qualquer pessoa válidos.",
        description = "Obter uma lista de suportes necessários qualquer pessoa, válidos na data fornecida, da tabela PersonSupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de suportes necessários de qualquer pessoa válidos encontrados.",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = PersonSupportNeededOutputModel::class)
                    ),
                )],
            ),
            ApiResponse(
                responseCode = "400", description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
        ],
    )
    @GetMapping("/valid")
    fun getValidPersonSupportNeededOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<PersonSupportNeededOutputModel>> {
        val result = service.getPersonSupportNeededValidOn(date)
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter uma lista de suportes necessários de uma pessoa.",
        description = "Obter uma lista de suportes necessários de uma pessoa, dado o seu ID, da tabela PersonSupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de suportes necessários de uma pessoa encontrados.",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = PersonSupportNeededOutputModel::class)
                    ),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Pessoa com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
        ],
    )
    @GetMapping("/person/{id}")
    fun getPersonSupportNeededByPersonId(@PathVariable id: Long): ResponseEntity<*> =
        when (val personSupportNeeded = service.getPersonSupportNeededByPersonId(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(personSupportNeeded.value)
            is Failure -> when(personSupportNeeded.value) {
                is ServiceErrors.PersonNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }
}