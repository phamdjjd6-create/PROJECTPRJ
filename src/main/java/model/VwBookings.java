package model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "vw_bookings")
@Data
@NoArgsConstructor
public class VwBookings implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "booking_id")
    private String bookingId;

    @Column(name = "date_booking")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateBooking;

    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Column(name = "status")
    private String status;

    @Column(name = "adults")
    private int adults;

    @Column(name = "children")
    private int children;

    @Column(name = "special_req")
    private String specialReq;

    @Column(name = "customer_id")
    private String customerId;

    @Column(name = "customer_name")
    private String customerName;

    @Column(name = "facility_id")
    private String facilityId;

    @Column(name = "facility_name")
    private String facilityName;

    @Column(name = "facility_type")
    private String facilityType;

    @Column(name = "cost_per_night")
    private BigDecimal costPerNight;

    @Column(name = "discount_percent")
    private Integer discountPercent;
}
