package pt.isel.ps.zcap.services.persons

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.persons.DepartureDestination
import pt.isel.ps.zcap.repository.dto.persons.departureDestination.DepartureDestinationInputModel
import pt.isel.ps.zcap.repository.dto.persons.departureDestination.DepartureDestinationOutputModel
import pt.isel.ps.zcap.repository.models.persons.DepartureDestinationRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class DepartureDestinationService(
    val repository: DepartureDestinationRepository
) {
    fun getAllDepartureDestinations(): List<DepartureDestinationOutputModel> =
        repository.findAll().map { it.toOutputModel() }

    fun getDepartureDestinationById(id: Long): Either<ServiceErrors,DepartureDestinationOutputModel> {
        val departureDestination = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(departureDestination.toOutputModel())
    }

    fun saveDepartureDestination(
        departureDestinationInput: DepartureDestinationInputModel
    ): Either<ServiceErrors,DepartureDestinationOutputModel> {
        if (departureDestinationInput.name.isBlank() ||
            departureDestinationInput.startDate.isAfter(departureDestinationInput.endDate ?: departureDestinationInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newDepartureDestination = DepartureDestination(
            name = departureDestinationInput.name,
            startDate = departureDestinationInput.startDate,
            endDate = departureDestinationInput.endDate
        )
        return try {
            success(repository.save(newDepartureDestination).toOutputModel())
        } catch(ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateDepartureDestinationById(
        id: Long,
        departureDestinationInput: DepartureDestinationInputModel
    ): Either<ServiceErrors,DepartureDestinationOutputModel> {
        val departureDestination = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        if (departureDestinationInput.name.isBlank() ||
            departureDestinationInput.startDate.isAfter(departureDestinationInput.endDate ?: departureDestinationInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newDepartureDestination = departureDestination.copy(
            name = departureDestinationInput.name,
            startDate = departureDestinationInput.startDate,
            endDate = departureDestinationInput.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repository.save(newDepartureDestination).toOutputModel())
        } catch(ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getDepartureDestinationsValidOn(date: LocalDate): List<DepartureDestinationOutputModel> =
        repository.findValidOnDate(date).map { it.toOutputModel() }

    @Transactional
    fun deleteDepartureDestinationById(id: Long): Either<ServiceErrors,Unit> {
        repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repository.deleteById(id))
        } catch(ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }
}