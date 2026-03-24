package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblContracts;

public class ContractDAO extends BaseDAO {

    public ContractDAO() {
        super();
    }

    public ContractDAO(EntityManager em) {
        super(em);
    }

    public List<TblContracts> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT c FROM TblContracts c", TblContracts.class)
                    .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public List<model.VwContracts> findByCustomerId(String customerId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                "SELECT v FROM VwContracts v WHERE v.customerId = :cid ORDER BY v.signedDate DESC",
                model.VwContracts.class)
                .setParameter("cid", customerId)
                .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public TblContracts findById(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(TblContracts.class, id);
        } finally {
            closeIfLocal(em);
        }
    }

    public void save(TblContracts contract) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            if (em.find(TblContracts.class, contract.getContractId()) == null) {
                em.persist(contract);
            } else {
                em.merge(contract);
            }
            if (isLocal) em.getTransaction().commit();
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            closeIfLocal(em);
        }
    }

    /**
     * Tạo contract khi admin duyệt booking.
     * Tính tổng tiền từ facility cost * số đêm.
     */
    public TblContracts createForBooking(String bookingId, String employeeId) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            model.TblBookings bk = em.find(model.TblBookings.class, bookingId);
            if (bk == null) throw new RuntimeException("Booking không tồn tại: " + bookingId);

            // Kiểm tra đã có contract chưa
            List<TblContracts> existing = em.createQuery(
                "SELECT c FROM TblContracts c WHERE c.bookingId.bookingId = :bid", TblContracts.class)
                .setParameter("bid", bookingId).getResultList();
            if (!existing.isEmpty()) {
                if (isLocal) em.getTransaction().rollback();
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
            if (isLocal) em.getTransaction().commit();
            return contract;
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException(e);
        } finally {
            closeIfLocal(em);
        }
    }

    public List<model.VwContracts> findAll_View() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT v FROM VwContracts v ORDER BY v.signedDate DESC", model.VwContracts.class)
                    .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public List<model.VwContracts> findByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT v FROM VwContracts v WHERE v.status = :s ORDER BY v.signedDate DESC", model.VwContracts.class)
                    .setParameter("s", status).getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public long countByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(c) FROM TblContracts c WHERE c.status = :s")
                    .setParameter("s", status).getSingleResult();
        } finally {
            closeIfLocal(em);
        }
    }

    /** Duyệt hợp đồng: DRAFT → ACTIVE (nếu có cọc) hoặc giữ DRAFT (chưa cọc) */
    public String approve(String contractId, String employeeId) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) {
                if (isLocal) em.getTransaction().rollback();
                return "Không tìm thấy hợp đồng";
            }
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
                if (isLocal) em.getTransaction().commit();
                return "APPROVED";
            } else {
                if (isLocal) em.getTransaction().rollback();
                return "PENDING_DEPOSIT";
            }
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            return "ERROR: " + e.getMessage();
        } finally {
            closeIfLocal(em);
        }
    }

    /**
     * Xác nhận đặt cọc: tính tiền cọc theo loại facility
     * VILLA (VL*)=50%, HOUSE (HS*)=40%, ROOM (RM*)=30%
     * Cập nhật deposit, paidAmount, status → ACTIVE
     */
    public String confirmDeposit(String contractId, String employeeId) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) {
                if (isLocal) em.getTransaction().rollback();
                return "Không tìm thấy hợp đồng";
            }

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
            if (isLocal) em.getTransaction().commit();
            return "OK:" + depositAmt.toPlainString() + ":" + facilityType;
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            return "ERROR: " + e.getMessage();
        } finally {
            closeIfLocal(em);
        }
    }

    /**
     * Thanh toán thêm: cộng amount vào paidAmount.
     * Nếu paidAmount >= totalPayment → status = COMPLETED
     * Trả về số tiền còn lại sau khi thanh toán
     */
    public String addPayment(String contractId, java.math.BigDecimal amount, String method, String note) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) {
                if (isLocal) em.getTransaction().rollback();
                return "ERROR:Không tìm thấy hợp đồng";
            }
            if (!"ACTIVE".equals(c.getStatus()) && !"DRAFT".equals(c.getStatus())) {
                if (isLocal) em.getTransaction().rollback();
                return "ERROR:Hợp đồng không ở trạng thái có thể thanh toán (cần ACTIVE hoặc DRAFT)";
            }

            java.math.BigDecimal newPaid = c.getPaidAmount().add(amount);
            // Không cho trả vượt quá tổng
            if (newPaid.compareTo(c.getTotalPayment()) > 0) newPaid = c.getTotalPayment();
            c.setPaidAmount(newPaid);

            boolean completed = newPaid.compareTo(c.getTotalPayment()) >= 0;
            if (completed) {
                c.setStatus("COMPLETED");
            } else if ("DRAFT".equals(c.getStatus())) {
                // Có thanh toán một phần → kích hoạt hợp đồng
                c.setStatus("ACTIVE");
                if (c.getDeposit() == null || c.getDeposit().compareTo(java.math.BigDecimal.ZERO) == 0) {
                    c.setDeposit(amount);
                }
            }

            // Ghi vào tbl_payments
            model.TblPayments payment = new model.TblPayments();
            payment.setAmount(amount);
            payment.setPaymentDate(new java.util.Date());
            payment.setPaymentMethod(method != null ? method : "CASH");
            payment.setNote(note);
            payment.setContractId(c);
            em.persist(payment);

            em.merge(c);
            if (isLocal) em.getTransaction().commit();

            java.math.BigDecimal remaining = c.getTotalPayment().subtract(newPaid);
            return "OK:" + remaining.toPlainString() + ":" + (completed ? "COMPLETED" : "ACTIVE");
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            return "ERROR:" + e.getMessage();
        } finally {
            closeIfLocal(em);
        }
    }

    /** Hủy contract theo bookingId (dùng khi khách hủy booking) */
    public void cancelByBookingId(String bookingId) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            List<TblContracts> list = em.createQuery(
                "SELECT c FROM TblContracts c WHERE c.bookingId.bookingId = :bid", TblContracts.class)
                .setParameter("bid", bookingId)
                .getResultList();
            for (TblContracts c : list) {
                c.setStatus("CANCELLED");
                em.merge(c);
            }
            if (isLocal) em.getTransaction().commit();
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("cancelByBookingId failed: " + e.getMessage(), e);
        } finally {
            closeIfLocal(em);
        }
    }

    public boolean updateStatus(String contractId, String newStatus) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblContracts c = em.find(TblContracts.class, contractId);
            if (c == null) {
                if (isLocal) em.getTransaction().rollback();
                return false;
            }
            c.setStatus(newStatus);
            em.merge(c);
            if (isLocal) em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            return false;
        } finally {
            closeIfLocal(em);
        }
    }
    /**
     * Tạo contract kèm đặt cọc ngay (10% tổng tiền).
     * totalPayment truyền vào đã tính voucher từ BookingController.
     * Booking status → CONFIRMED, Contract status → ACTIVE
     */
    public TblContracts createWithDeposit(String bookingId, java.math.BigDecimal totalPayment,
                                          java.math.BigDecimal depositAmount, String paymentCode) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            model.TblBookings bk = em.find(model.TblBookings.class, bookingId);
            if (bk == null) throw new RuntimeException("Booking không tồn tại: " + bookingId);

            // Kiểm tra đã có contract chưa
            List<TblContracts> existing = em.createQuery(
                "SELECT c FROM TblContracts c WHERE c.bookingId.bookingId = :bid", TblContracts.class)
                .setParameter("bid", bookingId).getResultList();
            if (!existing.isEmpty()) {
                if (isLocal) em.getTransaction().rollback();
                return existing.get(0);
            }

            TblContracts contract = new TblContracts();
            contract.setContractId("CT" + System.currentTimeMillis() % 10000000);
            contract.setBookingId(bk);
            contract.setDeposit(depositAmount);
            contract.setTotalPayment(totalPayment);
            contract.setPaidAmount(depositAmount);
            contract.setStatus("ACTIVE");
            contract.setSignedDate(new java.util.Date());
            contract.setNotes("Đặt cọc 10% — Mã GD: " + paymentCode);

            em.persist(contract);

            // Ghi payment record
            model.TblPayments payment = new model.TblPayments();
            payment.setAmount(depositAmount);
            payment.setPaymentDate(new java.util.Date());
            payment.setPaymentMethod("TRANSFER");
            payment.setNote("Đặt cọc 10% khi đặt phòng. Mã GD: " + paymentCode);
            payment.setContractId(contract);
            em.persist(payment);

            // Cập nhật booking → CONFIRMED
            bk.setStatus("CONFIRMED");
            em.merge(bk);

            if (isLocal) em.getTransaction().commit();
            return contract;
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException(e);
        } finally {
            closeIfLocal(em);
        }
    }

    public java.math.BigDecimal getTotalRevenue() {
        EntityManager em = getEntityManager();
        try {
            java.math.BigDecimal total = (java.math.BigDecimal) em.createQuery(
                "SELECT SUM(c.paidAmount) FROM TblContracts c WHERE c.status IN ('ACTIVE', 'COMPLETED')")
                .getSingleResult();
            return total != null ? total : java.math.BigDecimal.ZERO;
        } finally {
            closeIfLocal(em);
        }
    }
}
