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
import pt.isel.ps.zcap.api.invalidDataErrorMessage
import pt.isel.ps.zcap.api.notFoundMessage
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeInputModel
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeService
import java.time.LocalDate

@RestController
@RequestMapping("api/trees")
class TreeController(
    private val service: TreeService
) {
    @Operation(
        summary = "Obter todas as árvores.",
        description = "Retorna todos os registos existentes na tabela Trees.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllTrees(): ResponseEntity<List<TreeOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllTrees())

    @Operation(
        summary = "Obter Árvore por ID.",
        description = "Retorna uma Árvore com base no ID (chave primária) fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Árvore encontrada.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Árvore com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getTreeById(@PathVariable id: Long): ResponseEntity<*> =
        when (val tree = service.getTreeById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(tree.value)
            is Failure -> when(tree.value) {
                is ServiceErrors.RecordNotFound -> throw EntityNotFoundException(notFoundMessage("Tree", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Criar uma nova Árvore.",
        description = "Adiciona um novo registo na tabela de árvores.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Registo criado com sucesso.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeOutputModel::class)
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
                description = "Nível de árvore ou pai com o id ### não foi encontrado.",
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
    fun saveTree(@RequestBody treeRequest: TreeInputModel): ResponseEntity<*> =
        when (val tree = service.saveTree(treeRequest)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(tree.value)
            is Failure -> when(tree.value) {
                is ServiceErrors.TreeLevelNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level", treeRequest.treeLevelId))
                is ServiceErrors.ParentNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Parent", treeRequest.parentId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualizar uma Árvore.",
        description = "Atuliza um registo na tabela Trees pelo o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Registo atualizado com sucesso.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeOutputModel::class)
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
    fun updateTreeById(
        @PathVariable id: Long,
        @RequestBody treeUpdateRequest: TreeInputModel
    ): ResponseEntity<*> =
        when (
            val tree =
                service.updateTreeById(id, treeUpdateRequest)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(tree.value)
            is Failure -> when(tree.value) {
                is ServiceErrors.TreeLevelNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level", treeUpdateRequest.treeLevelId))
                is ServiceErrors.TreeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree", id))
                is ServiceErrors.ParentNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Parent", treeUpdateRequest.parentId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @DeleteMapping("/{id}")
    fun deleteTreeLevelById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteTreeById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> when(deleted.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException("Delete failed")
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter Árvores válidas numa data.",
        description = "Retorna todas as Árvores válidas na data fornecida.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeOutputModel::class),
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
    fun getValidTreesOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<TreeOutputModel>> {
        val result = service.getTreesValidOn(date)
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter Árvores pelo nome.",
        description = "Retorna todas as Árvores que contêm o nome fornecida.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeOutputModel::class),
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
    @GetMapping("/name")
    fun getTreesByNameContaining(
        @RequestParam name: String
    ): ResponseEntity<List<TreeOutputModel>> =
        when(val result = service.getTreesByNameContaining(name)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> when (result.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }


    @Operation(
        summary = "Obter Árvores pelo o nível.",
        description = "Retorna todas as Árvores que têm o nível dado.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeOutputModel::class),
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
    fun getTreesByTreeLevelId(@PathVariable id: Long): ResponseEntity<*> =
        when(val trees = service.getTreeByTreeLevelId(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(trees.value)
            is Failure -> when (trees.value) {
                is ServiceErrors.TreeLevelNotFound -> throw EntityNotFoundException(notFoundMessage("Tree", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os filhos diretos de uma Árvores.",
        description = "Retorna todas as Árvores que tem como parent o ID dado.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeOutputModel::class),
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
                description = "Árvore com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/children/{id}")
    fun getAllDirectChildren(@PathVariable id: Long): ResponseEntity<*> =
        when(val trees = service.getAllDirectChildren(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(trees.value)
            is Failure -> when (trees.value) {
                is ServiceErrors.RecordNotFound -> throw EntityNotFoundException(notFoundMessage("Tree", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os filhos de uma Árvores.",
        description = "Retorna todas as Árvores que tem como parent ou qualquer outra relação mais baixa com  o ID dado.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de Árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeOutputModel::class),
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
                description = "Árvore com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/allChildren/{id}")
    fun getAllChildrenTree(@PathVariable id: Long): ResponseEntity<List<TreeOutputModel>> =
        when (val trees = service.getAllChildren(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(trees.value)
            is Failure -> when (trees.value) {
                is ServiceErrors.RecordNotFound -> throw EntityNotFoundException(notFoundMessage("Tree", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }


}