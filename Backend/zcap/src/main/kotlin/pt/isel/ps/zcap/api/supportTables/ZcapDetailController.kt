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
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetails.ZcapDetailInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetails.ZcapDetailOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.supportTables.ZcapDetailService
import java.time.LocalDate

@RestController
@RequestMapping("api/zcap-details")
class ZcapDetailController(
    private val service: ZcapDetailService
) {
    @Operation(
        summary = "Obter todos os detalhes das zcaps.",
        description = "Retorna todos os registos existentes na tabela ZcapDetails.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista dos registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ZcapDetailOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllZcapDetailTypes(): ResponseEntity<List<ZcapDetailOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllZcapDetails())

    @Operation(
        summary = "Obter um detalhe das zcaps pelo ID.",
        description = "Retorna o detalhe das zcaps encontrada pelo ID na tabela zcapDetailTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Zcaps encontrada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapDetailOutputModel::class),
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
    fun getZcapDetailById(@PathVariable id: Long): ResponseEntity<ZcapDetailOutputModel> =
        when (val zcapDetail = service.getZcapDetailById(id)) {
            is Success -> ResponseEntity.ok(zcapDetail.value)
            is Failure -> when(zcapDetail.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap Detail", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Inserir um detalhe das zcaps.",
        description = "Insere e retorna o detalhe guardado na tabela ZcapDetails.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo guardado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapDetailOutputModel::class),
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
                description = "Zcap/Tipo de detalhe com o id ### não foi encontrado.",
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
    fun saveZcapDetail(@RequestBody input: ZcapDetailInputModel): ResponseEntity<ZcapDetailOutputModel> =
        when (val zcapDetail = service.saveZcapDetail(input)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(zcapDetail.value)
            is Failure -> when(zcapDetail.value) {
                is ServiceErrors.ZcapNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap", input.zcapId))
                is ServiceErrors.ZcapDetailTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap Detail Type", input.zcapDetailTypeId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualizar um detalhe das zcaps pelo ID.",
        description = "Atualiza e retorna o detalhe atuzalizado pelo ID na tabela ZcapDetails.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo atualizado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ZcapDetailOutputModel::class),
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
                description = "Zcap/tipo de detalhe/detalhe com o id ### não foi encontrado.", content = [Content(
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
    fun updateZcapDetailById(
        @PathVariable id: Long,
        @RequestBody input: ZcapDetailInputModel
    ): ResponseEntity<ZcapDetailOutputModel> =
        when (val zcapDetail = service.updateZcapDetailById(id, input)) {
            is Success -> ResponseEntity.ok(zcapDetail.value)
            is Failure -> when(zcapDetail.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap Detail", input.zcapId))
                is ServiceErrors.ZcapNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap", input.zcapId))
                is ServiceErrors.ZcapDetailTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap Detail Type", input.zcapDetailTypeId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os detalhes das zcaps válidos numa data.",
        description = "Retorna todos os registos válidos na data fornecida existentes na tabela ZcapDetails.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = ZcapDetailOutputModel::class),
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
    fun getZcapDetailsValidOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<ZcapDetailOutputModel>> = ResponseEntity.ok(service.getZcapDetailsValidOn(date))

}