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
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes.ZcapDetailTypeInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes.ZcapDetailTypeOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.supportTables.ZcapDetailTypeService
import java.time.LocalDate

@RestController
@RequestMapping("api/zcap-detail-types")
class ZcapDetailTypeController(
    private val service: ZcapDetailTypeService
) {
    @Operation(
        summary = "Obter todos os tipos de detalhe das zcaps.",
        description = "Retorna todos os registos existentes na tabela zcapDetailTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista dos registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ZcapDetailTypeOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllZcapDetailTypes(): ResponseEntity<List<ZcapDetailTypeOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllZcapDetailTypes())

    @Operation(
        summary = "Obter tipo de detalhe das zcaps pelo ID.",
        description = "Retorna o tipo de detalhe das zcaps encontrada pelo ID na tabela zcapDetailTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Zcaps encontrada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapDetailTypeOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha ao traduzir o ID fornecido.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Zcap Detail Type com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getZcapDetailTypeById(@PathVariable id: Long): ResponseEntity<ZcapDetailTypeOutputModel> =
        when (val zcapDetailType = service.getZcapDetailTypeById(id)) {
            is Success -> ResponseEntity.ok(zcapDetailType.value)
            is Failure -> when(zcapDetailType.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap Detail Type", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Inserir um tipo de detalhe das zcaps.",
        description = "Insere e retorna o tipo de detalhe guardado na tabela ZcapDetailTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo guardado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapDetailTypeOutputModel::class),
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
                description = "Categoria do tipo de detalhe com o id ### não foi encontrado.",
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
    fun saveZcapDetailTypes(@RequestBody input: ZcapDetailTypeInputModel): ResponseEntity<ZcapDetailTypeOutputModel> =
        when (val zcapDetailType = service.saveZcapDetailType(input)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(zcapDetailType.value)
            is Failure -> when(zcapDetailType.value) {
                is ServiceErrors.DetailTypeCategoryNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Detail Type Category", input.detailTypeCategoryId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualizar um tipo de detalhe das zcaps pelo ID.",
        description = "Atualiza e retorna o tipo de detalhe atuzalizado pelo ID na tabela ZcapDetailTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo atualizado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapDetailTypeOutputModel::class),
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
                description = "Categoria/tipo de detalhe com o id ### não foi encontrado.", content = [Content(
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
    fun updateZcapDetailTypeById(
        @PathVariable id: Long,
        @RequestBody input: ZcapDetailTypeInputModel): ResponseEntity<ZcapDetailTypeOutputModel> =
        when (val zcapDetailType = service.updateZcapDetailTypeById(id, input)) {
            is Success -> ResponseEntity.ok(zcapDetailType.value)
            is Failure -> when(zcapDetailType.value) {
                is ServiceErrors.BuildingTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Detail Type Category", input.detailTypeCategoryId))
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap Detail Type", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os tipos de detalhes das zcaps válidos numa data.",
        description = "Retorna todos os registos válidos na data fornecida existentes na tabela ZcapDetailTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ZcapDetailTypeOutputModel::class),
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
    fun getZcapDetailTypesValidOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<ZcapDetailTypeOutputModel>> = ResponseEntity.ok(service.getZcapDetailTypesValidOn(date))

}