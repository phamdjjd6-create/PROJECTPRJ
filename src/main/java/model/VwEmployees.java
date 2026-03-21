/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author Pheo
 */
@Entity
@Table(name = "vw_employees")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "VwEmployees.findAll", query = "SELECT v FROM VwEmployees v"),
    @NamedQuery(name = "VwEmployees.findById", query = "SELECT v FROM VwEmployees v WHERE v.id = :id"),
    @NamedQuery(name = "VwEmployees.findByFullName", query = "SELECT v FROM VwEmployees v WHERE v.fullName = :fullName"),
    @NamedQuery(name = "VwEmployees.findByDateOfBirth", query = "SELECT v FROM VwEmployees v WHERE v.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "VwEmployees.findByGender", query = "SELECT v FROM VwEmployees v WHERE v.gender = :gender"),
    @NamedQuery(name = "VwEmployees.findByIdCard", query = "SELECT v FROM VwEmployees v WHERE v.idCard = :idCard"),
    @NamedQuery(name = "VwEmployees.findByPhoneNumber", query = "SELECT v FROM VwEmployees v WHERE v.phoneNumber = :phoneNumber"),
    @NamedQuery(name = "VwEmployees.findByEmail", query = "SELECT v FROM VwEmployees v WHERE v.email = :email"),
    @NamedQuery(name = "VwEmployees.findByCreatedAt", query = "SELECT v FROM VwEmployees v WHERE v.createdAt = :createdAt"),
    @NamedQuery(name = "VwEmployees.findByDeptId", query = "SELECT v FROM VwEmployees v WHERE v.deptId = :deptId"),
    @NamedQuery(name = "VwEmployees.findByDeptName", query = "SELECT v FROM VwEmployees v WHERE v.deptName = :deptName"),
    @NamedQuery(name = "VwEmployees.findByLevel", query = "SELECT v FROM VwEmployees v WHERE v.level = :level"),
    @NamedQuery(name = "VwEmployees.findByPosition", query = "SELECT v FROM VwEmployees v WHERE v.position = :position"),
    @NamedQuery(name = "VwEmployees.findBySalary", query = "SELECT v FROM VwEmployees v WHERE v.salary = :salary"),
    @NamedQuery(name = "VwEmployees.findByHireDate", query = "SELECT v FROM VwEmployees v WHERE v.hireDate = :hireDate"),
    @NamedQuery(name = "VwEmployees.findByIsActive", query = "SELECT v FROM VwEmployees v WHERE v.isActive = :isActive")})
public class VwEmployees implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "full_name")
    private String fullName;
    @Column(name = "date_of_birth")
    @Temporal(TemporalType.DATE)
    private Date dateOfBirth;
    @Size(max = 10)
    @Column(name = "gender")
    private String gender;
    @Size(max = 20)
    @Column(name = "id_card")
    private String idCard;
    @Size(max = 20)
    @Column(name = "phone_number")
    private String phoneNumber;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Size(max = 100)
    @Column(name = "email")
    private String email;
    @Basic(optional = false)
    @NotNull
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Size(max = 10)
    @Column(name = "dept_id")
    private String deptId;
    @Size(max = 100)
    @Column(name = "dept_name")
    private String deptName;
    @Size(max = 30)
    @Column(name = "level")
    private String level;
    @Size(max = 60)
    @Column(name = "position")
    private String position;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
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

    @Size(max = 10)
    @Column(name = "role")
    private String role;

    @Size(max = 50)
    @Column(name = "account")
    private String account;

    public VwEmployees() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
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

    public boolean getIsActive() {
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

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }
    
}
