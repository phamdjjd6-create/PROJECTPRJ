package service;

import DAO.BookingDAO;
import DAO.CustomerDAO;
import DAO.PromotionDAO;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Stack;
import java.util.stream.Collectors;
import model.TblBookings;
import model.TblCustomers;
import model.TblPromotions;
import model.VwCustomers;

public class PromotionService implements IService<TblPromotions, Integer> {
    private final PromotionDAO promotionDAO;
    private final BookingDAO bookingDAO;
    private final CustomerDAO customerDAO;

    public PromotionService() {
        this.promotionDAO = new PromotionDAO();
        this.bookingDAO = new BookingDAO();
        this.customerDAO = new CustomerDAO();
    }

    @Override
    public List<TblPromotions> findAll() {
        return promotionDAO.findAll();
    }

    @Override
    public TblPromotions findById(Integer id) {
        return promotionDAO.findById(id);
    }

    @Override
    public void save(TblPromotions promotion) {
        promotionDAO.save(promotion);
    }

    @Override
    public void delete(Integer id) {
        promotionDAO.delete(id);
    }

    // --- Specific Promotion Logic ---

    /**
     * Get a list of customers who made bookings in a specific year.
     */
    public List<VwCustomers> getCustomersByYear(int year) {
        List<TblBookings> yearBookings = bookingDAO.findByYear(year);
        Set<String> customerIds = yearBookings.stream()
                .map(b -> b.getCustomerId().getId())
                .collect(Collectors.toSet());

        return customerDAO.findAll().stream()
                .filter(c -> customerIds.contains(c.getId()))
                .toList();
    }

    /**
     * Get a stack of customers entitled to vouchers for the current month.
     * Logic: Most recent bookers in the current month first.
     */
    public Stack<TblCustomers> getVoucherStack() {
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear();

        List<TblBookings> monthBookings = bookingDAO.findByMonth(year, month).stream()
                .sorted((b1, b2) -> b1.getDateBooking().compareTo(b2.getDateBooking()))
                .toList();

        Stack<TblCustomers> customerStack = new Stack<>();
        Set<String> addedIds = new HashSet<>();

        // Add from newest to oldest booking (reversed)
        for (int i = monthBookings.size() - 1; i >= 0; i--) {
            TblBookings b = monthBookings.get(i);
            if (addedIds.add(b.getCustomerId().getId())) {
                customerStack.push(b.getCustomerId());
            }
        }
        return customerStack;
    }

    /**
     * Count unique customers who booked in a given month/year.
     */
    public int getCountOfUniqueCustomersInMonth(int year, int month) {
        return (int) bookingDAO.findByMonth(year, month).stream()
                .map(b -> b.getCustomerId().getId())
                .distinct()
                .count();
    }

    public List<TblPromotions> getAllActivePromotions() {
        return promotionDAO.findAll();
    }
}
