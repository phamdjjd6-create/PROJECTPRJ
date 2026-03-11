/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;

/**
 *
 * @author Pheo
 */
@Entity
@Table(name = "tbl_customers")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TblCustomers.findAll", query = "SELECT t FROM TblCustomers t"),
    @NamedQuery(name = "TblCustomers.findById", query = "SELECT t FROM TblCustomers t WHERE t.id = :id"),
    @NamedQuery(name = "TblCustomers.findByTypeCustomer", query = "SELECT t FROM TblCustomers t WHERE t.typeCustomer = :typeCustomer"),
    @NamedQuery(name = "TblCustomers.findByAddress", query = "SELECT t FROM TblCustomers t WHERE t.address = :address"),
    @NamedQuery(name = "TblCustomers.findByLoyaltyPoints", query = "SELECT t FROM TblCustomers t WHERE t.loyaltyPoints = :loyaltyPoints"),
    @NamedQuery(name = "TblCustomers.findByTotalSpent", query = "SELECT t FROM TblCustomers t WHERE t.totalSpent = :totalSpent")})
public class TblCustomers implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "id")
    private String id;
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
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "customerId")
    private Collection<TblReviews> tblReviewsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "customerId")
    private Collection<TblBookings> tblBookingsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "customerId")
    private Collection<TblVouchers> tblVouchersCollection;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private TblPersons tblPersons;

    public TblCustomers() {
    }

    public TblCustomers(String id) {
        this.id = id;
    }

    public TblCustomers(String id, int loyaltyPoints, BigDecimal totalSpent) {
        this.id = id;
        this.loyaltyPoints = loyaltyPoints;
        this.totalSpent = totalSpent;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    @XmlTransient
    public Collection<TblReviews> getTblReviewsCollection() {
        return tblReviewsCollection;
    }

    public void setTblReviewsCollection(Collection<TblReviews> tblReviewsCollection) {
        this.tblReviewsCollection = tblReviewsCollection;
    }

    @XmlTransient
    public Collection<TblBookings> getTblBookingsCollection() {
        return tblBookingsCollection;
    }

    public void setTblBookingsCollection(Collection<TblBookings> tblBookingsCollection) {
        this.tblBookingsCollection = tblBookingsCollection;
    }

    @XmlTransient
    public Collection<TblVouchers> getTblVouchersCollection() {
        return tblVouchersCollection;
    }

    public void setTblVouchersCollection(Collection<TblVouchers> tblVouchersCollection) {
        this.tblVouchersCollection = tblVouchersCollection;
    }

    public TblPersons getTblPersons() {
        return tblPersons;
    }

    public void setTblPersons(TblPersons tblPersons) {
        this.tblPersons = tblPersons;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TblCustomers)) {
            return false;
        }
        TblCustomers other = (TblCustomers) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TblCustomers[ id=" + id + " ]";
    }
    
}
