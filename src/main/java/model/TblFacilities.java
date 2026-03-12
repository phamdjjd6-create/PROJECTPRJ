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

/**
 * Base Entity for all Resort Facilities (Villa, House, Room)
 * Implements Joined Table inheritance.
 */
@Entity
@Table(name = "tbl_facilities")
@Inheritance(strategy = InheritanceType.JOINED)
@DiscriminatorColumn(name = "facility_type")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblFacilities implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "service_code")
    private String serviceCode;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "service_name")
    private String serviceName;

    @Basic(optional = false)
    @NotNull
    @Column(name = "usable_area")
    private BigDecimal usableArea;

    @Basic(optional = false)
    @NotNull
    @Column(name = "cost")
    private BigDecimal cost;

    @Basic(optional = false)
    @NotNull
    @Column(name = "max_people")
    private int maxPeople;

    @Size(max = 20)
    @Column(name = "rental_type")
    private String rentalType;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "status")
    private String status;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "facility_type", insertable = false, updatable = false)
    private String facilityType;

    @Size(max = 500)
    @Column(name = "description")
    private String description;

    @Size(max = 300)
    @Column(name = "image_url")
    private String imageUrl;

    @Basic(optional = false)
    @NotNull
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Basic(optional = false)
    @NotNull
    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    @Basic(optional = false)
    @NotNull
    @Column(name = "is_deleted")
    private boolean isDeleted;

    @Basic(optional = false)
    @NotNull
    @Column(name = "usage_count")
    private int usageCount;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "facilityId")
    private Collection<TblBookings> tblBookingsCollection;
}
