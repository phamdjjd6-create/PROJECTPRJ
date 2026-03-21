package controller;

import DAO.BookingDAO;
import DAO.ContractDAO;
import DAO.FacilityDAO;
import DAO.PromotionDAO;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;
import jakarta.persistence.EntityManager;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();
    private final PromotionDAO promotionDAO = new PromotionDAO();
    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String view = request.getParameter("view");
        HttpSession session = request.getSession(false);

        if ("my".equals(view)) {
            if (session == null || session.getAttribute("account") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            TblPersons account = (TblPersons) session.getAttribute("account");
            List<TblBookings> myBookings = bookingDAO.findByCustomerId(account.getId());
            request.setAttribute("myBookings", myBookings);
            request.getRequestDispatcher("/WEB-INF/my_bookings.jsp").forward(request, response);
            return;
        }

        // Display booking.jsp with dynamic facilities
        List<TblFacilities> facilities = facilityDAO.findAll();
        request.setAttribute("facilities", facilities);
        request.getRequestDispatcher("/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        TblPersons account = (TblPersons) session.getAttribute("account");

        try {
            String facilityId = request.getParameter("facilityId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            int adults = Integer.parseInt(request.getParameter("adults"));
            int children = Integer.parseInt(request.getParameter("children"));
            String voucherCode = request.getParameter("voucherId");
            String specialReq = request.getParameter("specialReq");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(startDateStr);
            Date endDate = sdf.parse(endDateStr);

            long diff = endDate.getTime() - startDate.getTime();
            int nights = (int) TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
            if (nights <= 0) nights = 1;

            TblFacilities facility = facilityDAO.findByCode(facilityId);
            if (facility == null) {
                throw new Exception("Facility not found");
            }

            // Load Customer inside a small local EM if needed, or pass IDs
            EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
            TblCustomers customer;
            try {
                customer = em.find(TblCustomers.class, account.getId());
                if (customer == null) {
                    throw new Exception("Bạn cần là khách hàng hợp lệ (Customer) để đặt phòng.");
                }
            } finally {
                em.close();
            }

            // Calculate Base Cost
            BigDecimal baseCost = facility.getCost().multiply(new BigDecimal(nights));
            BigDecimal totalPayment = baseCost;

            // Apply Voucher
            TblPromotions appliedPromo = null;
            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                appliedPromo = promotionDAO.findByCode(voucherCode.trim());
                if (appliedPromo != null && appliedPromo.getMinNights() <= nights) {
                    if ("PERCENT".equals(appliedPromo.getDiscountType())) {
                        BigDecimal discount = baseCost.multiply(appliedPromo.getDiscountValue()).divide(new BigDecimal(100));
                        totalPayment = baseCost.subtract(discount);
                    } else if ("AMOUNT".equals(appliedPromo.getDiscountType())) {
                        totalPayment = baseCost.subtract(appliedPromo.getDiscountValue());
                    }
                }
            }

            if (totalPayment.compareTo(BigDecimal.ZERO) < 0) {
                totalPayment = BigDecimal.ZERO;
            }

            // Create Booking
            TblBookings booking = new TblBookings();
            booking.setBookingId(bookingDAO.generateBookingId());
            booking.setDateBooking(new Date());
            booking.setStartDate(startDate);
            booking.setEndDate(endDate);
            booking.setAdults(adults);
            booking.setChildren(children);
            booking.setSpecialReq(specialReq);
            booking.setStatus("PENDING");
            booking.setFacilityId(facility);
            booking.setCustomerId(customer);
            // Ignore voucherId in booking schema for now if it requires a specific TblVouchers entity, since promos != vouchers sometimes in this schema.
            // Wait, TblBookings has a voucherId field pointing to TblVouchers. TblPromotions is different! 
            // Vouchers are individual instances of a promotion. To simplify, we will just apply the discount to the contract total.
            
            bookingDAO.save(booking);

            // Create Contract
            TblContracts contract = new TblContracts();
            contract.setContractId("CT" + System.currentTimeMillis() % 1000000);
            contract.setBookingId(booking);
            contract.setDeposit(BigDecimal.ZERO);
            contract.setTotalPayment(totalPayment);
            contract.setPaidAmount(BigDecimal.ZERO);
            contract.setStatus("DRAFT");
            contract.setSignedDate(new Date());
            if (appliedPromo != null) {
                contract.setNotes("Áp dụng mã: " + appliedPromo.getPromoCode());
            }

            contractDAO.save(contract);

            // Redirect to Contracts view
            response.sendRedirect(request.getContextPath() + "/contracts");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("bookingError", "Lỗi đặt phòng: " + e.getMessage());
            // display booking form again
            doGet(request, response);
        }
    }
}
