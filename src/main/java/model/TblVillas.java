package model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_villas")
@PrimaryKeyJoinColumn(name = "service_code")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class TblVillas extends TblFacilities implements Serializable {

    private static final long serialVersionUID = 1L;

    @Column(name = "room_standard")
    private String roomStandard;

    @Column(name = "pool_area")
    private BigDecimal poolArea;

    @Column(name = "num_of_floor")
    private Integer numOfFloor;
}
