package model;

import jakarta.persistence.*;

@Entity
@Table(name = "tbl_rooms")
@DiscriminatorValue("ROOM")
@PrimaryKeyJoinColumn(name = "service_code")
public class TblRooms extends TblFacilities {

    private static final long serialVersionUID = 1L;

    @Column(name = "free_services")
    private String freeServices;

    @Column(name = "floor_number")
    private Integer floorNumber;

    public TblRooms() {
    }

    public String getFreeServices() {
        return freeServices;
    }

    public void setFreeServices(String freeServices) {
        this.freeServices = freeServices;
    }

    public Integer getFloorNumber() {
        return floorNumber;
    }

    public void setFloorNumber(Integer floorNumber) {
        this.floorNumber = floorNumber;
    }
}
