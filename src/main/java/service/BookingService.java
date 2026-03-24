package service;

import DAO.BookingDAO;
import DAO.CustomerDAO;
import DAO.FacilityDAO;
import DAO.PromotionDAO;
import DAO.ContractDAO;
import jakarta.persistence.EntityManager;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import model.TblBookings;

public class BookingService implements IService<TblBookings, String> {
    private final BookingDAO bookingDAO;
    private final CustomerDAO customerDAO;
    private final FacilityDAO facilityDAO;
    private final PromotionDAO promotionDAO;
    private final ContractDAO contractDAO;
    private final EmailService emailService;
    private final LoyaltyService loyaltyService;

    public BookingService() {
        this.bookingDAO = new BookingDAO();
        this.customerDAO = new CustomerDAO();
        this.facilityDAO = new FacilityDAO();
        this.promotionDAO = new PromotionDAO();
        this.contractDAO = new ContractDAO();
        this.emailService = new EmailService();
        this.loyaltyService = new LoyaltyService();
    }

    @Override
    public List<TblBookings> findAll() {
        return bookingDAO.findAll();
    }

    @Override
    public TblBookings findById(String id) {
        return bookingDAO.findById(id);
    }

    @Override
    public void save(TblBookings booking) {
        if (booking.getBookingId() == null || booking.getBookingId().isEmpty()) {
            booking.setBookingId(bookingDAO.generateBookingId());
        }
        if (booking.getDateBooking() == null) {
            booking.setDateBooking(new Date());
        }
        validateBooking(booking);
        bookingDAO.save(booking);
        
        // Increase usage logic
        facilityDAO.increaseUsage(booking.getFacilityId().getServiceCode());
    }

    /**
     * Quy trình đặt phòng đầy đủ (Transactional):
     * 1. Kiểm tra giới hạn khách.
     * 2. Tính toán tiền (Voucher).
     * 3. Lưu Booking & tăng lượt dùng Facility.
     * 4. Tạo Hợp đồng & Thanh toán (nếu có cọc 10%).
     */
    public String placeBooking(TblBookings booking, String voucherCode, boolean depositNow) throws Exception {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            // Khởi tạo các DAO với chung EntityManager
            BookingDAO bDAO = new BookingDAO(em);
            FacilityDAO fDAO = new FacilityDAO(em);
            PromotionDAO pDAO = new PromotionDAO(em);
            ContractDAO cDAO = new ContractDAO(em);
            CustomerDAO custDAO = new CustomerDAO(em);

            // 1. Validate Guest Limit
            model.TblFacilities facility = fDAO.findByCode(booking.getFacilityId().getServiceCode());
            if (facility == null) throw new Exception("Không tìm thấy dịch vụ.");
            
            int maxGuests = facility.getServiceCode().startsWith("VL") ? 15 : 
                           facility.getServiceCode().startsWith("HS") ? 5 : 3;
            if (booking.getAdults() + booking.getChildren() > maxGuests) {
                throw new Exception("Tổng số khách vượt quá giới hạn (tối đa " + maxGuests + " người).");
            }

            // 2. Cost Calculation
            long diff = booking.getEndDate().getTime() - booking.getStartDate().getTime();
            int nights = (int) java.util.concurrent.TimeUnit.DAYS.convert(diff, java.util.concurrent.TimeUnit.MILLISECONDS);
            if (nights <= 0) nights = 1;

            java.math.BigDecimal baseCost = facility.getCost().multiply(new java.math.BigDecimal(nights));
            
            // ── Loyalty: Áp dụng giảm giá theo hạng thành viên ──
            model.TblCustomers customerEntity = custDAO.findById(booking.getCustomerId().getId());
            if (customerEntity == null) {
                customerEntity = em.find(model.TblCustomers.class, booking.getCustomerId().getId());
            }
            LoyaltyService.Tier tier = loyaltyService.calculateTier(customerEntity);
            if (tier.getDiscountPercent() > 0) {
                java.math.BigDecimal tierDiscount = baseCost.multiply(new java.math.BigDecimal(tier.getDiscountPercent())).divide(new java.math.BigDecimal(100));
                baseCost = baseCost.subtract(tierDiscount);
            }
            
            java.math.BigDecimal totalPayment = baseCost;

            // Apply Voucher (áp dụng chồng lên hoặc thay thế - ở đây ta áp dụng chồng lên)
            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                model.TblPromotions promo = pDAO.findByCode(voucherCode.trim());
                if (promo != null && promo.getMinNights() <= nights) {
                    if ("PERCENT".equals(promo.getDiscountType())) {
                        java.math.BigDecimal discount = baseCost.multiply(promo.getDiscountValue()).divide(new java.math.BigDecimal(100));
                        totalPayment = baseCost.subtract(discount);
                    } else if ("AMOUNT".equals(promo.getDiscountType())) {
                        totalPayment = baseCost.subtract(promo.getDiscountValue());
                    }
                }
            }
            if (totalPayment.compareTo(java.math.BigDecimal.ZERO) < 0) totalPayment = java.math.BigDecimal.ZERO;

