package service;

import jakarta.persistence.EntityManager;
import java.util.Date;
import java.util.UUID;
import model.TblBookings;
import model.TblContracts;
import model.TblFacilities;
import util.JPAUtil;
import java.math.BigDecimal;

/**
 * Service for managing the Booking lifecycle.
 */
public class BookingService extends BaseService<TblBookings> {

    public BookingService() {
        super(TblBookings.class);
    }

    /**
     * Create a new booking and automatically generate a draft contract.
     */
    public TblBookings makeReservation(TblBookings booking) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            
            // 1. Set metadata
            if (booking.getId() == null) {
                booking.setId("BK" + System.currentTimeMillis() % 1000000);
            }
            booking.setDateBooking(new Date());
            booking.setStatus("PENDING");
            
            // 2. Persist Booking
            em.persist(booking);
            
            // 3. Create Draft Contract
            TblContracts contract = new TblContracts();
            contract.setId("CT" + booking.getId().substring(2));
            contract.setBookingId(booking);
            contract.setStatus("DRAFT");
            contract.setDeposit(BigDecimal.ZERO);
            
            // Calculate total (simple logic: cost * nights)
            long nights = (booking.getEndDate().getTime() - booking.getStartDate().getTime()) / (1000 * 60 * 60 * 24);
            if (nights <= 0) nights = 1;
            
            BigDecimal baseCost = booking.getFacilityId().getCost();
            BigDecimal total = baseCost.multiply(new BigDecimal(nights));
            contract.setTotalPayment(total);
            contract.setPaidAmount(BigDecimal.ZERO);
            
            em.persist(contract);
            
            em.getTransaction().commit();
            return booking;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void checkIn(String bookingId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            TblBookings b = em.find(TblBookings.class, bookingId);
            if (b != null) {
                b.setStatus("CHECKED_IN");
                // Update facility status to OCCUPIED
                TblFacilities f = b.getFacilityId();
                f.setStatus("OCCUPIED");
                f.setUpdatedAt(new Date());
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
