package pt.isel.ps.zcap.domain.persons

import jakarta.persistence.*

@Entity
@Table(name = "relation")
data class Relation(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val relationId: Long = 0,

    @ManyToOne
    @JoinColumn(name = "personId1")
    val person1: Person = Person(),

    @ManyToOne
    @JoinColumn(name = "personId2")
    val person2: Person = Person(),

    @ManyToOne
    @JoinColumn(name = "relationTypeId")
    val relationType: RelationType = RelationType()
)