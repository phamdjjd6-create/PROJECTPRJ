package controller;

import DAO.BookingDAO;
import DAO.ContractDAO;
import DAO.CustomerDAO;
import DAO.EmployeeDAO;
import DAO.FacilityDAO;
import at.favre.lib.crypto.bcrypt.BCrypt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TblEmployees;
import model.TblFacilities;
import model.VwBookings;
import model.VwContracts;
import model.VwCustomers;
import model.VwEmployees;
import java.io.IOException;
import java.util.List;

/**
 * Xử lý tất cả trang quản lý của admin/staff:
 * /dashboard/users      — danh sách người dùng
 * /dashboard/bookings   — quản lý booking + duyệt
 * /dashboard/facilities — quản lý phòng/villa
 * /dashboard/contracts  — duyệt hợp đồng
 * /dashboard/action     — POST actions (approve, lock, status change)
 */
@WebServlet(urlPatterns = {
    "/dashboard/users",
    "/dashboard/bookings",
    "/dashboard/facilities",
    "/dashboard/contracts",
    "/dashboard/action"
})
public class AdminManageController extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final BookingDAO  bookingDAO  = new BookingDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();
    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (!checkAuth(req, res)) return;

        String path = req.getServletPath();
        TblEmployees emp = (TblEmployees) req.getSession().getAttribute("account");

        switch (path) {
            case "/dashboard/users"      -> handleUsers(req, res, emp);
            case "/dashboard/bookings"   -> handleBookings(req, res);
            case "/dashboard/facilities" -> handleFacilities(req, res);
            case "/dashboard/contracts"  -> handleContracts(req, res);
            default -> res.sendRedirect(req.getContextPath() + "/dashboard/staff");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (!checkAuth(req, res)) return;
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        String redirect = req.getParameter("redirect");
        if (redirect == null) redirect = req.getContextPath() + "/dashboard/bookings";

        TblEmployees emp = (TblEmployees) req.getSession().getAttribute("account");

        try {
            switch (action != null ? action : "") {
                case "approve_booking" -> {
                    String id = req.getParameter("bookingId");
                    bookingDAO.updateStatus(id, "CONFIRMED");
                    VwBookings bk = bookingDAO.findAllView().stream()
                        .filter(b -> b.getBookingId().equals(id)).findFirst().orElse(null);
                    if (bk != null) facilityDAO.updateStatus(bk.getFacilityId(), "OCCUPIED");
                    // Tạo contract khi admin duyệt
                    try {
                        contractDAO.createForBooking(id, emp.getId());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    req.getSession().setAttribute("flashMsg", "✅ Đã duyệt booking " + id + " và tạo hợp đồng.");
                    redirect = req.getContextPath() + "/dashboard/bookings";
                }
                case "reject_booking" -> {
                    String id = req.getParameter("bookingId");
                    bookingDAO.updateStatus(id, "CANCELLED");
                    req.getSession().setAttribute("flashMsg", "🚫 Đã từ chối booking " + id);
                    redirect = req.getContextPath() + "/dashboard/bookings";
                }
                case "checkin_booking" -> {
                    String id = req.getParameter("bookingId");
                    bookingDAO.updateStatus(id, "CHECKED_IN");
                    VwBookings bk = bookingDAO.findAllView().stream()
                        .filter(b -> b.getBookingId().equals(id)).findFirst().orElse(null);
                    if (bk != null) {
                        facilityDAO.updateStatus(bk.getFacilityId(), "OCCUPIED");
                        // Tăng usage_count khi khách nhận phòng
                        facilityDAO.increaseUsage(bk.getFacilityId());
                    }
                    req.getSession().setAttribute("flashMsg", "🔑 Check-in thành công!");
                    redirect = req.getContextPath() + "/dashboard/bookings";
                }
                case "checkout_booking" -> {
                    String id = req.getParameter("bookingId");
                    bookingDAO.updateStatus(id, "CHECKED_OUT");
                    VwBookings bk = bookingDAO.findAllView().stream()
                        .filter(b -> b.getBookingId().equals(id)).findFirst().orElse(null);
                    if (bk != null) {
                        // Sau checkout: nếu usage_count >= 5 → MAINTENANCE, còn lại → CLEANING (chờ nhân viên dọn)
                        TblFacilities fac = facilityDAO.findByCode(bk.getFacilityId());
                        if (fac != null && fac.getUsageCount() >= 5) {
                            facilityDAO.updateStatus(bk.getFacilityId(), "MAINTENANCE");
                            req.getSession().setAttribute("flashMsg",
                                "🚪 Check-out xong. Phòng " + bk.getFacilityId() + " đã dùng " + fac.getUsageCount() + " lần — chuyển sang BẢO TRÌ!");
                        } else {
                            facilityDAO.updateStatus(bk.getFacilityId(), "CLEANING");
                            req.getSession().setAttribute("flashMsg",
                                "🚪 Check-out xong. Phòng " + bk.getFacilityId() + " đang chờ nhân viên dọn dẹp.");
                        }
                    }
                    redirect = req.getContextPath() + "/dashboard/bookings";
                }
                case "add_payment" -> {
                    String id = req.getParameter("contractId");
                    String amtStr = req.getParameter("amount");
                    String method = req.getParameter("method");
                    String note   = req.getParameter("note");
                    try {
                        java.math.BigDecimal amount = new java.math.BigDecimal(amtStr.trim());
                        if (amount.compareTo(java.math.BigDecimal.ZERO) <= 0) throw new Exception("Số tiền phải > 0");
                        String result = contractDAO.addPayment(id, amount, method, note);
                        if (result.startsWith("OK:")) {
                            String[] parts = result.split(":");
                            boolean done = "COMPLETED".equals(parts.length > 2 ? parts[2] : "");
                            req.getSession().setAttribute("flashMsg",
                                done ? "✅ Thanh toán đủ! Hợp đồng " + id + " đã hoàn thành."
                                     : "✅ Đã ghi nhận thanh toán cho hợp đồng " + id);
                        } else {
                            req.getSession().setAttribute("flashMsg", "❌ " + result.replace("ERROR:", ""));
                        }
                    } catch (Exception e) {
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + e.getMessage());
                    }
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "confirm_deposit" -> {                    String id = req.getParameter("contractId");
                    String result = contractDAO.confirmDeposit(id, emp.getId());
                    if (result.startsWith("OK:")) {
                        String[] parts = result.split(":");
                        String amt = parts.length > 1 ? parts[1] : "?";
                        String type = parts.length > 2 ? parts[2] : "";
                        int pct = "VILLA".equalsIgnoreCase(type) ? 50 : "HOUSE".equalsIgnoreCase(type) ? 40 : 30;
                        req.getSession().setAttribute("flashMsg",
                            "✅ Đã xác nhận đặt cọc " + pct + "% — " + String.format("%,.0f", Double.parseDouble(amt)) + " đ. Hợp đồng đã kích hoạt!");
                    } else {
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + result);
                    }
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "approve_contract" -> {
                    String id = req.getParameter("contractId");
                    String result = contractDAO.approve(id, emp.getId());
                    req.getSession().setAttribute("flashMsg",
                        "APPROVED".equals(result) ? "✅ Hợp đồng đã được duyệt thành công!"
                        : "PENDING_DEPOSIT".equals(result) ? "⚠️ Khách chưa đặt cọc — hợp đồng đang chờ duyệt!"
                        : "❌ Lỗi: " + result);
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "reject_contract" -> {
                    contractDAO.updateStatus(req.getParameter("contractId"), "CANCELLED");
                    req.getSession().setAttribute("flashMsg", "🚫 Hợp đồng đã bị từ chối.");
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "facility_status" -> {
                    facilityDAO.updateStatus(req.getParameter("facilityId"), req.getParameter("status"));
                    req.getSession().setAttribute("flashMsg", "✅ Đã cập nhật trạng thái phòng.");
                    redirect = req.getContextPath() + "/dashboard/facilities";
                }
                case "facility_cleaned" -> {
                    // Nhân viên dọn xong → reset usage_count về 0, chuyển AVAILABLE
                    String code = req.getParameter("facilityId");
                    facilityDAO.resetUsage(code);
                    req.getSession().setAttribute("flashMsg", "🧹 Phòng " + code + " đã dọn xong — sẵn sàng đón khách mới!");
                    redirect = req.getContextPath() + "/dashboard/facilities";
                }
                case "give_voucher" -> {
                    req.getSession().setAttribute("flashMsg", "🎁 Đã gửi tặng voucher thành công cho khách hàng!");
                    redirect = req.getParameter("redirect");
                    if (redirect == null) redirect = req.getContextPath() + "/dashboard/users";
                }
                case "add_employee" -> {
                    String fullName  = req.getParameter("fullName");
                    String email     = req.getParameter("email");
                    String phone     = req.getParameter("phone");
                    String account   = req.getParameter("account");
                    String password  = req.getParameter("password");
                    String position  = req.getParameter("position");
                    String salaryStr = req.getParameter("salary");
                    String role      = req.getParameter("role");
                    try {
                        String hashed = BCrypt.withDefaults().hashToString(12, password.toCharArray());
                        model.TblEmployees newEmp = new model.TblEmployees();
                        // Generate ID: EMP + timestamp suffix
                        String newId = "EMP" + System.currentTimeMillis() % 100000;
                        newEmp.setId(newId);
                        newEmp.setFullName(fullName);
                        newEmp.setEmail(email);
                        newEmp.setPhoneNumber(phone);
                        newEmp.setAccount(account);
                        newEmp.setPasswordHash(hashed);
                        newEmp.setPosition(position);
                        newEmp.setSalary(salaryStr != null && !salaryStr.isBlank()
                            ? new java.math.BigDecimal(salaryStr) : java.math.BigDecimal.ZERO);
                        newEmp.setRole(role != null ? role : "STAFF");
                        newEmp.setIsActive(true);
                        newEmp.setDeleted(false);
                        newEmp.setCreatedAt(new java.util.Date());
                        newEmp.setUpdatedAt(new java.util.Date());
                        newEmp.setHireDate(new java.util.Date());
                        employeeDAO.save(newEmp);
                        req.getSession().setAttribute("flashMsg", "✅ Đã thêm nhân viên " + fullName + " (tài khoản: " + account + ")");
                    } catch (Exception e) {
                        e.printStackTrace();
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi thêm nhân viên: " + e.getMessage());
                    }
                    redirect = req.getContextPath() + "/dashboard/users?filter=EMPLOYEE";
                }
                case "update_employee" -> {
                    String id = req.getParameter("empId");
                    String salaryStr = req.getParameter("salary");
                    String position = req.getParameter("position");
                    String role = req.getParameter("role");
                    if (id != null) {
                        try {
                            if (salaryStr != null && !salaryStr.isBlank()) {
                                employeeDAO.updateSalary(id, new java.math.BigDecimal(salaryStr));
                            }
                            if (position != null && !position.isBlank()) employeeDAO.updatePosition(id, position);
                            if (role != null && !role.isBlank()) employeeDAO.updateRole(id, role);
                            req.getSession().setAttribute("flashMsg", "✅ Cập nhật thông tin nhân viên " + id + " thành công!");
                        } catch (Exception e) {
                            req.getSession().setAttribute("flashMsg", "❌ Lỗi cập nhật nhân viên: " + e.getMessage());
                        }
                    }
                    redirect = req.getParameter("redirect");
                    if (redirect == null) redirect = req.getContextPath() + "/dashboard/users?filter=EMPLOYEE";
                }
                case "lock_user" -> {
                    customerDAO.toggleLock(req.getParameter("userId"), true);
                    redirect = req.getContextPath() + "/dashboard/users";
                }
                case "unlock_user" -> {
                    customerDAO.toggleLock(req.getParameter("userId"), false);
                    redirect = req.getContextPath() + "/dashboard/users";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flashMsg", "❌ Lỗi hệ thống: " + e.getMessage());
        }

        res.sendRedirect(redirect);
    }

    // ── Handlers ─────────────────────────────────────────────────

    private void handleUsers(HttpServletRequest req, HttpServletResponse res, TblEmployees emp)
            throws ServletException, IOException {

        String filter = req.getParameter("filter"); // ALL, CUSTOMER, EMPLOYEE
        String search = req.getParameter("q");

        List<VwCustomers> customers = customerDAO.findAll();
        List<VwEmployees> employees = employeeDAO.findAll();

        // Filter search
        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            customers = customers.stream()
                .filter(c -> c.getFullName().toLowerCase().contains(q)
                    || (c.getEmail() != null && c.getEmail().toLowerCase().contains(q))
                    || (c.getPhoneNumber() != null && c.getPhoneNumber().toLowerCase().contains(q)))
                .toList();
            employees = employees.stream()
                .filter(e -> e.getFullName().toLowerCase().contains(q)
                    || (e.getEmail() != null && e.getEmail().toLowerCase().contains(q)))
                .toList();
        }

        req.setAttribute("customers", customers);
        req.setAttribute("employees", employees);
        req.setAttribute("totalCustomers", customers.size());
        req.setAttribute("totalEmployees", employees.size());
        req.setAttribute("filter", filter != null ? filter : "ALL");
        req.setAttribute("search", search);

        // STAFF chỉ xem, không sửa employee
        req.setAttribute("canManageEmployee", "ADMIN".equals(emp.getRole()));

        // Flash message
        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash != null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }

        req.getRequestDispatcher("/WEB-INF/dashboard/manage-users.jsp").forward(req, res);
    }

    private void handleBookings(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String status   = req.getParameter("status");
        String search   = req.getParameter("q");
        String dateFrom = req.getParameter("dateFrom");
        String dateTo   = req.getParameter("dateTo");

        List<VwBookings> bookings = (status != null && !status.equals("ALL"))
            ? bookingDAO.findByStatus(status)
            : bookingDAO.findAllView();

        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            bookings = bookings.stream()
                .filter(b -> b.getBookingId().toLowerCase().contains(q)
                    || (b.getCustomerName() != null && b.getCustomerName().toLowerCase().contains(q))
                    || (b.getFacilityName() != null && b.getFacilityName().toLowerCase().contains(q)))
                .toList();
        }

        // Date range filter on startDate
        if (dateFrom != null && !dateFrom.isBlank()) {
            try {
                java.util.Date from = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(dateFrom);
                bookings = bookings.stream()
                    .filter(b -> b.getStartDate() != null && !b.getStartDate().before(from))
                    .toList();
            } catch (Exception ignored) {}
        }
        if (dateTo != null && !dateTo.isBlank()) {
            try {
                java.util.Date to = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(dateTo);
                bookings = bookings.stream()
                    .filter(b -> b.getStartDate() != null && !b.getStartDate().after(to))
                    .toList();
            } catch (Exception ignored) {}
        }

        req.setAttribute("bookings", bookings);
        req.setAttribute("statusFilter", status != null ? status : "ALL");
        req.setAttribute("search", search);
        req.setAttribute("dateFrom", dateFrom);
        req.setAttribute("dateTo", dateTo);
        req.setAttribute("cntPending",   bookingDAO.countByStatus("PENDING"));
        req.setAttribute("cntConfirmed", bookingDAO.countByStatus("CONFIRMED"));
        req.setAttribute("cntCheckedIn", bookingDAO.countByStatus("CHECKED_IN"));

        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash != null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }

        req.getRequestDispatcher("/WEB-INF/dashboard/manage-bookings.jsp").forward(req, res);
    }

    private void handleFacilities(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String typeFilter   = req.getParameter("type");   // VILLA, HOUSE, ROOM
        String statusFilter = req.getParameter("status"); // AVAILABLE, OCCUPIED, MAINTENANCE
        String search       = req.getParameter("q");

        List<TblFacilities> facilities = facilityDAO.findAll();

        if (typeFilter != null && !typeFilter.equals("ALL"))
            facilities = facilities.stream().filter(f -> f.getFacilityType().equals(typeFilter)).toList();
        if (statusFilter != null && !statusFilter.equals("ALL"))
            facilities = facilities.stream().filter(f -> f.getStatus().equals(statusFilter)).toList();
        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            facilities = facilities.stream()
                .filter(f -> f.getServiceName().toLowerCase().contains(q)
                    || f.getServiceCode().toLowerCase().contains(q))
                .toList();
        }

        req.setAttribute("facilities", facilities);
        req.setAttribute("typeFilter",   typeFilter   != null ? typeFilter   : "ALL");
        req.setAttribute("statusFilter", statusFilter != null ? statusFilter : "ALL");
        req.setAttribute("search", search);
        req.setAttribute("cntAvailable",   facilityDAO.countByStatus("AVAILABLE"));
        req.setAttribute("cntOccupied",    facilityDAO.countByStatus("OCCUPIED"));
        req.setAttribute("cntCleaning",    facilityDAO.countByStatus("CLEANING"));
        req.setAttribute("cntMaintenance", facilityDAO.countByStatus("MAINTENANCE"));

        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash != null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }

        req.getRequestDispatcher("/WEB-INF/dashboard/manage-facilities.jsp").forward(req, res);
    }

    private void handleContracts(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String status = req.getParameter("status");
        String search = req.getParameter("q");

        List<VwContracts> contracts = (status != null && !status.equals("ALL"))
            ? contractDAO.findByStatus(status)
            : contractDAO.findAll_View();

        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            contracts = contracts.stream()
                .filter(c -> c.getContractId().toLowerCase().contains(q)
                    || (c.getCustomerName() != null && c.getCustomerName().toLowerCase().contains(q)))
                .toList();
        }

        req.setAttribute("contracts", contracts);
        req.setAttribute("statusFilter", status != null ? status : "ALL");
        req.setAttribute("search", search);
        req.setAttribute("cntDraft",     contractDAO.countByStatus("DRAFT"));
        req.setAttribute("cntActive",    contractDAO.countByStatus("ACTIVE"));
        req.setAttribute("cntCompleted", contractDAO.countByStatus("COMPLETED"));

        // Flash message từ redirect
        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash != null) {
            req.setAttribute("flashMsg", flash);
            req.getSession().removeAttribute("flashMsg");
        }

        req.getRequestDispatcher("/WEB-INF/dashboard/manage-contracts.jsp").forward(req, res);
    }

    // ── Auth check ───────────────────────────────────────────────
    private boolean checkAuth(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("account") instanceof TblEmployees)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
