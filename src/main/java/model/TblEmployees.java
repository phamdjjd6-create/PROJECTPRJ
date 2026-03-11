package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_employees")
@PrimaryKeyJoinColumn(name = "id")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class TblEmployees extends TblPersons implements Serializable {

    private static final long serialVersionUID = 1L;

    @JoinColumn(name = "dept_id", referencedColumnName = "dept_id")
    @ManyToOne
    private TblDepartments deptId;

    @Size(max = 30)
    @Column(name = "level")
    private String level;

    @Size(max = 60)
    @Column(name = "position")
    private String position;

    @Basic(optional = false)
    @NotNull
    @Column(name = "salary")
    private BigDecimal salary;

    @Column(name = "hire_date")
    @Temporal(TemporalType.DATE)
    private Date hireDate;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "password_hash")
    private String passwordHash;

    @Basic(optional = false)
    @NotNull
    @Column(name = "is_active")
    private boolean isActive;
}
