package pt.isel.ps.zcap.repository.models.persons

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import pt.isel.ps.zcap.domain.persons.Person

@Repository
interface PersonRepository: JpaRepository<Person, Long> {
    fun findByName(name: String): List<Person>
}