package pt.isel.ps.zcap.services.incidents

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.incidents.IncidentZcapPerson
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcapPerson.IncidentZcapPersonInputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcapPerson.IncidentZcapPersonOutputModel
import pt.isel.ps.zcap.repository.dto.incidents.incidentZcapPerson.toOutputModel
import pt.isel.ps.zcap.repository.models.incidents.IncidentZcapPersonRepository
import pt.isel.ps.zcap.repository.models.incidents.IncidentZcapRepository
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class IncidentZcapPersonService(
    val repo: IncidentZcapPersonRepository,
    val incidentZcapRepository: IncidentZcapRepository,
    val personRepository: PersonRepository
) {
    fun getAllIncidentZcapPersons(): List<IncidentZcapPersonOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getIncidentZcapPersonById(id: Long): Either<ServiceErrors, IncidentZcapPersonOutputModel> {
        val izp = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(izp.toOutputModel())
    }

    fun saveIncidentZcapPerson(
        input: IncidentZcapPersonInputModel
    ): Either<ServiceErrors, IncidentZcapPersonOutputModel> {
        val incidentZcap = incidentZcapRepository.findById(input.incidentZcapId).getOrNull()
            ?: return failure(ServiceErrors.IncidentZcapNotFound)
        val person = personRepository.findById(input.personId).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound)
        if (input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newIncidentZcapPerson = IncidentZcapPerson(
            incidentZcap = incidentZcap,
            person = person,
            startDate = input.startDate,
            endDate = input.endDate
        )
        return try {
            success(repo.save(newIncidentZcapPerson).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateIncidentZcapPersonById(
        id: Long,
        input: IncidentZcapPersonInputModel
    ): Either<ServiceErrors, IncidentZcapPersonOutputModel> {
        val izp = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        val incidentZcap = incidentZcapRepository.findById(input.incidentZcapId).getOrNull()
            ?: return failure(ServiceErrors.IncidentZcapNotFound)
        val person = personRepository.findById(input.personId).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound)
        if (input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newIncidentZcapPerson = izp.copy(
            incidentZcap = incidentZcap,
            person = person,
            startDate = input.startDate,
            endDate = input.endDate,
            updatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newIncidentZcapPerson).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }


    fun getIncidentZcapPersonsValidOn(date: LocalDate): List<IncidentZcapPersonOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    fun getIncidentZcapPersonByIncidentZcapId(id: Long): Either<ServiceErrors, List<IncidentZcapPersonOutputModel>> {
        incidentZcapRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.IncidentNotFound)
        return success(repo.findByIncidentZcap_incidentZcapId(id).map { it.toOutputModel() })
    }

    fun getIncidentZcapPersonByPersonId(id: Long): Either<ServiceErrors, List<IncidentZcapPersonOutputModel>> {
        personRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.IncidentNotFound)
        return success(repo.findByPerson_personId(id).map { it.toOutputModel() })
    }
}