package pt.isel.ps.zcap.domain.supportTables

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "zcapDetailTypes")
data class ZcapDetailType(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val zcapDetailTypeId: Long = 0,

    val name: String = "",

    @ManyToOne
    @JoinColumn(name = "detailTypeCategoryId")
    val detailTypeCategory: DetailTypeCategory = DetailTypeCategory(),

    @Enumerated(EnumType.STRING)
    val dataType: DataTypes = DataTypes.STRING,
    val isMandatory: Boolean = false,
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)