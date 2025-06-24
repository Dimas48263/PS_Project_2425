package pt.isel.ps.zcap.services.supportTables

import jakarta.transaction.Transactional
import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.supportTables.DetailTypeCategory
import pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories.DetailTypeCategoryInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories.DetailTypeCategoryOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.detailTypesCategories.toOutputModel
import pt.isel.ps.zcap.repository.models.supportTables.DetailTypeCategoryRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Service
class DetailTypeCategoryService(
    private val repo: DetailTypeCategoryRepository
) {
    fun getAllDetailTypeCategories(): List<DetailTypeCategoryOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getDetailTypeCategoryById(id: Long): Either<ServiceErrors, DetailTypeCategoryOutputModel> {
        val dtc = repo.findById(id).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        return success(dtc.toOutputModel())
    }

    fun saveDetailTypeCategory(
        inputModel: DetailTypeCategoryInputModel
    ): Either<ServiceErrors, DetailTypeCategoryOutputModel> {
        if (inputModel.name.isBlank() || inputModel.startDate.isAfter(inputModel.endDate ?: inputModel.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newDetailTypeCategory = DetailTypeCategory(
            name = inputModel.name,
            startDate = inputModel.startDate,
            endDate = inputModel.endDate,
            createdAt = LocalDateTime.now(),
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newDetailTypeCategory).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    @Transactional
    fun updateDetailTypeCategoryById(
        id: Long,
        inputModel: DetailTypeCategoryInputModel
    ): Either<ServiceErrors, DetailTypeCategoryOutputModel> {
        val detailTypeCategory = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        if (inputModel.name.isBlank() || inputModel.startDate.isAfter(inputModel.endDate ?: inputModel.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newDetailTypeCategory = detailTypeCategory.copy(
            name = inputModel.name,
            startDate = inputModel.startDate,
            endDate = inputModel.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newDetailTypeCategory).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun getDetailTypeCategoriesValidOn(date: LocalDate): List<DetailTypeCategoryOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }
}