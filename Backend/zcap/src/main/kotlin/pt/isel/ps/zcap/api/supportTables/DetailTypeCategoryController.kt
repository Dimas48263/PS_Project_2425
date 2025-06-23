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
import pt.isel.ps.zcap.api.insertionFailedErrorMessage
import pt.isel.ps.zcap.api.invalidDataErrorMessage
import pt.isel.ps.zcap.api.notFoundMessage
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.supportTables.DetailTypeCategoryInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.DetailTypeCategoryOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.supportTables.DetailTypeCategoryService
import java.time.LocalDate

@Tag(
    name = "Detail Type Categories",
    description = "DetailTypeCategory representa a categoria de detalhes de uma ZCAP."
)
@SecurityRequirement(name = "BearerAuth")
@RestController
@RequestMapping("api/detail-type-categories")
class DetailTypeCategoryController(
    private val service: DetailTypeCategoryService
) {
    @Operation(
        summary = "Obter todos as categorias.",
        description = "Retorna todos os registos existentes na tabela detailTypeCategories.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de elementos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = DetailTypeCategoryOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllDetailTypeCategories(): ResponseEntity<List<DetailTypeCategoryOutputModel>> =
        ResponseEntity.ok(service.getAllDetailTypeCategories())

    @Operation(
        summary = "Obter categoria pelo ID.",
        description = "Retorna uma categoria com base no ID (chave primária) fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Registo encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = DetailTypeCategoryOutputModel::class)
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
                responseCode = "404", description = "Categoria com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getDetailTypeCategoryById(@PathVariable id: Long): ResponseEntity<DetailTypeCategoryOutputModel> =
        when(val dtc = service.getDetailTypeCategoryById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(dtc.value)
            is Failure -> when(dtc.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Detail Type Category", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }


    @Operation(
        summary = "Cria uma categoria.",
        description = "Adiciona um registo na tabela detailTypeCategories.",
        responses = [
            ApiResponse(
                responseCode = "201",
                description = "Categoria criada.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = DetailTypeCategoryOutputModel::class)
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
    fun saveDetailTypeCategory(
        @RequestBody detailTypeCategoryInputModel: DetailTypeCategoryInputModel
    ): ResponseEntity<DetailTypeCategoryOutputModel> =
        when(
            val dtc =
                service.saveDetailTypeCategory(detailTypeCategoryInputModel)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(dtc.value)
            is Failure -> when(dtc.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza uma categoria.",
        description = "Atualiza um registo na tabela detailTypeCategories com o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "201",
                description = "Registo criado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = DetailTypeCategoryOutputModel::class)
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
                description = "Categoria com o id ### não foi encontrado.",
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
    fun updateDetailTypeCategory(
        @PathVariable id: Long,
        @RequestBody newDetailTypeCategory: DetailTypeCategoryInputModel
    ): ResponseEntity<DetailTypeCategoryOutputModel> =
        when (
            val dtc =
                service.updateDetailTypeCategoryById(id, newDetailTypeCategory)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(dtc.value)
            is Failure -> when(dtc.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Detail Type Category", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter categoria válida.",
        description = "Retorna uma lista de categorias válidas na data fornecida.",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Lista encontrada.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = DetailTypeCategoryOutputModel::class)
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
    ): ResponseEntity<List<DetailTypeCategoryOutputModel>> {
        val result = service.getDetailTypeCategoriesValidOn(date)
        return ResponseEntity.ok(result)
    }
}