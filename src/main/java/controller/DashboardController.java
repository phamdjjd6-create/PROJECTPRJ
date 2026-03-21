package controller;

import DAO.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/dashboard/staff", "/dashboard/admin"})
public class DashboardController extends HttpServlet {

    private final BookingDAO  bookingDAO  = new BookingDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();
    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        TblPersons acc = (TblPersons) session.getAttribute("account");
        if (!(acc instanceof TblEmployees)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        TblEmployees emp = (TblEmployees) acc;
        String path = request.getServletPath();

        if ("/dashboard/admin".equals(path) && !"ADMIN".equals(emp.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard/staff");
            return;
        }

        // ── Stats chung ──────────────────────────────────────────
        try {
            request.setAttribute("cntPending",   bookingDAO.countByStatus("PENDING"));
            request.setAttribute("cntCheckedIn", bookingDAO.countByStatus("CHECKED_IN"));
            request.setAttribute("cntAvailable", facilityDAO.countByStatus("AVAILABLE"));
            request.setAttribute("cntActiveContracts", contractDAO.countByStatus("ACTIVE"));

            List<VwBookings> recentBookings = bookingDAO.findRecent(8);
            request.setAttribute("recentBookings", recentBookings);
        } catch (Exception e) { e.printStackTrace(); }

        if ("/dashboard/admin".equals(path)) {
            try {
                request.setAttribute("totalCustomers", customerDAO.count());
                request.setAttribute("totalEmployees", employeeDAO.findAll().size());
                request.setAttribute("employees", employeeDAO.findAll());
                request.setAttribute("cntDraftContracts", contractDAO.countByStatus("DRAFT"));
            } catch (Exception e) { e.printStackTrace(); }

            request.getRequestDispatcher("/WEB-INF/dashboard/admin.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/dashboard/staff.jsp").forward(request, response);
        }
    }
}
