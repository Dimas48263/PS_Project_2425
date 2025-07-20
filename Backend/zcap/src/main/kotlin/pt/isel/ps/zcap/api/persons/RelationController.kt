package pt.isel.ps.zcap.api.persons

import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.media.ArraySchema
import io.swagger.v3.oas.annotations.media.Content
import io.swagger.v3.oas.annotations.media.Schema
import io.swagger.v3.oas.annotations.responses.ApiResponse
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.persons.relation.RelationInputModel
import pt.isel.ps.zcap.repository.dto.persons.relation.RelationOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.persons.RelationService

@RestController
@RequestMapping("api/relations")
class RelationController(
    val service: RelationService
) {
    @Operation(
        summary = "Obter uma lista de todas as relações.",
        description = "Obter uma lista de todas as relações na tabela Relations.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de relações encontradas.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = RelationOutputModel::class)
                    ),
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllRelations(): ResponseEntity<List<RelationOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllRelations())

    @Operation(
        summary = "Obter uma relação pelo ID.",
        description = "Obter uma relação pelo ID na tabela Relations.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Relação encontrada.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = RelationOutputModel::class)
                    ),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Relação com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getRelationById(@PathVariable id: Long): ResponseEntity<*> =
        when (val relation = service.getRelationById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(relation.value)
            is Failure -> ResponseEntity(relation.value.errorResponse, relation.value.httpStatus)
        }

    @Operation(
        summary = "Insere uma relação.",
        description = "Insere uma relação na tabela Relations.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Relação guardada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = RelationOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400", description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
            ApiResponse(
                responseCode = "404", description = "Pessoa/tipo de relação com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
            ApiResponse(
                responseCode = "409", description = "Relação já existe.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
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
    fun saveRelation(
        @RequestBody relationInput: RelationInputModel
    ): ResponseEntity<*> =
        when (val relation = service.saveRelation(relationInput)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(relation.value)
            is Failure -> ResponseEntity(relation.value.errorResponse, relation.value.httpStatus)
        }

    @Operation(
        summary = "Apaga uma relação.",
        description = "Apaga uma relação pelo ID na tabela Relations.",
        responses = [
            ApiResponse(
                responseCode = "204", description = "Relação apagada com successo.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = RelationOutputModel::class)
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Relação com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao apagar registo na base de dados.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @DeleteMapping("/{id}")
    fun deleteRelationById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteRelationById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> ResponseEntity(deleted.value.errorResponse, deleted.value.httpStatus)
        }

    @Operation(
        summary = "Obter uma lista de relações que uma pessoa tem.",
        description = "Obter uma lista de relações que uma pessoa tem pelo ID na tabela Relations.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de relações encontradas.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = RelationOutputModel::class)
                    ),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Pessoa com id ### não encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = ErrorResponse::class)
                )],
            ),
        ],
    )
    @GetMapping("person1/{id}")
    fun findAllByPersonId1(@PathVariable id: Long): ResponseEntity<*> =
        when (val relations = service.findAllByPerson1Id(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(relations.value)
            is Failure -> ResponseEntity(relations.value.errorResponse, relations.value.httpStatus)
        }
}