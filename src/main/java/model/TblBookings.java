package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_bookings")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblBookings implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "id")
    private String id;

    @Basic(optional = false)
    @NotNull
    @Column(name = "date_booking")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateBooking;

    @Basic(optional = false)
    @NotNull
    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Basic(optional = false)
    @NotNull
    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "status")
    private String status;

    @Column(name = "special_req")
    private String specialReq;

    @Basic(optional = false)
    @NotNull
    @Column(name = "adults")
    private int adults;

    @Basic(optional = false)
    @NotNull
    @Column(name = "children")
    private int children;

    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblCustomers customerId;

    @JoinColumn(name = "facility_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblFacilities facilityId;

    @JoinColumn(name = "voucher_id", referencedColumnName = "id")
    @ManyToOne
    private TblVouchers voucherId;

    @JoinColumn(name = "created_by", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees createdBy;
}
