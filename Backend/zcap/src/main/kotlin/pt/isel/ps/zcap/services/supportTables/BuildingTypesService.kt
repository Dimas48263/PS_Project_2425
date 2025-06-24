package pt.isel.ps.zcap.services.supportTables

import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.supportTables.BuildingType
import pt.isel.ps.zcap.repository.dto.supportTables.buildingTypes.BuildingTypeInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.buildingTypes.BuildingTypeOutputModel
import pt.isel.ps.zcap.repository.models.supportTables.BuildingTypeRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Service
class BuildingTypesService(
    private val buildingTypeRepository: BuildingTypeRepository
) {
    fun getAllBuildingTypes(): List<BuildingTypeOutputModel> {
        val buildingTypes = buildingTypeRepository.findAll()
        return buildingTypes.map { toOutputModel(it) }
    }

    fun getBuildingTypesValidOn(date: LocalDate): List<BuildingTypeOutputModel> {
        val validBuildingTypes = buildingTypeRepository.findValidOnDate(date)
        return validBuildingTypes.map { toOutputModel(it) }
    }

    fun getBuildingTypeById(buildingTypeId: Long): Either<ServiceErrors, BuildingTypeOutputModel> {
        val buildingType = buildingTypeRepository.findById(buildingTypeId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        return success(toOutputModel(buildingType))
    }

    fun addBuildingType(newBuildingType: BuildingTypeInputModel): Either<ServiceErrors, BuildingTypeOutputModel> {
        if (newBuildingType.name.isBlank()
            || newBuildingType.startDate.isAfter(newBuildingType.endDate ?: newBuildingType.startDate)
        )
            return failure(ServiceErrors.InvalidDataInput)

        val buildingType = toBuildingType(newBuildingType)
        return try {
            success(toOutputModel(buildingTypeRepository.save(buildingType)))
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun updateBuildingType(
        buildingTypeId: Long,
        updatedBuildingType: BuildingTypeInputModel
    ): Either<ServiceErrors, BuildingTypeOutputModel> {

        if (updatedBuildingType.name.isBlank()
            || updatedBuildingType.startDate.isAfter(updatedBuildingType.endDate ?: updatedBuildingType.startDate)
        )
            return failure(ServiceErrors.InvalidDataInput)

        val oldBuildingType =
            buildingTypeRepository.findById(buildingTypeId).getOrNull() ?: return failure(ServiceErrors.RecordNotFound)

        val newRecord = oldBuildingType.copy(
            name = updatedBuildingType.name,
            startDate = updatedBuildingType.startDate,
            endDate = updatedBuildingType.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )

        return try {
            success(toOutputModel(buildingTypeRepository.save(newRecord)))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    // Conversion from InputModel to domain Model
    private fun toBuildingType(inputData: BuildingTypeInputModel): BuildingType = BuildingType(
        name = inputData.name,
        startDate = inputData.startDate,
        endDate = inputData.endDate,
        lastUpdatedAt = LocalDateTime.now()
    )

    // Conversion from domain Model to OutputModel
    fun toOutputModel(buildingType: BuildingType): BuildingTypeOutputModel {
        return BuildingTypeOutputModel(
            buildingTypeId = buildingType.buildingTypeId,
            name = buildingType.name,
            startDate = buildingType.startDate,
            endDate = buildingType.endDate,
            createdAt = buildingType.createdAt,
            lastUpdatedAt = buildingType.lastUpdatedAt,
        )
    }
}