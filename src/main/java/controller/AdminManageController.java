package controller;

import service.CustomerService;
import service.EmployeeService;
import service.BookingService;
import service.FacilityService;
import service.ContractService;
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
import java.io.PrintWriter;
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

    private final CustomerService customerService = new CustomerService();
    private final EmployeeService employeeService = new EmployeeService();
    private final BookingService  bookingService  = new BookingService();
    private final FacilityService facilityService = new FacilityService();
    private final ContractService contractService = new ContractService();

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
                    bookingService.approveBooking(id, emp.getId());
                    req.getSession().setAttribute("flashMsg", "✅ Đã duyệt booking " + id + " và tạo hợp đồng.");
                }
                case "reject_booking" -> {
                    String id = req.getParameter("bookingId");
                    bookingService.rejectBooking(id);
                    req.getSession().setAttribute("flashMsg", "🚫 Đã từ chối booking " + id);
                }
                case "checkin_booking" -> {
                    String id = req.getParameter("bookingId");
                    bookingService.checkInBooking(id);
                    req.getSession().setAttribute("flashMsg", "🔑 Check-in thành công!");
                }
                case "checkout_booking" -> {
                    String id = req.getParameter("bookingId");
                    String msg = bookingService.checkOutBooking(id);
                    req.getSession().setAttribute("flashMsg", msg);
                }
                case "add_payment" -> {
                    String id = req.getParameter("contractId");
                    String amtStr = req.getParameter("amount");
                    String method = req.getParameter("method");
                    String note   = req.getParameter("note");
                    try {
                        java.math.BigDecimal amount = new java.math.BigDecimal(amtStr.trim());
                        if (amount.compareTo(java.math.BigDecimal.ZERO) <= 0) throw new Exception("Số tiền phải > 0");
                        String result = contractService.addPayment(id, amount, method, note);
                        if (isAjax(req)) {
                            if (result.startsWith("OK:")) {
                                String[] parts = result.split(":");
                                String status = parts.length > 2 ? parts[2] : "ACTIVE";
                                String msg = "COMPLETED".equals(status) ? "Thanh toán đủ! Hợp đồng đã hoàn thành." : "Đã ghi nhận thanh toán.";
                                sendJson(res, 200, "{\"ok\":true,\"status\":" + jsonStr(status) + ",\"message\":" + jsonStr(msg) + "}");
                            } else {
                                sendJson(res, 400, "{\"ok\":false,\"message\":" + jsonStr(result.replace("ERROR:", "")) + "}");
                            }
                            return;
                        }
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
                        if (isAjax(req)) { sendJson(res, 400, "{\"ok\":false,\"message\":" + jsonStr(e.getMessage()) + "}"); return; }
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + e.getMessage());
                    }
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "confirm_deposit" -> {
                    String id = req.getParameter("contractId");
                    String result = contractService.confirmDeposit(id, emp.getId());
                    if (isAjax(req)) {
                        if (result.startsWith("OK:")) {
                            String[] parts = result.split(":");
                            String amt = parts.length > 1 ? parts[1] : "0";
                            String type = parts.length > 2 ? parts[2] : "";
                            int pct = "VILLA".equalsIgnoreCase(type) ? 50 : "HOUSE".equalsIgnoreCase(type) ? 40 : 30;
                            String msg = "Đã xác nhận đặt cọc " + pct + "% — " + String.format("%,.0f", Double.parseDouble(amt)) + " đ. Hợp đồng đã kích hoạt!";
                            sendJson(res, 200, "{\"ok\":true,\"status\":\"ACTIVE\",\"deposit\":" + amt + ",\"depositPct\":" + pct + ",\"message\":" + jsonStr(msg) + "}");
                        } else {
                            sendJson(res, 400, "{\"ok\":false,\"message\":" + jsonStr(result) + "}");
                        }
                        return;
                    }
                    req.getSession().setAttribute("flashMsg", result.startsWith("OK:") ? "✅ Đã xác nhận đặt cọc." : "❌ Lỗi: " + result);
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "approve_contract" -> {
                    String id = req.getParameter("contractId");
                    String result = contractService.approve(id, emp.getId());
                    req.getSession().setAttribute("flashMsg",
                        "APPROVED".equals(result) ? "✅ Hợp đồng đã được duyệt thành công!"
                        : "PENDING_DEPOSIT".equals(result) ? "⚠️ Khách chưa đặt cọc — hợp đồng đang chờ duyệt!"
                        : "❌ Lỗi: " + result);
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "reject_contract" -> {
                    String id = req.getParameter("contractId");
                    contractService.delete(id);
                    if (isAjax(req)) {
                        sendJson(res, 200, "{\"ok\":true,\"status\":\"CANCELLED\",\"message\":\"Hợp đồng đã bị từ chối.\"}");
                        return;
                    }
                    req.getSession().setAttribute("flashMsg", "🚫 Hợp đồng đã bị từ chối.");
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "facility_status" -> {
                    facilityService.updateStatus(req.getParameter("facilityId"), req.getParameter("status"));
                    req.getSession().setAttribute("flashMsg", "✅ Đã cập nhật trạng thái phòng.");
                    redirect = req.getContextPath() + "/dashboard/facilities";
                }
                case "facility_cleaned" -> {
                    String code = req.getParameter("facilityId");
                    facilityService.resetUsage(code);
                    facilityService.updateStatus(code, "AVAILABLE");
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
                        employeeService.save(newEmp);
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
                                employeeService.updateSalary(id, new java.math.BigDecimal(salaryStr));
                            }
                            if (position != null && !position.isBlank()) employeeService.updatePosition(id, position);
                            if (role != null && !role.isBlank()) employeeService.updateRole(id, role);
                            req.getSession().setAttribute("flashMsg", "✅ Cập nhật thông tin nhân viên " + id + " thành công!");
                        } catch (Exception e) {
                            req.getSession().setAttribute("flashMsg", "❌ Lỗi cập nhật nhân viên: " + e.getMessage());
                        }
                    }
                    redirect = req.getParameter("redirect");
                    if (redirect == null) redirect = req.getContextPath() + "/dashboard/users?filter=EMPLOYEE";
                }
                case "lock_user" -> {
                    customerService.toggleLock(req.getParameter("userId"), true);
                    redirect = req.getContextPath() + "/dashboard/users";
                }
                case "unlock_user" -> {
                    customerService.toggleLock(req.getParameter("userId"), false);
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

        List<VwCustomers> customers = customerService.findAllWithInfo();
        List<VwEmployees> employees = employeeService.findAllWithInfo();

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
        req.setAttribute("canManageEmployee", "ADMIN".equals(emp.getRole()));

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
            ? bookingService.findByStatus(status)
            : bookingService.findAllView();

        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            bookings = bookings.stream()
                .filter(b -> b.getBookingId().toLowerCase().contains(q)
                    || (b.getCustomerName() != null && b.getCustomerName().toLowerCase().contains(q))
                    || (b.getFacilityName() != null && b.getFacilityName().toLowerCase().contains(q)))
                .toList();
        }

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
        req.setAttribute("cntPending",   bookingService.countByStatus("PENDING"));
        req.setAttribute("cntConfirmed", bookingService.countByStatus("CONFIRMED"));
        req.setAttribute("cntCheckedIn", bookingService.countByStatus("CHECKED_IN"));

        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash != null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }

        req.getRequestDispatcher("/WEB-INF/dashboard/manage-bookings.jsp").forward(req, res);
    }

    private void handleFacilities(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String typeFilter   = req.getParameter("type");
        String statusFilter = req.getParameter("status");
        String search       = req.getParameter("q");

        List<TblFacilities> facilities = facilityService.findAll();

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
        req.setAttribute("cntAvailable",   facilityService.countByStatus("AVAILABLE"));
        req.setAttribute("cntOccupied",    facilityService.countByStatus("OCCUPIED"));
        req.setAttribute("cntCleaning",    facilityService.countByStatus("CLEANING"));
        req.setAttribute("cntMaintenance", facilityService.countByStatus("MAINTENANCE"));

        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash != null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }

        req.getRequestDispatcher("/WEB-INF/dashboard/manage-facilities.jsp").forward(req, res);
    }

    private void handleContracts(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String status = req.getParameter("status");
        String search = req.getParameter("q");

        List<VwContracts> contracts = (status != null && !status.equals("ALL"))
            ? contractService.findByStatus(status)
            : contractService.findAllView();

        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            contracts = contracts.stream()
                .filter(c -> c.getContractId().toLowerCase().contains(q)
                    || (c.getCustomerName() != null && c.getCustomerName().toLowerCase().contains(q)))
                .toList();
        }

        if (isAjax(req)) {
            StringBuilder sb = new StringBuilder("{\"contracts\":[");
            for (int i = 0; i < contracts.size(); i++) {
                if (i > 0) sb.append(',');
                sb.append(contractToJson(contracts.get(i)));
            }
            sb.append("],\"counts\":{")
              .append("\"DRAFT\":").append(contractService.countByStatus("DRAFT"))
              .append(",\"ACTIVE\":").append(contractService.countByStatus("ACTIVE"))
              .append(",\"COMPLETED\":").append(contractService.countByStatus("COMPLETED"))
              .append("}}");
            sendJson(res, 200, sb.toString());
            return;
        }

        req.setAttribute("contracts", contracts);
        req.setAttribute("statusFilter", status != null ? status : "ALL");
        req.setAttribute("search", search);
        req.setAttribute("cntDraft",     contractService.countByStatus("DRAFT"));
        req.setAttribute("cntActive",    contractService.countByStatus("ACTIVE"));
        req.setAttribute("cntCompleted", contractService.countByStatus("COMPLETED"));

        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash != null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }

        req.getRequestDispatcher("/WEB-INF/dashboard/manage-contracts.jsp").forward(req, res);
    }

    // ── JSON helpers ─────────────────────────────────────────────
    private boolean isAjax(HttpServletRequest req) {
        return "XMLHttpRequest".equals(req.getHeader("X-Requested-With"))
            || "json".equals(req.getParameter("format"));
    }

    private void sendJson(HttpServletResponse res, int status, String json) throws IOException {
        res.setStatus(status);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        out.print(json);
        out.flush();
    }

    private String contractToJson(VwContracts ct) {
        return "{"
            + "\"contractId\":" + jsonStr(ct.getContractId())
            + ",\"bookingId\":" + jsonStr(ct.getBookingId())
            + ",\"facilityId\":" + jsonStr(ct.getFacilityId())
            + ",\"customerName\":" + jsonStr(ct.getCustomerName())
            + ",\"status\":" + jsonStr(ct.getStatus())
            + ",\"deposit\":" + (ct.getDeposit() != null ? ct.getDeposit().toPlainString() : "0")
            + ",\"totalPayment\":" + (ct.getTotalPayment() != null ? ct.getTotalPayment().toPlainString() : "0")
            + ",\"paidAmount\":" + (ct.getPaidAmount() != null ? ct.getPaidAmount().toPlainString() : "0")
            + ",\"remainingAmount\":" + (ct.getRemainingAmount() != null ? ct.getRemainingAmount().toPlainString() : "0")
            + ",\"startDate\":" + jsonStr(ct.getStartDate())
            + ",\"endDate\":" + jsonStr(ct.getEndDate())
            + ",\"employeeName\":" + jsonStr(ct.getEmployeeName())
            + "}";
    }

    private String jsonStr(String s) {
        if (s == null) return "null";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                       .replace("\n", "\\n").replace("\r", "\\r") + "\"";
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
