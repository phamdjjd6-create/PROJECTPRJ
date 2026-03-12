package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_bookings")
public class TblBookings implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "booking_id")
    private String bookingId;

    @Basic(optional = false)
    @NotNull
    @Column(name = "date_booking")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateBooking;

    @Basic(optional = false)
    @NotNull
    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Basic(optional = false)
    @NotNull
    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "status")
    private String status;

    @Column(name = "special_req")
    private String specialReq;

    @Basic(optional = false)
    @NotNull
    @Column(name = "adults")
    private int adults;

    @Basic(optional = false)
    @NotNull
    @Column(name = "children")
    private int children;

    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblCustomers customerId;

    @JoinColumn(name = "facility_id", referencedColumnName = "service_code")
    @ManyToOne(optional = false)
    private TblFacilities facilityId;

    @JoinColumn(name = "voucher_id", referencedColumnName = "voucher_id")
    @ManyToOne
    private TblVouchers voucherId;

    @JoinColumn(name = "created_by", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees createdBy;

    public TblBookings() {
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public Date getDateBooking() {
        return dateBooking;
    }

    public void setDateBooking(Date dateBooking) {
        this.dateBooking = dateBooking;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSpecialReq() {
        return specialReq;
    }

    public void setSpecialReq(String specialReq) {
        this.specialReq = specialReq;
    }

    public int getAdults() {
        return adults;
    }

    public void setAdults(int adults) {
        this.adults = adults;
    }

    public int getChildren() {
        return children;
    }

    public void setChildren(int children) {
        this.children = children;
    }

    public TblCustomers getCustomerId() {
        return customerId;
    }

    public void setCustomerId(TblCustomers customerId) {
        this.customerId = customerId;
    }

    public TblFacilities getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(TblFacilities facilityId) {
        this.facilityId = facilityId;
    }

    public TblVouchers getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(TblVouchers voucherId) {
        this.voucherId = voucherId;
    }

    public TblEmployees getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(TblEmployees createdBy) {
        this.createdBy = createdBy;
    }
}
