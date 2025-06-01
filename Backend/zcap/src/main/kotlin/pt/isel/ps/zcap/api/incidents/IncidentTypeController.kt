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
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import pt.isel.ps.zcap.api.exceptions.DatabaseInsertException
import pt.isel.ps.zcap.api.exceptions.InvalidDataException
import pt.isel.ps.zcap.api.insertionFailedErrorMessage
import pt.isel.ps.zcap.api.invalidDataErrorMessage
import pt.isel.ps.zcap.api.notFoundMessage
import pt.isel.ps.zcap.repository.dto.ErrorResponse
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.IncidentTypeInputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.IncidentTypeOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.incidents.IncidentTypeService
import java.time.LocalDate

@RestController
@RequestMapping("api/incident-types")
class IncidentTypeController(
    private val service: IncidentTypeService
) {
    @Operation(
        summary = "Obter todos os tipos de incidente.",
        description = "Retorna todos os registos de tipos de incidente existentes na tabela IncidentTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de tipos de incidentes encontradas (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentTypeOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllIncidentTypes(): ResponseEntity<List<IncidentTypeOutputModel>> =
        ResponseEntity.ok(service.getAllIncidentTypes())

    @Operation(
        summary = "Obter um tipo de incidente pelo ID.",
        description = "Retorna o registo de tipo de incidente encontrado com o ID fornecido na tabela IncidentTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Tipo de incidente encontrado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = IncidentTypeOutputModel::class),
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
                description = "Tipo de incidente com id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getIncidentTypeById(@PathVariable id: Long): ResponseEntity<*> =
        when(val incidentType = service.getIncidentTypeById(id)) {
            is Success -> ResponseEntity.ok(incidentType.value)
            is Failure -> when (incidentType.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Type", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Insere um tipo de incidente.",
        description = "Insere e retorna o registo de tipo de incidente guardado na tabela IncidentTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Tipo de incidente guardado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = IncidentTypeOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
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
    fun saveIncidentType(@RequestBody input: IncidentTypeInputModel): ResponseEntity<*> =
        when(val incidentType = service.saveIncidentType(input)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(incidentType.value)
            is Failure -> when (incidentType.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza um tipo de incidente pelo ID.",
        description = "Atualiza e retorna o registo de tipo de incidente atualizado na tabela IncidentTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Tipo de incidente atualizado.",
                content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = IncidentTypeOutputModel::class),
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
                description = "Falha ao atualizar na base de dados.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PutMapping("/{id}")
    fun updateIncidentTypeById(
        @PathVariable id: Long,
        @RequestBody input: IncidentTypeInputModel
    ): ResponseEntity<*> =
        when(val incidentType = service.updateIncidentTypeById(id, input)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(incidentType.value)
            is Failure -> when (incidentType.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Incident Type", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter todos os tipos de incidente válidos na data fornecida.",
        description = "Retorna todos os registos de tipos de incidente válidos na tabela IncidentTypes.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de tipos de incientes encontrados (pode ser uma lista vazia).",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = IncidentTypeOutputModel::class),
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
    fun getAllIncidentTypesValidOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<IncidentTypeOutputModel>> =
        ResponseEntity.ok(service.getIncidentTypesValidOn(date))
}