package model;


import java.sql.*;
import java.util.*;

public class StudentDAO {

    public boolean insert(Book s) {
        String sql = "INSERT INTO BooKing (Carname, StartDate, ReturnDate,Amount,Statuss) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getCarname());
            ps.setString(2, s.getStartDate());
            ps.setString(3, s.getReturnDate());
            ps.setInt(4, s.getAmount());
             ps.setString(5, s.getStatuss());
          
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Book> getAllStudents() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.BooKing";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Book(
                        rs.getInt("CarID"),
                        rs.getString("Carname"),
                        rs.getString("StartDate"),
                        rs.getString("ReturnDate"),
                        rs.getInt("Amount"),
                        rs.getString("Statuss")
                        
                       ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
