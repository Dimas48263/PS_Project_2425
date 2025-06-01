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
import pt.isel.ps.zcap.repository.dto.trees.treeLevel.TreeLevelInputModel
import pt.isel.ps.zcap.repository.dto.trees.treeLevel.TreeLevelOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.tree.TreeLevelService
import java.time.LocalDate

@RestController
@RequestMapping("api/tree-levels")
class TreeLevelsLController(private val service: TreeLevelService) {

    @Operation(
        summary = "Obter todas os niveis das árvores.",
        description = "Retorna todos os registos existentes na tabela TreeLevels.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de nivel das árvores encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = TreeLevelOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllTreeLevels(): ResponseEntity<List<TreeLevelOutputModel>> =
        ResponseEntity.ok(service.getAllTreeLevels())

    @Operation(
        summary = "Cria um nível de árvore.",
        description = "Adiciona um registo na tabela TreeLevels.",
        responses = [
            ApiResponse(
                responseCode = "201",
                description = "Nível de árvore criado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeLevelOutputModel::class)
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
                responseCode = "500",
                description = "Falha ao inserir registo na base de dados.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PostMapping
    fun saveTreeLevel(@RequestBody treeLevelRequest: TreeLevelInputModel): ResponseEntity<*> =
        when(
            val treeLevel =
                service.saveTreeLevel(treeLevelRequest)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(treeLevel.value)
            is Failure -> when(treeLevel.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter nível de árvore por ID.",
        description = "Retorna um nível de árvore com base no ID (chave primária) fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Nível de árvore encontrada.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeLevelOutputModel::class)
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
                responseCode = "404", description = "Nível de árvore com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getTreeLevelById(@PathVariable id: Long): ResponseEntity<*> =
        when(val treeLevel = service.getTreeLevelById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(treeLevel.value)
            is Failure -> when(treeLevel.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza um nível de árvore.",
        description = "Atualiza um registo na tabela TreeLevels com o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "201",
                description = "Nível de árvore criado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeLevelOutputModel::class)
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
    fun updateTreeLevel(
        @PathVariable id: Long,
        @RequestBody treeLevelUpdateRequest: TreeLevelInputModel
    ): ResponseEntity<*> =
        when (
            val treeLevel =
                service.updateTreeLevel(id, treeLevelUpdateRequest)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(treeLevel.value)
            is Failure -> when(treeLevel.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @DeleteMapping("/{id}")
    fun deleteTreeLevelById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteTreeLevelById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> when(deleted.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Tree Level", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter nível de árvore por ID.",
        description = "Retorna um nível de árvore com base no ID (chave primária) fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Nível de árvore encontrada.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = TreeLevelOutputModel::class)
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
    fun getValidTreeLevelsOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<TreeLevelOutputModel>> {
        val result = service.getTreeLevelsValidOn(date)
        return ResponseEntity.ok(result)
    }
}
