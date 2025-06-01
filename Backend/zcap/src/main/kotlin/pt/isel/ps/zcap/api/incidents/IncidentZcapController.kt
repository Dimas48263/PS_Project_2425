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
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcap.IncidentZcapInputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcap.IncidentZcapOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.incidents.IncidentZcapService
import java.time.LocalDate

@RestController
@RequestMapping("api/incident-zcaps")
class IncidentZcapController(
    val service: IncidentZcapService
){
    @Operation(
        summary = "Obter todos os incidentes associados a uma zcap.",
        description = "Retorna todos os registos de incidente associados a uma zcap existentes na tabela IncidentZcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de incidentes encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentZcapOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllIncidentZcaps(): ResponseEntity<List<IncidentZcapOutputModel>> =
        ResponseEntity.ok(service.getAllIncidentZcaps())

    @Operation(
        summary = "Obter um incidentes associados a uma zcap pelo ID.",
        description = "Retorna o registo de incidente associados a uma zcap encontrado existente na tabela IncidentZcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Incidente encontrado.",
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
                description = "Incidente com id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getIncidentZcapById(@PathVariable id: Long): ResponseEntity<IncidentZcapOutputModel> =
        when(val incidentZcap = service.getIncidentZcapById(id)) {
            is Success -> ResponseEntity.ok(incidentZcap.value)
            is Failure -> when (incidentZcap.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Zcap", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Inserir um incidente associados a uma zcap.",
        description = "Insere e retorna o registo de incidente associados a uma zcap guardado existente na tabela IncidentZcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Incidente guardado.",
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
                description = "Incidente/entidade/zcap com id ### não foi encontrado.", content = [Content(
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
    fun saveIncidentZcap(@RequestBody input: IncidentZcapInputModel): ResponseEntity<IncidentZcapOutputModel> =
        when(val incidentZcap = service.saveIncidentZcap(input)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(incidentZcap.value)
            is Failure -> when (incidentZcap.value) {
                is ServiceErrors.IncidentNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident", input.incidentId))
                is ServiceErrors.ZcapNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap", input.zcapId))
                is ServiceErrors.EntityNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Entity", input.entityId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualziar um incidente associados a uma zcap.",
        description = "Atualiza e retorna o registo de incidente associados a uma zcap atualizado existente na tabela IncidentZcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Incidente atualizado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = IncidentZcapOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y..", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404",
                description = "Incidente associado a uma zcap/incidente/zcap/entidate com id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "500",
                description = "Falha ao altualizar na base de dados.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PutMapping("/{id}")
    fun updateIncidentZcapById(
        @PathVariable id: Long,
        @RequestBody input: IncidentZcapInputModel
    ): ResponseEntity<IncidentZcapOutputModel> =
        when(val incidentZcap = service.updateIncidentZcapById(id, input)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(incidentZcap.value)
            is Failure -> when (incidentZcap.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Zcap", id))
                is ServiceErrors.IncidentNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident", input.incidentId))
                is ServiceErrors.ZcapNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap", input.zcapId))
                is ServiceErrors.EntityNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Entity", input.entityId))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os incidentes associados a uma zcap válidos na data fornecida.",
        description = "Retorna todos os registos de incidentes associados a uma zcap válidos na tabela IncidentZcaps.",
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
    ): ResponseEntity<List<IncidentZcapOutputModel>> =
        ResponseEntity.ok(service.getIncidentZcapsValidOn(date))

    @Operation(
        summary = "Obter os incidentes associados a uma zcap pelo incidente fornecido.",
        description = "Retorna todos os registos de incidente associados a uma zcap pelo id do incidente encontrados na tabela IncidentZcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de incidentes encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentZcapOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "404",
                description = "Incidente com id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/incidents/{id}")
    fun getIncidentZcapsByIncidentId(@PathVariable id: Long): ResponseEntity<List<IncidentZcapOutputModel>> =
        when(val incidentZcap = service.getIncidentZcapsByIncidentId(id)) {
            is Success -> ResponseEntity.ok(incidentZcap.value)
            is Failure -> when (incidentZcap.value) {
                is ServiceErrors.IncidentNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter os incidentes associados a uma zcap pela zcap fornecido.",
        description = "Retorna todos os registos de incidente associados a uma zcap pelo id da zcap encontrados na tabela IncidentZcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de incidentes encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentZcapOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "404",
                description = "Zcap com id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/zcaps/{id}")
    fun getIncidentZcapsByZcapId(@PathVariable id: Long): ResponseEntity<List<IncidentZcapOutputModel>> =
        when(val incidentZcap = service.getIncidentZcapsByZcapId(id)) {
            is Success -> ResponseEntity.ok(incidentZcap.value)
            is Failure -> when (incidentZcap.value) {
                is ServiceErrors.IncidentNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Zcap", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter os incidentes associados a uma zcap pela entidade fornecido.",
        description = "Retorna todos os registos de incidente associados a uma zcap pelo id da entidade encontrados na tabela IncidentZcaps.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de incidentes encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentZcapOutputModel::class),
                    )
                )],
            ),
            ApiResponse(
                responseCode = "404",
                description = "Entidade com id ### não foi encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/entities/{id}")
    fun getIncidentZcapsByEntityId(@PathVariable id: Long): ResponseEntity<List<IncidentZcapOutputModel>> =
        when(val incidentZcap = service.getIncidentZcapsByEntityId(id)) {
            is Success -> ResponseEntity.ok(incidentZcap.value)
            is Failure -> when (incidentZcap.value) {
                is ServiceErrors.IncidentNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Entity", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }
}