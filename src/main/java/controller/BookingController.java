package controller;

import model.*;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    private final service.BookingService bookingService = new service.BookingService();
    private final service.ContractService contractService = new service.ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String view = request.getParameter("view");
        HttpSession session = request.getSession(false);

        // ── Voucher AJAX validation ───────────────────────────────────────────
        if ("validateVoucher".equals(request.getParameter("action"))) {
            response.setContentType("application/json; charset=UTF-8");
            String code = request.getParameter("code");
            int nights = 1;
            try { nights = Integer.parseInt(request.getParameter("nights")); } catch (Exception ignored) {}
            
            java.util.Map<String, Object> result = bookingService.validateVoucher(code, nights);
            
            // Minimalist JSON construction (could use a library if available, but staying consistent with existing code)
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"valid\":").append(result.get("valid")).append(",");
            if (result.containsKey("type")) sb.append("\"type\":\"").append(result.get("type")).append("\",");
            if (result.containsKey("value")) sb.append("\"value\":").append(result.get("value")).append(",");
            sb.append("\"msg\":\"").append(result.get("msg")).append("\"");
            sb.append("}");
            response.getWriter().write(sb.toString());
            return;
        }

        if ("my".equals(view)) {
            if (session == null || session.getAttribute("account") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            TblPersons account = (TblPersons) session.getAttribute("account");
            List<TblBookings> myBookings = bookingService.getBookingsByCustomer(account.getId());
            request.setAttribute("myBookings", myBookings);

            // Build bookingId → VwContracts map for inline display
            List<model.VwContracts> myContracts = contractService.findByCustomerId(account.getId());
            Map<String, model.VwContracts> contractMap = new HashMap<>();
            for (model.VwContracts c : myContracts) {
                contractMap.put(c.getBookingId(), c);
            }
            request.setAttribute("contractMap", contractMap);

            request.getRequestDispatcher("/WEB-INF/my_bookings.jsp").forward(request, response);
            return;
        }

        // Display booking.jsp with dynamic facilities
        Date ci = null, co = null;
        try {
            String checkinParam  = request.getParameter("checkin");
            String checkoutParam = request.getParameter("checkout");
            if (checkinParam != null && !checkinParam.isEmpty() && checkoutParam != null && !checkoutParam.isEmpty()) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                ci = sdf.parse(checkinParam);
                co = sdf.parse(checkoutParam);
            }
        } catch (Exception ignored) {}

        List<TblFacilities> facilities = bookingService.getAvailableFacilities(ci, co);
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

        // Hủy booking
        if ("cancel".equals(request.getParameter("action"))) {
            String bookingId = request.getParameter("bookingId");
            try {
                bookingService.cancelBooking(bookingId);
                session.setAttribute("bookingFlash", "✅ Đã hủy booking " + bookingId + " thành công.");
            } catch (Exception e) {
                session.setAttribute("bookingFlash", "❌ Lỗi: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/booking?view=my");
            return;
        }

        try {
            String facilityId = request.getParameter("facilityId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            int adults = Integer.parseInt(request.getParameter("adults"));
            int children = Integer.parseInt(request.getParameter("children"));
            String voucherCode = request.getParameter("voucherId");
            String specialReq = request.getParameter("specialReq");
            boolean depositNow = "1".equals(request.getParameter("depositNow"));

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(startDateStr);
            Date endDate = sdf.parse(endDateStr);

            TblBookings booking = new TblBookings();
            booking.setStartDate(startDate);
            booking.setEndDate(endDate);
            booking.setAdults(adults);
            booking.setChildren(children);
            booking.setSpecialReq(specialReq);
            
            TblFacilities facility = new TblFacilities();
            facility.setServiceCode(facilityId);
            booking.setFacilityId(facility);
            
            TblCustomers customer = new TblCustomers();
            customer.setId(account.getId());
            booking.setCustomerId(customer);

            String msg = bookingService.placeBooking(booking, voucherCode, depositNow);
            session.setAttribute("bookingFlash", msg);
            
            response.sendRedirect(request.getContextPath() + "/booking?view=my");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("bookingError", "Lỗi đặt phòng: " + e.getMessage());
            doGet(request, response);
        }
    }
}
