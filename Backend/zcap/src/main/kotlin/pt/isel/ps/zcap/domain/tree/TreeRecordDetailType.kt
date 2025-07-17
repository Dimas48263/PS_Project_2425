package pt.isel.ps.zcap.domain.tree

import jakarta.persistence.*
import pt.isel.ps.zcap.domain.supportTables.DataTypes
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "treeRecordDetailTypes")
data class TreeRecordDetailType(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val detailTypeId: Long = 0,

    val name: String = "",

    @Enumerated(EnumType.STRING)
    val unit: DataTypes = DataTypes.STRING,
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)