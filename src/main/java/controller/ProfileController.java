package controller;

import DAO.AccountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.TblPersons;
import model.TblCustomers;
import DAO.CustomerDAO;
import service.LoyaltyService;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private LoyaltyService loyaltyService = new LoyaltyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        TblPersons account = (TblPersons) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Fetch the latest details of the user from the DB
        TblPersons updatedPerson = accountDAO.findByUsername(account.getAccount());
        if(updatedPerson != null) {
             session.setAttribute("account", updatedPerson);
             
             // ── Fetch Loyalty Data ──
             TblCustomers customer = customerDAO.findById(updatedPerson.getId());
             if (customer != null) {
                 request.setAttribute("customerData", customer);
                 request.setAttribute("membershipTier", loyaltyService.calculateTier(customer));
             }
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        TblPersons currentUser = (TblPersons) session.getAttribute("account");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // ── Change Password ──────────────────────────────────────────────────
        if ("change_password".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword     = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            try {
                if (newPassword == null || newPassword.length() < 6) {
                    request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 6 ký tự.");
                } else if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
                } else {
                    // Verify current password
                    boolean verified = at.favre.lib.crypto.bcrypt.BCrypt.verifyer()
                        .verify(currentPassword.toCharArray(), currentUser.getPasswordHash()).verified;
                    if (!verified) {
                        request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                    } else {
                        String hashed = at.favre.lib.crypto.bcrypt.BCrypt.withDefaults()
                            .hashToString(12, newPassword.toCharArray());
                        currentUser.setPasswordHash(hashed);
                        accountDAO.updatePerson(currentUser);
                        session.setAttribute("account", currentUser);
                        request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi đổi mật khẩu: " + e.getMessage());
            }
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        String fullName = request.getParameter("fullName");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String phoneNumber = request.getParameter("phoneNumber");
        String idCard = request.getParameter("idCard");
        String email = request.getParameter("email");

        try {
            // Update the entity
            currentUser.setFullName(fullName);
            currentUser.setGender(gender);
            currentUser.setPhoneNumber(phoneNumber);
            currentUser.setIdCard(idCard);
            currentUser.setEmail(email);

            if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dob = sdf.parse(dateOfBirthStr);

                // Check if user is at least 18
                java.util.Calendar dobCal = java.util.Calendar.getInstance();
                dobCal.setTime(dob);
                
                java.util.Calendar today = java.util.Calendar.getInstance();
                int age = today.get(java.util.Calendar.YEAR) - dobCal.get(java.util.Calendar.YEAR);
                if (today.get(java.util.Calendar.DAY_OF_YEAR) < dobCal.get(java.util.Calendar.DAY_OF_YEAR)){
                    age--;
                }

                if (age < 18) {
                    request.setAttribute("errorMessage", "Xin lỗi, bạn phải đủ 18 tuổi.");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                    return;
                }

                currentUser.setDateOfBirth(dob);
            }

            currentUser.setUpdatedAt(new Date());

            // Save to DB
            boolean isUpdated = accountDAO.updatePerson(currentUser);

            if (isUpdated) {
                // Update session object
                session.setAttribute("account", currentUser);
                request.setAttribute("successMessage", "Cập nhật hồ sơ thành công!");
            } else {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi cập nhật hồ sơ!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Dữ liệu nhập vào không hợp lệ!");
        }

        // Forward back to profile page
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
