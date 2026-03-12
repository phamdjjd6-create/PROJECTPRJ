package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;

@Entity
@Table(name = "tbl_vouchers")
public class TblVouchers implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "voucher_id")
    private Integer voucherId;

    @Basic(optional = false)
    @NotNull
    @Column(name = "discount_percent")
    private int discountPercent;

    @Basic(optional = false)
    @NotNull
    @Column(name = "expiry_date")
    @Temporal(TemporalType.DATE)
    private Date expiryDate;

    @Basic(optional = false)
    @NotNull
    @Column(name = "is_used")
    private boolean isUsed;

    @Basic(optional = false)
    @NotNull
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "min_order_value")
    private BigDecimal minOrderValue;

    @OneToMany(mappedBy = "voucherId")
    private Collection<TblBookings> tblBookingsCollection;

    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblCustomers customerId;

    public TblVouchers() {
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public boolean isIsUsed() {
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public BigDecimal getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(BigDecimal minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public Collection<TblBookings> getTblBookingsCollection() {
        return tblBookingsCollection;
    }

    public void setTblBookingsCollection(Collection<TblBookings> tblBookingsCollection) {
        this.tblBookingsCollection = tblBookingsCollection;
    }

    public TblCustomers getCustomerId() {
        return customerId;
    }

    public void setCustomerId(TblCustomers customerId) {
        this.customerId = customerId;
    }
}
