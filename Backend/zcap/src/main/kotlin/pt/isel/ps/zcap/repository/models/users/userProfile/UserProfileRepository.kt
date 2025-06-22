package pt.isel.ps.zcap.repository.models.users.userProfile

import jakarta.transaction.Transactional
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.users.userProfile.UserProfile
import java.time.LocalDate


@Repository
@Transactional
interface UserProfileRepository : JpaRepository<UserProfile, Long> {
    @Query(
        """
    SELECT u FROM UserProfile u
    WHERE u.startDate <= :targetDate
      AND (u.endDate IS NULL OR u.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<UserProfile>
}