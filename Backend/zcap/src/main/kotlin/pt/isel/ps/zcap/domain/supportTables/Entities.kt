package pt.isel.ps.zcap.domain.supportTables

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "entities")
data class Entities(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val entityId: Long = 0,
    val name: String = "",

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "entityTypeId")
    val entityType: EntityType = EntityType(),

    val email: String? = null,
    val phone1: String = "",
    val phone2: String? = null,

    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,

    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now(),
)