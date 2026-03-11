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
@Table(name = "tbl_services")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblServices implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "service_name")
    private String serviceName;

    @Size(max = 50)
    @Column(name = "category")
    private String category;

    @Basic(optional = false)
    @NotNull
    @Column(name = "unit_price")
    private BigDecimal unitPrice;

    @Size(max = 30)
    @Column(name = "unit")
    private String unit;

    @Size(max = 300)
    @Column(name = "description")
    private String description;

    @Basic(optional = false)
    @NotNull
    @Column(name = "is_active")
    private boolean isActive;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "serviceId")
    private Collection<TblBookingServices> tblBookingServicesCollection;
}
