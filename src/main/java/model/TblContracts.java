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
@Table(name = "tbl_contracts")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblContracts implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "id")
    private String id;

    @Basic(optional = false)
    @NotNull
    @Column(name = "deposit")
    private BigDecimal deposit;

    @Basic(optional = false)
    @NotNull
    @Column(name = "total_payment")
    private BigDecimal totalPayment;

    @Basic(optional = false)
    @NotNull
    @Column(name = "paid_amount")
    private BigDecimal paidAmount;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "status")
    private String status;

    @Column(name = "signed_date")
    @Temporal(TemporalType.DATE)
    private Date signedDate;

    @Size(max = 500)
    @Column(name = "notes")
    private String notes;

    @JoinColumn(name = "booking_id", referencedColumnName = "id")
    @OneToOne(optional = false)
    private TblBookings bookingId;

    @JoinColumn(name = "employee_id", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees employeeId;
}
