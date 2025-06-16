package pt.isel.ps.zcap.services.tree

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.tree.TreeLevel
import pt.isel.ps.zcap.repository.dto.trees.treeLevel.TreeLevelInputModel
import pt.isel.ps.zcap.repository.dto.trees.treeLevel.TreeLevelOutputModel
import pt.isel.ps.zcap.repository.models.trees.TreeLevelRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class TreeLevelService(
    private val repo: TreeLevelRepository
) {
    fun getAllTreeLevels(): List<TreeLevelOutputModel> = repo.findAll().map { it.toOutputModel() }

    fun saveTreeLevel(treeLevelInputModel: TreeLevelInputModel): Either<ServiceErrors, TreeLevelOutputModel> {
        if (treeLevelInputModel.name.isBlank() ||
            treeLevelInputModel.startDate.isAfter(treeLevelInputModel.endDate ?: treeLevelInputModel.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        treeLevelInputModel.description?.let {
            if (it.isBlank()) return failure(ServiceErrors.InvalidDataInput)
        }
        return try {
            success(repo.save(treeLevelInputModel.toTreeLevel()).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getTreeLevelById(id: Long): Either<ServiceErrors, TreeLevelOutputModel> {
        val treeLevel = repo.findById(id).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        return success(treeLevel.toOutputModel())
    }

    @Transactional
    fun updateTreeLevel(id: Long, treeLevelUpdate: TreeLevelInputModel): Either<ServiceErrors, TreeLevelOutputModel> {
        val treeLevel = repo.findById(id).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        if (treeLevelUpdate.name.isBlank() ||
            treeLevelUpdate.description?.isBlank() == true ||
            treeLevelUpdate.startDate.isAfter(treeLevelUpdate.endDate ?: treeLevelUpdate.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newTreeLevel = treeLevel.copy(
            levelId = treeLevelUpdate.levelId,
            name = treeLevelUpdate.name,
            description = treeLevelUpdate.description,
            startDate = treeLevelUpdate.startDate,
            endDate = treeLevelUpdate.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newTreeLevel).toOutputModel())
        } catch(ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deleteTreeLevelById(id: Long): Either<ServiceErrors, Unit> {
        val exists = repo.existsById(id)
        if (!exists) return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repo.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getTreeLevelsValidOn(date: LocalDate): List<TreeLevelOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    private fun TreeLevelInputModel.toTreeLevel() = TreeLevel(
        levelId = levelId,
        name = name,
        description = description,
        startDate = startDate,
        endDate = endDate
    )
}