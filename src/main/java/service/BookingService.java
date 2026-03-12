package service;

import DAO.BookingDAO;
import DAO.CustomerDAO;
import DAO.FacilityDAO;
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

    public BookingService() {
        this.bookingDAO = new BookingDAO();
        this.customerDAO = new CustomerDAO();
        this.facilityDAO = new FacilityDAO();
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
        
        // Increase usage logic from mavenproject1
        LocalDate start = booking.getStartDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate today = LocalDate.now();
        if (start.getMonth() == today.getMonth() && start.getYear() == today.getYear()) {
            facilityDAO.increaseUsage(booking.getFacilityId().getServiceCode());
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
}
