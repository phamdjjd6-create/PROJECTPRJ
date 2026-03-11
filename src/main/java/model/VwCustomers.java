/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
@Table(name = "vw_customers")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "VwCustomers.findAll", query = "SELECT v FROM VwCustomers v"),
    @NamedQuery(name = "VwCustomers.findById", query = "SELECT v FROM VwCustomers v WHERE v.id = :id"),
    @NamedQuery(name = "VwCustomers.findByFullName", query = "SELECT v FROM VwCustomers v WHERE v.fullName = :fullName"),
    @NamedQuery(name = "VwCustomers.findByDateOfBirth", query = "SELECT v FROM VwCustomers v WHERE v.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "VwCustomers.findByGender", query = "SELECT v FROM VwCustomers v WHERE v.gender = :gender"),
    @NamedQuery(name = "VwCustomers.findByIdCard", query = "SELECT v FROM VwCustomers v WHERE v.idCard = :idCard"),
    @NamedQuery(name = "VwCustomers.findByPhoneNumber", query = "SELECT v FROM VwCustomers v WHERE v.phoneNumber = :phoneNumber"),
    @NamedQuery(name = "VwCustomers.findByEmail", query = "SELECT v FROM VwCustomers v WHERE v.email = :email"),
    @NamedQuery(name = "VwCustomers.findByCreatedAt", query = "SELECT v FROM VwCustomers v WHERE v.createdAt = :createdAt"),
    @NamedQuery(name = "VwCustomers.findByTypeCustomer", query = "SELECT v FROM VwCustomers v WHERE v.typeCustomer = :typeCustomer"),
    @NamedQuery(name = "VwCustomers.findByAddress", query = "SELECT v FROM VwCustomers v WHERE v.address = :address"),
    @NamedQuery(name = "VwCustomers.findByLoyaltyPoints", query = "SELECT v FROM VwCustomers v WHERE v.loyaltyPoints = :loyaltyPoints"),
    @NamedQuery(name = "VwCustomers.findByTotalSpent", query = "SELECT v FROM VwCustomers v WHERE v.totalSpent = :totalSpent")})
public class VwCustomers implements Serializable {

    private static final long serialVersionUID = 1L;
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
    @Size(max = 20)
    @Column(name = "type_customer")
    private String typeCustomer;
    @Size(max = 200)
    @Column(name = "address")
    private String address;
    @Basic(optional = false)
    @NotNull
    @Column(name = "loyalty_points")
    private int loyaltyPoints;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "total_spent")
    private BigDecimal totalSpent;

    public VwCustomers() {
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

    public String getTypeCustomer() {
        return typeCustomer;
    }

    public void setTypeCustomer(String typeCustomer) {
        this.typeCustomer = typeCustomer;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void setLoyaltyPoints(int loyaltyPoints) {
        this.loyaltyPoints = loyaltyPoints;
    }

    public BigDecimal getTotalSpent() {
        return totalSpent;
    }

    public void setTotalSpent(BigDecimal totalSpent) {
        this.totalSpent = totalSpent;
    }
    
}
