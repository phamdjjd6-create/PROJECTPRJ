package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_booking_services")
@Data
@NoArgsConstructor
@AllArgsConstructor
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

    @JoinColumn(name = "booking_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblBookings bookingId;

    @JoinColumn(name = "service_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblServices serviceId;
}
