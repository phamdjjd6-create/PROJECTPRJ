package DAO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;
import model.TblCustomers;
import model.VwCustomers;

public class CustomerDAO {

    private static final EntityManagerFactory emf = 
            Persistence.createEntityManagerFactory("ResortPU");

    public List<VwCustomers> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            // Using the View to get combined Person and Customer data easily
            return em.createQuery("SELECT c FROM VwCustomers c", VwCustomers.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<TblCustomers> findAllEntities() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT c FROM TblCustomers c WHERE c.tblPersons.isDeleted = false", TblCustomers.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public TblCustomers findById(String id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(TblCustomers.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblCustomers customer) {
        EntityManager em = emf.createEntityManager();
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
