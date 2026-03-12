package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblCustomers;
import model.VwCustomers;

public class CustomerDAO {
    public List<VwCustomers> findAll() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // Using the View to get combined Person and Customer data easily
            return em.createQuery("SELECT c FROM VwCustomers c", VwCustomers.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<TblCustomers> findAllEntities() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT c FROM TblCustomers c WHERE c.tblPersons.isDeleted = false", TblCustomers.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public TblCustomers findById(String id) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(TblCustomers.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblCustomers customer) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            if (em.find(TblCustomers.class, customer.getId()) == null) {
                em.persist(customer);
            } else {
                em.merge(customer);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
