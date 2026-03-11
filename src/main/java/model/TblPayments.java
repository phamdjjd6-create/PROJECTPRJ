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
@Table(name = "tbl_payments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblPayments implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;

    @Basic(optional = false)
    @NotNull
    @Column(name = "amount")
    private BigDecimal amount;

    @Basic(optional = false)
    @NotNull
    @Column(name = "payment_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date paymentDate;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 30)
    @Column(name = "payment_method")
    private String paymentMethod;

    @Size(max = 100)
    @Column(name = "transaction_ref")
    private String transactionRef;

    @Size(max = 200)
    @Column(name = "note")
    private String note;

    @JoinColumn(name = "contract_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblContracts contractId;

    @JoinColumn(name = "received_by", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees receivedBy;
}
