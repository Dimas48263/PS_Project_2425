package pt.isel.ps.zcap.services.tree

import jakarta.transaction.Transactional
import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import pt.isel.ps.zcap.domain.tree.TreeRecordDetailType
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail.TreeRecordDetailInputModel
import pt.isel.ps.zcap.repository.dto.trees.treeRecordDetail.TreeRecordDetailOutputModel
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRecordDetailTypeRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Service
class TreeRecordDetailService(
    private val repo: TreeRecordDetailRepository,
    private val treeRepo: TreeRepository,
    private val trdtRepo: TreeRecordDetailTypeRepository
) {
    fun getAllTreeRecordDetails(): List<TreeRecordDetailOutputModel> = repo.findAll().map { it.toOutputModel() }

    fun getTreeRecordDetailById(id: Long): Either<ServiceErrors, TreeRecordDetailOutputModel> {
        val treeRecordDetail = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound(id))
        return success(treeRecordDetail.toOutputModel())
    }

    fun saveTreeRecordDetail(
        treeRecordDetailInput: TreeRecordDetailInputModel
    ): Either<ServiceErrors, TreeRecordDetailOutputModel> {
        val tree = treeRepo.findById(treeRecordDetailInput.treeRecordId).getOrNull()
            ?: return failure(ServiceErrors.TreeNotFound(treeRecordDetailInput.treeRecordId))

        val trdt = trdtRepo.findById(treeRecordDetailInput.detailTypeId).getOrNull()
            ?: return failure(ServiceErrors.TreeRecordDetailTypeNotFound(treeRecordDetailInput.detailTypeId))

        if (treeRecordDetailInput.valueCol.isBlank() ||
            treeRecordDetailInput.startDate.isAfter(treeRecordDetailInput.endDate ?: treeRecordDetailInput.startDate)
            ) return failure(ServiceErrors.InvalidDataInput)

        return try {
            success(repo.save(treeRecordDetailInput.toTreeRecordDetail(tree, trdt)).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    @Transactional
    fun updateTreeRecordDetailById(
        id: Long,
        treeRecordDetailUpdate: TreeRecordDetailInputModel
    ): Either<ServiceErrors, TreeRecordDetailOutputModel> {
        val treeRecordDetail = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.TreeRecordDetailNotFound(id))

        val tree = treeRepo.findById(treeRecordDetailUpdate.treeRecordId).getOrNull()
            ?: return failure(ServiceErrors.TreeNotFound(treeRecordDetailUpdate.treeRecordId))

        val trdt = trdtRepo.findById(treeRecordDetailUpdate.detailTypeId).getOrNull()
            ?: return failure(ServiceErrors.TreeRecordDetailTypeNotFound(treeRecordDetailUpdate.detailTypeId))

        if (treeRecordDetailUpdate.valueCol.isBlank() ||
            treeRecordDetailUpdate.startDate.isAfter(treeRecordDetailUpdate.endDate ?: treeRecordDetailUpdate.startDate) ||
            treeRecordDetail.lastUpdatedAt.isAfter(treeRecordDetailUpdate.lastUpdatedAt))
            return failure(ServiceErrors.InvalidDataInput)

        val newTreeRecordDetail = treeRecordDetail.copy(
            treeRecord = tree,
            detailType = trdt,
            valueCol = treeRecordDetailUpdate.valueCol,
            startDate = treeRecordDetailUpdate.startDate,
            endDate = treeRecordDetailUpdate.endDate,
            createdAt = treeRecordDetailUpdate.createdAt,
            lastUpdatedAt = treeRecordDetailUpdate.lastUpdatedAt
        )
        return try {
            success(repo.save(newTreeRecordDetail).toOutputModel())
        } catch(ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deleteTreeRecordDetailById(id: Long): Either<ServiceErrors, Unit> {
        val exists = repo.existsById(id)
        if (!exists) return failure(ServiceErrors.RecordNotFound(id))
        return try {
            success(repo.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.DeleteFailed)
        }
    }

    fun getTreeRecordDetailsValidOn(date: LocalDate): List<TreeRecordDetailOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    fun getTreeRecordDetailsByDetailTypeId(id: Long): Either<ServiceErrors, List<TreeRecordDetailOutputModel>> {
        trdtRepo.findById(id).getOrNull() ?: return failure(ServiceErrors.TreeRecordDetailTypeNotFound(id))
        return success(repo.findByDetailType_DetailTypeId(id).map { it.toOutputModel() })
    }

    private fun TreeRecordDetailInputModel.toTreeRecordDetail(
        tree: Tree,
        trdt: TreeRecordDetailType
    ): TreeRecordDetail =
        TreeRecordDetail(
            treeRecord = tree,
            detailType = trdt,
            valueCol = valueCol,
            startDate = startDate,
            endDate = endDate,
            createdAt = createdAt,
            lastUpdatedAt = lastUpdatedAt
        )
}