package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_vouchers")
@Data
@NoArgsConstructor
@AllArgsConstructor
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
}
