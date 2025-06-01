package pt.isel.ps.zcap.services.incidents

import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.incidents.IncidentZcap
import pt.isel.ps.zcap.repository.dto.incidents.incident.toOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcap.IncidentZcapInputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcap.IncidentZcapOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcap.toOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.toOutputModel
import pt.isel.ps.zcap.repository.models.incidents.IncidentRepository
import pt.isel.ps.zcap.repository.models.incidents.IncidentZcapRepository
import pt.isel.ps.zcap.repository.models.supportTables.EntitiesRepository
import pt.isel.ps.zcap.repository.models.supportTables.ZcapRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class IncidentZcapService(
    val repo: IncidentZcapRepository,
    val incidentRepository: IncidentRepository,
    val zcapRepository: ZcapRepository,
    val entitiesRepository: EntitiesRepository
) {
    fun getAllIncidentZcaps(): List<IncidentZcapOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getIncidentZcapById(id: Long): Either<ServiceErrors, IncidentZcapOutputModel> {
        val incidentZcap = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(incidentZcap.toOutputModel())
    }

    fun saveIncidentZcap(input: IncidentZcapInputModel): Either<ServiceErrors, IncidentZcapOutputModel> {
        val incident = incidentRepository.findById(input.incidentId).getOrNull()
            ?: return failure(ServiceErrors.IncidentNotFound)
        val zcap = zcapRepository.findById(input.zcapId).getOrNull()
            ?: return failure(ServiceErrors.ZcapNotFound)
        val entity = entitiesRepository.findById(input.entityId).getOrNull()
            ?: return failure(ServiceErrors.EntityNotFound)
        if (input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newIncidentZcap = IncidentZcap(
            incident = incident,
            zcap = zcap,
            entity = entity,
            startDate = input.startDate,
            endDate = input.endDate
        )

        return try {
            success(repo.save(newIncidentZcap).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun updateIncidentZcapById(id: Long, input: IncidentZcapInputModel): Either<ServiceErrors, IncidentZcapOutputModel> {
        val incidentZcap = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        val incident = incidentRepository.findById(input.incidentId).getOrNull()
            ?: return failure(ServiceErrors.IncidentNotFound)
        val zcap = zcapRepository.findById(input.zcapId).getOrNull()
            ?: return failure(ServiceErrors.ZcapNotFound)
        val entity = entitiesRepository.findById(input.entityId).getOrNull()
            ?: return failure(ServiceErrors.EntityNotFound)
        if (input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newIncidentZcap = incidentZcap.copy(
            incident = incident,
            zcap = zcap,
            entity = entity,
            startDate = input.startDate,
            endDate = input.endDate,
            updatedAt = LocalDateTime.now()
        )

        return try {
            success(repo.save(newIncidentZcap).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getIncidentZcapsValidOn(date: LocalDate): List<IncidentZcapOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    fun getIncidentZcapsByIncidentId(id: Long): Either<ServiceErrors, List<IncidentZcapOutputModel>> {
        incidentRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.IncidentNotFound)
        return success(repo.findByIncident_incidentId(id).map { it.toOutputModel() })
    }

    fun getIncidentZcapsByZcapId(id: Long): Either<ServiceErrors, List<IncidentZcapOutputModel>> {
        zcapRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.ZcapNotFound)
        return success(repo.findByZcap_zcapId(id).map { it.toOutputModel() })
    }

    fun getIncidentZcapsByEntityId(id: Long): Either<ServiceErrors, List<IncidentZcapOutputModel>> {
        entitiesRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.EntityNotFound)
        return success(repo.findByEntity_entityId(id).map { it.toOutputModel() })
    }
}