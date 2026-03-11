package service;

import jakarta.persistence.EntityManager;
import java.util.Date;
import model.TblPayments;
import model.TblContracts;
import model.TblCustomers;
import util.JPAUtil;
import java.math.BigDecimal;

/**
 * Service for handling payments and loyalty points.
 */
public class PaymentService extends BaseService<TblPayments> {

    public PaymentService() {
        super(TblPayments.class);
    }

    /**
     * Process a payment, update contract, and award loyalty points to customer.
     */
    public TblPayments processPayment(TblPayments payment) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            
            payment.setPaymentDate(new Date());
            em.persist(payment);
            
            // 1. Update Contract
            TblContracts contract = em.find(TblContracts.class, payment.getContractId().getId());
            if (contract != null) {
                BigDecimal newPaid = contract.getPaidAmount().add(payment.getAmount());
                contract.setPaidAmount(newPaid);
                
                if (newPaid.compareTo(contract.getTotalPayment()) >= 0) {
                   contract.setStatus("PAID");
                } else {
                   contract.setStatus("PARTIALLY_PAID");
                }
                
                // 2. Award Loyalty Points (1000 VND = 1 Point)
                TblCustomers customer = contract.getBookingId().getCustomerId();
                TblCustomers persistentCustomer = em.find(TblCustomers.class, customer.getId());
                if (persistentCustomer != null) {
                    int points = payment.getAmount().divide(new BigDecimal(1000)).intValue();
                    persistentCustomer.setLoyaltyPoints(persistentCustomer.getLoyaltyPoints() + points);
                    persistentCustomer.setTotalSpent(persistentCustomer.getTotalSpent().add(payment.getAmount()));
                }
            }
            
            em.getTransaction().commit();
            return payment;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
