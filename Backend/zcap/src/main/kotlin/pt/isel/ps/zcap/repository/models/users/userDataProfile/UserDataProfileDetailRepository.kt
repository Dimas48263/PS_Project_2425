package pt.isel.ps.zcap.repository.models.users.userDataProfile

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfileDetail
import pt.isel.ps.zcap.domain.users.userDataProfile.UserDataProfileDetailId

interface UserDataProfileDetailRepository: JpaRepository<UserDataProfileDetail, UserDataProfileDetailId>{

    @Query("SELECT u FROM UserDataProfileDetail u WHERE u.id.userDataProfileId = :profileId")
    fun findByUserDataProfileId(@Param("profileId") userDataProfileId: Long): List<UserDataProfileDetail>
}