package model;

import jakarta.persistence.*;

@Entity
@Table(name = "tbl_houses")
@DiscriminatorValue("HOUSE")
@PrimaryKeyJoinColumn(name = "service_code")
public class TblHouses extends TblFacilities {

    private static final long serialVersionUID = 1L;

    @Column(name = "room_standard")
    private String roomStandard;

    @Column(name = "num_of_floor")
    private Integer numOfFloor;

    public TblHouses() {
    }

    public String getRoomStandard() {
        return roomStandard;
    }

    public void setRoomStandard(String roomStandard) {
        this.roomStandard = roomStandard;
    }

    public Integer getNumOfFloor() {
        return numOfFloor;
    }

    public void setNumOfFloor(Integer numOfFloor) {
        this.numOfFloor = numOfFloor;
    }
}
