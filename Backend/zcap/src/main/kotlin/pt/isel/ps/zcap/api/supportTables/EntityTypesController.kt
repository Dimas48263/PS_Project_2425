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
import pt.isel.ps.zcap.repository.dto.supportTables.EntityTypeInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.EntityTypeOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.supportTables.EntityTypesService
import java.time.LocalDate

@Tag(name = "1 - (Swagger Example) Entity Types", description = "EntityTypes representa o agrupador de entidades.")
@SecurityRequirement(name = "BearerAuth")
@RestController
@RequestMapping("api/entityTypes")
class EntityTypesController(
    private val entityTypesService: EntityTypesService
) {

    @Operation(
        summary = "Obter todos os tipos de entidade",
        description = "Retorna todos os registos existentes na tabela Entity Types",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Tipos de Entidade encontradas (pode ser uma lista vazia)",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = EntityTypeOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllEntityTypes(): ResponseEntity<List<EntityTypeOutputModel>> {
        val result = entityTypesService.getAllEntityTypes()
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter tipos de entidade válidos numa data",
        description = "Retorna todos os tipos de entidade válidos na data fornecida",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Tipos de Entidade encontradas (pode ser uma lista vazia)",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = EntityTypeOutputModel::class),
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
    fun getValidEntityTypesOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<EntityTypeOutputModel>> {
        val result = entityTypesService.getEntityTypesValidOn(date)
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter tipo de entidade por ID",
        description = "Retorna um tipo de entidade com base no ID (chave primária) fornecido",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Entidade encontrada",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = EntityTypeOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "404", description = "Entidade com o id ### não foi encontrado", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("{entityTypeId}")
    fun getEntityTypeById(@PathVariable entityTypeId: Long): ResponseEntity<EntityTypeOutputModel> =
        when (val result = entityTypesService.getEntityTypeById(entityTypeId = entityTypeId)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> {
                when (result.value) {
                    is ServiceErrors.RecordNotFound -> throw EntityNotFoundException("Entity with ID $entityTypeId not found")
                    else -> throw Exception("An error occurred while processing the request")
                }
            }
        }

    @Operation(
        summary = "Criar novo tipo de entidade",
        description = "Adiciona um novo registo na tabela de tipos de entidade",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Registo criado com sucesso",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = EntityTypeOutputModel::class)
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
    fun addEntityType(@RequestBody entityType: EntityTypeInputModel): ResponseEntity<EntityTypeOutputModel> =
        when (val result = entityTypesService.addEntityType(entityType)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(result.value)
            is Failure -> {
                when (result.value) {
                    is ServiceErrors.InvalidDataInput -> throw InvalidDataException("Invalid data provided")
                    is ServiceErrors.InsertFailed -> throw DatabaseInsertException("Failed to insert record into the database")
                    else -> throw Exception("An error occurred while processing the request")
                }
            }
        }

    @Operation(
        summary = "Atualizar tipo de entidade existente",
        description = "Atualiza os dados de um tipo de entidade",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo atualizado com sucesso",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = EntityTypeOutputModel::class)
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
    @PutMapping("{entityTypeId}")
    fun updateEntityType(
        @PathVariable entityTypeId: Long, @RequestBody entityType: EntityTypeInputModel
    ): ResponseEntity<EntityTypeOutputModel> = when (val result = entityTypesService.updateEntityType(entityTypeId, entityType)) {
        is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
        is Failure -> {
            when (result.value) {
                is ServiceErrors.InvalidDataInput -> throw InvalidDataException("Invalid data provided")
                is ServiceErrors.RecordNotFound -> throw EntityNotFoundException("Entity with ID $entityTypeId not found")
                is ServiceErrors.InsertFailed -> throw DatabaseInsertException("Failed to insert record into the database")
                else -> throw Exception("An error occurred while processing the request")
            }
        }
    }
}