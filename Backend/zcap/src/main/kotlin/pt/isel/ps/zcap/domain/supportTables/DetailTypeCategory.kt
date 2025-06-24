package pt.isel.ps.zcap.domain.supportTables

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "detailTypeCategories")
data class DetailTypeCategory(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val detailTypeCategoryId: Long = 0,

    val name: String = "",
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)