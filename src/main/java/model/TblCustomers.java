package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_customers")
@PrimaryKeyJoinColumn(name = "id")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblCustomers extends TblPersons {

    private static final long serialVersionUID = 1L;

    @Size(max = 20)
    @Column(name = "type_customer")
    private String typeCustomer;

    @Size(max = 200)
    @Column(name = "address")
    private String address;

    @Basic(optional = false)
    @NotNull
    @Column(name = "loyalty_points")
    private int loyaltyPoints;

    @Basic(optional = false)
    @NotNull
    @Column(name = "total_spent")
    private BigDecimal totalSpent;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "customerId")
    private Collection<TblBookings> tblBookingsCollection;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "customerId")
    private Collection<TblVouchers> tblVouchersCollection;
}
