package pt.isel.ps.zcap.domain.supportTables

import jakarta.persistence.*
import pt.isel.ps.zcap.domain.supportTables.BuildingType
import pt.isel.ps.zcap.domain.supportTables.Entities
import pt.isel.ps.zcap.domain.tree.Tree
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "zcaps")
data class Zcap (
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val zcapId: Long = 0,

    val name: String = "",

    @ManyToOne
    @JoinColumn(name = "buildingTypeId")
    val buildingType: BuildingType = BuildingType(),

    val address: String = "",

    @ManyToOne
    @JoinColumn(name = "treeRecordId")
    val tree: Tree? = null,

    val latitude: Float? = null,
    val longitude: Float? = null,

    @ManyToOne
    @JoinColumn(name = "entityId")
    val entity: Entities = Entities(),

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)