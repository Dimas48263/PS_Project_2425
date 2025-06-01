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
import pt.isel.ps.zcap.api.exceptions.DatabaseInsertException
import pt.isel.ps.zcap.api.exceptions.InvalidDataException
import pt.isel.ps.zcap.api.insertionFailedErrorMessage
import pt.isel.ps.zcap.api.invalidDataErrorMessage
import pt.isel.ps.zcap.api.notFoundMessage
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail.TreeRecordDetailInputModel
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail.TreeRecordDetailOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeRecordDetailService
import java.time.LocalDate

@RestController
@RequestMapping("api/tree-record-details")
class TreeRecordDetailController(
    private val service: TreeRecordDetailService
) {
    @Operation(
        summary = "Obter todos os detalhes.",
        description = "Retorna todos os registos existentes na tabela TreeRecordDetails.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de detalhes encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeRecordDetailOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllTreeRecordDetails(): ResponseEntity<List<TreeRecordDetailOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllTreeRecordDetails())

    @Operation(
        summary = "Obter um detalhe.",
        description = "Retorna um detalhe com o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Detalhe encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeRecordDetailOutputModel::class),
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
                responseCode = "404", description = "Detalhe com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getTreeRecordDetailById(@PathVariable id: Long): ResponseEntity<*> =
        when (val treeRecordDetail = service.getTreeRecordDetailById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(treeRecordDetail.value)
            is Failure -> when(treeRecordDetail.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Insere um detalhe.",
        description = "Insere um detalhe na tabela TreeRecordDetails.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Detalhe guardado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeRecordDetailOutputModel::class),
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
                responseCode = "404", description = "Tipo de detalhe/árvore com o id ### não foi encontrado.", content = [Content(
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
    fun saveTreeRecordDetail(@RequestBody treeRecordDetailRequest: TreeRecordDetailInputModel): ResponseEntity<*> =
        when (
            val tree =
                service.saveTreeRecordDetail(treeRecordDetailRequest)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(tree.value)
            is Failure -> when(tree.value) {
                is ServiceErrors.TreeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree", treeRecordDetailRequest.treeRecordId))
                is ServiceErrors.TreeRecordDetailTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail Type", treeRecordDetailRequest.detailTypeId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza um detalhe.",
        description = "Retorna o detalhe atualizado com o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Detalhe atualizado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeRecordDetailOutputModel::class),
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
                responseCode = "404",
                description = "Tipo de detalhe/Árvore/Detalhe com o id ### não foi encontrado.",
                content = [Content(
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
    fun updateTreeById(
        @PathVariable id: Long,
        @RequestBody treeRecordDetailUpdateRequest: TreeRecordDetailInputModel
    ): ResponseEntity<*> =
        when (
            val treeRecordDetail =
                service.updateTreeRecordDetailById(id, treeRecordDetailUpdateRequest)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(treeRecordDetail.value)
            is Failure -> when(treeRecordDetail.value) {
                is ServiceErrors.TreeRecordDetailNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail", id))
                is ServiceErrors.TreeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree", treeRecordDetailUpdateRequest.treeRecordId))
                is ServiceErrors.TreeRecordDetailTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail Type", treeRecordDetailUpdateRequest.detailTypeId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @DeleteMapping("/{id}")
    fun deleteTreeRecordDetailById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteTreeRecordDetailById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> when(deleted.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException("Failed to delete record into the database")
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os detalhes validos.",
        description = "Retorna todos os registos existentes na tabela TreeRecordDetails validos na data fornecida.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de detalhes encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeRecordDetailOutputModel::class),
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
    @GetMapping("/valid")
    fun getValidTreeRecordDetailsOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<TreeRecordDetailOutputModel>> {
        val result = service.getTreeRecordDetailsValidOn(date)
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter todos os detalhes pelo tipo de detalhe.",
        description = "Retorna todos os registos existentes na tabela TreeRecordDetails do tipo de detalhe fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de detalhes encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeRecordDetailOutputModel::class),
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
            ApiResponse(
                responseCode = "404",
                description = "Detalhe com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/detailType/{id}")
    fun getTreeRecordDetailsByTreeRecordDetailTypeId(@PathVariable id: Long): ResponseEntity<*> =
        when(val result = service.getTreeRecordDetailsByDetailTypeId(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> when(result.value) {
                is ServiceErrors.TreeRecordDetailTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Record Detail", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }
}