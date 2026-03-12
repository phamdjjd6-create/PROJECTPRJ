package DAO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;
import model.TblBookings;

public class BookingDAO {

    private static final EntityManagerFactory emf = 
            Persistence.createEntityManagerFactory("ResortPU");

    public List<TblBookings> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT b FROM TblBookings b ORDER BY b.dateBooking DESC", TblBookings.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public TblBookings findById(String id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(TblBookings.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblBookings booking) {
        EntityManager em = emf.createEntityManager();
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
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT b FROM TblBookings b WHERE b.customerId.id = :customerId", TblBookings.class)
                    .setParameter("customerId", customerId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
