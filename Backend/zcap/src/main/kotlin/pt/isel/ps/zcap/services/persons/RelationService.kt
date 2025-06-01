package pt.isel.ps.zcap.services.persons

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.persons.Relation
import pt.isel.ps.zcap.repository.dto.persons.relation.RelationInputModel
import pt.isel.ps.zcap.repository.dto.persons.relation.RelationOutputModel
import pt.isel.ps.zcap.repository.dto.persons.specialNeed.SpecialNeedInputModel
import pt.isel.ps.zcap.repository.dto.persons.specialNeed.SpecialNeedOutputModel
import pt.isel.ps.zcap.repository.models.persons.PersonRepository
import pt.isel.ps.zcap.repository.models.persons.RelationRepository
import pt.isel.ps.zcap.repository.models.persons.RelationTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.sql.Timestamp
import kotlin.jvm.optionals.getOrNull

@Component
class RelationService(
    val repository: RelationRepository,
    val personRepository: PersonRepository,
    val relationTypeRepository: RelationTypeRepository
) {
    fun getAllRelations(): List<RelationOutputModel> =
        repository.findAll().map { it.toOutputModel() }

    fun getRelationById(id: Long): Either<ServiceErrors, RelationOutputModel> {
        val relation = repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(relation.toOutputModel())
    }

    fun saveRelation(relationInput: RelationInputModel): Either<ServiceErrors, RelationOutputModel> {
        if (relationInput.personId1 == relationInput.personId2) return failure(ServiceErrors.InvalidDataInput)
        val person1 = personRepository.findById(relationInput.personId1).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound)
        val person2 = personRepository.findById(relationInput.personId2).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound)
        val relationType = relationTypeRepository.findById(relationInput.relationTypeId).getOrNull()
            ?: return failure(ServiceErrors.RelationTypeNotFound)

        if (repository.existsByPersonsAndType(
                relationInput.personId1,
                relationInput.personId2,
                relationInput.relationTypeId
        ))
            return failure(ServiceErrors.RecordAlreadyExists)

        val newRelation = Relation(
            person1 = person1,
            person2 = person2,
            relationType = relationType
        )
        return try {
            success(repository.save(newRelation).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun deleteRelationById(id: Long): Either<ServiceErrors, Unit> {
        repository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return try {
            success(repository.deleteById(id))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun findAllByPerson1Id(id: Long): Either<ServiceErrors, List<RelationOutputModel>> {
        personRepository.findById(id).getOrNull()
            ?: return failure(ServiceErrors.PersonNotFound)
        return success(repository.findAllByPerson1Id(id).map { it.toOutputModel() })
    }

    private fun Relation.toOutputModel(): RelationOutputModel =
        RelationOutputModel(
            relationId,
            person1.toOutputModel(),
            person2.toOutputModel(),
            relationType.toOutputModel()
        )
}