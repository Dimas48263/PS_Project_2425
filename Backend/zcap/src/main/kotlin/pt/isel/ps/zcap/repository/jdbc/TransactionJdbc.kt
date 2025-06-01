package pt.isel.ps.zcap.repository.jdbc
//
//import jakarta.persistence.EntityManager
//import pt.isel.ps.zcap.repository.models.*
//
//class TransactionJdbc(
//    private val entityManager: EntityManager
//) : Transaction {
//
//    override val treeRepo: TreeRepository = TreeRepositoryJdbc(entityManager)
//    override val incidentRepo: IncidentRepository = IncidentRepositoryJdbc(entityManager)
//    override val personRepo: PersonRepository = PersonRepositoryJdbc(entityManager)
//
//    override val zcapRepo: ZcapRepository = ZcapRepositoryJdbc(entityManager)
//    override fun rollback() {
//        val transaction = entityManager.transaction
//        if (transaction.isActive) {
//            transaction.rollback()
//        }
//    }
//}
