package pt.isel.ps.zcap.services.persons

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.persons.PersonSupportNeeded
import pt.isel.ps.zcap.repository.dto.persons.personSupportNeeded.PersonSupportNeededInputModel
import pt.isel.ps.zcap.repository.dto.persons.personSupportNeeded.PersonSupportNeededOutputModel
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import pt.isel.ps.zcap.repository.models.persons.PersonSupportNeededRepository
import pt.isel.ps.zcap.repository.models.persons.SupportNeededRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class PersonSupportNeededService(
    val repository: PersonSupportNeededRepository,
    val personRepository: PersonRepository,
    val supportNeededRepository: SupportNeededRepository
) {
    fun getAllPersonSupportNeeded(): List<PersonSupportNeededOutputModel> =
        repository.findAll().map { it.toOutputModel() }

    fun getPersonSupportNeededById(id: Long): Either<ServiceErrors, PersonSupportNeededOutputModel> {
        val personSupportNeeded = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(personSupportNeeded.toOutputModel())
    }

    fun savePersonSupportNeeded(
        personSupportNeededInput: PersonSupportNeededInputModel
    ): Either<ServiceErrors, PersonSupportNeededOutputModel> {
        val person = personRepository.findById(personSupportNeededInput.personId).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound)
        val supportNeeded = supportNeededRepository.findById(personSupportNeededInput.supportNeededId).getOrNull()
            ?: return failure(ServiceErrors.SupportNeededNotFound)
        if (personSupportNeededInput.description?.isBlank() == true ||
            personSupportNeededInput.startDate.isAfter(personSupportNeededInput.endDate ?: personSupportNeededInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newPersonSupportNeeded = PersonSupportNeeded(
            person = person,
            supportNeeded = supportNeeded,
            description = personSupportNeededInput.description,
            startDate = personSupportNeededInput.startDate,
            endDate = personSupportNeededInput.endDate
        )

        return try {
            success(repository.save(newPersonSupportNeeded).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updatePersonSupportNeededById(
        id: Long,
        personSupportNeededInput: PersonSupportNeededInputModel
    ): Either<ServiceErrors, PersonSupportNeededOutputModel> {
        val personSupportNeeded = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        val person = personRepository.findById(personSupportNeededInput.personId).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound)
        val supportNeeded = supportNeededRepository.findById(personSupportNeededInput.supportNeededId).getOrNull()
            ?: return failure(ServiceErrors.SupportNeededNotFound)
        if (personSupportNeededInput.description?.isBlank() == true ||
            personSupportNeededInput.startDate.isAfter(personSupportNeededInput.endDate ?: personSupportNeededInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newPersonSupportNeeded = personSupportNeeded.copy(
            person = person,
            supportNeeded = supportNeeded,
            description = personSupportNeededInput.description,
            startDate = personSupportNeededInput.startDate,
            endDate = personSupportNeededInput.endDate,
            updatedAt = LocalDateTime.now()
        )

        return try {
            success(repository.save(newPersonSupportNeeded).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deletePersonSupportNeededById(id: Long): Either<ServiceErrors, Unit> {
        repository.findById(id).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repository.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getPersonSupportNeededValidOn(date: LocalDate): List<PersonSupportNeededOutputModel> =
        repository.findValidOnDate(date).map { it.toOutputModel() }

    fun getPersonSupportNeededByPersonId(id: Long): Either<ServiceErrors, List<PersonSupportNeededOutputModel>> {
        personRepository.findById(id).getOrNull() ?: return failure(ServiceErrors.PersonNotFound)
        return success(repository.findByPerson_PersonId(id).map { it.toOutputModel() })
    }

    private fun PersonSupportNeeded.toOutputModel(): PersonSupportNeededOutputModel =
        PersonSupportNeededOutputModel(
            personSupportNeededId,
            person.toOutputModel(),
            supportNeeded.toOutputModel(),
            description,
            startDate,
            endDate,
            updatedAt,
            createdAt
        )
}