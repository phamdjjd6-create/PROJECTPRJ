package DAO;

import jakarta.persistence.EntityManager;
import java.math.BigDecimal;

import model.TblCustomers;
import model.TblPersons;

/**
 * DAO xử lý tài khoản — đăng ký & tìm kiếm người dùng
 */
public class AccountDAO {


    // Use JpaUtil for centralized EntityManagerFactory
    // ── Tìm theo account (username) ─────────────────────────────-
    // Dùng createQuery (JPQL): tên class Java, không phải tên bảng
    public TblPersons findByUsername(String username) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM TblPersons p WHERE p.account = :username",
                    TblPersons.class)
                    .setParameter("username", username)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);
        } finally {
            em.close();
        }
    }

    // ── Tìm theo email ──────────────────────────────────────────-
    public TblPersons findByEmail(String email) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM TblPersons p WHERE p.email = :email",
                    TblPersons.class)
                    .setParameter("email", email)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);
        } finally {
            em.close();
        }
    }

    /**
     * Đăng ký khách hàng mới dùng em.persist() (JPA chuẩn).
     *
     * Hoạt động được vì TblPersons có @DiscriminatorValue("CUSTOMER")
     * → JPA tự gán person_type = 'CUSTOMER' khi INSERT.
     *
     * @return true nếu thành công
     */
    public boolean registerCustomer(TblPersons person) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            // Tạo ID dạng KHxxx
            String newId = generateCustomerId(em);
            person.setId(newId);

            // 1. persist vào tbl_persons — JPA tự set person_type='CUSTOMER'
            em.persist(person);
            em.flush(); // đảm bảo INSERT xong trước khi persist TblCustomers

            // 2. persist vào tbl_customers
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

    // ── Tạo ID khách hàng tự động: KH001, KH002, ... ────────────
    // Dùng createQuery (JPQL) để lấy ID lớn nhất
    private String generateCustomerId(EntityManager em) {
        try {
            // Lấy tất cả ID của CUSTOMER, tìm số lớn nhất
            java.util.List<String> ids = em.createQuery(
                    "SELECT p.id FROM TblPersons p WHERE p.id LIKE 'KH%'",
                    String.class)
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
}
