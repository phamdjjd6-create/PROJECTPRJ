package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblFacilities;

public class FacilityDAO {


    public List<TblFacilities> findAll() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT f FROM TblFacilities f WHERE f.isDeleted = false", TblFacilities.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public TblFacilities findByCode(String code) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(TblFacilities.class, code);
        } finally {
            em.close();
        }
    }

    public void save(TblFacilities facility) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            if (em.find(TblFacilities.class, facility.getServiceCode()) == null) {
                em.persist(facility);
            } else {
                em.merge(facility);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void increaseUsage(String code) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblFacilities facility = em.find(TblFacilities.class, code);
            if (facility != null) {
                facility.setUsageCount(facility.getUsageCount() + 1);
                if (facility.getUsageCount() >= 5) {
                    facility.setStatus("MAINTENANCE");
                }
                em.merge(facility);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void resetUsage(String code) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblFacilities facility = em.find(TblFacilities.class, code);
            if (facility != null) {
                facility.setUsageCount(0);
                facility.setStatus("AVAILABLE");
                em.merge(facility);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(String code) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblFacilities facility = em.find(TblFacilities.class, code);
            if (facility != null) {
                facility.setDeleted(true); // Soft delete
                em.merge(facility);
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
