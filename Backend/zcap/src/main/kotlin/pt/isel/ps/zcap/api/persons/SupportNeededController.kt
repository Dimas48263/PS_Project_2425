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
import pt.isel.ps.zcap.repository.dto.persons.supportNeeded.SupportNeededInputModel
import pt.isel.ps.zcap.repository.dto.persons.supportNeeded.SupportNeededOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.persons.SupportNeededService
import java.time.LocalDate

@RestController
@RequestMapping("api/support-needed")
class SupportNeededController(
    val service: SupportNeededService
) {
    @Operation(
        summary = "Obter uma lista de todas os suportes necessários.",
        description = "Obter uma lista de todas os suportes necessários na tabela SupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de suportes necessários encontradas.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = SupportNeededOutputModel::class)
                    ),
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllSupportNeeded(): ResponseEntity<List<SupportNeededOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllSupportNeeded())

    @Operation(
        summary = "Obter um suporte necessário pelo ID.",
        description = "Obter um suporte necessário pelo ID na tabela SupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Suportes necessário encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = SupportNeededOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Suporte necessário com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getSupportNeededById(@PathVariable id: Long): ResponseEntity<*> =
        when (val supportNeeded = service.getSupportNeededById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(supportNeeded.value)
            is Failure -> when(supportNeeded.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Support Needed", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Inserir um suporte necessário.",
        description = "Inserir um suporte necessário na tabela SupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Suportes necessário guardado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = SupportNeededOutputModel::class)
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
    fun saveSupportNeeded(
        @RequestBody supportNeededInput: SupportNeededInputModel
    ): ResponseEntity<*> =
        when (val supportNeeded = service.saveSupportNeeded(supportNeededInput)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(supportNeeded.value)
            is Failure -> when(supportNeeded.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualizar um suporte necessário pelo ID.",
        description = "Atualizar um suporte necessário pelo ID na tabela SupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Suportes necessário atualizado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = SupportNeededOutputModel::class)
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
                responseCode = "404", description = "Suporte necessário com id ### não encontrado.",
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
    fun updateSupportNeededById(
        @PathVariable id: Long,
        @RequestBody supportNeededInput: SupportNeededInputModel
    ): ResponseEntity<*> =
        when (
            val supportNeeded =
                service.updateSupportNeededById(id, supportNeededInput)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(supportNeeded.value)
            is Failure -> when(supportNeeded.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Support Needed", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @DeleteMapping("/{id}")
    fun deleteSupportNeededById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteSupportNeededById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> when(deleted.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Support Needed", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter uma lista de todas os suportes necessários válidos.",
        description = "Obter uma lista de todas os suportes necessários válidos na data fornecida na tabela SupportNeeded.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de suportes necessários encontradas.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = SupportNeededOutputModel::class)
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
    fun getValidSupportNeededOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<SupportNeededOutputModel>> {
        val result = service.getSupportNeededValidOn(date)
        return ResponseEntity.ok(result)
    }
}