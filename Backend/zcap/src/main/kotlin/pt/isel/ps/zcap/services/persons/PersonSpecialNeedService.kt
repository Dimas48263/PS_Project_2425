package pt.isel.ps.zcap.services.persons

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.persons.PersonSpecialNeed
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedInputModel
import pt.isel.ps.zcap.repository.dto.persons.personSpecialNeed.PersonSpecialNeedOutputModel
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import pt.isel.ps.zcap.repository.models.persons.PersonSpecialNeedRepository
import pt.isel.ps.zcap.repository.models.persons.SpecialNeedRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class PersonSpecialNeedService(
    val repository: PersonSpecialNeedRepository,
    val personRepository: PersonRepository,
    val specialNeedRepository: SpecialNeedRepository
) {
    fun getAllPersonSpecialNeeds(): List<PersonSpecialNeedOutputModel> =
        repository.findAll().map { it.toOutputModel() }

    fun getPersonSpecialNeedById(id: Long): Either<ServiceErrors, PersonSpecialNeedOutputModel> {
        val personSpecialNeed = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound(id))
        return success(personSpecialNeed.toOutputModel())
    }

    fun savePersonSpecialNeed(
        personSpecialNeedInput: PersonSpecialNeedInputModel
    ): Either<ServiceErrors, PersonSpecialNeedOutputModel> {
        val person = personRepository.findById(personSpecialNeedInput.personId).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound(personSpecialNeedInput.personId))
        val specialNeed = specialNeedRepository.findById(personSpecialNeedInput.specialNeedId).getOrNull()
            ?: return failure(ServiceErrors.SpecialNeedNotFound(personSpecialNeedInput.specialNeedId))
        if (personSpecialNeedInput.description?.isBlank() == true ||
            personSpecialNeedInput.startDate.isAfter(personSpecialNeedInput.endDate ?: personSpecialNeedInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newPersonSpecialNeed = PersonSpecialNeed(
            person = person,
            specialNeed = specialNeed,
            description = personSpecialNeedInput.description,
            startDate = personSpecialNeedInput.startDate,
            endDate = personSpecialNeedInput.endDate,
            createdAt = personSpecialNeedInput.createdAt,
            lastUpdatedAt = personSpecialNeedInput.lastUpdatedAt
        )
        return try {
            success(repository.save(newPersonSpecialNeed).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    @Transactional
    fun updatePersonSpecialNeedById(
        id: Long,
        personSpecialNeedInput: PersonSpecialNeedInputModel
    ): Either<ServiceErrors, PersonSpecialNeedOutputModel> {
        val personSpecialNeed = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound(id))
        val person = personRepository.findById(personSpecialNeedInput.personId).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound(personSpecialNeedInput.personId))
        val specialNeed = specialNeedRepository.findById(personSpecialNeedInput.specialNeedId).getOrNull()
            ?: return failure(ServiceErrors.SpecialNeedNotFound(personSpecialNeedInput.specialNeedId))
        if (personSpecialNeedInput.description?.isBlank() == true ||
            personSpecialNeedInput.startDate.isAfter(personSpecialNeedInput.endDate ?: personSpecialNeedInput.startDate) ||
            personSpecialNeed.lastUpdatedAt.isAfter(personSpecialNeedInput.lastUpdatedAt))
            return failure(ServiceErrors.InvalidDataInput)
        val newPersonSpecialNeed = personSpecialNeed.copy(
            person = person,
            specialNeed = specialNeed,
            description = personSpecialNeedInput.description,
            startDate = personSpecialNeedInput.startDate,
            endDate = personSpecialNeedInput.endDate,
            createdAt = personSpecialNeedInput.createdAt,
            lastUpdatedAt = personSpecialNeedInput.lastUpdatedAt
        )
        return try {
            success(repository.save(newPersonSpecialNeed).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deletePersonSpecialNeedById(
        id: Long
    ): Either<ServiceErrors, Unit> {
        repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound(id))
        return try {
            success(repository.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.DeleteFailed)
        }
    }

    fun getPersonSpecialNeedsValidOn(date: LocalDate): List<PersonSpecialNeedOutputModel> =
        repository.findValidOnDate(date).map { it.toOutputModel() }

    fun getPersonSpecialNeedsByPersonId(id: Long): Either<ServiceErrors, List<PersonSpecialNeedOutputModel>> {
        personRepository.findById(id).getOrNull() ?: return failure(ServiceErrors.PersonNotFound(id))
        return success(repository.findByPerson_PersonId(id).map { it.toOutputModel() })
    }
}