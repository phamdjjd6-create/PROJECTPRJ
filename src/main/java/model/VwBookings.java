package model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "vw_bookings")
public class VwBookings implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "booking_id")
    private String bookingId;

    @Column(name = "date_booking")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateBooking;

    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Column(name = "status")
    private String status;

    @Column(name = "adults")
    private int adults;

    @Column(name = "children")
    private int children;

    @Column(name = "special_req")
    private String specialReq;

    @Column(name = "customer_id")
    private String customerId;

    @Column(name = "customer_name")
    private String customerName;

    @Column(name = "facility_id")
    private String facilityId;

    @Column(name = "facility_name")
    private String facilityName;

    @Column(name = "facility_type")
    private String facilityType;

    @Column(name = "cost_per_night")
    private BigDecimal costPerNight;

    @Column(name = "discount_percent")
    private Integer discountPercent;

    public VwBookings() {}

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

    public Date getDateBooking() { return dateBooking; }
    public void setDateBooking(Date dateBooking) { this.dateBooking = dateBooking; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getAdults() { return adults; }
    public void setAdults(int adults) { this.adults = adults; }

    public int getChildren() { return children; }
    public void setChildren(int children) { this.children = children; }

    public String getSpecialReq() { return specialReq; }
    public void setSpecialReq(String specialReq) { this.specialReq = specialReq; }

    public String getCustomerId() { return customerId; }
    public void setCustomerId(String customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getFacilityId() { return facilityId; }
    public void setFacilityId(String facilityId) { this.facilityId = facilityId; }

    public String getFacilityName() { return facilityName; }
    public void setFacilityName(String facilityName) { this.facilityName = facilityName; }

    public String getFacilityType() { return facilityType; }
    public void setFacilityType(String facilityType) { this.facilityType = facilityType; }

    public BigDecimal getCostPerNight() { return costPerNight; }
    public void setCostPerNight(BigDecimal costPerNight) { this.costPerNight = costPerNight; }

    public Integer getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(Integer discountPercent) { this.discountPercent = discountPercent; }
}
