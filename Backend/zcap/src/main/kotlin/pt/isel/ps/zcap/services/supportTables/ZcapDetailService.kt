package pt.isel.ps.zcap.services.supportTables

import jakarta.transaction.Transactional
import org.springframework.stereotype.Component
import pt.isel.ps.zcap.domain.supportTables.ZcapDetail
import pt.isel.ps.zcap.repository.dto.supportTables.zcap.toOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetailTypes.toOutputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetails.ZcapDetailInputModel
import pt.isel.ps.zcap.repository.dto.supportTables.zcapDetails.ZcapDetailOutputModel
import pt.isel.ps.zcap.repository.models.supportTables.ZcapDetailRepository
import pt.isel.ps.zcap.repository.models.supportTables.ZcapDetailTypeRepository
import pt.isel.ps.zcap.repository.models.supportTables.ZcapRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import java.time.LocalDate
import java.time.LocalDateTime
import kotlin.jvm.optionals.getOrNull

@Component
class ZcapDetailService(
    val repo: ZcapDetailRepository,
    val zcapRepo: ZcapRepository,
    val zcapDetailTypeRepo: ZcapDetailTypeRepository
) {
    fun getAllZcapDetails(): List<ZcapDetailOutputModel> =
        repo.findAll().map { it.toOutputModel() }

    fun getZcapDetailById(id: Long): Either<ServiceErrors, ZcapDetailOutputModel> {
        val zcapDetail = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        return success(zcapDetail.toOutputModel())
    }

    fun saveZcapDetail(input: ZcapDetailInputModel): Either<ServiceErrors, ZcapDetailOutputModel> {
        val zcap = zcapRepo.findById(input.zcapId).getOrNull()
            ?: return failure(ServiceErrors.ZcapNotFound)
        val zcapDetailType = zcapDetailTypeRepo.findById(input.zcapDetailTypeId).getOrNull()
            ?: return failure(ServiceErrors.ZcapDetailTypeNotFound)
        if (input.valueCol.isBlank() ||
            input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newZcapDetail = ZcapDetail(
            zcap = zcap,
            zcapDetailType = zcapDetailType,
            valueCol = input.valueCol,
            startDate = input.startDate,
            endDate = input.endDate,
            createdAt = LocalDateTime.now(),
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newZcapDetail).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    @Transactional
    fun updateZcapDetailById(
        id: Long,
        input: ZcapDetailInputModel
    ): Either<ServiceErrors, ZcapDetailOutputModel> {
        val zcapDetail = repo.findById(id).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)
        val zcap = zcapRepo.findById(input.zcapId).getOrNull()
            ?: return failure(ServiceErrors.ZcapNotFound)
        val zcapDetailType = zcapDetailTypeRepo.findById(input.zcapDetailTypeId).getOrNull()
            ?: return failure(ServiceErrors.ZcapDetailTypeNotFound)
        if (zcapDetailType.isMandatory && input.valueCol.isBlank() ||
            input.startDate.isAfter(input.endDate ?: input.startDate))
            return failure(ServiceErrors.InvalidDataInput)
        val newZcapDetail = zcapDetail.copy(
            zcap = zcap,
            zcapDetailType = zcapDetailType,
            valueCol = input.valueCol,
            startDate = input.startDate,
            endDate = input.endDate,
            lastUpdatedAt = LocalDateTime.now()
        )
        return try {
            success(repo.save(newZcapDetail).toOutputModel())
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun getZcapDetailsValidOn(date: LocalDate): List<ZcapDetailOutputModel> =
        repo.findValidOnDate(date).map { it.toOutputModel() }

    private fun ZcapDetail.toOutputModel(): ZcapDetailOutputModel =
        ZcapDetailOutputModel(
            zcapDetailId,
            zcap.toOutputModel(),
            zcapDetailType.toOutputModel(),
            valueCol,
            startDate,
            endDate,
            createdAt,
            lastUpdatedAt
        )
}