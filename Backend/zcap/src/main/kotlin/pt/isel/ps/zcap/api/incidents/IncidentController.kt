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
import pt.isel.ps.zcap.repository.dto.incidents.incident.IncidentInputModel
import pt.isel.ps.zcap.repository.dto.incidents.incident.IncidentOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.incidents.IncidentService
import java.time.LocalDate

@RestController
@RequestMapping("api/incidents")
class IncidentController(
    private val service: IncidentService
) {
    @Operation(
        summary = "Obter todos os incidentes.",
        description = "Retorna todos os registos de incidentes existentes na tabela Incidents.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de incidentes encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllIncidentTypes(): ResponseEntity<List<IncidentOutputModel>> =
        ResponseEntity.ok(service.getAllIncident())

    @Operation(
        summary = "Obter um incidente pelo ID.",
        description = "Retorna o registo de incidente encontrado com o ID fornecido na tabela Incidents.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Incidente encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = IncidentOutputModel::class),
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
                description = "Incidente com id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getIncidentById(@PathVariable id: Long): ResponseEntity<*> =
        when(val incident = service.getIncidentById(id)) {
            is Success -> ResponseEntity.ok(incident.value)
            is Failure -> when (incident.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Insere um incidente.",
        description = "Insere e retorna o registo de incidente guardado na tabela Incident.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Incidente guardado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = IncidentOutputModel::class),
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
                description = "Tipo de incidente com id ### não foi encontrado.", content = [Content(
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
    @PostMapping()
    fun saveIncident(@RequestBody input: IncidentInputModel): ResponseEntity<*> =
        when(val incident = service.saveIncident(input)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(incident.value)
            is Failure -> when (incident.value) {
                is ServiceErrors.IncidentTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Type", input.incidentTypeId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza um incidente pelo ID.",
        description = "Atualiza e retorna o registo de incidente atualizado na tabela Incidents.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Incidente atualizado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = IncidentOutputModel::class),
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
                description = "Incidente/Tipo de incidente com id ### não foi encontrado.", content = [Content(
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
    fun updateIncidentById(
        @PathVariable id: Long,
        @RequestBody input: IncidentInputModel
    ): ResponseEntity<*> =
        when(val incident = service.updateIncidentById(id, input)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(incident.value)
            is Failure -> when (incident.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident", id))
                is ServiceErrors.IncidentTypeNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Type", input.incidentTypeId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os incidentes válidos na data fornecida.",
        description = "Retorna todos os registos de incidentes válidos na tabela Incidents.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de incientes encontrados (pode ser uma lista vazia).",
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
    fun getAllIncidentsValidOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<IncidentOutputModel>> =
        ResponseEntity.ok(service.getIncidentValidOn(date))

    @Operation(
        summary = "Obter todos os incidentes pelo tipo.",
        description = "Retorna todos os registos de incidentes pelo tipo fornecido na tabela Incidents.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de incientes encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Falha ao traduzir o ID fornecida.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Tipo de incidente com id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/incident-type/{id}")
    fun getIncidentsByIncidentTypeId(@PathVariable id: Long): ResponseEntity<*> =
        when(val incidents = service.getIncidentsByIncidentTypeId(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(incidents.value)
            is Failure -> when (incidents.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Type", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }
}