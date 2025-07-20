package pt.isel.ps.zcap.api.persons

import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.media.ArraySchema
import io.swagger.v3.oas.annotations.media.Content
import io.swagger.v3.oas.annotations.media.Schema
import io.swagger.v3.oas.annotations.responses.ApiResponse
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedInputModel
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.persons.PersonSpecialNeedService
import java.time.LocalDate

@RestController
@RequestMapping("api/person-special-needs")
class PersonSpecialNeedController(
    val service: PersonSpecialNeedService
){
    @Operation(
        summary = "Obter uma lista de todas necessidade especial de todas as pessoas.",
        description = "Obter uma lista, pelo ID fornecido, de todas necessidade especial todas pessoa na tabela PersonSpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista das necessidades especiais de todas as pessoas encontradas.",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = PersonSpecialNeedOutputModel::class)
                    ),
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllPersons(): ResponseEntity<List<PersonSpecialNeedOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllPersonSpecialNeeds())

    @Operation(
        summary = "Obter uma necessidade especial de uma pessoa.",
        description = "Obter, pelo ID fornecido, uma necessidade especial de uma pessoa na tabela PersonSpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Necessidade especial de uma pessoa.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonSpecialNeedOutputModel::class),
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
                description = "Necessidade especial de uma pessoa com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getPersonSpecialNeedById(@PathVariable id: Long): ResponseEntity<*> =
        when (val personSpecialNeed = service.getPersonSpecialNeedById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(personSpecialNeed.value)
            is Failure -> ResponseEntity(personSpecialNeed.value.errorResponse, personSpecialNeed.value.httpStatus)
        }

    @Operation(
        summary = "Inserir uma necessidade especial de uma pessoa.",
        description = "Insere uma necessidade especial de uma pessoa na tabela PersonSpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Necessidade especial de uma pessoa guardada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonSpecialNeedOutputModel::class),
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
                description = "Pessoa/necessidade especial com o id ### não foi encontrado.",
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
    fun savePersonSpecialNeed(
        @RequestBody personSpecialNeedInput: PersonSpecialNeedInputModel
    ): ResponseEntity<*> =
        when (val personSpecialNeed = service.savePersonSpecialNeed(personSpecialNeedInput)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(personSpecialNeed.value)
            is Failure -> ResponseEntity(personSpecialNeed.value.errorResponse, personSpecialNeed.value.httpStatus)
        }

    @Operation(
        summary = "Atualizar uma necessidade especial de uma pessoa.",
        description = "Atualiza pelo ID fornecido uma necessidade especial de uma pessoa na tabela PersonSpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Necessidade especial de uma pessoa atualizada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonSpecialNeedOutputModel::class),
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
                description = "Necessidade especial de uma pessoa/pessoa/necessidade especial com o id ### não foi encontrado.",
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
    fun updatePersonSpecialNeed(
        @PathVariable id: Long,
        @RequestBody personSpecialNeedInput: PersonSpecialNeedInputModel
    ): ResponseEntity<*> =
        when (val personSpecialNeed = service.updatePersonSpecialNeedById(id, personSpecialNeedInput)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(personSpecialNeed.value)
            is Failure -> ResponseEntity(personSpecialNeed.value.errorResponse, personSpecialNeed.value.httpStatus)
        }

    @Operation(
        summary = "Apaga uma necessidade especial de uma pessoa.",
        description = "Apaga, pelo ID fornecido, uma necessidade especial de uma pessoa na tabela PersonSpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "204", description = "Necessidade especial de uma pessoa apagada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonSpecialNeedOutputModel::class),
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
                description = "Necessidade especial de uma pessoa com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
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
    fun deletePersonSpecialNeedById(@PathVariable id: Long): ResponseEntity<*> =
        when (val delete = service.deletePersonSpecialNeedById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(delete.value)
            is Failure -> ResponseEntity(delete.value.errorResponse, delete.value.httpStatus)
        }

    @Operation(
        summary = "Obter uma lista de necessidades especial, de todas as pessoas, válida.",
        description = "Obter uma lista de necessidades especial de qualquer pessoa na tabela PersonSpecialNeeds com data válida de acordo com a data fornecida.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de necessidadea especiais de qualquer pessoa válidos encontrados.",
                content = [Content(
                    mediaType = "application/json",
                    array = ArraySchema(
                        schema = Schema(implementation = PersonSpecialNeedOutputModel::class)
                    ),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/valid")
    fun getValidPersonSpecialNeedsOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<PersonSpecialNeedOutputModel>> {
        val result = service.getPersonSpecialNeedsValidOn(date)
        return ResponseEntity.ok(result)
    }

    @Operation(
        summary = "Obter uma lista de necessidade especial de uma pessoa.",
        description = "Obter uma lista, pelo ID da pessoa fornecido, das necessidades especiais na tabela PersonSpecialNeeds.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de necessidades especiais de uma pessoa encontrados.",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = PersonSpecialNeedOutputModel::class)
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
                responseCode = "404",
                description = "Pessoa com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/person/{id}")
    fun getPersonSpecialNeedsByPersonId(@PathVariable id: Long): ResponseEntity<*> =
        when (val personSpecialNeeds = service.getPersonSpecialNeedsByPersonId(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(personSpecialNeeds.value)
            is Failure -> ResponseEntity(personSpecialNeeds.value.errorResponse, personSpecialNeeds.value.httpStatus)
        }
}