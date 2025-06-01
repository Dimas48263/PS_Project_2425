package pt.isel.ps.zcap.repository.models.users

import jakarta.transaction.Transactional
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.supportTables.EntityType
import pt.isel.ps.zcap.domain.users.User
import java.time.LocalDate
import java.util.Optional

@Repository
@Transactional
interface UserRepository : JpaRepository<User, Long>{
    fun findByUserName(userName: String): List<User>

    @Query(
        """
    SELECT u FROM User u
    WHERE u.startDate <= :targetDate
      AND (u.endDate IS NULL OR u.endDate >= :targetDate)
        """
    )
    fun findValidOnDate(@Param("targetDate") targetDate: LocalDate): List<User>
}

