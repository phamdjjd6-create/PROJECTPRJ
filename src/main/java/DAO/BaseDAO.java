package DAO;

import jakarta.persistence.EntityManager;
import util.JpaUtil;

/**
 * BaseDAO provides a shared EntityManager for transaction management.
 * It allows multiple DAOs to participate in the same transaction.
 */
public abstract class BaseDAO {
    protected EntityManager em;

    public BaseDAO() {
    }

    public BaseDAO(EntityManager em) {
        this.em = em;
    }

    /**
     * Gets the current EntityManager. 
     * If one was provided in the constructor (shared), it returns that.
     * Otherwise, it creates a new temporary one.
     */
    protected EntityManager getEntityManager() {
        if (this.em != null) {
            return this.em;
        }
        return JpaUtil.getEntityManagerFactory().createEntityManager();
    }

    /**
     * Closes the EntityManager ONLY if it was created locally (not shared).
     */
    protected void closeIfLocal(EntityManager entityManager) {
        if (this.em == null && entityManager != null && entityManager.isOpen()) {
            entityManager.close();
        }
    }
}
