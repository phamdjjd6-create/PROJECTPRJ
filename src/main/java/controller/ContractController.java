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
}
