package pt.isel.ps.zcap.services.incidents

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.incidents.Incident
import pt.isel.ps.zcap.repository.dto.incidents.incident.IncidentInputModel
import pt.isel.ps.zcap.repository.dto.incidents.incident.IncidentOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incident.toOutputModel
import pt.isel.ps.zcap.repository.models.incidents.IncidentRepository
import pt.isel.ps.zcap.repository.models.incidents.IncidentTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class IncidentService(
    val repo: IncidentRepository,
    val incidentTypeRepo: IncidentTypeRepository
) {
    fun getAllIncident(): List<IncidentOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getIncidentById(id: Long): Either<ServiceErrors, IncidentOutputModel> {
        val incident = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(incident.toOutputModel())
    }

    fun saveIncident(input: IncidentInputModel): Either<ServiceErrors, IncidentOutputModel> {
        val incidentType = incidentTypeRepo.findById(input.incidentTypeId).getOrNull()
            ?: return failure(ServiceErrors.IncidentTypeNotFound)
        if (input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newIncident = Incident(
            incidentType = incidentType,
            startDate = input.startDate,
            endDate = input.endDate
        )
        return try {
            success(repo.save(newIncident).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateIncidentById(
        id: Long,
        input: IncidentInputModel
    ): Either<ServiceErrors, IncidentOutputModel> {
        val incident = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        val incidentType = incidentTypeRepo.findById(input.incidentTypeId).getOrNull()
            ?: return failure(ServiceErrors.IncidentTypeNotFound)
        if (input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newIncident = incident.copy(
            incidentType = incidentType,
            startDate = input.startDate,
            endDate = input.endDate,
            updatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newIncident).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getIncidentValidOn(date: LocalDate): List<IncidentOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    fun getIncidentsByIncidentTypeId(id: Long): Either<ServiceErrors, List<IncidentOutputModel>> {
        incidentTypeRepo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(repo.findByIncidentTypeId(id).map { it.toOutputModel() })
    }
}