package pt.isel.ps.zcap.repository.jdbc

//import jakarta.inject.Named
//import jakarta.persistence.EntityManagerFactory
//import pt.isel.ps.zcap.repository.models.Transaction
//import pt.isel.ps.zcap.repository.models.TransactionManager
//
//@Named
//class TransactionManagerJdbc(
//    private val entityManagerFactory: EntityManagerFactory
//) : TransactionManager {
//
//    override fun <R> run(block: (Transaction) -> R): R {
//        val entityManager = entityManagerFactory.createEntityManager()
//        val transaction = entityManager.transaction
//
//        return try {
//            transaction.begin() // Inicia a transação
//            val result = block(TransactionJdbc(entityManager))
//            transaction.commit() // Confirma a transação
//            result
//        } catch (ex: Exception) {
//            if (transaction.isActive) {
//                transaction.rollback() // Reverte a transação em caso de erro
//            }
//            throw ex
//        } finally {
//            entityManager.close() // Fecha o EntityManager para liberar recursos
//        }
//    }
//}