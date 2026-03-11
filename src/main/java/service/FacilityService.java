package service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.Date;
import java.util.List;
import model.TblFacilities;
import util.JPAUtil;

/**
 * Service for managing Facilities (Villa, House, Room).
 */
public class FacilityService extends BaseService<TblFacilities> {

    public FacilityService() {
        super(TblFacilities.class);
    }

    /**
     * Search for available facilities in a date range.
     */
    public List<TblFacilities> findAvailable(Date start, Date end, String type) {
        try (EntityManager em = JPAUtil.getEntityManager()) {
            String jpql = "SELECT f FROM TblFacilities f WHERE f.isDeleted = false " +
                          "AND f.status = 'AVAILABLE' ";
            
            if (type != null && !type.isEmpty()) {
                jpql += "AND f.facilityType = :type ";
            }
            
            // Logic to exclude already booked facilities in this range
            jpql += "AND NOT EXISTS (SELECT b FROM TblBookings b WHERE b.facilityId = f " +
                    "AND b.status NOT IN ('CANCELLED') " +
                    "AND ((b.startDate BETWEEN :start AND :end) OR (b.endDate BETWEEN :start AND :end)))";

            TypedQuery<TblFacilities> query = em.createQuery(jpql, TblFacilities.class);
            query.setParameter("start", start);
            query.setParameter("end", end);
            if (type != null && !type.isEmpty()) {
                query.setParameter("type", type);
            }
            
            return query.getResultList();
        }
    }

    public void updateStatus(String id, String status) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            TblFacilities f = em.find(TblFacilities.class, id);
            if (f != null) {
                f.setStatus(status);
                f.setUpdatedAt(new Date());
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
