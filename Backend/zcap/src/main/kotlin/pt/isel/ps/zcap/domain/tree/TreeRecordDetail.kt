package pt.isel.ps.zcap.domain.tree

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "treeRecordDetails")
data class TreeRecordDetail(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val detailId: Long = 0,

    @ManyToOne
    @JoinColumn(name = "treeRecordId")
    val treeRecord: Tree = Tree(),

    @ManyToOne
    @JoinColumn(name = "detailTypeId")
    val detailType: TreeRecordDetailType = TreeRecordDetailType(),
    val valueCol: String = "",
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)