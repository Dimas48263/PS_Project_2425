package pt.isel.ps.zcap.services.incidents

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.incidents.IncidentType
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.IncidentTypeInputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.IncidentTypeOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentType.toOutputModel
import pt.isel.ps.zcap.repository.models.incidents.IncidentTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class IncidentTypeService(
    val repo: IncidentTypeRepository
) {
    fun getAllIncidentTypes(): List<IncidentTypeOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getIncidentTypeById(id: Long): Either<ServiceErrors, IncidentTypeOutputModel> {
        val incidentType = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(incidentType.toOutputModel())
    }

    fun saveIncidentType(input: IncidentTypeInputModel): Either<ServiceErrors, IncidentTypeOutputModel> {
        if (input.name.isBlank() || input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newIncidentType = IncidentType(
            name = input.name,
            startDate = input.startDate,
            endDate = input.endDate
        )
        return try {
            success(repo.save(newIncidentType).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateIncidentTypeById(
        id: Long,
        input: IncidentTypeInputModel
    ): Either<ServiceErrors, IncidentTypeOutputModel> {
        val incidentType = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        if (input.name.isBlank() || input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newIncidentType = incidentType.copy(
            name = input.name,
            startDate = input.startDate,
            endDate = input.endDate,
            updatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newIncidentType).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getIncidentTypesValidOn(date: LocalDate): List<IncidentTypeOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }
}

