package pt.isel.ps.zcap.services.supportTables

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.supportTables.ZcapDetailType
import pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories.toOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes.ZcapDetailTypeInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes.ZcapDetailTypeOutputModel
import pt.isel.ps.zcap.repository.models.supportTables.DetailTypeCategoryRepository
import pt.isel.ps.zcap.repository.models.supportTables.ZcapDetailTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class ZcapDetailTypeService(
    val repo: ZcapDetailTypeRepository,
    val detailTypeCategoryRepository: DetailTypeCategoryRepository
) {
    fun getAllZcapDetailTypes(): List<ZcapDetailTypeOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getZcapDetailTypeById(id: Long): Either<ServiceErrors, ZcapDetailTypeOutputModel> {
        val zdt = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(zdt.toOutputModel())
    }

    fun saveZcapDetailType(
        zcapDetailTypeInput: ZcapDetailTypeInputModel
    ): Either<ServiceErrors, ZcapDetailTypeOutputModel> {
        if (zcapDetailTypeInput.name.isBlank() ||
            zcapDetailTypeInput.startDate.isAfter(zcapDetailTypeInput.endDate ?: zcapDetailTypeInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val detailTypeCategory = detailTypeCategoryRepository.findById(zcapDetailTypeInput.detailTypeCategoryId).getOrNull()
            ?: return failure(ServiceErrors.DetailTypeCategoryNotFound)
        val newZcapDetailType = ZcapDetailType(
            name = zcapDetailTypeInput.name,
            detailTypeCategory = detailTypeCategory,
            dataType = zcapDetailTypeInput.dataType,
            isMandatory = zcapDetailTypeInput.isMandatory,
            startDate = zcapDetailTypeInput.startDate,
            endDate = zcapDetailTypeInput.endDate,
            createdAt = LocalDateTime.now(),
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newZcapDetailType).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateZcapDetailTypeById(
        id: Long,
        zcapDetailTypeInput: ZcapDetailTypeInputModel
    ): Either<ServiceErrors, ZcapDetailTypeOutputModel> {
        val zcapDetailType = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        if (zcapDetailTypeInput.name.isBlank() ||
            zcapDetailTypeInput.startDate.isAfter(zcapDetailTypeInput.endDate ?: zcapDetailTypeInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val detailTypeCategory = detailTypeCategoryRepository.findById(zcapDetailTypeInput.detailTypeCategoryId).getOrNull()
            ?: return failure(ServiceErrors.DetailTypeCategoryNotFound)
        val newZcapDetailType = zcapDetailType.copy(
            name = zcapDetailTypeInput.name,
            detailTypeCategory = detailTypeCategory,
            dataType = zcapDetailTypeInput.dataType,
            isMandatory = zcapDetailTypeInput.isMandatory,
            startDate = zcapDetailTypeInput.startDate,
            endDate = zcapDetailTypeInput.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newZcapDetailType).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getZcapDetailTypesValidOn(date: LocalDate): List<ZcapDetailTypeOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    fun ZcapDetailType.toOutputModel(): ZcapDetailTypeOutputModel =
        ZcapDetailTypeOutputModel(
            zcapDetailTypeId,
            name,
            detailTypeCategory.toOutputModel(),
            dataType,
            isMandatory,
            startDate,
            endDate,
            createdAt,
            lastUpdatedAt
        )
}