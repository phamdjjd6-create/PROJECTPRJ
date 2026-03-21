package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "tbl_booking_services")
public class TblBookingServices implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;

    @Basic(optional = false)
    @NotNull
    @Column(name = "quantity")
    private int quantity;

    @Basic(optional = false)
    @NotNull
    @Column(name = "unit_price")
    private BigDecimal unitPrice;

    @Column(name = "total_price", insertable = false, updatable = false)
    private BigDecimal totalPrice;

    @Column(name = "service_date")
    @Temporal(TemporalType.DATE)
    private Date serviceDate;

    @Size(max = 200)
    @Column(name = "note")
    private String note;

    @JoinColumn(name = "booking_id", referencedColumnName = "booking_id")
    @ManyToOne(optional = false)
    private TblBookings bookingId;

    @JoinColumn(name = "service_id", referencedColumnName = "service_id")
    @ManyToOne(optional = false)
    private TblServices serviceId;

    public TblBookingServices() {
    }

    public TblBookingServices(Integer id, int quantity, BigDecimal unitPrice, BigDecimal totalPrice, Date serviceDate, String note, TblBookings bookingId, TblServices serviceId) {
        this.id = id;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.serviceDate = serviceDate;
        this.note = note;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    public Date getServiceDate() { return serviceDate; }
    public void setServiceDate(Date serviceDate) { this.serviceDate = serviceDate; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public TblBookings getBookingId() { return bookingId; }
    public void setBookingId(TblBookings bookingId) { this.bookingId = bookingId; }
    public TblServices getServiceId() { return serviceId; }
    public void setServiceId(TblServices serviceId) { this.serviceId = serviceId; }
}
