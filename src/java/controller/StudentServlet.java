package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Book;

import model.StudentDAO;

@WebServlet(name = "StudentServlet", urlPatterns = { "/students" })
public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        StudentDAO dao = new StudentDAO();

        if (action == null || action.isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        switch (action) {
            case "ls":
                List<Book> list = dao.getAllStudents();
                request.setAttribute("students", list);
                request.getRequestDispatcher("/WEB-INF/students.jsp").forward(request, response);
                break;
            case "add":
                request.getRequestDispatcher("/add.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//
        String action = request.getParameter("action");
        StudentDAO dao = new StudentDAO(); // đỏi tên chú ý

        String name = request.getParameter("Carname");
        String strat = request.getParameter("StartDate");
        String endaate = request.getParameter("ReturnDate");
          String amount = request.getParameter("Amount");
                    String stass = request.getParameter("Statuss");
        
        try {
           int agee = Integer.parseInt(amount);
           
            
            Book s = new Book(0, name,strat ,endaate, agee,stass);
            dao.insert(s);
        } catch (NumberFormatException e) {
        }

        response.sendRedirect("students?action=ls");
    }
}
