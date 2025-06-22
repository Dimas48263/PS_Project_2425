package pt.isel.ps.zcap.services.users.userDataProfile

import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfileDetail
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfileDetailId
import pt.isel.ps.zcap.repository.dto.users.userDataProfile.UserDataProfileDetailInputModel
import pt.isel.ps.zcap.repository.dto.users.userDataProfile.UserDataProfileDetailOutputModel
import pt.isel.ps.zcap.repository.models.trees.TreeRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileDetailRepository
import pt.isel.ps.zcap.repository.models.users.userDataProfile.UserDataProfileRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import kotlin.jvm.optionals.getOrNull

@Service
class UserDataProfileDetailService(
    private val userDataProfileDetailRepository: UserDataProfileDetailRepository,
    private val userDataProfileRepository: UserDataProfileRepository,
    private val treeRepository: TreeRepository,
) {

    fun getAllDetailsForProfile(profileId: Long): List<UserDataProfileDetailOutputModel> =
        userDataProfileDetailRepository.findByUserDataProfileId(profileId).map {
            UserDataProfileDetailOutputModel(
                userDataProfileId = it.userDataProfileDetailId.userDataProfileId,
                treeRecordId = it.userDataProfileDetailId.treeRecordId,
                treeLevelName = it.treeRecord.treeLevel.name,
                treeName = it.treeRecord.name
            )
        }

    fun addDetail(input: UserDataProfileDetailInputModel): Either<ServiceErrors, UserDataProfileDetailOutputModel> {

        val userDataProfile = userDataProfileRepository.findById(input.userDataProfileId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        val treeRecord = treeRepository.findById(input.treeRecordId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        val detail = UserDataProfileDetail(
            userDataProfileDetailId = UserDataProfileDetailId(
                userDataProfileId = input.userDataProfileId,
                treeRecordId = input.treeRecordId
            ),
            userDataProfile = userDataProfile,
            treeRecord = treeRecord
        )
        println("Detail: $detail")
        return try {
            val saved = userDataProfileDetailRepository.save(detail)
            success(
//                getAllDetailsForProfile(input.userDataProfileId)
                UserDataProfileDetailOutputModel(
                    userDataProfileId = saved.userDataProfileDetailId.userDataProfileId,
                    treeRecordId = saved.userDataProfileDetailId.treeRecordId,
                    treeLevelName = saved.treeRecord.treeLevel.name,
                    treeName = saved.treeRecord.name
                )
            )
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun deleteDetailById(input: UserDataProfileDetailInputModel): Either<ServiceErrors, Unit> {
        val id = UserDataProfileDetailId(
            userDataProfileId = input.userDataProfileId,
            treeRecordId = input.treeRecordId
        )

        return if (!userDataProfileDetailRepository.existsById(id)) {
            failure(ServiceErrors.RecordNotFound)
        } else {
            userDataProfileDetailRepository.deleteById(id)
            success(Unit)
        }
    }
}