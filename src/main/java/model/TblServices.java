/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
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
@Table(name = "tbl_services")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TblServices.findAll", query = "SELECT t FROM TblServices t"),
    @NamedQuery(name = "TblServices.findByServiceId", query = "SELECT t FROM TblServices t WHERE t.serviceId = :serviceId"),
    @NamedQuery(name = "TblServices.findByServiceName", query = "SELECT t FROM TblServices t WHERE t.serviceName = :serviceName"),
    @NamedQuery(name = "TblServices.findByCategory", query = "SELECT t FROM TblServices t WHERE t.category = :category"),
    @NamedQuery(name = "TblServices.findByUnitPrice", query = "SELECT t FROM TblServices t WHERE t.unitPrice = :unitPrice"),
    @NamedQuery(name = "TblServices.findByUnit", query = "SELECT t FROM TblServices t WHERE t.unit = :unit"),
    @NamedQuery(name = "TblServices.findByDescription", query = "SELECT t FROM TblServices t WHERE t.description = :description"),
    @NamedQuery(name = "TblServices.findByIsActive", query = "SELECT t FROM TblServices t WHERE t.isActive = :isActive")})
public class TblServices implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "service_id")
    private Integer serviceId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "service_name")
    private String serviceName;
    @Size(max = 50)
    @Column(name = "category")
    private String category;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "unit_price")
    private BigDecimal unitPrice;
    @Size(max = 30)
    @Column(name = "unit")
    private String unit;
    @Size(max = 300)
    @Column(name = "description")
    private String description;
    @Basic(optional = false)
    @NotNull
    @Column(name = "is_active")
    private boolean isActive;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "serviceId")
    private Collection<TblBookingServices> tblBookingServicesCollection;

    public TblServices() {
    }

    public TblServices(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public TblServices(Integer serviceId, String serviceName, BigDecimal unitPrice, boolean isActive) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.unitPrice = unitPrice;
        this.isActive = isActive;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    @XmlTransient
    public Collection<TblBookingServices> getTblBookingServicesCollection() {
        return tblBookingServicesCollection;
    }

    public void setTblBookingServicesCollection(Collection<TblBookingServices> tblBookingServicesCollection) {
        this.tblBookingServicesCollection = tblBookingServicesCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (serviceId != null ? serviceId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TblServices)) {
            return false;
        }
        TblServices other = (TblServices) object;
        if ((this.serviceId == null && other.serviceId != null) || (this.serviceId != null && !this.serviceId.equals(other.serviceId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TblServices[ serviceId=" + serviceId + " ]";
    }
    
}
