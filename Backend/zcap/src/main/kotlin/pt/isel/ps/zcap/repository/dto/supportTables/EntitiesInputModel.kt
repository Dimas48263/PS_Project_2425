package pt.isel.ps.zcap.repository.dto.supportTables

import pt.isel.ps.zcap.domain.supportTables.Entities
import pt.isel.ps.zcap.domain.supportTables.EntityType
import java.time.LocalDate
import java.time.LocalDateTime

data class EntitiesInputModel(
    val name: String,
    val entityTypeId: Long,
    val email: String?,
    val phone1: String,
    val phone2: String?,
    val startDate: LocalDate,
    val endDate: LocalDate?,
)

// Conversion from InputModel to domain Model
fun EntitiesInputModel.toEntity(entityType: EntityType): Entities = Entities(
    name = name,
    entityType = entityType,
    email = email,
    phone1 = phone1,
    phone2 = phone2,
    startDate = startDate,
    endDate = endDate,
    lastUpdatedAt = LocalDateTime.now()
)


