package pt.isel.ps.zcap.services.persons

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.persons.SpecialNeed
import pt.isel.ps.zcap.repository.dto.persons.specialNeed.SpecialNeedInputModel
import pt.isel.ps.zcap.repository.dto.persons.specialNeed.SpecialNeedOutputModel
import pt.isel.ps.zcap.repository.models.persons.SpecialNeedRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class SpecialNeedService(
    val repository: SpecialNeedRepository
) {
    fun getAllSpecialNeeds(): List<SpecialNeedOutputModel> =
        repository.findAll().map { it.toOutputModel() }

    fun getSpecialNeedById(id: Long): Either<ServiceErrors, SpecialNeedOutputModel> {
        val specialNeed = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(specialNeed.toOutputModel())
    }

    fun saveSpecialNeed(specialNeedInput: SpecialNeedInputModel): Either<ServiceErrors, SpecialNeedOutputModel> {
        if (specialNeedInput.name.isBlank() ||
            specialNeedInput.startDate.isAfter(specialNeedInput.endDate ?: specialNeedInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newSpecialNeed = SpecialNeed(
            name = specialNeedInput.name,
            startDate = specialNeedInput.startDate,
            endDate = specialNeedInput.endDate
        )
        return try {
            success(repository.save(newSpecialNeed).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateSpecialNeedById(
        id: Long,
        specialNeedInput: SpecialNeedInputModel
    ): Either<ServiceErrors, SpecialNeedOutputModel> {
        val specialNeed = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        if (specialNeedInput.name.isBlank() ||
            specialNeedInput.startDate.isAfter(specialNeedInput.endDate ?: specialNeedInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newSpecialNeed = specialNeed.copy(
            name = specialNeedInput.name,
            startDate = specialNeedInput.startDate,
            endDate = specialNeedInput.endDate,
            updatedAt = LocalDateTime.now()
        )
        return try {
            success(repository.save(newSpecialNeed).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deleteSpecialNeedById(id: Long): Either<ServiceErrors, Unit> {
        repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repository.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getSpecialNeedsValidOn(date: LocalDate): List<SpecialNeedOutputModel> =
        repository.findValidOnDate(date).map { it.toOutputModel() }

}