package pt.isel.ps.zcap.api.supportTables

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
import pt.isel.ps.zcap.repository.dto.supportTables.ZcapInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.ZcapOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.supportTables.ZcapService
import java.time.LocalDate

@RestController
@RequestMapping("api/zcaps")
class ZcapController(
    private val service: ZcapService
){
    @Operation(
        summary = "Obter todas as zcaps.",
        description = "Retorna todos os registos existentes na tabela Zcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de zcaps encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ZcapOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllZcaps(): ResponseEntity<List<ZcapOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllZcaps())

    @Operation(
        summary = "Obter zcap pelo ID.",
        description = "Retorna a zcap encontrada pelo ID na tabela Zcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Zcaps encontrada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha ao traduzir o ID fornecido.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Zcap com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getZcapById(@PathVariable id: Long): ResponseEntity<*> =
        when (val zcap = service.getZcapById(id)) {
            is Success -> ResponseEntity.ok(zcap.value)
            is Failure -> when(zcap.value) {
                is ServiceErrors.RecordNotFound -> throw EntityNotFoundException(notFoundMessage("Zcap", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Inserir uma zcap.",
        description = "Insere e retorna a zcap guardada na tabela Zcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Zcaps guardada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Tipo de edificio/árvore/entidade com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
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
    fun saveZcap(@RequestBody input: ZcapInputModel): ResponseEntity<*> =
        when (val zcap = service.saveZcap(input)) {
            is Success -> ResponseEntity.ok(zcap.value)
            is Failure -> when(zcap.value) {
                is ServiceErrors.BuildingTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Building Type", input.buildingTypeId))
                is ServiceErrors.TreeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree", input.treeRecordId))
                is ServiceErrors.EntityNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Entity", input.entityId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualizar uma zcap pelo ID.",
        description = "Atualiza e retorna a zcap atuzalizada pelo ID na tabela Zcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Zcaps atualizada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Zcap/tipo de edificio/árvore/entidade com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao atulizar registo na base de dados.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PutMapping("/{id}")
    fun updateZcapById(@PathVariable id: Long, @RequestBody input: ZcapInputModel): ResponseEntity<*> =
        when (val zcap = service.updateZcapById(id, input)) {
            is Success -> ResponseEntity.ok(zcap.value)
            is Failure -> when(zcap.value) {
                is ServiceErrors.BuildingTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Building Type", input.buildingTypeId))
                is ServiceErrors.TreeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree", input.treeRecordId))
                is ServiceErrors.EntityNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Entity", input.entityId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todas as zcaps válidas numa data.",
        description = "Retorna todos os registos válidos na data fornecida existentes na tabela Zcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de zcaps encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ZcapOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha ao traduzir a data fornecida.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/valid")
    fun getZcapsValidOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<*> = ResponseEntity.ok(service.getAllZcapsValidOn(date))

    @Operation(
        summary = "Obter zcaps pelo tipo de edificio.",
        description = "Retorna todos os registos com o o tipo de edificio fornecido existentes na tabela Zcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de zcaps encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ZcapOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha ao traduzir o id fornecido.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Tipo de edificio com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/building-types/{id}")
    fun getZcapsByBuildingTypeId(@PathVariable id: Long): ResponseEntity<*> =
        when (val zcap = service.getZcapsByBuildingTypeId(id)) {
            is Success -> ResponseEntity.ok(zcap.value)
            is Failure -> when(zcap.value) {
                is ServiceErrors.BuildingTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Building Type", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter zcaps pela entidade.",
        description = "Retorna todos os registos com entidade fornecido existentes na tabela Zcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de zcaps encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ZcapOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha ao traduzir o id fornecido.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Entidade com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/entities/{id}")
    fun getZcapsByEntityId(@PathVariable id: Long): ResponseEntity<*> =
        when (val zcap = service.getZcapsByEntityId(id)) {
            is Success -> ResponseEntity.ok(zcap.value)
            is Failure -> when(zcap.value) {
                is ServiceErrors.BuildingTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Entity", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

}