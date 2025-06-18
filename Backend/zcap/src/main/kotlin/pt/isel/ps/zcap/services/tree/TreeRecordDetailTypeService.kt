package pt.isel.ps.zcap.services.tree

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType.TreeRecordDetailTypeInputModel
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetailType.TreeRecordDetailTypeOutputModel
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class TreeRecordDetailTypeService(
    private val repo:  TreeRecordDetailTypeRepository
) {
    fun getAllTreeRecordTypes(): List<TreeRecordDetailTypeOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getTreeRecordDetailTypeById(id: Long): Either<ServiceErrors, TreeRecordDetailTypeOutputModel> {
        val trdt = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(trdt.toOutputModel())
    }

    fun saveTreeRecordDetailType(
        treeRecordDetailTypeInput: TreeRecordDetailTypeInputModel
    ): Either<ServiceErrors, TreeRecordDetailTypeOutputModel> {
        if (treeRecordDetailTypeInput.name.isBlank() ||
            treeRecordDetailTypeInput.unit.isBlank() ||
            treeRecordDetailTypeInput.startDate.isAfter(treeRecordDetailTypeInput.endDate ?: treeRecordDetailTypeInput.startDate)
            )
            return failure(ServiceErrors.InvalidDataInput)
        return try {
            success(repo.save(treeRecordDetailTypeInput.toTreeRecordDetailType()).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }
    @Transactional
    fun updateTreeRecordDetailTypeById(
        id: Long,
        treeRecordDetailTypeInput: TreeRecordDetailTypeInputModel
    ): Either<ServiceErrors, TreeRecordDetailTypeOutputModel> {
        val trdt = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        if (treeRecordDetailTypeInput.name.isBlank() ||
            treeRecordDetailTypeInput.unit.isBlank() ||
            treeRecordDetailTypeInput.startDate.isAfter(treeRecordDetailTypeInput.endDate ?: treeRecordDetailTypeInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newTrdt = trdt.copy(
            name = treeRecordDetailTypeInput.name,
            unit = treeRecordDetailTypeInput.unit,
            startDate = treeRecordDetailTypeInput.startDate,
            endDate = treeRecordDetailTypeInput.endDate ?: trdt.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newTrdt).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deleteTreeRecordDetailTypeById(id: Long): Either<ServiceErrors, Unit> {
        val exists = repo.existsById(id)
        if (!exists) return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repo.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getTreeRecordDetailTypesValidOn(date: LocalDate): List<TreeRecordDetailTypeOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    private fun TreeRecordDetailTypeInputModel.toTreeRecordDetailType(): TreeRecordDetailType =
        TreeRecordDetailType(
            name = name,
            unit = unit,
            startDate = startDate,
            endDate = endDate
        )
    fun TreeRecordDetailType.toOutputModel(): TreeRecordDetailTypeOutputModel =
        TreeRecordDetailTypeOutputModel(
            this.detailTypeId,
            this.name,
            this.unit,
            this.startDate,
            this.endDate,
            this.createdAt,
            this.lastUpdatedAt
        )
}