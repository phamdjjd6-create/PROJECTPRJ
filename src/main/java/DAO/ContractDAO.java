package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblContracts;

public class ContractDAO {
    public List<TblContracts> findAll() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT c FROM TblContracts c", TblContracts.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<model.VwContracts> findByCustomerId(String customerId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery(
                "SELECT v FROM VwContracts v WHERE v.customerId = :cid ORDER BY v.signedDate DESC",
                model.VwContracts.class)
                .setParameter("cid", customerId)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public TblContracts findById(String id) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(TblContracts.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblContracts contract) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            if (em.find(TblContracts.class, contract.getContractId()) == null) {
                em.persist(contract);
            } else {
                em.merge(contract);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public List<model.VwContracts> findAll_View() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT v FROM VwContracts v ORDER BY v.signedDate DESC", model.VwContracts.class)
                    .getResultList();
        } finally { em.close(); }
    }

    public List<model.VwContracts> findByStatus(String status) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT v FROM VwContracts v WHERE v.status = :s ORDER BY v.signedDate DESC", model.VwContracts.class)
                    .setParameter("s", status).getResultList();
        } finally { em.close(); }
    }

    public long countByStatus(String status) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(c) FROM TblContracts c WHERE c.status = :s")
                    .setParameter("s", status).getSingleResult();
        } finally { em.close(); }
    }

    /** Duyệt hợp đồng: DRAFT → ACTIVE (nếu có cọc) hoặc giữ DRAFT (chưa cọc) */
    public String approve(String contractId, String employeeId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) return "Không tìm thấy hợp đồng";
            java.math.BigDecimal zero = java.math.BigDecimal.ZERO;
            boolean hasDeposit = c.getDeposit() != null && c.getDeposit().compareTo(zero) > 0;
            if (hasDeposit) {
                c.setStatus("ACTIVE");
                c.setSignedDate(new java.util.Date());
                if (employeeId != null) {
                    model.TblEmployees emp = em.find(model.TblEmployees.class, employeeId);
                    if (emp != null) c.setEmployeeId(emp);
                }
                em.merge(c);
                em.getTransaction().commit();
                return "APPROVED";
            } else {
                em.getTransaction().rollback();
                return "PENDING_DEPOSIT";
            }
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return "ERROR: " + e.getMessage();
        } finally { em.close(); }
    }

    public boolean updateStatus(String contractId, String newStatus) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) return false;
            c.setStatus(newStatus);
            em.merge(c);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }
}
