package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "tbl_maintenance")
public class TblMaintenance implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "maintenance_id")
    private Integer maintenanceId;

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

    @JoinColumn(name = "facility_id", referencedColumnName = "service_code")
    @ManyToOne(optional = false)
    private TblFacilities facilityId;

    @JoinColumn(name = "assigned_to", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees assignedTo;

    public TblMaintenance() {
    }

    public TblMaintenance(Integer maintenanceId, Date startDate, Date endDate, String reason, String status, BigDecimal cost, TblFacilities facilityId, TblEmployees assignedTo) {
        this.maintenanceId = maintenanceId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.reason = reason;
        this.status = status;
        this.cost = cost;
        this.facilityId = facilityId;
        this.assignedTo = assignedTo;
    }

    public Integer getMaintenanceId() { return maintenanceId; }
    public void setMaintenanceId(Integer maintenanceId) { this.maintenanceId = maintenanceId; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public BigDecimal getCost() { return cost; }
    public void setCost(BigDecimal cost) { this.cost = cost; }
    public TblFacilities getFacilityId() { return facilityId; }
    public void setFacilityId(TblFacilities facilityId) { this.facilityId = facilityId; }
    public TblEmployees getAssignedTo() { return assignedTo; }
    public void setAssignedTo(TblEmployees assignedTo) { this.assignedTo = assignedTo; }
}
