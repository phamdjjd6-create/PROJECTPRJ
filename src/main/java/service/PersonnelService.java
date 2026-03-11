package service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;
import model.TblEmployees;
import model.TblCustomers;
import util.JPAUtil;

/**
 * Service for managing Employees and Customers.
 */
public class PersonnelService {

    public List<TblEmployees> findAllEmployees() {
        try (EntityManager em = JPAUtil.getEntityManager()) {
            return em.createQuery("SELECT e FROM TblEmployees e WHERE e.isDeleted = false", TblEmployees.class).getResultList();
        }
    }

    public List<TblCustomers> findAllCustomers() {
        try (EntityManager em = JPAUtil.getEntityManager()) {
            return em.createQuery("SELECT c FROM TblCustomers c WHERE c.isDeleted = false", TblCustomers.class).getResultList();
        }
    }

    public TblEmployees findEmployeeById(String id) {
        try (EntityManager em = JPAUtil.getEntityManager()) {
            return em.find(TblEmployees.class, id);
        }
    }
    
    public TblCustomers findCustomerById(String id) {
        try (EntityManager em = JPAUtil.getEntityManager()) {
            return em.find(TblCustomers.class, id);
        }
    }
}
