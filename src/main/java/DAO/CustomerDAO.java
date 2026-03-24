package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblCustomers;
import model.VwCustomers;

public class CustomerDAO {
    private EntityManager em;

    public CustomerDAO() {}

    public CustomerDAO(EntityManager em) {
        this.em = em;
    }

    private EntityManager getEntityManager() {
        if (em != null) return em;
        return util.JpaUtil.getEntityManagerFactory().createEntityManager();
    }

    private void closeEntityManager(EntityManager emLocal) {
        if (em == null && emLocal != null) emLocal.close();
    }

    public List<VwCustomers> findAll() {
        EntityManager emLocal = getEntityManager();
        try {
            return emLocal.createQuery("SELECT c FROM VwCustomers c", VwCustomers.class)
                    .getResultList();
        } finally {
            closeEntityManager(emLocal);
        }
    }

    public List<TblCustomers> findAllEntities() {
        EntityManager emLocal = getEntityManager();
        try {
            return emLocal.createQuery("SELECT c FROM TblCustomers c WHERE c.tblPersons.deleted = false", TblCustomers.class)
                    .getResultList();
        } finally {
            closeEntityManager(emLocal);
        }
    }

    public TblCustomers findById(String id) {
        EntityManager emLocal = getEntityManager();
        try {
            return emLocal.find(TblCustomers.class, id);
        } finally {
            closeEntityManager(emLocal);
        }
    }

    public void save(TblCustomers customer) {
        EntityManager emLocal = getEntityManager();
        boolean externalTransaction = (em != null);
        try {
            if (!externalTransaction) emLocal.getTransaction().begin();
            
            if (emLocal.find(TblCustomers.class, customer.getId()) == null) {
                emLocal.persist(customer);
            } else {
                emLocal.merge(customer);
            }
            
            if (!externalTransaction) emLocal.getTransaction().commit();
        } catch (Exception e) {
            if (!externalTransaction && emLocal.getTransaction().isActive()) emLocal.getTransaction().rollback();
            throw e;
        } finally {
            closeEntityManager(emLocal);
        }
    }

    public long count() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(c) FROM TblCustomers c WHERE c.tblPersons.deleted = false")
                    .getSingleResult();
        } finally { em.close(); }
    }

    public boolean toggleLock(String id, boolean lock) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            model.TblPersons p = em.find(model.TblPersons.class, id);
            if (p == null) return false;
            p.setDeleted(lock);
            em.merge(p);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }
    
    
    // ── Cập nhật thông tin khách hàng (ADMIN only) ────────────────
    public boolean updateCustomer(String id, String typeCustomer, String address,
                                  String fullName, String email, String phoneNumber,
                                  java.math.BigDecimal totalSpent) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            // Cập nhật tbl_persons
            model.TblPersons p = em.find(model.TblPersons.class, id);
            if (p == null) return false;
            if (fullName    != null && !fullName.isBlank())    p.setFullName(fullName.trim());
            if (email       != null && !email.isBlank())       p.setEmail(email.trim());
            if (phoneNumber != null)                           p.setPhoneNumber(phoneNumber.trim());
            p.setUpdatedAt(new java.util.Date());
            em.merge(p);
            // Cập nhật tbl_customers
            TblCustomers c = em.find(TblCustomers.class, id);
            if (c != null) {
                if (typeCustomer != null && !typeCustomer.isBlank()) c.setTypeCustomer(typeCustomer);
                if (address      != null)                            c.setAddress(address.trim());
                if (totalSpent   != null)                            c.setTotalSpent(totalSpent);
                em.merge(c);
            }
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }
}
