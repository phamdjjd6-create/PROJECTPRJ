package DAO;

import jakarta.persistence.EntityManager;
import java.util.Date;
import java.util.List;
import model.TblFacilities;

public class FacilityDAO extends BaseDAO {

    public FacilityDAO() {
        super();
    }

    public FacilityDAO(EntityManager em) {
        super(em);
    }

    public List<TblFacilities> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT f FROM TblFacilities f WHERE f.deleted = false", TblFacilities.class)
                    .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    /**
     * Returns facilities that have no overlapping CONFIRMED/PENDING/CHECKED_IN bookings
     * in the given date range. Excludes CANCELLED bookings.
     */
    public List<TblFacilities> findAvailableBetween(Date checkin, Date checkout) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                "SELECT f FROM TblFacilities f WHERE f.deleted = false AND f.status != 'MAINTENANCE' " +
                "AND f.serviceCode NOT IN (" +
                "  SELECT b.facilityId.serviceCode FROM TblBookings b " +
                "  WHERE b.status NOT IN ('CANCELLED') " +
                "  AND b.startDate < :checkout AND b.endDate > :checkin" +
                ")", TblFacilities.class)
                .setParameter("checkin", checkin)
                .setParameter("checkout", checkout)
                .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public TblFacilities findByCode(String code) {
        EntityManager em = getEntityManager();
        try {
            return em.find(TblFacilities.class, code);
        } finally {
            closeIfLocal(em);
        }
    }

    public void save(TblFacilities facility) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            if (em.find(TblFacilities.class, facility.getServiceCode()) == null) {
                em.persist(facility);
            } else {
                em.merge(facility);
            }
            if (isLocal) em.getTransaction().commit();
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            closeIfLocal(em);
        }
    }

    public void increaseUsage(String code) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblFacilities facility = em.find(TblFacilities.class, code);
            if (facility != null) {
                facility.setUsageCount(facility.getUsageCount() + 1);
                em.merge(facility);
            }
            if (isLocal) em.getTransaction().commit();
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            closeIfLocal(em);
        }
    }

    public void resetUsage(String code) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblFacilities facility = em.find(TblFacilities.class, code);
            if (facility != null) {
                facility.setUsageCount(0);
                facility.setStatus("AVAILABLE");
                em.merge(facility);
            }
            if (isLocal) em.getTransaction().commit();
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            closeIfLocal(em);
        }
    }

    public void delete(String code) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblFacilities facility = em.find(TblFacilities.class, code);
            if (facility != null) {
                facility.setDeleted(true);
                em.merge(facility);
            }
            if (isLocal) em.getTransaction().commit();
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            closeIfLocal(em);
        }
    }

    public long countByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(f) FROM TblFacilities f WHERE f.status = :s AND f.deleted = false")
                    .setParameter("s", status).getSingleResult();
        } finally {
            closeIfLocal(em);
        }
    }

    public boolean updateStatus(String code, String newStatus) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblFacilities f = em.find(TblFacilities.class, code);
            if (f == null) return false;
            f.setStatus(newStatus);
            em.merge(f);
            if (isLocal) em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally {
            closeIfLocal(em);
        }
    }
}
