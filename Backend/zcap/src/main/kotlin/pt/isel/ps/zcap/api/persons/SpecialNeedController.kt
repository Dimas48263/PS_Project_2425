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
import pt.isel.ps.zcap.repository.dto.persons.specialNeed.SpecialNeedInputModel
import pt.isel.ps.zcap.repository.dto.persons.specialNeed.SpecialNeedOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.persons.SpecialNeedService
import java.time.LocalDate

@RestController
@RequestMapping("api/special-needs")
class SpecialNeedController(
    val service: SpecialNeedService
) {
    @Operation(
        summary = "Obter uma lista de todas as necessidades especiais.",
        description = "Obter uma lista de todas as necessidades especiais na tabela SpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de necessidades especiais encontradas.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = SpecialNeedOutputModel::class)
                    ),
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllSpecialNeeds(): ResponseEntity<List<SpecialNeedOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllSpecialNeeds())

    @Operation(
        summary = "Obter uma necessidade especial pelo ID.",
        description = "Obter uma necessidade especial pelo ID na tabela SpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Necessidades especial encontradas.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = SpecialNeedOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Necessidade especial com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getSpecialNeedById(@PathVariable id: Long): ResponseEntity<*> =
        when (val specialNeed = service.getSpecialNeedById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(specialNeed.value)
            is Failure -> when(specialNeed.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Special Need", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Insere uma necessidade especial.",
        description = "Insere uma necessidade especial na tabela SpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Necessidades especial guardada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = SpecialNeedOutputModel::class)
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
    fun saveSpecialNeed(
        @RequestBody specialNeedInput: SpecialNeedInputModel
    ): ResponseEntity<*> =
        when (val specialNeed = service.saveSpecialNeed(specialNeedInput)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(specialNeed.value)
            is Failure -> when(specialNeed.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza uma necessidade especial pelo ID.",
        description = "Atualiza uma necessidade especial pelo ID na tabela SpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Necessidade especial atualizada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = SpecialNeedOutputModel::class)
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
                responseCode = "404", description = "Necessidade especial com id ### não encontrado.",
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
    fun updateSpecialNeedById(
        @PathVariable id: Long,
        @RequestBody specialNeedInput: SpecialNeedInputModel
    ): ResponseEntity<*> =
        when (
            val specialNeed =
                service.updateSpecialNeedById(id, specialNeedInput)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(specialNeed.value)
            is Failure -> when(specialNeed.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Special Need", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @DeleteMapping("/{id}")
    fun deleteSpecialNeedById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteSpecialNeedById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> when(deleted.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Special Need", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter uma lista de todas as necessidades especiais válidas.",
        description = "Obter uma lista de todas as necessidades válidas especiais na data fornecida na tabela SpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de necessidades especiais encontradas.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = SpecialNeedOutputModel::class)
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
    fun getValidSpecialNeedsOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<SpecialNeedOutputModel>> {
        val result = service.getSpecialNeedsValidOn(date)
        return ResponseEntity.ok(result)
    }
}