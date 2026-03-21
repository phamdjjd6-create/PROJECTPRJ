package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblFacilities;

public class FacilityDAO {


    public List<TblFacilities> findAll() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT f FROM TblFacilities f WHERE f.deleted = false", TblFacilities.class)
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
                facility.setDeleted(true);
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

    public long countByStatus(String status) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(f) FROM TblFacilities f WHERE f.status = :s AND f.deleted = false")
                    .setParameter("s", status).getSingleResult();
        } finally { em.close(); }
    }

    public boolean updateStatus(String code, String newStatus) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblFacilities f = em.find(TblFacilities.class, code);
            if (f == null) return false;
            f.setStatus(newStatus);
            em.merge(f);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }
}
