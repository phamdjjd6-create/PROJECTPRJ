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
@Table(name = "tbl_maintenance")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblMaintenance implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;

    @Basic(optional = false)
    @NotNull
    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Size(max = 300)
    @Column(name = "reason")
    private String reason;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "status")
    private String status;

    @Column(name = "cost")
    private BigDecimal cost;

    @JoinColumn(name = "facility_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblFacilities facilityId;

    @JoinColumn(name = "assigned_to", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees assignedTo;
}
