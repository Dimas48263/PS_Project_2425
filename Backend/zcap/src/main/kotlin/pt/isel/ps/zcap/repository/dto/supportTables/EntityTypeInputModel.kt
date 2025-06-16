package pt.isel.ps.zcap.repository.dto.supportTables

import pt.isel.ps.zcap.domain.supportTables.EntityType
import java.time.LocalDate
import java.time.LocalDateTime

data class EntityTypeInputModel(
    val name: String,
    val startDate: LocalDate,
    val endDate: LocalDate?,
)

// Conversion from InputModel to domain Model
fun EntityTypeInputModel.toEntityType(): EntityType = EntityType(
    name = name,
    startDate = startDate,
    endDate = endDate,
    lastUpdatedAt = LocalDateTime.now()
)


// Conversion from InputModel to domain Model
// Incorrect. The correct form is EntityTypeInputModel -> EntityType
//fun EntityType.toEntityType(inputData: EntityTypeInputModel): EntityType = EntityType(
//    name = inputData.name,
//    startDate = inputData.startDate,
//    endDate = inputData.endDate,
//    updatedAt = LocalDateTime.now()
//)