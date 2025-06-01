package pt.isel.ps.zcap.services.persons

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.persons.Person
import pt.isel.ps.zcap.repository.dto.persons.person.PersonInputModel
import pt.isel.ps.zcap.repository.dto.persons.person.PersonOutputModel
import pt.isel.ps.zcap.repository.models.persons.DepartureDestinationRepository
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.sql.Timestamp
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class PersonService(
    val personRepository: PersonRepository,
    val treeRecordDetailRepository: TreeRecordDetailRepository,
    val treeRepository: TreeRepository,
    val departureDestinationRepository: DepartureDestinationRepository
) {
    fun getAllPersons(): List<PersonOutputModel> =
        personRepository.findAll().map { it.toOutputModel() }

    fun getPersonById(id: Long): Either<ServiceErrors, PersonOutputModel> {
        val person = personRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(person.toOutputModel())
    }

    fun savePerson(personInput: PersonInputModel): Either<ServiceErrors, PersonOutputModel> {
        val countryCode = treeRecordDetailRepository.findById(personInput.countryCodeId).getOrNull()
            ?: return failure(ServiceErrors.CountryCodeNotFound)
        val placeOfResidence = treeRepository.findById(personInput.placeOfResidenceId).getOrNull()
            ?: return failure(ServiceErrors.TreeNotFound)
        val nationality = personInput.nationalityId?.let {
            treeRecordDetailRepository.findById(it).getOrNull()
                ?: return failure(ServiceErrors.NationalityNotFound)
        }
        val departureDestination = personInput.departureDestinationId?.let {
            departureDestinationRepository.findById(it).getOrNull()
                ?: return failure(ServiceErrors.DepartureDestinationNotFound)
        }
        if(personInput.name.isBlank() ||
            personInput.entryDateTime.isAfter(personInput.departureDateTime ?: personInput.entryDateTime) ||
            (personInput.address != null  && personInput.address.isBlank()))
            return failure(ServiceErrors.InvalidDataInput)
        val newPerson = Person(
            name = personInput.name,
            age = personInput.age,
            contact = personInput.contact,
            countryCode = countryCode,
            placeOfResidence = placeOfResidence,
            entryDatetime = personInput.entryDateTime,
            departureDatetime = personInput.departureDateTime,
            birthDate = personInput.birthDate,
            nationality = nationality,
            address = personInput.address,
            niss = personInput.niss,
            departureDestination = departureDestination,
            destinationContact = personInput.destinationContact
        )
        return try {
            success(personRepository.save(newPerson).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updatePersonById(id: Long, personInput: PersonInputModel): Either<ServiceErrors, PersonOutputModel> {
        val person = personRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        val countryCode = treeRecordDetailRepository.findById(personInput.countryCodeId).getOrNull()
            ?: return failure(ServiceErrors.CountryCodeNotFound)
        val placeOfResidence = treeRepository.findById(personInput.placeOfResidenceId).getOrNull()
            ?: return failure(ServiceErrors.TreeNotFound)
        val nationality = personInput.nationalityId?.let {
            treeRecordDetailRepository.findById(it).getOrNull()
                ?: return failure(ServiceErrors.NationalityNotFound)
        }
        val departureDestination = personInput.departureDestinationId?.let {
            departureDestinationRepository.findById(it).getOrNull()
                ?: return failure(ServiceErrors.DepartureDestinationNotFound)
        }
        if(personInput.name.isBlank() ||
            personInput.entryDateTime.isAfter(personInput.departureDateTime ?: personInput.entryDateTime) ||
            (personInput.address != null  && personInput.address.isBlank()))
            return failure(ServiceErrors.InvalidDataInput)
        val newPerson = person.copy(
            name = personInput.name,
            age = personInput.age,
            contact = personInput.contact,
            countryCode = countryCode,
            placeOfResidence = placeOfResidence,
            entryDatetime = personInput.entryDateTime,
            departureDatetime = personInput.departureDateTime,
            birthDate = personInput.birthDate,
            nationality = nationality,
            address = personInput.address,
            niss = personInput.niss,
            departureDestination = departureDestination,
            destinationContact = personInput.destinationContact,
            updatedAt = LocalDateTime.now()
        )
        return try {
            success(personRepository.save(newPerson).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deletePersonById(id: Long): Either<ServiceErrors, Unit> {
        personRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return try {
            success(personRepository.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getPersonsByName(name: String): Either<ServiceErrors,List<PersonOutputModel>> {
        if (name.isBlank()) return failure(ServiceErrors.InvalidDataInput)
        return success(personRepository.findByName(name).map { it.toOutputModel() })
    }
}