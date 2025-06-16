package pt.isel.ps.zcap.services.persons

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.persons.RelationType
import pt.isel.ps.zcap.repository.dto.persons.relationType.RelationTypeInputModel
import pt.isel.ps.zcap.repository.dto.persons.relationType.RelationTypeOutputModel
import pt.isel.ps.zcap.repository.models.persons.RelationTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class RelationTypeService(
    val repository: RelationTypeRepository
) {
    fun getAllRelationTypes(): List<RelationTypeOutputModel> =
        repository.findAll().map { it.toOutputModel() }

    fun getRelationTypeById(id: Long): Either<ServiceErrors, RelationTypeOutputModel> {
        val relationType = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(relationType.toOutputModel())
    }

    fun saveRelationType(relationTypeInput: RelationTypeInputModel): Either<ServiceErrors, RelationTypeOutputModel> {
        if (relationTypeInput.name.isBlank() ||
            relationTypeInput.startDate.isAfter(relationTypeInput.endDate ?: relationTypeInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newRelationType = RelationType(
            name = relationTypeInput.name,
            startDate = relationTypeInput.startDate,
            endDate = relationTypeInput.endDate
        )
        return try {
            success(repository.save(newRelationType).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateRelationTypeById(
        id: Long,
        relationTypeInput: RelationTypeInputModel
    ): Either<ServiceErrors, RelationTypeOutputModel> {
        val relationType = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        if (relationTypeInput.name.isBlank() ||
            relationTypeInput.startDate.isAfter(relationTypeInput.endDate ?: relationTypeInput.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newRelationType = relationType.copy(
            name = relationTypeInput.name,
            startDate = relationTypeInput.startDate,
            endDate = relationTypeInput.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repository.save(newRelationType).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deleteRelationTypeById(id: Long): Either<ServiceErrors, Unit> {
        repository.findById(id).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repository.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getRelationTypesValidOn(date: LocalDate): List<RelationTypeOutputModel> =
        repository.findValidOnDate(date).map { it.toOutputModel() }
}