package controller;

import DAO.AccountDAO;
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

@WebServlet(urlPatterns = {
    "/dashboard/users",
    "/dashboard/bookings",
    "/dashboard/facilities",
    "/dashboard/contracts",
    "/dashboard/action"
})
public class AdminManageController extends HttpServlet {

    private final AccountDAO  accountDAO  = new AccountDAO();
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

        String action   = req.getParameter("action");
        String redirect = req.getParameter("redirect");
        if (redirect == null) redirect = req.getContextPath() + "/dashboard/bookings";

        TblEmployees emp = (TblEmployees) req.getSession().getAttribute("account");

        try {
            switch (action != null ? action : "") {

                // ── BOOKING ───────────────────────────────────────────────
                case "approve_booking" -> {
                    String id = req.getParameter("bookingId");
                    bookingDAO.updateStatus(id, "CONFIRMED");
                    VwBookings bk = bookingDAO.findAllView().stream()
                        .filter(b -> b.getBookingId().equals(id)).findFirst().orElse(null);
                    if (bk != null) facilityDAO.updateStatus(bk.getFacilityId(), "OCCUPIED");
                    try { contractDAO.createForBooking(id, emp.getId()); } catch (Exception e) { e.printStackTrace(); }
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

                // ── PAYMENT / DEPOSIT ─────────────────────────────────────
                case "add_payment" -> {
                    String id     = req.getParameter("contractId");
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
                case "confirm_deposit" -> {
                    String id     = req.getParameter("contractId");
                    String result = contractDAO.confirmDeposit(id, emp.getId());
                    if (result.startsWith("OK:")) {
                        String[] parts = result.split(":");
                        String amt  = parts.length > 1 ? parts[1] : "?";
                        String type = parts.length > 2 ? parts[2] : "";
                        int pct = "VILLA".equalsIgnoreCase(type) ? 50 : "HOUSE".equalsIgnoreCase(type) ? 40 : 30;
                        req.getSession().setAttribute("flashMsg",
                            "✅ Đã xác nhận đặt cọc " + pct + "% — " + String.format("%,.0f", Double.parseDouble(amt)) + " đ. Hợp đồng đã kích hoạt!");
                    } else {
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + result);
                    }
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }

                // ── CONTRACT ──────────────────────────────────────────────
                case "approve_contract" -> {
                    String id     = req.getParameter("contractId");
                    String result = contractDAO.approve(id, emp.getId());
                    req.getSession().setAttribute("flashMsg",
                        "APPROVED".equals(result)        ? "✅ Hợp đồng đã được duyệt thành công!" :
                        "PENDING_DEPOSIT".equals(result) ? "⚠️ Khách chưa đặt cọc — hợp đồng đang chờ duyệt!" :
                                                           "❌ Lỗi: " + result);
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }
                case "reject_contract" -> {
                    contractDAO.updateStatus(req.getParameter("contractId"), "CANCELLED");
                    req.getSession().setAttribute("flashMsg", "🚫 Hợp đồng đã bị từ chối.");
                    redirect = req.getContextPath() + "/dashboard/contracts";
                }

                // ── FACILITY ──────────────────────────────────────────────
                case "facility_status" -> {
                    facilityDAO.updateStatus(req.getParameter("facilityId"), req.getParameter("status"));
                    req.getSession().setAttribute("flashMsg", "✅ Đã cập nhật trạng thái phòng.");
                    redirect = req.getContextPath() + "/dashboard/facilities";
                }
                case "facility_cleaned" -> {
                    String code = req.getParameter("facilityId");
                    facilityDAO.resetUsage(code);
                    req.getSession().setAttribute("flashMsg", "🧹 Phòng " + code + " đã dọn xong — sẵn sàng đón khách mới!");
                    redirect = req.getContextPath() + "/dashboard/facilities";
                }

                // ── USER LOCK ─────────────────────────────────────────────
                case "lock_user" -> {
                    customerDAO.toggleLock(req.getParameter("userId"), true);
                    redirect = req.getContextPath() + "/dashboard/users?tab=customers";
                }
                case "unlock_user" -> {
                    customerDAO.toggleLock(req.getParameter("userId"), false);
                    redirect = req.getContextPath() + "/dashboard/users?tab=customers";
                }

                // ── GIVE VOUCHER — lưu vào session ────────────────────────
                case "give_voucher" -> {
                    String cusId      = req.getParameter("cusId");
                    String voucherCode = req.getParameter("voucherCode");
                    @SuppressWarnings("unchecked")
                    java.util.Set<String> gifted = (java.util.Set<String>)
                        req.getSession().getAttribute("giftedVouchers");
                    if (gifted == null) gifted = new java.util.HashSet<>();
                    if (cusId != null) gifted.add(cusId);
                    req.getSession().setAttribute("giftedVouchers", gifted);
                    req.getSession().setAttribute("flashMsg",
                        "🎁 Đã tặng voucher " + (voucherCode != null ? voucherCode : "") + " thành công!");
                    redirect = req.getContextPath() + "/dashboard/users?tab=customers";
                }

                // ── EDIT EMPLOYEE (ADMIN only) ────────────────────────────
                case "edit_employee" -> {
                    if (!"ADMIN".equals(emp.getRole())) {
                        req.getSession().setAttribute("flashMsg", "❌ Không có quyền!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=employees"; break;
                    }
                    String empId     = req.getParameter("empId");
                    String fullName  = req.getParameter("fullName");
                    String email     = req.getParameter("email");
                    String pos       = req.getParameter("position");
                    String eRole     = req.getParameter("role");
                    String sal       = req.getParameter("salary");
                    String deptId    = req.getParameter("deptId");
                    String activeStr = req.getParameter("isActive");
                    try {
                        employeeDAO.updatePersonInfo(empId, fullName, email);
                        if (sal    != null && !sal.isBlank())    employeeDAO.updateSalary(empId, new java.math.BigDecimal(sal));
                        if (pos    != null && !pos.isBlank())    employeeDAO.updatePosition(empId, pos);
                        if (eRole  != null && !eRole.isBlank())  employeeDAO.updateRole(empId, eRole);
                        if (deptId != null && !deptId.isBlank()) employeeDAO.updateDept(empId, deptId);
                        if (activeStr != null) employeeDAO.updateActive(empId, "true".equals(activeStr));
                        req.getSession().setAttribute("flashMsg", "✅ Cập nhật nhân viên " + empId + " thành công!");
                    } catch (Exception ex) {
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + ex.getMessage());
                    }
                    redirect = req.getContextPath() + "/dashboard/users?tab=employees";
                }

                // ── EDIT CUSTOMER (ADMIN only) ────────────────────────────
                case "edit_customer" -> {
                    if (!"ADMIN".equals(emp.getRole())) {
                        req.getSession().setAttribute("flashMsg", "❌ Không có quyền!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=customers"; break;
                    }
                    String cusId        = req.getParameter("cusId");
                    String typeCustomer = req.getParameter("typeCustomer");
                    String address      = req.getParameter("address");
                    String fullName     = req.getParameter("fullName");
                    String email        = req.getParameter("email");
                    String phoneNumber  = req.getParameter("phoneNumber");
                    String tsStr        = req.getParameter("totalSpent");
                    java.math.BigDecimal totalSpent = null;
                    if (tsStr != null && !tsStr.isBlank()) {
                        try { totalSpent = new java.math.BigDecimal(tsStr); } catch (NumberFormatException ignored) {}
                    }
                    try {
                        customerDAO.updateCustomer(cusId, typeCustomer, address, fullName, email, phoneNumber, totalSpent);
                        req.getSession().setAttribute("flashMsg", "✅ Cập nhật khách hàng " + cusId + " thành công!");
                    } catch (Exception ex) {
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + ex.getMessage());
                    }
                    redirect = req.getContextPath() + "/dashboard/users?tab=customers";
                }

                // ── DELETE CUSTOMER (ADMIN only) ──────────────────────────
                case "delete_customer" -> {
                    if (!"ADMIN".equals(emp.getRole())) {
                        req.getSession().setAttribute("flashMsg", "❌ Không có quyền!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=customers"; break;
                    }
                    try {
                        customerDAO.toggleLock(req.getParameter("cusId"), true);
                        req.getSession().setAttribute("flashMsg", "🗑️ Đã xóa khách hàng thành công!");
                    } catch (Exception ex) {
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + ex.getMessage());
                    }
                    redirect = req.getContextPath() + "/dashboard/users?tab=customers";
                }

                // ── DELETE EMPLOYEE (ADMIN only) — hard delete ────────────
                case "delete_employee" -> {
                    if (!"ADMIN".equals(emp.getRole())) {
                        req.getSession().setAttribute("flashMsg", "❌ Không có quyền!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=employees"; break;
                    }
                    try {
                        employeeDAO.hardDelete(req.getParameter("empId"));
                        req.getSession().setAttribute("flashMsg", "🗑️ Đã xóa nhân viên thành công!");
                    } catch (Exception ex) {
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + ex.getMessage());
                    }
                    redirect = req.getContextPath() + "/dashboard/users?tab=employees";
                }

                // ── ADD CUSTOMER (ADMIN only) ─────────────────────────────
                case "add_customer" -> {
                    if (!"ADMIN".equals(emp.getRole())) {
                        req.getSession().setAttribute("flashMsg", "❌ Không có quyền!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=customers"; break;
                    }
                    String username      = req.getParameter("username");
                    String fullName2     = req.getParameter("fullName");
                    String email2        = req.getParameter("email");
                    String phone2        = req.getParameter("phoneNumber");
                    String password2     = req.getParameter("password");
                    String typeCustomer2 = req.getParameter("typeCustomer");
                    if (username==null||username.isBlank()||fullName2==null||fullName2.isBlank()
                            ||email2==null||email2.isBlank()||password2==null||password2.isBlank()) {
                        req.getSession().setAttribute("flashMsg", "❌ Vui lòng điền đầy đủ thông tin!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=customers"; break;
                    }
                    if (accountDAO.findByUsername(username.trim()) != null) {
                        req.getSession().setAttribute("flashMsg", "❌ Tài khoản \"" + username + "\" đã tồn tại!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=customers"; break;
                    }
                    if (accountDAO.findByEmail(email2.trim()) != null) {
                        req.getSession().setAttribute("flashMsg", "❌ Email \"" + email2 + "\" đã được đăng ký!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=customers"; break;
                    }
                    String hashed = BCrypt.withDefaults().hashToString(12, password2.toCharArray());
                    model.TblPersons person = new model.TblPersons();
                    person.setAccount(username.trim());
                    person.setFullName(fullName2.trim());
                    person.setEmail(email2.trim());
                    person.setPhoneNumber(phone2!=null&&!phone2.isBlank()?phone2.trim():null);
                    person.setPasswordHash(hashed);
                    person.setPersonType("CUSTOMER");
                    person.setGender("Nam");
                    person.setCreatedAt(new java.util.Date());
                    person.setUpdatedAt(new java.util.Date());
                    person.setDeleted(false);
                    boolean ok = accountDAO.registerCustomer(person);
                    if (ok && typeCustomer2!=null && !typeCustomer2.equals("Normal"))
                        customerDAO.updateCustomer(person.getId(), typeCustomer2, null, null, null, null, null);
                    req.getSession().setAttribute("flashMsg",
                        ok ? "✅ Thêm khách hàng " + fullName2.trim() + " thành công!"
                           : "❌ Lỗi khi tạo khách hàng!");
                    redirect = req.getContextPath() + "/dashboard/users?tab=customers";
                }

                // ── ADD EMPLOYEE (ADMIN only) ─────────────────────────────
                case "add_employee" -> {
                    if (!"ADMIN".equals(emp.getRole())) {
                        req.getSession().setAttribute("flashMsg", "❌ Không có quyền!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=employees"; break;
                    }
                    String username2 = req.getParameter("username");
                    String fullName3 = req.getParameter("fullName");
                    String email3    = req.getParameter("email");
                    String phone3    = req.getParameter("phoneNumber");
                    String password3 = req.getParameter("password");
                    String position3 = req.getParameter("position");
                    String salStr3   = req.getParameter("salary");
                    String role3     = req.getParameter("role");
                    String deptId3   = req.getParameter("deptId");
                    if (username2==null||username2.isBlank()||fullName3==null||fullName3.isBlank()
                            ||email3==null||email3.isBlank()||password3==null||password3.isBlank()
                            ||position3==null||position3.isBlank()) {
                        req.getSession().setAttribute("flashMsg", "❌ Vui lòng điền đầy đủ thông tin!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=employees"; break;
                    }
                    if (accountDAO.findByUsername(username2.trim()) != null) {
                        req.getSession().setAttribute("flashMsg", "❌ Tài khoản \"" + username2 + "\" đã tồn tại!");
                        redirect = req.getContextPath() + "/dashboard/users?tab=employees"; break;
                    }
                    String hashed3 = BCrypt.withDefaults().hashToString(12, password3.toCharArray());
                    jakarta.persistence.EntityManager em2 =
                        util.JpaUtil.getEntityManagerFactory().createEntityManager();
                    try {
                        em2.getTransaction().begin();
                        java.util.List<String> ids2 = em2.createQuery(
                            "SELECT p.id FROM TblPersons p WHERE p.id LIKE 'NV%'", String.class)
                            .getResultList();
                        int maxId = 0;
                        for (String nid : ids2) {
                            try { int n = Integer.parseInt(nid.substring(2)); if(n>maxId) maxId=n; }
                            catch (NumberFormatException ignored) {}
                        }
                        String newEmpId = String.format("NV%03d", maxId + 1);
                        model.TblEmployees newEmp = new model.TblEmployees();
                        newEmp.setId(newEmpId);
                        newEmp.setAccount(username2.trim());
                        newEmp.setFullName(fullName3.trim());
                        newEmp.setEmail(email3.trim());
                        newEmp.setPhoneNumber(phone3!=null&&!phone3.isBlank()?phone3.trim():null);
                        newEmp.setPasswordHash(hashed3);
                        newEmp.setGender("Nam");
                        newEmp.setCreatedAt(new java.util.Date());
                        newEmp.setUpdatedAt(new java.util.Date());
                        newEmp.setDeleted(false);
                        newEmp.setPosition(position3.trim());
                        newEmp.setSalary(salStr3!=null&&!salStr3.isBlank()
                            ? new java.math.BigDecimal(salStr3) : java.math.BigDecimal.ZERO);
                        newEmp.setRole(role3!=null&&!role3.isBlank() ? role3 : "STAFF");
                        newEmp.setIsActive(true);
                        newEmp.setHireDate(new java.util.Date());
                        if (deptId3!=null && !deptId3.isBlank()) {
                            model.TblDepartments dept = em2.find(model.TblDepartments.class, deptId3);
                            if (dept != null) newEmp.setDeptId(dept);
                        }
                        em2.persist(newEmp);
                        em2.getTransaction().commit();
                        req.getSession().setAttribute("flashMsg", "✅ Thêm nhân viên " + fullName3.trim() + " thành công!");
                    } catch (Exception ex) {
                        if (em2.getTransaction().isActive()) em2.getTransaction().rollback();
                        ex.printStackTrace();
                        req.getSession().setAttribute("flashMsg", "❌ Lỗi: " + ex.getMessage());
                    } finally { em2.close(); }
                    redirect = req.getContextPath() + "/dashboard/users?tab=employees";
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
        String filter = req.getParameter("filter");
        String search = req.getParameter("q");
        List<VwCustomers> customers = customerDAO.findAll();
        List<VwEmployees> employees = employeeDAO.findAll();
        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            customers = customers.stream()
                .filter(c -> c.getFullName().toLowerCase().contains(q)
                    || (c.getEmail()!=null && c.getEmail().toLowerCase().contains(q))
                    || (c.getPhoneNumber()!=null && c.getPhoneNumber().toLowerCase().contains(q)))
                .toList();
            employees = employees.stream()
                .filter(e -> e.getFullName().toLowerCase().contains(q)
                    || (e.getEmail()!=null && e.getEmail().toLowerCase().contains(q)))
                .toList();
        }
        req.setAttribute("customers",         customers);
        req.setAttribute("employees",         employees);
        req.setAttribute("totalCustomers",    customers.size());
        req.setAttribute("totalEmployees",    employees.size());
        req.setAttribute("filter",            filter != null ? filter : "ALL");
        req.setAttribute("search",            search);
        req.setAttribute("canManageEmployee", "ADMIN".equals(emp.getRole()));
        try { req.setAttribute("departments", employeeDAO.findAllDepts()); } catch (Exception e) { e.printStackTrace(); }
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
        List<VwBookings> bookings = (status!=null && !status.equals("ALL"))
            ? bookingDAO.findByStatus(status) : bookingDAO.findAllView();
        if (search!=null && !search.isBlank()) {
            String q = search.toLowerCase();
            bookings = bookings.stream()
                .filter(b -> b.getBookingId().toLowerCase().contains(q)
                    || (b.getCustomerName()!=null && b.getCustomerName().toLowerCase().contains(q))
                    || (b.getFacilityName()!=null && b.getFacilityName().toLowerCase().contains(q)))
                .toList();
        }
        if (dateFrom!=null && !dateFrom.isBlank()) {
            try {
                java.util.Date from = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(dateFrom);
                bookings = bookings.stream().filter(b -> b.getStartDate()!=null && !b.getStartDate().before(from)).toList();
            } catch (Exception ignored) {}
        }
        if (dateTo!=null && !dateTo.isBlank()) {
            try {
                java.util.Date to = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(dateTo);
                bookings = bookings.stream().filter(b -> b.getStartDate()!=null && !b.getStartDate().after(to)).toList();
            } catch (Exception ignored) {}
        }
        req.setAttribute("bookings",     bookings);
        req.setAttribute("statusFilter", status!=null ? status : "ALL");
        req.setAttribute("search",       search);
        req.setAttribute("dateFrom",     dateFrom);
        req.setAttribute("dateTo",       dateTo);
        req.setAttribute("cntPending",   bookingDAO.countByStatus("PENDING"));
        req.setAttribute("cntConfirmed", bookingDAO.countByStatus("CONFIRMED"));
        req.setAttribute("cntCheckedIn", bookingDAO.countByStatus("CHECKED_IN"));
        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash!=null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }
        req.getRequestDispatcher("/WEB-INF/dashboard/manage-bookings.jsp").forward(req, res);
    }

    private void handleFacilities(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String typeFilter   = req.getParameter("type");
        String statusFilter = req.getParameter("status");
        String search       = req.getParameter("q");
        List<TblFacilities> facilities = facilityDAO.findAll();
        if (typeFilter!=null && !typeFilter.equals("ALL"))
            facilities = facilities.stream().filter(f -> f.getFacilityType().equals(typeFilter)).toList();
        if (statusFilter!=null && !statusFilter.equals("ALL"))
            facilities = facilities.stream().filter(f -> f.getStatus().equals(statusFilter)).toList();
        if (search!=null && !search.isBlank()) {
            String q = search.toLowerCase();
            facilities = facilities.stream()
                .filter(f -> f.getServiceName().toLowerCase().contains(q) || f.getServiceCode().toLowerCase().contains(q)).toList();
        }
        req.setAttribute("facilities",     facilities);
        req.setAttribute("typeFilter",     typeFilter!=null   ? typeFilter   : "ALL");
        req.setAttribute("statusFilter",   statusFilter!=null ? statusFilter : "ALL");
        req.setAttribute("search",         search);
        req.setAttribute("cntAvailable",   facilityDAO.countByStatus("AVAILABLE"));
        req.setAttribute("cntOccupied",    facilityDAO.countByStatus("OCCUPIED"));
        req.setAttribute("cntCleaning",    facilityDAO.countByStatus("CLEANING"));
        req.setAttribute("cntMaintenance", facilityDAO.countByStatus("MAINTENANCE"));
        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash!=null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }
        req.getRequestDispatcher("/WEB-INF/dashboard/manage-facilities.jsp").forward(req, res);
    }

    private void handleContracts(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String status = req.getParameter("status");
        String search = req.getParameter("q");
        List<VwContracts> contracts = (status!=null && !status.equals("ALL"))
            ? contractDAO.findByStatus(status) : contractDAO.findAll_View();
        if (search!=null && !search.isBlank()) {
            String q = search.toLowerCase();
            contracts = contracts.stream()
                .filter(c -> c.getContractId().toLowerCase().contains(q)
                    || (c.getCustomerName()!=null && c.getCustomerName().toLowerCase().contains(q)))
                .toList();
        }
        req.setAttribute("contracts",    contracts);
        req.setAttribute("statusFilter", status!=null ? status : "ALL");
        req.setAttribute("search",       search);
        req.setAttribute("cntDraft",     contractDAO.countByStatus("DRAFT"));
        req.setAttribute("cntActive",    contractDAO.countByStatus("ACTIVE"));
        req.setAttribute("cntCompleted", contractDAO.countByStatus("COMPLETED"));
        String flash = (String) req.getSession().getAttribute("flashMsg");
        if (flash!=null) { req.setAttribute("flashMsg", flash); req.getSession().removeAttribute("flashMsg"); }
        req.getRequestDispatcher("/WEB-INF/dashboard/manage-contracts.jsp").forward(req, res);
    }

    private boolean checkAuth(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session==null || !(session.getAttribute("account") instanceof TblEmployees)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}