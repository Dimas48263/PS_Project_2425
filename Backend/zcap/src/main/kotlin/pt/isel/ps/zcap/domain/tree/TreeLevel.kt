package pt.isel.ps.zcap.domain.tree

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "treeLevels")
data class TreeLevel(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) val treeLevelId: Long = 0,
    val levelId: Int = 0,
    val name: String = "",
    val description: String? = null,
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)