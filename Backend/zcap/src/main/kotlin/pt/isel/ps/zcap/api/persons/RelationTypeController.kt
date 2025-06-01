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
import pt.isel.ps.zcap.repository.dto.persons.relationType.RelationTypeInputModel
import pt.isel.ps.zcap.repository.dto.persons.relationType.RelationTypeOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.persons.RelationTypeService
import java.time.LocalDate

@RestController
@RequestMapping("api/relation-type")
class RelationTypeController(
    val service: RelationTypeService
) {
    @Operation(
        summary = "Obter uma lista de todas os tipos de relação.",
        description = "Obter uma lista de todas os tipos de relação na tabela RelationTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de tipos de relação encontradas.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = RelationTypeOutputModel::class)
                    ),
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllRelationTypes(): ResponseEntity<List<RelationTypeOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllRelationTypes())

    @Operation(
        summary = "Obter um tipo de relação pelo ID.",
        description = "Obter um tipo de relação pelo ID fornecido na tabela RelationTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Tipos de relação encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = RelationTypeOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Tipo de relação com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getRelationTypeById(@PathVariable id: Long): ResponseEntity<*> =
        when (val relationType = service.getRelationTypeById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(relationType.value)
            is Failure -> when(relationType.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Relation Type", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Insere um tipo de relação.",
        description = "Insere um tipo de relação na tabela RelationTypes.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Tipos de relação guardado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = RelationTypeOutputModel::class)
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
    fun saveRelationType(
        @RequestBody relationTypeInput: RelationTypeInputModel
    ): ResponseEntity<*> =
        when (val relationType = service.saveRelationType(relationTypeInput)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(relationType.value)
            is Failure -> when(relationType.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza um tipo de relação.",
        description = "Atualiza, pelo ID, um tipo de relação na tabela RelationTypes.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Tipos de relação guardado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = RelationTypeOutputModel::class)
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
                responseCode = "404", description = "Tipo de relação com id ### não encontrado.",
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
    @PutMapping("/{id}")
    fun updateRelationTypeById(
        @PathVariable id: Long,
        @RequestBody relationTypeInput: RelationTypeInputModel
    ): ResponseEntity<*> =
        when (
            val relationType =
                service.updateRelationTypeById(id, relationTypeInput)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(relationType.value)
            is Failure -> when(relationType.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Relation Type", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @DeleteMapping("/{id}")
    fun deleteRelationTypeById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteRelationTypeById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> when(deleted.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Relation Type", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter uma lista de tipos de relação válidos.",
        description = "Obter uma lista de tipos de relação válidos na data fornecida na tabela RelationTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista do tipos de relação encontrados.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = RelationTypeOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400", description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ErrorResponse::class)
                    ),
                )],
            ),
        ],
    )
    @GetMapping("/valid")
    fun getValidRelationTypesOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<RelationTypeOutputModel>> {
        val result = service.getRelationTypesValidOn(date)
        return ResponseEntity.ok(result)
    }
}