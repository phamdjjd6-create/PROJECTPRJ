package DAO;

import jakarta.persistence.EntityManager;
import java.util.Date;
import java.util.List;
import java.util.Calendar;
import model.TblBookings;

public class BookingDAO {

    public List<TblBookings> findAll() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT b FROM TblBookings b ORDER BY b.dateBooking DESC", TblBookings.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public TblBookings findById(String id) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(TblBookings.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblBookings booking) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            if (em.find(TblBookings.class, booking.getBookingId()) == null) {
                em.persist(booking);
            } else {
                em.merge(booking);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public List<TblBookings> findByCustomerId(String customerId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT b FROM TblBookings b WHERE b.customerId.id = :customerId", TblBookings.class)
                    .setParameter("customerId", customerId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public String generateBookingId() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            List<String> ids = em.createQuery("SELECT b.bookingId FROM TblBookings b WHERE b.bookingId LIKE 'BK%'", String.class)
                    .getResultList();
            int max = 0;
            for (String id : ids) {
                try {
                    int n = Integer.parseInt(id.substring(2));
                    if (n > max) max = n;
                } catch (NumberFormatException ignored) {}
            }
            return String.format("BK%03d", max + 1);
        } catch (Exception e) {
            return "BK001";
        } finally {
            em.close();
        }
    }

    public List<TblBookings> findByYear(int year) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            Calendar cal = Calendar.getInstance();
            cal.set(year, 0, 1, 0, 0, 0);
            Date start = cal.getTime();
            cal.set(year, 11, 31, 23, 59, 59);
            Date end = cal.getTime();
            
            return em.createQuery("SELECT b FROM TblBookings b WHERE b.startDate BETWEEN :start AND :end", TblBookings.class)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<TblBookings> findByMonth(int year, int month) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            Calendar cal = Calendar.getInstance();
            cal.set(year, month - 1, 1, 0, 0, 0);
            Date start = cal.getTime();
            cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            Date end = cal.getTime();

            return em.createQuery("SELECT b FROM TblBookings b WHERE b.startDate BETWEEN :start AND :end", TblBookings.class)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
