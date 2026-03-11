package model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "vw_facilities")
@Data
@NoArgsConstructor
public class VwFacilities implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "id")
    private String id;

    @Column(name = "service_name")
    private String serviceName;

    @Column(name = "usable_area")
    private BigDecimal usableArea;

    @Column(name = "cost")
    private BigDecimal cost;

    @Column(name = "max_people")
    private int maxPeople;

    @Column(name = "rental_type")
    private String rentalType;

    @Column(name = "status")
    private String status;

    @Column(name = "facility_type")
    private String facilityType;

    @Column(name = "description")
    private String description;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "room_standard")
    private String roomStandard;

    @Column(name = "pool_area")
    private BigDecimal poolArea;

    @Column(name = "num_of_floor")
    private Integer numOfFloor;

    @Column(name = "house_standard")
    private String houseStandard;

    @Column(name = "house_floors")
    private Integer houseFloors;

    @Column(name = "free_services")
    private String freeServices;

    @Column(name = "floor_number")
    private Integer floorNumber;
}
