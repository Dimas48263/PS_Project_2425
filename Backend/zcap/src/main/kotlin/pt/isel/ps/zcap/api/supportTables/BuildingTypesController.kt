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
import pt.isel.ps.zcap.repository.dto.supportTables.BuildingTypeInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.BuildingTypeOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.supportTables.BuildingTypesService
import java.time.LocalDate

@Tag(
    name = "Building Types",
    description = "BuildingTypes representa o tipo de estruturas diferentes que podem ser utilizadas como ZCAP."
)
@SecurityRequirement(name = "BearerAuth")
@RestController
@RequestMapping("api/buildingTypes")
class BuildingTypesController(
    private val buildingTypesService: BuildingTypesService
) {

    @Operation(
        summary = "Obter todos os tipos de edificio",
        description = "Retorna todos os registos existentes na tabela Building Types",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Lista de Tipos de Edificios encontradas (pode ser uma lista vazia)",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = BuildingTypeOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllBuildingTypes(): ResponseEntity<List<BuildingTypeOutputModel>> {
        val result = buildingTypesService.getAllBuildingTypes()
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter tipos de edificio válidos numa data",
        description = "Retorna todos os tipos de edificio válidos na data fornecida",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Tipos de edificio encontradas (pode ser uma lista vazia)",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = BuildingTypeOutputModel::class),
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
    fun getValidBuildingTypesOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<BuildingTypeOutputModel>> {
        val result = buildingTypesService.getBuildingTypesValidOn(date)
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter tipo de edificio por ID",
        description = "Retorna um tipo de edificio com base no ID (chave primária) fornecido",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Tipo de edificio encontrado",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = BuildingTypeOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "404",
                description = "Tipo de edificio com o id ### não foi encontrado",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("{buildingTypeId}")
    fun getBuildingTypeById(@PathVariable buildingTypeId: Long): ResponseEntity<BuildingTypeOutputModel> =
        when (val result = buildingTypesService.getBuildingTypeById(buildingTypeId = buildingTypeId)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> {
                when (result.value) {
                    is ServiceErrors.RecordNotFound -> throw EntityNotFoundException("Entity with ID $buildingTypeId not found")
                    else -> throw Exception("An error occurred while processing the request")
                }
            }
        }

    @Operation(
        summary = "Criar novo tipo de edificio",
        description = "Adiciona um novo registo na tabela de tipos de edificio",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Registo criado com sucesso",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = BuildingTypeOutputModel::class)
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
    fun addBuildingType(@RequestBody buildingType: BuildingTypeInputModel): ResponseEntity<BuildingTypeOutputModel> =
        when (val result = buildingTypesService.addBuildingType(buildingType)) {
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
        summary = "Atualizar tipo de edificio existente",
        description = "Atualiza os dados de um tipo de edificio",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo atualizado com sucesso",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = BuildingTypeOutputModel::class)
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
                responseCode = "404", description = "Edificio com o id ### não foi encontrado", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PutMapping("{buildingTypeId}")
    fun updateBuildingType(
        @PathVariable buildingTypeId: Long, @RequestBody buildingType: BuildingTypeInputModel
    ): ResponseEntity<BuildingTypeOutputModel> =
        when (val result = buildingTypesService.updateBuildingType(buildingTypeId, buildingType)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> {
                when (result.value) {
                    is ServiceErrors.InvalidDataInput -> throw InvalidDataException("Invalid data provided")
                    is ServiceErrors.RecordNotFound -> throw EntityNotFoundException("Entity with ID $buildingTypeId not found")
                    is ServiceErrors.InsertFailed -> throw DatabaseInsertException("Failed to insert record into the database")
                    else -> throw Exception("An error occurred while processing the request")
                }
            }
        }
}