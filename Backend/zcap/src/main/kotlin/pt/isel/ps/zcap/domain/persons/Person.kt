package pt.isel.ps.zcap.domain.persons

import jakarta.persistence.*
import pt.isel.ps.zcap.domain.tree.Tree
import pt.isel.ps.zcap.domain.tree.TreeRecordDetail
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "persons")
data class Person(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val personId: Long = 0,

    val name: String = "",
    val age: Int = 0,
    val contact: String = "",

    @ManyToOne
    @JoinColumn(name = "countryCodeId")
    val countryCode: TreeRecordDetail = TreeRecordDetail(),

    @ManyToOne
    @JoinColumn(name = "placeOfResidence")
    val placeOfResidence: Tree = Tree(),

    val entryDatetime: LocalDateTime = LocalDateTime.now(),
    val departureDatetime: LocalDateTime? = null,
    val birthDate: LocalDate? = LocalDate.now(),

    @ManyToOne
    @JoinColumn(name = "nationalityId")
    val nationality: TreeRecordDetail? = null,

    val address: String? = null,
    val niss: Int? = null,

    @ManyToOne
    @JoinColumn(name = "departureDestinationId")
    val departureDestination: DepartureDestination? = null,

    val destinationContact: Int? = null,

    @OneToMany(mappedBy = "person")
    val specialNeeds: List<PersonSpecialNeed> = emptyList(),
    @OneToMany(mappedBy = "person")
    val supportNeeded: List<PersonSupportNeeded> = emptyList(),

    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)