package pt.isel.ps.zcap.api.persons

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
import pt.isel.ps.zcap.repository.dto.persons.departureDestination.DepartureDestinationInputModel
import pt.isel.ps.zcap.repository.dto.persons.departureDestination.DepartureDestinationOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.persons.DepartureDestinationService
import java.time.LocalDate

@RestController
@RequestMapping("api/departure-destinations")
class DepartureDestinationController(
    val service: DepartureDestinationService
) {
    @Operation(
        summary = "Obter todas os destinos.",
        description = "Retorna todos os registos existentes na tabela DepartureDestinations com todos os destinos de saída da zcap.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de destinos encontradas (pode ser uma lista vazia)",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = DepartureDestinationOutputModel::class),
                    )
                )],
            ),
        ],
    )
    @GetMapping
    fun getAllDepartureDestinations(): ResponseEntity<List<DepartureDestinationOutputModel>> =
        ResponseEntity.status(HttpStatus.OK).body(service.getAllDepartureDestinations())

    @Operation(
        summary = "Obter um destino pelo ID.",
        description = "Retorna um destino pelo ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "O destino encontrado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = DepartureDestinationOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Destino com o id ### não foi encontrado.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @GetMapping("/{id}")
    fun getDepartureDestinationById(@PathVariable id: Long): ResponseEntity<*> =
        when (val departureDestination = service.getDepartureDestinationById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(departureDestination.value)
            is Failure -> when(departureDestination.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Departure Destination", id))
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Insere um destino.",
        description = "Insere um destino fornecido na tabela DepartureDestinations.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "O destino guardado.",
                content = [Content(
                    mediaType = "application/json",
                    schema = Schema(implementation = DepartureDestinationOutputModel::class),
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
                description = "Falha ao inserir registo na base de dados.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
        ],
    )
    @PostMapping
    fun saveDepartureDestination(
        @RequestBody departureDestinationInput: DepartureDestinationInputModel
    ): ResponseEntity<*> =
        when (val departureDestination = service.saveDepartureDestination(departureDestinationInput)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(departureDestination.value)
            is Failure -> when(departureDestination.value) {
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Atualiza um destino.",
        description = "Atualiza um destino na tabela DepartureDestinations pelo ID fornecido.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "O destino atualizado.",
                content = [Content(
                    mediaType = "application/json" ,
                    schema = Schema(implementation = DepartureDestinationOutputModel::class),
                )],
            ),
            ApiResponse(
                responseCode = "400",
                description = "Tipo de dados invalidos. Esperado o formato X mas recebido formato Y.", content = [Content(
                    mediaType = "application/json", schema = Schema(implementation = ErrorResponse::class)
                )]
            ),
            ApiResponse(
                responseCode = "404", description = "Destino com o id ### não foi encontrado.", content = [Content(
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
    fun updateDepartureDestinationById(
        @PathVariable id: Long,
        @RequestBody departureDestinationInput: DepartureDestinationInputModel
    ): ResponseEntity<*> =
        when (
            val departureDestination =
                service.updateDepartureDestinationById(id, departureDestinationInput)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(departureDestination.value)
            is Failure -> when(departureDestination.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Departure Destination", id))
                is ServiceErrors.InvalidDataInput ->
                    throw InvalidDataException(invalidDataErrorMessage)
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @DeleteMapping("/{id}")
    fun deleteDepartureDestinationById(@PathVariable id: Long): ResponseEntity<*> =
        when (val deleted = service.deleteDepartureDestinationById(id)) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).body(null)
            is Failure -> when(deleted.value) {
                is ServiceErrors.RecordNotFound ->
                    throw EntityNotFoundException(notFoundMessage("Departure Destination", id))
                is ServiceErrors.UpdateFailed ->
                    throw DatabaseInsertException(insertionFailedErrorMessage)
                else -> throw Exception("NOT SUPPOSED TO BE HERE")
            }
        }

    @Operation(
        summary = "Obter uma lista de destinos válidos.",
        description = "Obter uma lista de destinos na tabela DepartureDestinations válidos na data fornecida.",
        responses = [
            ApiResponse(
                responseCode = "200", description = "Lista de destinos encontrados.",
                content = [Content(
                    mediaType = "application/json", array = ArraySchema(
                        schema = Schema(implementation = DepartureDestinationOutputModel::class),
                    )
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
    fun getValidDepartureDestinationsOn(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate
    ): ResponseEntity<List<DepartureDestinationOutputModel>> {
        val result = service.getDepartureDestinationsValidOn(date)
        return ResponseEntity.ok(result)
    }
}