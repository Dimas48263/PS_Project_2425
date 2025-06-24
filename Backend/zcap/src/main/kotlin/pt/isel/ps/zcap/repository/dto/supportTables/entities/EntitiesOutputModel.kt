package pt.isel.ps.zcap.repository.dto.supportTables.entities

import pt.isel.ps.zcap.domain.supportTables.Entities
import pt.isel.ps.zcap.repository.dto.supportTables.entityTypes.EntityTypeOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.entityTypes.toOutputModel
import java.time.LocalDate
import java.time.LocalDateTime

data class EntitiesOutputModel(
    val entityId: Long,
    val name: String,
    val entityType: EntityTypeOutputModel,

    val email: String?,
    val phone1: String,
    val phone2: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)

// Conversion from domain Model to OutputModel
fun Entities.toOutputModel(): EntitiesOutputModel {
    return EntitiesOutputModel(
        entityId = entityId,
        name = name,
        entityType = entityType.toOutputModel(),
        email = email,
        phone1 = phone1,
        phone2 = phone2,
        startDate = startDate,
        endDate = endDate,
        createdAt = createdAt,
        lastUpdatedAt = lastUpdatedAt,
    )
}