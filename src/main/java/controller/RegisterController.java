package controller;

import DAO.AccountDAO;
import at.favre.lib.crypto.bcrypt.BCrypt;
import java.io.IOException;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TblPersons;

@WebServlet(name = "RegisterController", urlPatterns = { "/register" })
public class RegisterController extends HttpServlet {

    private final AccountDAO dao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ── Lấy dữ liệu từ form ─────────────────────────────────
        String username = trim(request.getParameter("username"));
        String fullName = trim(request.getParameter("fullName"));
        String phone = trim(request.getParameter("phone"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String confPassword = request.getParameter("confPass");

        // ── Validate bắt buộc ────────────────────────────────────
        if (username.isEmpty() || fullName.isEmpty() || email.isEmpty()
                || password == null || password.isEmpty()) {
            error(request, response, "Vui lòng điền đầy đủ thông tin bắt buộc!");
            return;
        }

        if (password.length() < 6) {
            error(request, response, "Mật khẩu phải có ít nhất 6 ký tự!");
            return;
        }

        if (!password.equals(confPassword)) {
            error(request, response, "Mật khẩu xác nhận không khớp! Vui lòng thử lại.");
            return;
        }

        // ── Kiểm tra account đã tồn tại chưa ────────────────────
        if (dao.findByUsername(username) != null) {
            error(request, response, "Tên tài khoản \"" + username + "\" đã được sử dụng. Vui lòng chọn tên khác!");
            return;
        }

        // ── Kiểm tra email đã tồn tại chưa ──────────────────────
        if (dao.findByEmail(email) != null) {
            error(request, response, "Email \"" + email + "\" đã được đăng ký. Vui lòng dùng email khác!");
            return;
        }

        // ── Mã hóa mật khẩu bằng BCrypt ─────────────────────────
        String hashedPassword = BCrypt.withDefaults()
                .hashToString(12, password.toCharArray());

        // ── Tạo đối tượng TblPersons ─────────────────────────────
        TblPersons person = new TblPersons();
        person.setAccount(username);
        person.setFullName(fullName);
        person.setPhoneNumber(phone.isEmpty() ? null : phone); 
        person.setEmail(email);
        person.setPasswordHash(hashedPassword);
        person.setPersonType("CUSTOMER");
        person.setCreatedAt(new Date());
        person.setUpdatedAt(new Date());
        person.setIsDeleted(false);

        // ── Lưu vào database ─────────────────────────────────────
        boolean success = dao.registerCustomer(person);

        if (success) {
            // Redirect về trang login với query param 'registered'
            // để login.jsp hiển thị thông báo thành công
            response.sendRedirect("login?registered=1");
        } else {
            error(request, response, "Đã xảy ra lỗi khi lưu dữ liệu. Vui lòng thử lại sau!");
        }
    }
    
    

    // ── Helper ───────────────────────────────────────────────────
    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }

    private void error(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}
