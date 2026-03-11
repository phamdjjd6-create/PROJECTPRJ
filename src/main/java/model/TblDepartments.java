/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;

/**
 *
 * @author Pheo
 */
@Entity
@Table(name = "tbl_departments")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TblDepartments.findAll", query = "SELECT t FROM TblDepartments t"),
    @NamedQuery(name = "TblDepartments.findByDeptId", query = "SELECT t FROM TblDepartments t WHERE t.deptId = :deptId"),
    @NamedQuery(name = "TblDepartments.findByDeptName", query = "SELECT t FROM TblDepartments t WHERE t.deptName = :deptName")})
public class TblDepartments implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "dept_id")
    private String deptId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "dept_name")
    private String deptName;
    @JoinColumn(name = "manager_id", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees managerId;
    @OneToMany(mappedBy = "deptId")
    private Collection<TblEmployees> tblEmployeesCollection;

    public TblDepartments() {
    }

    public TblDepartments(String deptId) {
        this.deptId = deptId;
    }

    public TblDepartments(String deptId, String deptName) {
        this.deptId = deptId;
        this.deptName = deptName;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public TblEmployees getManagerId() {
        return managerId;
    }

    public void setManagerId(TblEmployees managerId) {
        this.managerId = managerId;
    }

    @XmlTransient
    public Collection<TblEmployees> getTblEmployeesCollection() {
        return tblEmployeesCollection;
    }

    public void setTblEmployeesCollection(Collection<TblEmployees> tblEmployeesCollection) {
        this.tblEmployeesCollection = tblEmployeesCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (deptId != null ? deptId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TblDepartments)) {
            return false;
        }
        TblDepartments other = (TblDepartments) object;
        if ((this.deptId == null && other.deptId != null) || (this.deptId != null && !this.deptId.equals(other.deptId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TblDepartments[ deptId=" + deptId + " ]";
    }
    
}
