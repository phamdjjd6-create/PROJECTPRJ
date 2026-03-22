package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblContracts;

public class ContractDAO {
    public List<TblContracts> findAll() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT c FROM TblContracts c", TblContracts.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<model.VwContracts> findByCustomerId(String customerId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery(
                "SELECT v FROM VwContracts v WHERE v.customerId = :cid ORDER BY v.signedDate DESC",
                model.VwContracts.class)
                .setParameter("cid", customerId)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public TblContracts findById(String id) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(TblContracts.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblContracts contract) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            if (em.find(TblContracts.class, contract.getContractId()) == null) {
                em.persist(contract);
            } else {
                em.merge(contract);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Tạo contract khi admin duyệt booking.
     * Tính tổng tiền từ facility cost * số đêm.
     */
    public TblContracts createForBooking(String bookingId, String employeeId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            model.TblBookings bk = em.find(model.TblBookings.class, bookingId);
            if (bk == null) throw new RuntimeException("Booking không tồn tại: " + bookingId);

            // Kiểm tra đã có contract chưa
            List<TblContracts> existing = em.createQuery(
                "SELECT c FROM TblContracts c WHERE c.bookingId.bookingId = :bid", TblContracts.class)
                .setParameter("bid", bookingId).getResultList();
            if (!existing.isEmpty()) {
                em.getTransaction().rollback();
                return existing.get(0); // đã có rồi
            }

            // Tính số đêm
            long diffMs = bk.getEndDate().getTime() - bk.getStartDate().getTime();
            int nights = (int) java.util.concurrent.TimeUnit.DAYS.convert(diffMs, java.util.concurrent.TimeUnit.MILLISECONDS);
            if (nights <= 0) nights = 1;

            java.math.BigDecimal total = bk.getFacilityId().getCost()
                .multiply(new java.math.BigDecimal(nights));

            TblContracts contract = new TblContracts();
            contract.setContractId("CT" + System.currentTimeMillis() % 10000000);
            contract.setBookingId(bk);
            contract.setDeposit(java.math.BigDecimal.ZERO);
            contract.setTotalPayment(total);
            contract.setPaidAmount(java.math.BigDecimal.ZERO);
            contract.setStatus("DRAFT");
            contract.setSignedDate(new java.util.Date());

            if (employeeId != null) {
                model.TblEmployees emp = em.find(model.TblEmployees.class, employeeId);
                if (emp != null) contract.setEmployeeId(emp);
            }

            em.persist(contract);
            em.getTransaction().commit();
            return contract;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException(e);
        } finally {
            em.close();
        }
    }

    public List<model.VwContracts> findAll_View() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT v FROM VwContracts v ORDER BY v.signedDate DESC", model.VwContracts.class)
                    .getResultList();
        } finally { em.close(); }
    }

    public List<model.VwContracts> findByStatus(String status) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.createQuery("SELECT v FROM VwContracts v WHERE v.status = :s ORDER BY v.signedDate DESC", model.VwContracts.class)
                    .setParameter("s", status).getResultList();
        } finally { em.close(); }
    }

    public long countByStatus(String status) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(c) FROM TblContracts c WHERE c.status = :s")
                    .setParameter("s", status).getSingleResult();
        } finally { em.close(); }
    }

    /** Duyệt hợp đồng: DRAFT → ACTIVE (nếu có cọc) hoặc giữ DRAFT (chưa cọc) */
    public String approve(String contractId, String employeeId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) return "Không tìm thấy hợp đồng";
            java.math.BigDecimal zero = java.math.BigDecimal.ZERO;
            boolean hasDeposit = c.getDeposit() != null && c.getDeposit().compareTo(zero) > 0;
            if (hasDeposit) {
                c.setStatus("ACTIVE");
                c.setSignedDate(new java.util.Date());
                if (employeeId != null) {
                    model.TblEmployees emp = em.find(model.TblEmployees.class, employeeId);
                    if (emp != null) c.setEmployeeId(emp);
                }
                em.merge(c);
                em.getTransaction().commit();
                return "APPROVED";
            } else {
                em.getTransaction().rollback();
                return "PENDING_DEPOSIT";
            }
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return "ERROR: " + e.getMessage();
        } finally { em.close(); }
    }

    /**
     * Xác nhận đặt cọc: tính tiền cọc theo loại facility
     * VILLA (VL*)=50%, HOUSE (HS*)=40%, ROOM (RM*)=30%
     * Cập nhật deposit, paidAmount, status → ACTIVE
     */
    public String confirmDeposit(String contractId, String employeeId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) return "Không tìm thấy hợp đồng";

            String facilityCode = c.getBookingId().getFacilityId().getServiceCode().toUpperCase();
            String facilityType;
            java.math.BigDecimal rate;
            if (facilityCode.startsWith("VL")) {
                facilityType = "VILLA"; rate = new java.math.BigDecimal("0.50");
            } else if (facilityCode.startsWith("HS")) {
                facilityType = "HOUSE"; rate = new java.math.BigDecimal("0.40");
            } else {
                facilityType = "ROOM";  rate = new java.math.BigDecimal("0.30");
            }

            java.math.BigDecimal depositAmt = c.getTotalPayment().multiply(rate)
                .setScale(0, java.math.RoundingMode.HALF_UP);

            c.setDeposit(depositAmt);
            c.setPaidAmount(depositAmt);
            c.setStatus("ACTIVE");
            c.setSignedDate(new java.util.Date());

            if (employeeId != null) {
                model.TblEmployees emp = em.find(model.TblEmployees.class, employeeId);
                if (emp != null) c.setEmployeeId(emp);
            }

            c.getBookingId().setStatus("CONFIRMED");
            em.merge(c.getBookingId());
            em.merge(c);
            em.getTransaction().commit();
            return "OK:" + depositAmt.toPlainString() + ":" + facilityType;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return "ERROR: " + e.getMessage();
        } finally {
            em.close();
        }
    }

    /**
     * Thanh toán thêm: cộng amount vào paidAmount.
     * Nếu paidAmount >= totalPayment → status = COMPLETED
     * Trả về số tiền còn lại sau khi thanh toán
     */
    public String addPayment(String contractId, java.math.BigDecimal amount, String method, String note) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) return "ERROR:Không tìm thấy hợp đồng";
            if (!"ACTIVE".equals(c.getStatus())) return "ERROR:Hợp đồng không ở trạng thái hiệu lực";

            java.math.BigDecimal newPaid = c.getPaidAmount().add(amount);
            // Không cho trả vượt quá tổng
            if (newPaid.compareTo(c.getTotalPayment()) > 0) newPaid = c.getTotalPayment();
            c.setPaidAmount(newPaid);

            boolean completed = newPaid.compareTo(c.getTotalPayment()) >= 0;
            if (completed) c.setStatus("COMPLETED");

            // Ghi vào tbl_payments
            model.TblPayments payment = new model.TblPayments();
            payment.setAmount(amount);
            payment.setPaymentDate(new java.util.Date());
            payment.setPaymentMethod(method != null ? method : "CASH");
            payment.setNote(note);
            payment.setContractId(c);
            em.persist(payment);

            em.merge(c);
            em.getTransaction().commit();

            java.math.BigDecimal remaining = c.getTotalPayment().subtract(newPaid);
            return "OK:" + remaining.toPlainString() + ":" + (completed ? "COMPLETED" : "ACTIVE");
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return "ERROR:" + e.getMessage();
        } finally {
            em.close();
        }
    }

    /** Hủy contract theo bookingId (dùng khi khách hủy booking) */
    public void cancelByBookingId(String bookingId) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            List<TblContracts> list = em.createQuery(
                "SELECT c FROM TblContracts c WHERE c.bookingId.bookingId = :bid", TblContracts.class)
                .setParameter("bid", bookingId)
                .getResultList();
            for (TblContracts c : list) {
                c.setStatus("CANCELLED");
                em.merge(c);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("cancelByBookingId failed: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public boolean updateStatus(String contractId, String newStatus) {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) return false;
            c.setStatus(newStatus);
            em.merge(c);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally { em.close(); }
    }
    public java.math.BigDecimal getTotalRevenue() {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            java.math.BigDecimal total = (java.math.BigDecimal) em.createQuery(
                "SELECT SUM(c.paidAmount) FROM TblContracts c WHERE c.status IN ('ACTIVE', 'COMPLETED')")
                .getSingleResult();
            return total != null ? total : java.math.BigDecimal.ZERO;
        } finally { em.close(); }
    }
}
