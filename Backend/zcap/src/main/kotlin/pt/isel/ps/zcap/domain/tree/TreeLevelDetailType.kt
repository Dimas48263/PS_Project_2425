package pt.isel.ps.zcap.domain.tree

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "treeLevelDetailType")
data class TreeLevelDetailType (
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val treeLevelDetailTypeId: Long = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "treeLevelId")
    val treeLevel: TreeLevel = TreeLevel(),

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "detailTypeId")
    val detailType: TreeRecordDetailType = TreeRecordDetailType(),

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)