package DAO;

import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.TblCustomers;
import model.TblEmployees;
import model.TblPersons;

/**
 * DAO xử lý tài khoản — đăng ký & tìm kiếm người dùng
 *
 * Chiến lược login:
 *  1. Dùng JDBC thuần để lấy id + person_type (tránh vấn đề JOINED inheritance của EclipseLink)
 *  2. Dùng em.find(TblEmployees/TblCustomers, id) để load entity đúng subclass
 */
public class AccountDAO {

    // ── JDBC connection string (khớp với persistence.xml) ────────
    private static final String JDBC_URL  = "jdbc:sqlserver://localhost:1433;databaseName=ResortDB;encrypt=true;trustServerCertificate=true";
    private static final String JDBC_USER = "sa";
    private static final String JDBC_PASS = "123";

    // ── Tìm theo account (username) ──────────────────────────────
    public TblPersons findByUsername(String username) {
        return findByColumn("account", username);
    }

    public TblPersons findByEmail(String email) {
        return findByColumn("email", email);
    }

    /**
     * Bước 1: JDBC thuần → lấy id + person_type
     * Bước 2: em.find() đúng subclass → entity đầy đủ
     */
    private TblPersons findByColumn(String column, String value) {
        String id = null;
        String personType = null;

        String sql = "SELECT id, person_type FROM tbl_persons WHERE " + column + " = ?";
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    id         = rs.getString("id");
                    personType = rs.getString("person_type");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        if (id == null) return null;

        // Bước 2: load entity đúng subclass để tránh EclipseLink JOINED inheritance issue
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            if ("EMPLOYEE".equals(personType)) {
                // TblEmployees extends TblPersons → find trả về TblPersons (subclass)
                return em.find(TblEmployees.class, id);
            } else {
                // TblCustomers KHÔNG extends TblPersons → find TblPersons trực tiếp
                return em.find(TblPersons.class, id);
            }
        } finally {
            em.close();
        }
    }

    /**
     * Đăng ký khách hàng mới dùng em.persist() (JPA chuẩn).
     */
    public boolean registerCustomer(TblPersons person) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            String newId = generateCustomerId(em);
            person.setId(newId);

            em.persist(person);
            em.flush();

            TblCustomers customer = new TblCustomers();
            customer.setId(newId);
            customer.setTypeCustomer("Normal");
            customer.setLoyaltyPoints(0);
            customer.setTotalSpent(BigDecimal.ZERO);
            em.persist(customer);

            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    private String generateCustomerId(EntityManager em) {
        try {
            java.util.List<String> ids = em.createQuery(
                    "SELECT p.id FROM TblPersons p WHERE p.id LIKE 'KH%'", String.class)
                    .getResultList();
            int max = 0;
            for (String id : ids) {
                try {
                    int n = Integer.parseInt(id.substring(2));
                    if (n > max) max = n;
                } catch (NumberFormatException ignored) {}
            }
            return String.format("KH%03d", max + 1);
        } catch (Exception e) {
            return "KH001";
        }
    }

    public boolean updatePerson(TblPersons person) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(person);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}
