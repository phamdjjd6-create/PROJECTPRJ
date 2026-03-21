package controller;

import DAO.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TblPersons;
import model.VwContracts;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ContractController", urlPatterns = {"/contracts"})
public class ContractController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        TblPersons currentUser = (TblPersons) session.getAttribute("account");
        String customerId = currentUser.getId();

        try {
            List<VwContracts> contracts = contractDAO.findByCustomerId(customerId);
            request.setAttribute("contracts", contracts);
        } catch (Throwable ex) {
            Throwable cause = ex.getCause() != null ? ex.getCause() : ex;
            request.setAttribute("contractError", "[" + ex.getClass().getSimpleName() + "] " + cause.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/contracts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add_payment".equals(action)) {
            String contractId = request.getParameter("contractId");
            String amountStr  = request.getParameter("amount");
            String method     = request.getParameter("method");
            String note       = request.getParameter("note");

            try {
                java.math.BigDecimal amount = new java.math.BigDecimal(amountStr.replaceAll("[^0-9.]", ""));
                if (amount.compareTo(java.math.BigDecimal.ZERO) <= 0) throw new Exception("Số tiền phải lớn hơn 0");

                String result = contractDAO.addPayment(contractId, amount, method, note);
                if (result.startsWith("OK:")) {
                    String[] parts = result.split(":");
                    boolean completed = "COMPLETED".equals(parts.length > 2 ? parts[2] : "");
                    session.setAttribute("paymentFlash",
                        completed ? "✅ Thanh toán đủ! Hợp đồng " + contractId + " đã hoàn thành."
                                  : "✅ Đã ghi nhận thanh toán cho hợp đồng " + contractId);
                } else {
                    session.setAttribute("paymentFlash", "❌ " + result.replace("ERROR:", ""));
                }
            } catch (Exception e) {
                session.setAttribute("paymentFlash", "❌ Lỗi: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/contracts");
    }
}