            // 3. Save Booking & Update loyalty
            booking.setBookingId(bDAO.generateBookingId());
            booking.setDateBooking(new Date());
            booking.setStatus("PENDING");
            bDAO.save(booking);
            fDAO.increaseUsage(facility.getServiceCode());
            
            // ── Loyalty: Cộng điểm và tích lũy chi tiêu ──
            int pointsEarned = loyaltyService.calculateAwardedPoints(totalPayment);
            customerEntity.setLoyaltyPoints(customerEntity.getLoyaltyPoints() + pointsEarned);
            customerEntity.setTotalSpent(customerEntity.getTotalSpent().add(totalPayment));
            em.merge(customerEntity);

            String message;
            if (depositNow) {
                java.math.BigDecimal deposit10 = totalPayment.multiply(new java.math.BigDecimal("0.10"))
                        .setScale(0, java.math.RoundingMode.HALF_UP);
                String payCode = "AZ" + System.currentTimeMillis() % 100000000L;

                model.TblContracts contract = new model.TblContracts();
                contract.setContractId("CT" + System.currentTimeMillis() % 10000000);
                contract.setBookingId(booking);
                contract.setDeposit(deposit10);
                contract.setTotalPayment(totalPayment);
                contract.setPaidAmount(deposit10);
                contract.setStatus("ACTIVE");
                contract.setSignedDate(new Date());
                contract.setNotes("Đặt cọc 10% — Mã GD: " + payCode);
                cDAO.save(contract);

                model.TblPayments payment = new model.TblPayments();
                payment.setAmount(deposit10);
                payment.setPaymentDate(new Date());
                payment.setPaymentMethod("TRANSFER");
                payment.setNote("Đặt cọc 10% khi đặt phòng. Mã GD: " + payCode);
                payment.setContractId(contract);
                em.persist(payment);

                booking.setStatus("CONFIRMED");
                bDAO.save(booking); // Update status

                message = "✅ Đặt phòng thành công! Đã đặt cọc 10% (" +
                          String.format("%,.0f", deposit10.doubleValue()) + " đ). Nhận ngay " + pointsEarned + " điểm thưởng Azure!";
            } else {
                message = "✅ Đặt phòng thành công! Nhận ngay " + pointsEarned + " điểm thưởng Azure! Vui lòng chờ admin xác nhận.";
            }

            em.getTransaction().commit();

            // ── Gửi Email xác nhận (Hành động bất đồng bộ - Async) ──
            try {
                // Lấy thông tin khách hàng từ DB để có Email/FullName
                final model.TblCustomers fullCust = customerDAO.findById(booking.getCustomerId().getId());
                booking.setCustomerId(fullCust);
                final java.math.BigDecimal finalPayment = totalPayment;
                new Thread(() -> emailService.sendBookingConfirmation(booking, facility, finalPayment)).start();
            } catch (Exception e) {
                System.err.println("[BookingService] Không thể khởi tạo luồng gửi email: " + e.getMessage());
            }

