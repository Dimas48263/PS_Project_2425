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
import pt.isel.ps.zcap.repository.dto.persons.person.PersonInputModel
import pt.isel.ps.zcap.repository.dto.persons.person.PersonOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.persons.PersonService

@RestController
@RequestMapping("api/persons")
class PersonController(
    val service: PersonService
) {
    @Operation(
        summary = "Obter uma lista de todas as pessoas.",
        description = "Lista de todas as pessoas encontradas na tabela Persons.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista das pessoas encontradas.",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = PersonOutputModel::class),
                    )
                )],
            )
        ],
    )
    @GetMapping
    fun getAllPersons(): ResponseEntity<List<PersonOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllPersons())

    @Operation(
        summary = "Obter uma pessoa.",
        description = "Obter uma pessoa pelo ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Pessoa encontrada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Pessoa com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getPersonById(@PathVariable id: Long): ResponseEntity<*> =
        when (val person = service.getPersonById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(person.value)
            is Failure -> ResponseEntity(person.value.errorResponse, person.value.httpStatus)
        }

    @Operation(
        summary = "Inserir uma pessoa.",
        description = "Insere uma pessoa na tabela Persons com os campos fornecidos.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Pessoa guardada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonOutputModel::class),
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
                description = "código do país/árvore/nacionalidade/destino com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao inserir registo na base de dados", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PostMapping
    fun savePerson(@RequestBody personInput: PersonInputModel): ResponseEntity<*> =
        when (val person = service.savePerson(personInput)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(person.value)
            is Failure -> ResponseEntity(person.value.errorResponse, person.value.httpStatus)
        }

    @Operation(
        summary = "Atulizar uma pessoa.",
        description = "Atualiza uma pessoa na tabela Persons com o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "201", description = "Pessoa atualizada.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = PersonOutputModel::class),
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
                description = "Pessoa/código do país/árvore/nacionalidade/destino com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao atualizar registo na base de dados.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PutMapping("/{id}")
    fun updatePerson(
        @PathVariable id: Long,
        @RequestBody personInput: PersonInputModel
    ): ResponseEntity<*> =
        when (val person = service.updatePersonById(id, personInput)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(person.value)
            is Failure -> ResponseEntity(person.value.errorResponse, person.value.httpStatus)
        }

    @Operation(
        summary = "Apaga uma pessoa.",
        description = "Apaga o restisto de uma pessoa na tabela Persons com o ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "204", description = "Pessoa foi apagada."
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Pessoa/código do país/árvore/nacionalidade/destino com o id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao apagar registo na base de dados.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @DeleteMapping("/{id}")
    fun deletePersonById(@PathVariable id: Long): ResponseEntity<*> =
        when (val delete = service.deletePersonById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(delete.value)
            is Failure -> ResponseEntity(delete.value.errorResponse, delete.value.httpStatus)
        }

    @Operation(
        summary = "Obter uma lista de pessoas pelo nome.",
        description = "Obter uma lista de pessoas que tenham o nome fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200",
                description = "Lista de pessoas encontradas com o nome fornecido (lista pode ser vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = PersonOutputModel::class)
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
    @GetMapping("/name")
    fun getPersonsByName(@RequestParam name: String): ResponseEntity<*> =
        when (val persons = service.getPersonsByName(name)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(persons.value)
            is Failure -> ResponseEntity(persons.value.errorResponse, persons.value.httpStatus)
        }
}