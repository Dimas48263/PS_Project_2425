package pt.isel.ps.zcap.api.incidents

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
import pt.isel.ps.zcap.repository.dto.incidents.incident.IncidentOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcap.IncidentZcapOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcapPerson.IncidentZcapPersonInputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcapPerson.IncidentZcapPersonOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.incidents.IncidentZcapPersonService
import java.time.LocalDate

@RestController
@RequestMapping("api/incident-zcap-persons")
class IncidentZcapPersonController(
    val service: IncidentZcapPersonService
) {
    @Operation(
        summary = "Obter todos os incidentes de uma zcap associado a uma pessoa.",
        description = "Retorna todos os registos de incidentes de uma zcap associado a uma pessoa existentes na tabela IncidentZcapPersons.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentZcapOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllIncidentZcapPersons(): ResponseEntity<List<IncidentZcapPersonOutputModel>> =
        ResponseEntity.ok(service.getAllIncidentZcapPersons())

    @Operation(
        summary = "Obter um incidentes de uma zcap associado a uma pessoa pelo ID.",
        description = "Retorna o registo de incidentes de uma zcap associado a uma pessoa encontrado existente na tabela IncidentZcapPersons.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = IncidentZcapOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha na tradução do ID fornecido.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Registo com id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getIncidentZcapPerson(@PathVariable id: Long): ResponseEntity<IncidentZcapPersonOutputModel> =
        when(val izp = service.getIncidentZcapPersonById(id)) {
            is Success -> ResponseEntity.ok(izp.value)
            is Failure -> when (izp.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Zcap Person", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Inserir um incidente de uma zcap associado a uma pessoa.",
        description = "Insere e retorna o registo de incidentes de uma zcap associado a uma pessoa encontrado existente na tabela IncidentZcapPersons.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo guardado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = IncidentZcapOutputModel::class),
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
                description = "Incidente de zcap/pessoa com id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao inserir na base de dados.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PostMapping
    fun saveIncidentZcapPerson(
        @RequestBody input: IncidentZcapPersonInputModel
    ): ResponseEntity<IncidentZcapPersonOutputModel> =
        when(val izp = service.saveIncidentZcapPerson(input)) {
            is Success ->  ResponseEntity.status(HttpStatus.CREATED).body(izp.value)
            is Failure -> when (izp.value) {
                is ServiceErrors.IncidentZcapNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Zcap", input.incidentZcapId))
                is ServiceErrors.PersonNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person", input.personId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualizar um incidente de uma zcap associado a uma pessoa pelo ID fornecido.",
        description = "Atualiza e retorna o registo de incidentes de uma zcap associado a uma pessoa atualizado existente na tabela IncidentZcapPersons.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Registo atualizado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = IncidentZcapOutputModel::class),
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
                description = "Registo/Incidente de zcap/pessoa com id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao atualizar na base de dados.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PutMapping("/{id}")
    fun updateIncidentZcapPersonById(
        @PathVariable id: Long,
        @RequestBody input: IncidentZcapPersonInputModel
    ): ResponseEntity<IncidentZcapPersonOutputModel> =
        when(val izp = service.updateIncidentZcapPersonById(id, input)) {
            is Success ->  ResponseEntity.status(HttpStatus.CREATED).body(izp.value)
            is Failure -> when (izp.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Zcap Person", id))
                is ServiceErrors.IncidentZcapNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Zcap", input.incidentZcapId))
                is ServiceErrors.PersonNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person", input.personId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os incidentes de uma zcap associado a uma pessoa válidos na data fornecida.",
        description = "Retorna todos os registos de um incidente de uma zcap associado a uma pessoa válidos na tabela IncidentZcapPersons.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentOutputModel::class),
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
    fun getAllIncidentZcapPersonsValidOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<IncidentZcapPersonOutputModel>> =
        ResponseEntity.ok(service.getIncidentZcapPersonsValidOn(date))

    @Operation(
        summary = "Obter os um incidente de uma zcap associado a uma pessoa pelo incidente de uma zcap fornecido.",
        description = "Retorna todos os registos de incidentes de uma zcap associado a uma pessoa pelo id do incidente de uma zcap encontrados na tabela IncidentZcapPersons.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentZcapOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha na tradução do ID fornecido.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Incidente de uma zcap com id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/incident-zcaps/{id}")
    fun getIncidentZcapsByIncidentZcapId(@PathVariable id: Long): ResponseEntity<List<IncidentZcapPersonOutputModel>> =
        when(val incidentZcap = service.getIncidentZcapPersonByIncidentZcapId(id)) {
            is Success -> ResponseEntity.ok(incidentZcap.value)
            is Failure -> when (incidentZcap.value) {
                is ServiceErrors.PersonNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Zcap", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter os um incidente de uma zcap associado a uma pessoa pela pessoa fornecido.",
        description = "Retorna todos os registos de incidentes de uma zcap associado a uma pessoa pelo id da pessoa encontrados na tabela IncidentZcapPersons.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de registos encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentZcapOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha na tradução do ID fornecido.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Pessoa com id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/persons/{id}")
    fun getIncidentZcapsByPersonId(@PathVariable id: Long): ResponseEntity<List<IncidentZcapPersonOutputModel>> =
        when(val incidentZcap = service.getIncidentZcapPersonByPersonId(id)) {
            is Success -> ResponseEntity.ok(incidentZcap.value)
            is Failure -> when (incidentZcap.value) {
                is ServiceErrors.PersonNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Person", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }
}