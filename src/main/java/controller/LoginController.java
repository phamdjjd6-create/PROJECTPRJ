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
        TblPersons acc = null;
        try {
            acc = dao.findByUsername(username);
        } catch (Exception ex) {
            ex.printStackTrace();
            error(request, response, "Lỗi DB: " + ex.getClass().getSimpleName() + " — " + ex.getMessage());
            return;
        }

        // ── Kiểm tra tồn tại ────────────────────────────────────
        if (acc == null) {
            error(request, response, "Không tìm thấy tài khoản: \"" + username + "\"");
            return;
        }
        if (acc.getPasswordHash() == null) {
            error(request, response, "Tài khoản chưa có mật khẩu. Liên hệ quản trị viên.");
            return;
        }

        // ── BCrypt verify ────────────────────────────────────────
        boolean pwdOk;
        try {
            String storedHash = acc.getPasswordHash();
            // Thử BCrypt trước
            if (storedHash != null && storedHash.startsWith("$2")) {
                pwdOk = BCrypt.verifyer().verify(password.toCharArray(), storedHash).verified;
            } else {
                // Fallback: plain text (chỉ dùng khi chưa hash)
                pwdOk = password.equals(storedHash);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            error(request, response, "Lỗi BCrypt: " + ex.getMessage());
            return;
        }
        if (!pwdOk) {
            error(request, response, "Sai mật khẩu! Hash trong DB: " + acc.getPasswordHash().substring(0, 29) + "...");
            return;
        }

        // ── Kiểm tra tài khoản bị khóa (soft-delete) ────────────
        if (acc.isDeleted()) {
            error(request, response, "Tài khoản đã bị vô hiệu hóa. Vui lòng liên hệ quản trị viên.");
            return;
        }

        // ── Tạo session lưu thông tin đăng nhập ─────────────────
        HttpSession session = request.getSession(true);
        session.setAttribute("account", acc);
        session.setAttribute("userId", acc.getId());
        session.setAttribute("fullName", acc.getFullName());

        // personType: ưu tiên từ instanceof (tránh null khi EclipseLink không populate discriminator)
        String role = (acc instanceof model.TblEmployees) ? "EMPLOYEE" : "CUSTOMER";
        session.setAttribute("personType", role);

        // ── Phân quyền redirect ──────────────────────────────────
        redirectByRole(session, response);
    }

    /**
     * Redirect về đúng trang theo role:
     * - CUSTOMER → /
     * - EMPLOYEE STAFF → /dashboard/staff
     * - EMPLOYEE ADMIN → /dashboard/admin
     */
    private void redirectByRole(HttpSession session, HttpServletResponse response)
            throws IOException {

        TblPersons acc = (TblPersons) session.getAttribute("account");
        if (acc == null) {
            response.sendRedirect("login");
            return;
        }

        if (acc instanceof model.TblEmployees) {
            model.TblEmployees emp = (model.TblEmployees) acc;
            if ("ADMIN".equals(emp.getRole())) {
                response.sendRedirect("dashboard/admin");
            } else {
                response.sendRedirect("dashboard/staff");
            }
        } else {
            response.sendRedirect("index.jsp");
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
