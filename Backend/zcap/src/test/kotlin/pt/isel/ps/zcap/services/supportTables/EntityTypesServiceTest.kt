package pt.isel.ps.zcap.services.supportTables

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import pt.isel.ps.zcap.domain.supportTables.EntityType
import pt.isel.ps.zcap.repository.models.supportTables.EntityTypeRepository
import java.time.LocalDate
import kotlin.test.assertContains
import kotlin.test.assertContentEquals

@SpringBootTest
@ActiveProfiles("test")
class EntityTypesServiceTest(
    @Autowired private val entityTypeRepository: EntityTypeRepository,
    @Autowired private val entityTypesService: EntityTypesService,
) {

    val entityType1 = EntityType(
        name = "Entity type 1",
        startDate = LocalDate.parse("2020-01-01"),
        endDate = null,
    )
    val entityType2 = EntityType(
        name = "Entity type 2",
        startDate = LocalDate.parse("2021-01-01"),
        endDate = LocalDate.parse("2021-12-31"),
    )
    var entityType3 = EntityType(
        name = "Entity type 3",
        startDate = LocalDate.parse("2010-01-01"),
        endDate = LocalDate.parse("2025-01-01"),
    )

    @BeforeEach
    fun setup() {
        entityTypeRepository.deleteAll()
        entityTypeRepository.saveAll(listOf(entityType1, entityType2, entityType3))
    }

    @Test
    fun `just an empty test`() {
        //Arrange
        entityTypeRepository.deleteAll()

        //Act
        val listEntities = entityTypesService.getAllEntityTypes()

        //Assert
        assertTrue(listEntities.isEmpty())
    }

    @Test
    fun `should return all existing records as output models`() {
        //given


        //When
        val listEntities = entityTypesService.getAllEntityTypes()

        //Then
        assertEquals(3, listEntities.size)

    }

//    getEntityTypesValidOn
//    getEntityTypeById
//    addEntityType
//    updateEntityType
}