            return message;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(String id) {
        TblBookings booking = bookingDAO.findById(id);
        if (booking != null) {
            booking.setStatus("CANCELLED");
            bookingDAO.save(booking);
        } else {
            throw new IllegalArgumentException("Không tìm thấy booking để xóa: " + id);
        }
    }

    public List<TblBookings> getBookingsForDisplay() {
        List<TblBookings> list = new ArrayList<>(bookingDAO.findAll());
        
        Comparator<TblBookings> displayComparator = (o1, o2) -> {
            int dateBookingCompare = o2.getDateBooking().compareTo(o1.getDateBooking());
            if (dateBookingCompare != 0) {
                return dateBookingCompare;
            }
            int endDateCompare = o2.getEndDate().compareTo(o1.getEndDate());
            if (endDateCompare != 0) {
                return endDateCompare;
            }
            return o1.getBookingId().compareTo(o2.getBookingId());
        };

        Collections.sort(list, displayComparator);
        return list;
    }

    public List<TblBookings> getBookingsByCustomer(String customerId) {
        return bookingDAO.findByCustomerId(customerId);
    }

    private void validateBooking(TblBookings b) {
        if (b == null) throw new IllegalArgumentException("Dữ liệu Booking rỗng.");

        // Check if customer and facility exist
        if (customerDAO.findById(b.getCustomerId().getId()) == null) {
            throw new IllegalArgumentException("Không tìm thấy khách hàng: " + b.getCustomerId().getId());
        }

        if (facilityDAO.findByCode(b.getFacilityId().getServiceCode()) == null) {
            throw new IllegalArgumentException("Không tìm thấy dịch vụ: " + b.getFacilityId().getServiceCode());
        }

        if (b.getStartDate() == null || b.getEndDate() == null) {
             throw new IllegalArgumentException("Ngày bắt đầu và kết thúc không được để trống.");
        }

        LocalDate start = b.getStartDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate end = b.getEndDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        
        if (end.isBefore(start)) {
            throw new IllegalArgumentException("Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");
        }
    }
    /** Hủy đặt phòng và các hợp đồng liên quan */
    public void cancelBooking(String bookingId) throws Exception {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            
            BookingDAO bDAO = new BookingDAO(em);
            ContractDAO cDAO = new ContractDAO(em);
            
            TblBookings bk = bDAO.findById(bookingId);
            if (bk == null) throw new Exception("Không tìm thấy booking " + bookingId);
            
            if ("CHECKED_IN".equals(bk.getStatus()) || "CHECKED_OUT".equals(bk.getStatus())) {
                throw new Exception("Không thể hủy — khách đã check-in hoặc check-out.");
            }
            if ("CONFIRMED".equals(bk.getStatus())) {
                throw new Exception("Booking đã xác nhận (có đặt cọc). Vui lòng liên hệ hotline để hỗ trợ.");
            }
            if (!"PENDING".equals(bk.getStatus()) && !"DRAFT".equals(bk.getStatus())) {
                throw new Exception("Không thể hủy — trạng thái hiện tại: " + bk.getStatus());
            }

            bDAO.updateStatus(bookingId, "CANCELLED");
            cDAO.cancelByBookingId(bookingId);
            
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public java.util.Map<String, Object> validateVoucher(String code, int nights) {
        java.util.Map<String, Object> result = new java.util.HashMap<>();
        if (code == null || code.trim().isEmpty()) {
            result.put("valid", false);
            result.put("msg", "Vui lòng nhập mã giảm giá.");
            return result;
        }
        model.TblPromotions promo = promotionDAO.findByCode(code.trim());
        if (promo == null) {
            result.put("valid", false);
            result.put("msg", "Mã không tồn tại hoặc đã hết hạn.");
        } else if (promo.getMinNights() > nights) {
            result.put("valid", false);
            result.put("msg", "Mã yêu cầu tối thiếu " + promo.getMinNights() + " đêm.");
        } else if (promo.getMaxUses() != null && promo.getUsedCount() >= promo.getMaxUses()) {
            result.put("valid", false);
            result.put("msg", "Mã đã hết lượt sử dụng.");
        } else {
            result.put("valid", true);
            result.put("type", promo.getDiscountType());
            result.put("value", promo.getDiscountValue());
            String desc = "PERCENT".equals(promo.getDiscountType()) ? 
                         promo.getDiscountValue().stripTrailingZeros().toPlainString() + "%" :
                         String.format("%,.0f đ", promo.getDiscountValue().doubleValue());
            result.put("msg", "Áp dụng thành công! Giảm " + desc + " — " + promo.getPromoName());
        }
        return result;
    }

    public List<model.VwBookings> findAllView() {
        return bookingDAO.findAllView();
    }

    public List<model.VwBookings> findByStatus(String status) {
        return bookingDAO.findByStatus(status);
    }

    public long countByStatus(String status) {
        return bookingDAO.countByStatus(status);
    }

    public List<model.TblFacilities> getAvailableFacilities(java.util.Date checkin, java.util.Date checkout) {
        if (checkin != null && checkout != null && checkout.after(checkin)) {
            return facilityDAO.findAvailableBetween(checkin, checkout);
        }
        return facilityDAO.findAll();
    }

    public void approveBooking(String bookingId, String employeeId) throws Exception {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            BookingDAO bDAO = new BookingDAO(em);
            FacilityDAO fDAO = new FacilityDAO(em);
            ContractDAO cDAO = new ContractDAO(em);

            bDAO.updateStatus(bookingId, "CONFIRMED");
            TblBookings bk = bDAO.findById(bookingId);
            if (bk != null) {
                fDAO.updateStatus(bk.getFacilityId().getServiceCode(), "OCCUPIED");
                cDAO.createForBooking(bookingId, employeeId);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void rejectBooking(String bookingId) {
        bookingDAO.updateStatus(bookingId, "CANCELLED");
    }

    public void checkInBooking(String bookingId) throws Exception {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            BookingDAO bDAO = new BookingDAO(em);
            FacilityDAO fDAO = new FacilityDAO(em);
            
            bDAO.updateStatus(bookingId, "CHECKED_IN");
            TblBookings bk = bDAO.findById(bookingId);
            if (bk != null) {
                fDAO.updateStatus(bk.getFacilityId().getServiceCode(), "OCCUPIED");
                fDAO.increaseUsage(bk.getFacilityId().getServiceCode());
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public String checkOutBooking(String bookingId) throws Exception {
        EntityManager em = util.JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            BookingDAO bDAO = new BookingDAO(em);
            FacilityDAO fDAO = new FacilityDAO(em);

            bDAO.updateStatus(bookingId, "CHECKED_OUT");
            TblBookings bk = bDAO.findById(bookingId);
            String message = "🚪 Check-out thành công!";
            
            if (bk != null) {
                model.TblFacilities facility = fDAO.findByCode(bk.getFacilityId().getServiceCode());
                if (facility != null && facility.getUsageCount() >= 5) {
                    fDAO.updateStatus(facility.getServiceCode(), "MAINTENANCE");
                    message = "🚪 Check-out xong. Phòng " + facility.getServiceCode() + 
                              " đã dùng " + facility.getUsageCount() + " lần — chuyển sang BẢO TRÌ!";
                } else {
                    fDAO.updateStatus(bk.getFacilityId().getServiceCode(), "CLEANING");
                    message = "🚪 Check-out xong. Phòng " + bk.getFacilityId().getServiceCode() + " đang chờ dọn dẹp.";
                }
            }
            em.getTransaction().commit();
            return message;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
