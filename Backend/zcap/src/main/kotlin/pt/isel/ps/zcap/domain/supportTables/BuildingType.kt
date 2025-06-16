package pt.isel.ps.zcap.domain.supportTables

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "buildingTypes")
data class BuildingType(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val buildingTypeId: Long = 0,
    val name: String = "",

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,

    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now(),
)