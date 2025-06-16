package pt.isel.ps.zcap.services.supportTables

import org.springframework.stereotype.Service
import pt.isel.ps.zcap.repository.dto.supportTables.EntitiesInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.EntitiesOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.toEntity
import pt.isel.ps.zcap.repository.dto.supportTables.toOutputModel
import pt.isel.ps.zcap.repository.models.supportTables.EntitiesRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Service
class EntitiesService(
    private val entitiesRepository: EntitiesRepository,
    private val entityTypesService: EntityTypesService,
) {
    fun getAllEntities(): List<EntitiesOutputModel> {
        val entities = entitiesRepository.findAll()
        return entities.map { it.toOutputModel() }
    }

    fun getEntitiesValidOn(date: LocalDate): List<EntitiesOutputModel> {
        val validEntities = entitiesRepository.findValidOnDate(date)
        return validEntities.map { it.toOutputModel() }
    }

    fun getEntityById(entityId: Long): Either<ServiceErrors, EntitiesOutputModel> {
        val entity = entitiesRepository.findById(entityId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        return success(entity.toOutputModel())
    }

    fun addEntity(newEntity: EntitiesInputModel): Either<ServiceErrors, EntitiesOutputModel> {
        if (newEntity.name.isBlank()
            || newEntity.startDate.isAfter(newEntity.endDate ?: newEntity.startDate)
        ) return failure(ServiceErrors.InvalidDataInput)

        val entityType = entityTypesService.getEntityTypeByIdInternal(newEntity.entityTypeId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        return try {
            success(entitiesRepository.save(newEntity.toEntity(entityType)).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun updateEntity(
        entityId: Long,
        updatedEntity: EntitiesInputModel
    ): Either<ServiceErrors, EntitiesOutputModel> {

        if (updatedEntity.name.isBlank()
            || updatedEntity.startDate.isAfter(updatedEntity.endDate ?: updatedEntity.startDate)
        ) return failure(ServiceErrors.InvalidDataInput)

        val oldEntity =
            entitiesRepository.findById(entityId).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)

        val entityType = entityTypesService.getEntityTypeByIdInternal(updatedEntity.entityTypeId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        val newProfile = oldEntity.copy(
            name = updatedEntity.name,
            entityType = entityType,
            email = updatedEntity.email,
            phone1 = updatedEntity.phone1,
            phone2 = updatedEntity.phone2,

            startDate = updatedEntity.startDate,
            endDate = updatedEntity.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )

        return try {
            success(entitiesRepository.save(newProfile).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }
}