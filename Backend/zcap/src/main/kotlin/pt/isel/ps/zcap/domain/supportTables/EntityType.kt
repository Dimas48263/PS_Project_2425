package pt.isel.ps.zcap.domain.supportTables

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "entityTypes")
data class EntityType(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val entityTypeId: Long = 0,
    val name: String = "",

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,

    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now(),
)