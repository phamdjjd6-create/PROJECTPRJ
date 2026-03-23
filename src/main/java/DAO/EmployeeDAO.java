package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblEmployees;
import model.VwEmployees;

public class EmployeeDAO {

    // ── Lấy danh sách từ View ─────────────────────────────────────
    public List<VwEmployees> findAll() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT e FROM VwEmployees e", VwEmployees.class)
                    .getResultList();
        } finally { em.close(); }
    }

    // ── Lấy danh sách entity thật ─────────────────────────────────
    public List<TblEmployees> findAllEntities() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery(
                "SELECT e FROM TblEmployees e WHERE e.deleted = false",
                TblEmployees.class).getResultList();
        } finally { em.close(); }
    }

    // ── Tìm theo ID ───────────────────────────────────────────────
    public TblEmployees findById(String id) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(TblEmployees.class, id);
        } finally { em.close(); }
    }

    // ── Đếm tổng nhân viên ───────────────────────────────────────
    public long count() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return (long) em.createQuery(
                "SELECT COUNT(e) FROM TblEmployees e WHERE e.deleted = false")
                .getSingleResult();
        } finally { em.close(); }
    }

    // ── Lưu (thêm mới hoặc cập nhật) ─────────────────────────────
    public void save(TblEmployees employee) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            if (em.find(TblEmployees.class, employee.getId()) == null) {
                em.persist(employee);
            } else {
                em.merge(employee);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally { em.close(); }
    }

    // ── Cập nhật lương ────────────────────────────────────────────
    public boolean updateSalary(String id, java.math.BigDecimal salary) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblEmployees e = em.find(TblEmployees.class, id);
            if (e == null) return false;
            e.setSalary(salary);
            em.merge(e);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }

    // ── Cập nhật chức vụ ──────────────────────────────────────────
    public boolean updatePosition(String id, String position) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblEmployees e = em.find(TblEmployees.class, id);
            if (e == null) return false;
            e.setPosition(position);
            em.merge(e);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }

    // ── Cập nhật role (ADMIN only) ────────────────────────────────
    public boolean updateRole(String id, String role) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblEmployees e = em.find(TblEmployees.class, id);
            if (e == null) return false;
            e.setRole(role);
            em.merge(e);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }

    // ── Cập nhật thông tin cá nhân (tbl_persons) ──────────────────
    public boolean updatePersonInfo(String id, String fullName, String email) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            model.TblPersons p = em.find(model.TblPersons.class, id);
            if (p == null) return false;
            if (fullName != null && !fullName.isBlank()) p.setFullName(fullName.trim());
            if (email    != null && !email.isBlank())    p.setEmail(email.trim());
            p.setUpdatedAt(new java.util.Date());
            em.merge(p);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }

    // ── Cập nhật phòng ban ────────────────────────────────────────
    public boolean updateDept(String id, String deptId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblEmployees e = em.find(TblEmployees.class, id);
            if (e == null) return false;
            if (deptId != null && !deptId.isBlank()) {
                model.TblDepartments dept = em.find(model.TblDepartments.class, deptId);
                e.setDeptId(dept);
            }
            em.merge(e);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }

    // ── Cập nhật trạng thái active ────────────────────────────────
    public boolean updateActive(String id, boolean isActive) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblEmployees e = em.find(TblEmployees.class, id);
            if (e == null) return false;
            e.setIsActive(isActive);
            em.merge(e);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }

    // ── Lấy danh sách phòng ban ───────────────────────────────────
    public List<model.TblDepartments> findAllDepts() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT d FROM TblDepartments d", model.TblDepartments.class)
                    .getResultList();
        } finally { em.close(); }
    }

    // ── Vô hiệu hóa nhân viên (soft delete) ──────────────────────
    public boolean deactivate(String id) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblEmployees e = em.find(TblEmployees.class, id);
            if (e == null) return false;
            e.setIsActive(false);
            em.merge(e);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }

    // ── Xóa hẳn nhân viên (hard delete) ──────────────────────────
    public boolean hardDelete(String id) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblEmployees e = em.find(TblEmployees.class, id);
            if (e != null) em.remove(e);
            model.TblPersons p = em.find(model.TblPersons.class, id);
            if (p != null) em.remove(p);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }
}
