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
import pt.isel.ps.zcap.repository.dto.trees.treeLevelDetailType.TreeLevelDetailTypeInputModel
import pt.isel.ps.zcap.repository.dto.trees.treeLevelDetailType.TreeLevelDetailTypeOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeLevelDetailTypeService
import java.time.LocalDate

@RestController
@RequestMapping("api/tree-level-detail-type")
class TreeLevelDetailTypeController(
    private val service: TreeLevelDetailTypeService
) {
    @Operation(
        summary = "Obter todos os tipos de detalhe associados a um nível da árvore.",
        description = "Retorna todos os registos existentes na tabela TreeLevelDetailType.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeLevelDetailTypeOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllTreeLevelDetailType(): ResponseEntity<List<TreeLevelDetailTypeOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllTreeLevelDetailType())

    @Operation(
        summary = "Obter um tipo de detalhe associado a um nível da árvore.",
        description = "Retorna um tipo de detalhe associado a um nível da árvore com base no ID (chave primária) fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Registo encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = TreeLevelDetailTypeOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Registo com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getTreeLevelDetailTypeById(@PathVariable id: Long): ResponseEntity<TreeLevelDetailTypeOutputModel> =
        when (val tldt = service.getTreeById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(tldt.value)
            is Failure -> when(tldt.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level Detail Type", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Criar um novo tipo de detalhe associado a um nível da árvore.",
        description = "Adiciona um novo registo na tabela treeLevelDetailType.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Registo criado com sucesso.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = TreeLevelDetailTypeOutputModel::class)
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
                description = "Tipo de detalhe/nível de árvore com o id ### não foi encontrado.",
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
    fun saveTreeLevelDetailType(
        @RequestBody tldtRequest: TreeLevelDetailTypeInputModel
    ): ResponseEntity<TreeLevelDetailTypeOutputModel> =
        when (val tldt = service.saveTreeLevelDetailType(tldtRequest)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(tldt.value)
            is Failure -> when(tldt.value) {
                is ServiceErrors.TreeLevelNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level", tldtRequest.treeLevelId))
                is ServiceErrors.TreeRecordDetailTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Detail Type", tldtRequest.detailTypeId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualizar um tipo de detalhe associado a um nível da árvore.",
        description = "Atuliza um registo na tabela TreeLevelDetailType pelo o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Registo atualizado com sucesso.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeLevelDetailTypeOutputModel::class)
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
                description = "Nível de árvore ou pai ou árvore com o id ### não foi encontrado.",
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
    fun updateTreeLevelDetailTypeById(
        @PathVariable id: Long,
        @RequestBody tldtRequest: TreeLevelDetailTypeInputModel
    ): ResponseEntity<TreeLevelDetailTypeOutputModel> =
        when (
            val tldt =
                service.updateTreeLevelDetailTypeById(id, tldtRequest)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(tldt.value)
            is Failure -> when(tldt.value) {
                is ServiceErrors.TreeLevelNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level", tldtRequest.treeLevelId))
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level Detail Type", id))
                is ServiceErrors.TreeRecordDetailTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Detail Type", tldtRequest.detailTypeId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todas os tipos de detalhe associados a um nível de árvore válidas numa data.",
        description = "Retorna todas os registos válidos na data fornecida.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeLevelDetailTypeOutputModel::class),
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
    fun getValidTreeLevelDetailTypeOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<TreeLevelDetailTypeOutputModel>> {
        val result = service.getTreeLevelDetailTypeValidOn(date)
        return ResponseEntity.ok(result)
    }


    @Operation(
        summary = "Obter todos os tipos de detalhe associados a um nível de árvore pelo o nível.",
        description = "Retorna todos os registos que têm o ID do nível dado.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeLevelDetailTypeOutputModel::class),
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
                description = "Nível de árvore com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/treeLevel/{id}")
    fun getTreeLevelDetailTypeByTreeLevelId(@PathVariable id: Long): ResponseEntity<List<TreeLevelDetailTypeOutputModel>> =
        when(val tldt = service.getTreeLevelDetailTypeByTreeLevelId(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(tldt.value)
            is Failure -> when (tldt.value) {
                is ServiceErrors.TreeLevelNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }
    @Operation(
        summary = "Obter todos os tipos de detalhe associados a um nível de árvore pelo o tipo de detalhe.",
        description = "Retorna todos os registos que têm o ID do tipo de detalhe dado.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeLevelDetailTypeOutputModel::class),
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
                description = "Tipo de detalhe com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/detailType/{id}")
    fun getTreeLevelDetailTypeByDetailTypeId(@PathVariable id: Long): ResponseEntity<List<TreeLevelDetailTypeOutputModel>> =
        when(val tldt = service.getTreeLevelDetailTypeByDetailTypeId(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(tldt.value)
            is Failure -> when (tldt.value) {
                is ServiceErrors.TreeRecordDetailTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Detail Type", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }
}