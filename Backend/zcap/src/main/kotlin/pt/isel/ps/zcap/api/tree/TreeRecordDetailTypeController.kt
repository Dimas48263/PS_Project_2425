package pt.isel.ps.zcap.api.tree

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
import pt.isel.ps.zcap.api.insertionFailedErrorMessage
import pt.isel.ps.zcap.api.exceptions.DatabaseInsertException
import pt.isel.ps.zcap.api.exceptions.InvalidDataException
import pt.isel.ps.zcap.api.notFoundMessage
import pt.isel.ps.zcap.api.invalidDataErrorMessage
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType.TreeRecordDetailTypeInputModel
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType.TreeRecordDetailTypeOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeRecordDetailTypeService
import java.time.LocalDate

@RestController
@RequestMapping("api/tree-record-detail-types")
class TreeRecordDetailTypeController(
    private val service: TreeRecordDetailTypeService
) {
    @Operation(
        summary = "Obter todos os tipos de detalhe.",
        description = "Retorna todos os registos existentes na tabela TreeRecordDetailTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de detalhes de árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeRecordDetailTypeOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllTrees(): ResponseEntity<List<TreeRecordDetailTypeOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllTreeRecordTypes())

    @Operation(
        summary = "Obter um tipo de detalhe.",
        description = "Retorna o tipo de detalhe com o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Tipo de detalhe encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeRecordDetailTypeOutputModel::class),
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
                responseCode = "404", description = "Tipo de detalhe com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getTreeRecordDetailTypeById(@PathVariable id: Long): ResponseEntity<*> =
        when (val trdt = service.getTreeRecordDetailTypeById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(trdt.value)
            is Failure -> when(trdt.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail Type", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Inserir um tipo de detalhe.",
        description = "Insere um tipo de detalhe na tabela TreeRecordDetailTypes.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Tipo de detalhe guardado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeRecordDetailTypeOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400", description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
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
    fun saveTreeRecordDetailType(
        @RequestBody treeRecordDetailTypeRequest: TreeRecordDetailTypeInputModel
    ): ResponseEntity<*> =
        when(
            val trdt =
                service.saveTreeRecordDetailType(treeRecordDetailTypeRequest)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(trdt.value)
            is Failure -> when(trdt.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza um tipo de detalhe.",
        description = "Atualiza um tipo de detalhe na tabela TreeRecordDetailTypes com o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Tipo de detalhe atualizado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeRecordDetailTypeOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400", description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Tipo de detalhe com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
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
    fun updateTreeRecordDetailTypeById(
        @PathVariable id: Long,
        @RequestBody treeRecordDetailTypeUpdateRequest: TreeRecordDetailTypeInputModel
    ): ResponseEntity<*> =
        when (val trdt =
            service.updateTreeRecordDetailTypeById(
                id,
                treeRecordDetailTypeUpdateRequest
            )) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(trdt.value)
            is Failure -> when(trdt.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail Type", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @DeleteMapping("/{id}")
    fun deleteTreeRecordDetailTypeById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteTreeRecordDetailTypeById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> when(deleted.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail Type", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os tipos de detalhe validos numa data.",
        description = "Retorna todos os registos existentes na tabela TreeRecordDetailTypes válidos na data fornecida.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de detalhes de árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeRecordDetailTypeOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "400", description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/valid")
    fun getValidTreeRecordDetailTypesOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<TreeRecordDetailTypeOutputModel>> {
        val result = service.getTreeRecordDetailTypesValidOn(date)
        return ResponseEntity.ok(result)
    }
}

