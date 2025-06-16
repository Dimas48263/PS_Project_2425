package pt.isel.ps.zcap.services.persons

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.persons.SupportNeeded
import pt.isel.ps.zcap.repository.dto.persons.supportNeeded.SupportNeededInputModel
import pt.isel.ps.zcap.repository.dto.persons.supportNeeded.SupportNeededOutputModel
import pt.isel.ps.zcap.repository.models.persons.SupportNeededRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class SupportNeededService(
    val repository: SupportNeededRepository
) {
    fun getAllSupportNeeded(): List<SupportNeededOutputModel> =
        repository.findAll().map { it.toOutputModel() }

    fun getSupportNeededById(id: Long): Either<ServiceErrors, SupportNeededOutputModel> {
        val supportNeeded = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(supportNeeded.toOutputModel())
    }

    fun saveSupportNeeded(supportNeededInput: SupportNeededInputModel): Either<ServiceErrors, SupportNeededOutputModel> {
        if (supportNeededInput.name.isBlank() ||
            supportNeededInput.startDate.isAfter(supportNeededInput.endDate ?: supportNeededInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newSupportNeeded = SupportNeeded(
            name = supportNeededInput.name,
            startDate = supportNeededInput.startDate,
            endDate = supportNeededInput.endDate
        )
        return try {
            success(repository.save(newSupportNeeded).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateSupportNeededById(
        id: Long,
        supportNeededInput: SupportNeededInputModel
    ): Either<ServiceErrors, SupportNeededOutputModel> {
        val supportNeeded = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        if (supportNeededInput.name.isBlank() ||
            supportNeededInput.startDate.isAfter(supportNeededInput.endDate ?: supportNeededInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newSupportNeeded = supportNeeded.copy(
            name = supportNeededInput.name,
            startDate = supportNeededInput.startDate,
            endDate = supportNeededInput.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repository.save(newSupportNeeded).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deleteSupportNeededById(id: Long): Either<ServiceErrors, Unit> {
        repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repository.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getSupportNeededValidOn(date: LocalDate): List<SupportNeededOutputModel> =
        repository.findValidOnDate(date).map { it.toOutputModel() }

}