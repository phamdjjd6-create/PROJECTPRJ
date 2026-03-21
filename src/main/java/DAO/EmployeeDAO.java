package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblEmployees;
import model.VwEmployees;

public class EmployeeDAO {

    public List<VwEmployees> findAll() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT e FROM VwEmployees e", VwEmployees.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<TblEmployees> findAllEntities() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT e FROM TblEmployees e WHERE e.deleted = false", TblEmployees.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public TblEmployees findById(String id) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(TblEmployees.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblEmployees employee) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            if (em.find(TblEmployees.class, employee.getId()) == null) {
                em.persist(employee);
            } else {
                em.merge(employee);
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
