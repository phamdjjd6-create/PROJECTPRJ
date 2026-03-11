package model;

import jakarta.persistence.*;
import java.io.Serializable;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_houses")
@PrimaryKeyJoinColumn(name = "id")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class TblHouses extends TblFacilities {

    private static final long serialVersionUID = 1L;

    @Column(name = "room_standard")
    private String roomStandard;

    @Column(name = "num_of_floor")
    private Integer numOfFloor;
}
