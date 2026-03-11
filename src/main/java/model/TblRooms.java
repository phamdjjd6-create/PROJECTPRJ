package model;

import jakarta.persistence.*;
import java.io.Serializable;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_rooms")
@PrimaryKeyJoinColumn(name = "id")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class TblRooms extends TblFacilities {

    private static final long serialVersionUID = 1L;

    @Column(name = "free_services")
    private String freeServices;

    @Column(name = "floor_number")
    private Integer floorNumber;
}
