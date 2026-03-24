package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblAuditLog;

public class AuditLogDAO extends BaseDAO {

    public AuditLogDAO() { super(); }
    public AuditLogDAO(EntityManager em) { super(em); }

    public List<TblAuditLog> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT a FROM TblAuditLog a ORDER BY a.changedAt DESC", TblAuditLog.class)
                    .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public List<TblAuditLog> findRecent(int limit) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT a FROM TblAuditLog a ORDER BY a.changedAt DESC", TblAuditLog.class)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public void create(TblAuditLog log) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(log);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            closeIfLocal(em);
        }
    }
}
