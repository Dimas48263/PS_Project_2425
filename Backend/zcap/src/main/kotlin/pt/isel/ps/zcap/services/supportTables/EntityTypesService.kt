package pt.isel.ps.zcap.services.supportTables

import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.supportTables.EntityType
import pt.isel.ps.zcap.repository.dto.supportTables.EntityTypeInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.EntityTypeOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.toEntityType
import pt.isel.ps.zcap.repository.dto.supportTables.toOutputModel
import pt.isel.ps.zcap.repository.models.supportTables.EntityTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.*
import kotlin.jvm.optionals.getOrNull

@Service
class EntityTypesService(
    private val entityTypeRepository: EntityTypeRepository
) {
    fun getAllEntityTypes(): List<EntityTypeOutputModel> {
        val entityTypes = entityTypeRepository.findAll()
        return entityTypes.map { it.toOutputModel() }
    }

    fun getEntityTypesValidOn(date: LocalDate): List<EntityTypeOutputModel> {
        val validEntityTypes = entityTypeRepository.findValidOnDate(date)
        return validEntityTypes.map { it.toOutputModel() }
    }

    fun getEntityTypeById(entityTypeId: Long): Either<ServiceErrors, EntityTypeOutputModel> {
        val entityType = entityTypeRepository.findById(entityTypeId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        return success(entityType.toOutputModel())
    }

    fun getEntityTypeByIdInternal(entityTypeId: Long): Optional<EntityType> =
        entityTypeRepository.findById(entityTypeId)

    fun addEntityType(newEntityType: EntityTypeInputModel): Either<ServiceErrors, EntityTypeOutputModel> {
        if (newEntityType.name.isBlank()
            || newEntityType.startDate.isAfter(newEntityType.endDate ?: newEntityType.startDate)
        )
            return failure(ServiceErrors.InvalidDataInput)

        return try {
            success(entityTypeRepository.save(newEntityType.toEntityType()).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun updateEntityType(
        entityTypeId: Long,
        updatedEntityType: EntityTypeInputModel
    ): Either<ServiceErrors, EntityTypeOutputModel> {

        if (updatedEntityType.name.isBlank()
            || updatedEntityType.startDate.isAfter(updatedEntityType.endDate ?: updatedEntityType.startDate)
        )
            return failure(ServiceErrors.InvalidDataInput)

        val oldEntityType =
            entityTypeRepository.findById(entityTypeId).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)

        val newProfile = oldEntityType.copy(
            name = updatedEntityType.name,
            startDate = updatedEntityType.startDate,
            endDate = updatedEntityType.endDate,
            updatedAt = LocalDateTime.now()
        )

        return try {
            success(entityTypeRepository.save(newProfile).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }
}