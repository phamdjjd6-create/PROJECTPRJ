package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "tbl_employees")
@PrimaryKeyJoinColumn(name = "id")
@DiscriminatorValue("EMPLOYEE")
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
    @Column(name = "is_active")
    private boolean isActive;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "role")
    private String role; // "ADMIN" | "STAFF"

    public TblEmployees() {
    }

    public TblDepartments getDeptId() {
        return deptId;
    }

    public void setDeptId(TblDepartments deptId) {
        this.deptId = deptId;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public BigDecimal getSalary() {
        return salary;
    }

    public void setSalary(BigDecimal salary) {
        this.salary = salary;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }


    @Override
    public boolean isDeleted() {
        return super.isDeleted();
    }

    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
