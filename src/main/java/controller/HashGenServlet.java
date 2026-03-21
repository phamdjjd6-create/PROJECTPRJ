package controller;

import at.favre.lib.crypto.bcrypt.BCrypt;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/hashgen")
public class HashGenServlet extends HttpServlet {

    private static final String JDBC_URL  = "jdbc:sqlserver://localhost:1433;databaseName=ResortDB;encrypt=true;trustServerCertificate=true";
    private static final String JDBC_USER = "sa";
    private static final String JDBC_PASS = "123";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = res.getWriter();

        String pw = "123456";
        String hash = BCrypt.withDefaults().hashToString(10, pw.toCharArray());
        boolean ok = BCrypt.verifyer().verify(pw.toCharArray(), hash).verified;

        out.println("New hash   : " + hash);
        out.println("Verify ok  : " + ok);

        // Tự động update tất cả accounts trong DB
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
                 PreparedStatement ps = conn.prepareStatement(
                     "UPDATE tbl_persons SET password_hash = ?")) {
                ps.setString(1, hash);
                int rows = ps.executeUpdate();
                out.println("Updated rows: " + rows);
                out.println("DONE — all accounts now use password: " + pw);
            }
        } catch (Exception e) {
            out.println("DB Error: " + e.getMessage());
        }
    }
}
