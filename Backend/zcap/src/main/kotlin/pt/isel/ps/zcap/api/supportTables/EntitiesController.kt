package pt.isel.ps.zcap.api.supportTables

import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.media.ArraySchema
import io.swagger.v3.oas.annotations.media.Content
import io.swagger.v3.oas.annotations.media.Schema
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.persistence.EntityNotFoundException
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.api.exceptions.DatabaseInsertException
import pt.isel.ps.zcap.api.exceptions.InvalidDataException
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.supportTables.EntitiesInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.EntitiesOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.supportTables.EntitiesService
import java.time.LocalDate

@Tag(name = "Entities", description = "Tabela de entidades oficiais disponíveis")
@SecurityRequirement(name = "BearerAuth")
@RestController
@RequestMapping("api/entities")
class EntitiesController(
    private val entitiesService: EntitiesService
) {

    @Operation(
        summary = "Obter todas as entidades",
        description = "Retorna todos os registos existentes na tabela Entities",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Entidades encontradas (pode ser uma lista vazia)",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = EntitiesOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllEntities(): ResponseEntity<List<EntitiesOutputModel>> {
        val result = entitiesService.getAllEntities()
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter Entidades válidas numa data",
        description = "Retorna todas as Entidades válidas na data fornecida",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Entidades encontradas (pode ser uma lista vazia)",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = EntitiesOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("valid")
    fun getValidEntitiesOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<EntitiesOutputModel>> {
        val result = entitiesService.getEntitiesValidOn(date)
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter Entidade por ID",
        description = "Retorna uma Entidade com base no ID (chave primária) fornecido",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Entidade encontrada",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = EntitiesOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "404", description = "Entidade com o id ### não foi encontrado", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("{entityId}")
    fun getEntitiesById(@PathVariable entityId: Long): ResponseEntity<EntitiesOutputModel> =
        when (val result = entitiesService.getEntityById(entityId = entityId)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> {
                when (result.value) {
                    is ServiceErrors.RecordNotFound -> throw EntityNotFoundException("Entity with ID $entityId not found")
                    else -> throw Exception("An error occurred while processing the request")
                }
            }
        }

    @Operation(
        summary = "Criar uma nova Entidade",
        description = "Adiciona um novo registo na tabela de entidades",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Registo criado com sucesso",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = EntitiesOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PostMapping
    fun addEntity(@RequestBody entity: EntitiesInputModel): ResponseEntity<EntitiesOutputModel> =
        when (val result = entitiesService.addEntity(entity)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(result.value)
            is Failure -> {
                when (result.value) {
                    is ServiceErrors.InvalidDataInput -> throw InvalidDataException("Invalid data provided")
                    is ServiceErrors.InsertFailed -> throw DatabaseInsertException("Failed to insert record into the database")
                    is ServiceErrors.RecordNotFound -> throw EntityNotFoundException("No record found with provided ID")
                    else -> throw Exception("An error occurred while processing the request")
                }
            }
        }

    @Operation(
        summary = "Atualizar uma Entidade existente",
        description = "Atualiza os dados de uma entidade",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo atualizado com sucesso",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = EntitiesOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Entidade com o id ### não foi encontrado", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PutMapping("{entityId}")
    fun updateEntity(
        @PathVariable entityId: Long, @RequestBody entityType: EntitiesInputModel
    ): ResponseEntity<EntitiesOutputModel> = when (val result = entitiesService.updateEntity(entityId, entityType)) {
        is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
        is Failure -> {
            when (result.value) {
                is ServiceErrors.InvalidDataInput -> throw InvalidDataException("Invalid data provided")
                is ServiceErrors.RecordNotFound -> throw EntityNotFoundException("Entity with ID $entityId not found")
                is ServiceErrors.InsertFailed -> throw DatabaseInsertException("Failed to insert record into the database")
                else -> throw Exception("An error occurred while processing the request")
            }
        }
    }
}