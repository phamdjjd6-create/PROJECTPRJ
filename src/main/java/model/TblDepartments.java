package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_departments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblDepartments implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "id")
    private String id;

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "dept_name")
    private String deptName;

    @OneToMany(mappedBy = "deptId")
    private Collection<TblEmployees> tblEmployeesCollection;

    @JoinColumn(name = "manager_id", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees managerId;
}
