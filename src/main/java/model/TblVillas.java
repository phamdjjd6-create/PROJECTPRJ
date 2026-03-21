package model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tbl_villas")
@DiscriminatorValue("VILLA")
@PrimaryKeyJoinColumn(name = "service_code")
public class TblVillas extends TblFacilities {

    private static final long serialVersionUID = 1L;

    @Column(name = "room_standard")
    private String roomStandard;

    @Column(name = "pool_area")
    private BigDecimal poolArea;

    @Column(name = "num_of_floor")
    private Integer numOfFloor;

    public TblVillas() {
    }

    public String getRoomStandard() {
        return roomStandard;
    }

    public void setRoomStandard(String roomStandard) {
        this.roomStandard = roomStandard;
    }

    public BigDecimal getPoolArea() {
        return poolArea;
    }

    public void setPoolArea(BigDecimal poolArea) {
        this.poolArea = poolArea;
    }

    public Integer getNumOfFloor() {
        return numOfFloor;
    }

    public void setNumOfFloor(Integer numOfFloor) {
        this.numOfFloor = numOfFloor;
    }
}
