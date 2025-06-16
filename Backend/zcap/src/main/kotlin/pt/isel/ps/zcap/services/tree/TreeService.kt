package pt.isel.ps.zcap.services.tree

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeInputModel
import pt.isel.ps.zcap.repository.dto.trees.tree.TreeOutputModel
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class TreeService(
    private val treeLevelRepo: TreeLevelRepository,
    private val repo: TreeRepository
) {
    fun getAllTrees(): List<TreeOutputModel> = repo.findAll().map { it.toOutputModel() }

    fun getTreeById(id: Long): Either<ServiceErrors, TreeOutputModel> {
        val tree = repo.findById(id).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        return success(tree.toOutputModel())
    }

    fun saveTree(treeInput: TreeInputModel): Either<ServiceErrors, TreeOutputModel> {
        val treeLevel = treeLevelRepo.findById(treeInput.treeLevelId).getOrNull()
            ?: return failure(ServiceErrors.TreeLevelNotFound)

        val parent = treeInput.parentId?.let {
            repo.findById(it).getOrNull() ?: return failure(ServiceErrors.ParentNotFound)
        }

        if (treeInput.name.isBlank() || treeInput.startDate.isAfter(treeInput.endDate ?: treeInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        return try {
            success(repo.save(treeInput.toTree(treeLevel, parent)).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateTreeById(id: Long, treeUpdate: TreeInputModel): Either<ServiceErrors, TreeOutputModel> {
        val tree = repo.findById(id).getOrNull() ?: return failure(ServiceErrors.TreeNotFound)
        val treeLevel = treeLevelRepo.findById(treeUpdate.treeLevelId).getOrNull()
            ?: return failure(ServiceErrors.TreeLevelNotFound)

        val parent = treeUpdate.parentId?.let {
            repo.findById(it).getOrNull() ?: return failure(ServiceErrors.ParentNotFound)
        }

        if (treeUpdate.name.isBlank() ||
            treeUpdate.startDate.isAfter(treeUpdate.endDate ?: treeUpdate.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newTree = tree.copy(
            name = treeUpdate.name,
            treeLevel = treeLevel,
            parent = parent ?: tree.parent,
            startDate = treeUpdate.startDate,
            endDate = treeUpdate.endDate ?: tree.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newTree).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deleteTreeById(id: Long): Either<ServiceErrors, Unit> {
        val exists = repo.existsById(id)
        if (!exists) return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repo.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getTreesValidOn(date: LocalDate): List<TreeOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    fun getTreesByNameContaining(name: String): Either<ServiceErrors, List<TreeOutputModel>> {
        if (name.isBlank()) return failure(ServiceErrors.InvalidDataInput)
        return success(repo.findByNameContaining(name).map { it.toOutputModel() })
    }

    fun getTreeByTreeLevelId(id: Long): Either<ServiceErrors,List<TreeOutputModel>> {
        treeLevelRepo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.TreeLevelNotFound)
        return success(repo.findByTreeLevelId(id).map { it.toOutputModel() })
    }

    fun getAllDirectChildren(parentId: Long): Either<ServiceErrors, List<TreeOutputModel>> {
        repo.findById(parentId).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        return success(repo.findByParent_TreeRecordId(parentId).map { it.toOutputModel() })
    }

    fun getAllChildren(parentId: Long): Either<ServiceErrors, List<TreeOutputModel>> {
        repo.findById(parentId).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        val result = mutableListOf<Tree>()
        val childrenToVerify = repo.findByParent_TreeRecordId(parentId) as MutableList
        while (childrenToVerify.isNotEmpty()) {
            val nextChildrenToVerify = mutableListOf<Tree>()
            childrenToVerify.forEach {
                val children = repo.findByParent_TreeRecordId(it.treeRecordId)
                if (children.isNotEmpty()) nextChildrenToVerify.addAll(children)
                result.add(it)
            }
            childrenToVerify.clear()
            childrenToVerify.addAll(nextChildrenToVerify)
        }
        return success(result.map { it.toOutputModel() })
    }

    private fun TreeInputModel.toTree(treeLevel: TreeLevel, parent: Tree?): Tree = Tree(
        name = this.name,
        treeLevel = treeLevel,
        parent = parent,
        startDate = this.startDate,
        endDate = this.endDate,
    )
}

