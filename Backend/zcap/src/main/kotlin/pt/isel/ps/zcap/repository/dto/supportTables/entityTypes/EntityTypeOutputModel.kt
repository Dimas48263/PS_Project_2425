package pt.isel.ps.zcap.repository.dto.supportTables.entityTypes

import pt.isel.ps.zcap.domain.supportTables.EntityType
import java.time.LocalDate
import java.time.LocalDateTime

data class EntityTypeOutputModel(
    val entityTypeId: Long,
    val name: String,

    val startDate: LocalDate,
    val endDate: LocalDate?,
    val createdAt: LocalDateTime,
    val lastUpdatedAt: LocalDateTime,
)

// Conversion from domain Model to OutputModel
fun EntityType.toOutputModel(): EntityTypeOutputModel {
    return EntityTypeOutputModel(
        entityTypeId = entityTypeId,
        name = name,
        startDate = startDate,
        endDate = endDate,
        createdAt = createdAt,
        lastUpdatedAt = lastUpdatedAt,
    )
}