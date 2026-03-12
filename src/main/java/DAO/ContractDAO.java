package DAO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;
import model.TblContracts;

public class ContractDAO {

    private static final EntityManagerFactory emf = 
            Persistence.createEntityManagerFactory("ResortPU");

    public List<TblContracts> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT c FROM TblContracts c", TblContracts.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public TblContracts findById(String id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(TblContracts.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblContracts contract) {
        EntityManager em = emf.createEntityManager();
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
}
