package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblEmployees;
import model.VwEmployees;

public class EmployeeDAO {
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

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
    public boolean updateSalary(String id, java.math.BigDecimal salary) {
    EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
    try {
        em.getTransaction().begin();
        TblEmployees emp = em.find(TblEmployees.class, id);
        if (emp == null) return false;
        emp.setSalary(salary);
        em.merge(emp);
        em.getTransaction().commit();
        return true;
    } catch (Exception e) {
        if (em.getTransaction().isActive()) em.getTransaction().rollback();
        return false;
    } finally { em.close(); }
}

// Cập nhật chức vụ nhân viên
public boolean updatePosition(String id, String position) {
    EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
    try {
        em.getTransaction().begin();
        TblEmployees emp = em.find(TblEmployees.class, id);
        if (emp == null) return false;
        emp.setPosition(position);
        em.merge(emp);
        em.getTransaction().commit();
        return true;
    } catch (Exception e) {
        if (em.getTransaction().isActive()) em.getTransaction().rollback();
        return false;
    } finally { em.close(); }
}

// Cập nhật quyền nhân viên (STAFF ↔ ADMIN)
public boolean updateRole(String id, String role) {
    EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
    try {
        em.getTransaction().begin();
        TblEmployees emp = em.find(TblEmployees.class, id);
        if (emp == null) return false;
        emp.setRole(role);
        em.merge(emp);
        em.getTransaction().commit();
        return true;
    } catch (Exception e) {
        if (em.getTransaction().isActive()) em.getTransaction().rollback();
        return false;
    } finally { em.close(); }
}
}
