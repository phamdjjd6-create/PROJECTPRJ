package controller;

import DAO.AccountDAO;
import at.favre.lib.crypto.bcrypt.BCrypt;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TblPersons;

@WebServlet(name = "LoginController", urlPatterns = { "/login" })
public class LoginController extends HttpServlet {

    private final AccountDAO dao = new AccountDAO();

    // GET: hiển thị trang đăng nhập
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu đã đăng nhập rồi → redirect thẳng vào dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            redirectByRole(session, response);
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // POST: xử lý đăng nhập
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");

        // ── Validate cơ bản ──────────────────────────────────────
        if (username.isEmpty() || password == null || password.isEmpty()) {
            error(request, response, "Vui lòng nhập tên tài khoản và mật khẩu!");
            return;
        }

        // ── Tìm tài khoản trong DB ───────────────────────────────
        TblPersons acc = dao.findByUsername(username);

        // ── Kiểm tra tồn tại & BCrypt verify ────────────────────
        if (acc == null || !BCrypt.verifyer()
                .verify(password.toCharArray(), acc.getPasswordHash()).verified) {
            error(request, response, "Tên tài khoản hoặc mật khẩu không đúng!");
            return;
        }

        // ── Kiểm tra tài khoản bị khóa (soft-delete) ────────────
        if (acc.isIsDeleted()) {
            error(request, response, "Tài khoản đã bị vô hiệu hóa. Vui lòng liên hệ quản trị viên.");
            return;
        }

        // ── Tạo session lưu thông tin đăng nhập ─────────────────
        HttpSession session = request.getSession(true);
        session.setAttribute("account", acc);
        session.setAttribute("userId", acc.getId());
        session.setAttribute("fullName", acc.getFullName());
        session.setAttribute("personType", acc.getPersonType()); // EMPLOYEE | CUSTOMER

        // ── Phân quyền redirect ──────────────────────────────────
        redirectByRole(session, response);
    }

    /**
     * Redirect về đúng dashboard theo role:
     * - CUSTOMER → index.jsp (trang đặt phòng)
     * - EMPLOYEE (STAFF) → dashboard/staff.jsp
     * - EMPLOYEE (ADMIN) → dashboard/admin.jsp
     */
    private void redirectByRole(HttpSession session, HttpServletResponse response)
            throws IOException {

        TblPersons acc = (TblPersons) session.getAttribute("account");
        if (acc == null) {
            response.sendRedirect("login");
            return;
        }

        String personType = acc.getPersonType();
        if ("CUSTOMER".equals(personType)) {
            response.sendRedirect("index.jsp");
        } else {
            // Nhân viên — cần load thêm role từ DB nếu cần phân biệt ADMIN/STAFF
            // Tạm thời redirect về staff dashboard
            response.sendRedirect("dashboard/staff.jsp");
        }
    }

    // ── Helpers ──────────────────────────────────────────────────
    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }

    private void error(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }
}
