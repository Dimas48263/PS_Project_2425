package pt.isel.ps.zcap.domain.supportTables

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "zcapDetails")
data class ZcapDetail(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val zcapDetailId: Long = 0,

    @ManyToOne
    @JoinColumn(name = "zcapId")
    val zcap: Zcap = Zcap(),

    @ManyToOne
    @JoinColumn(name = "zcapDetailTypeId")
    val zcapDetailType: ZcapDetailType = ZcapDetailType(),

    val valueCol: String = "",
    val startDate: LocalDate = LocalDate.now(),
    val endDate: LocalDate? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val lastUpdatedAt: LocalDateTime = LocalDateTime.now()
)