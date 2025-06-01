package pt.isel.ps.zcap.services.supportTables

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.supportTables.BuildingType
import pt.isel.ps.zcap.domain.supportTables.Zcap
import pt.isel.ps.zcap.repository.dto.supportTables.BuildingTypeOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.toOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.ZcapInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.ZcapOutputModel
import pt.isel.ps.zcap.repository.models.supportTables.BuildingTypeRepository
import pt.isel.ps.zcap.repository.models.supportTables.EntitiesRepository
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.repository.models.supportTables.ZcapRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import pt.isel.ps.zcap.services.tree.toOutputModel
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class ZcapService(
    private val repo: ZcapRepository,
    private val buildingTypeRepository: BuildingTypeRepository,
    private val treeRepository: TreeRepository,
    private val entitiesRepository: EntitiesRepository
) {
    fun getAllZcaps(): List<ZcapOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getZcapById(id: Long): Either<ServiceErrors, ZcapOutputModel> {
        val zcap = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(zcap.toOutputModel())
    }

    fun saveZcap(input: ZcapInputModel): Either<ServiceErrors, ZcapOutputModel> {
        val buildingType = buildingTypeRepository.findById(input.buildingTypeId).getOrNull()
            ?: return failure(ServiceErrors.BuildingTypeNotFound)
        val tree = input.treeRecordId?.let {
            treeRepository.findById(it).getOrNull() ?: return failure(ServiceErrors.TreeNotFound)
        }
        val entity = entitiesRepository.findById(input.entityId).getOrNull()
            ?: return failure(ServiceErrors.EntityNotFound)

        if (input.name.isBlank() ||
            input.address.isBlank() ||
            input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newZcap = Zcap(
            name = input.name,
            buildingType = buildingType,
            address = input.address,
            tree = tree,
            latitude = input.latitude,
            longitude = input.longitude,
            entity = entity,
            startDate = input.startDate,
            endDate = input.endDate
        )

        return try {
            success(repo.save(newZcap).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateZcapById(id: Long, input: ZcapInputModel): Either<ServiceErrors, ZcapOutputModel> {
        val zcap = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        val buildingType = buildingTypeRepository.findById(input.buildingTypeId).getOrNull()
            ?: return failure(ServiceErrors.BuildingTypeNotFound)
        val tree = input.treeRecordId?.let {
            treeRepository.findById(it).getOrNull() ?: return failure(ServiceErrors.TreeNotFound)
        }
        val entity = entitiesRepository.findById(input.entityId).getOrNull()
            ?: return failure(ServiceErrors.EntityNotFound)

        if (input.name.isBlank() ||
            input.address.isBlank() ||
            input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)

        val newZcap = zcap.copy(
            name = input.name,
            buildingType = buildingType,
            address = input.address,
            tree = tree,
            latitude = input.latitude,
            longitude = input.longitude,
            entity = entity,
            startDate = input.startDate,
            endDate = input.endDate,
            updatedAt = LocalDateTime.now()
        )

        return try {
            success(repo.save(newZcap).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getAllZcapsValidOn(date: LocalDate): List<ZcapOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    fun getZcapsByBuildingTypeId(id: Long): Either<ServiceErrors, List<ZcapOutputModel>> {
        buildingTypeRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.BuildingTypeNotFound)
        return success(repo.findByBuildingType_buildingTypeId(id).map { it.toOutputModel() })
    }

    fun getZcapsByEntityId(id: Long): Either<ServiceErrors, List<ZcapOutputModel>> {
        entitiesRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.BuildingTypeNotFound)
        return success(repo.findByEntity_entityId(id).map { it.toOutputModel() })
    }
}