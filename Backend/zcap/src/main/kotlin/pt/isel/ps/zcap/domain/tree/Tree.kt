package pt.isel.ps.zcap.domain.tree

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "tree")
data class Tree(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val treeRecordId: Long = 0,

    val name: String = "",

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "treeLevelId")
    val treeLevel: TreeLevel = TreeLevel(),

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parentId")
    val parent: Tree? = null,

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)