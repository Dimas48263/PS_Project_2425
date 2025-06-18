package pt.isel.ps.zcap.services.tree

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.tree.TreeLevelDetailType
import pt.isel.ps.zcap.repository.dto.trees.treeLevelDetailType.TreeLevelDetailTypeInputModel
import pt.isel.ps.zcap.repository.dto.trees.treeLevelDetailType.TreeLevelDetailTypeOutputModel
import pt.isel.ps.zcap.repository.models.trees.TreeLevelDetailTypeRepository
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class TreeLevelDetailTypeService(
    private val treeLevelRepo: TreeLevelRepository,
    private val detailTypeRepo: TreeRecordDetailTypeRepository,
    private val repo: TreeLevelDetailTypeRepository
) {
    fun getAllTreeLevelDetailType(): List<TreeLevelDetailTypeOutputModel> = repo.findAll().map { it.toOutputModel() }

    fun getTreeById(id: Long): Either<ServiceErrors, TreeLevelDetailTypeOutputModel> {
        val tldt = repo.findById(id).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        return success(tldt.toOutputModel())
    }

    fun saveTreeLevelDetailType(
        tldtInput: TreeLevelDetailTypeInputModel
    ): Either<ServiceErrors, TreeLevelDetailTypeOutputModel> {
        val treeLevel = treeLevelRepo.findById(tldtInput.treeLevelId).getOrNull()
            ?: return failure(ServiceErrors.TreeLevelNotFound)

        val detailType = detailTypeRepo.findById(tldtInput.detailTypeId).getOrNull()
            ?: return failure(ServiceErrors.TreeRecordDetailTypeNotFound)

        if (tldtInput.startDate.isAfter(tldtInput.endDate ?: tldtInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newtldt = TreeLevelDetailType(
            treeLevel = treeLevel,
            detailType = detailType,
            startDate = tldtInput.startDate,
            endDate = tldtInput.endDate,
            createdAt = LocalDateTime.now(),
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newtldt).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateTreeLevelDetailTypeById(
        id: Long,
        tldtInput: TreeLevelDetailTypeInputModel
    ): Either<ServiceErrors, TreeLevelDetailTypeOutputModel> {
        val tldt = repo.findById(id).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        val treeLevel = treeLevelRepo.findById(tldtInput.treeLevelId).getOrNull()
            ?: return failure(ServiceErrors.TreeLevelNotFound)

        val detailType = detailTypeRepo.findById(tldtInput.detailTypeId).getOrNull()
            ?: return failure(ServiceErrors.TreeRecordDetailTypeNotFound)

        if (tldtInput.startDate.isAfter(tldtInput.endDate ?: tldtInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newTldt = tldt.copy(
            treeLevel = treeLevel,
            detailType = detailType,
            startDate = tldtInput.startDate,
            endDate = tldtInput.endDate ?: tldt.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newTldt).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getTreeLevelDetailTypeValidOn(date: LocalDate): List<TreeLevelDetailTypeOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    fun getTreeLevelDetailTypeByTreeLevelId(id: Long): Either<ServiceErrors, List<TreeLevelDetailTypeOutputModel>> {
        treeLevelRepo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.TreeLevelNotFound)
        return success(repo.findByTreeLevel_TreeLevelId(id).map { it.toOutputModel() })
    }

    fun getTreeLevelDetailTypeByDetailTypeId(id: Long): Either<ServiceErrors, List<TreeLevelDetailTypeOutputModel>> {
        detailTypeRepo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.TreeRecordDetailTypeNotFound)
        return success(repo.findByDetailType_DetailTypeId(id).map { it.toOutputModel() })
    }

    fun TreeLevelDetailType.toOutputModel() =
        TreeLevelDetailTypeOutputModel(
            treeLevelDetailTypeId,
            treeLevel.toOutputModel(),
            detailType.toOutputModel(),
            startDate,
            endDate,
            createdAt,
            lastUpdatedAt
        )
}