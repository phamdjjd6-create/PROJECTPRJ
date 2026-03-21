package model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Table(name = "vw_facilities")
public class VwFacilities implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "service_code")
    private String serviceCode;

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

    public VwFacilities() {}

    public String getServiceCode() { return serviceCode; }
    public void setServiceCode(String serviceCode) { this.serviceCode = serviceCode; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public BigDecimal getUsableArea() { return usableArea; }
    public void setUsableArea(BigDecimal usableArea) { this.usableArea = usableArea; }
    public BigDecimal getCost() { return cost; }
    public void setCost(BigDecimal cost) { this.cost = cost; }
    public int getMaxPeople() { return maxPeople; }
    public void setMaxPeople(int maxPeople) { this.maxPeople = maxPeople; }
    public String getRentalType() { return rentalType; }
    public void setRentalType(String rentalType) { this.rentalType = rentalType; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getFacilityType() { return facilityType; }
    public void setFacilityType(String facilityType) { this.facilityType = facilityType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getRoomStandard() { return roomStandard; }
    public void setRoomStandard(String roomStandard) { this.roomStandard = roomStandard; }
    public BigDecimal getPoolArea() { return poolArea; }
    public void setPoolArea(BigDecimal poolArea) { this.poolArea = poolArea; }
    public Integer getNumOfFloor() { return numOfFloor; }
    public void setNumOfFloor(Integer numOfFloor) { this.numOfFloor = numOfFloor; }
    public String getHouseStandard() { return houseStandard; }
    public void setHouseStandard(String houseStandard) { this.houseStandard = houseStandard; }
    public Integer getHouseFloors() { return houseFloors; }
    public void setHouseFloors(Integer houseFloors) { this.houseFloors = houseFloors; }
    public String getFreeServices() { return freeServices; }
    public void setFreeServices(String freeServices) { this.freeServices = freeServices; }
    public Integer getFloorNumber() { return floorNumber; }
    public void setFloorNumber(Integer floorNumber) { this.floorNumber = floorNumber; }
}
