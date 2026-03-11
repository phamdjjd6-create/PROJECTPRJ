/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
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
@Table(name = "tbl_promotions")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TblPromotions.findAll", query = "SELECT t FROM TblPromotions t"),
    @NamedQuery(name = "TblPromotions.findByPromoId", query = "SELECT t FROM TblPromotions t WHERE t.promoId = :promoId"),
    @NamedQuery(name = "TblPromotions.findByPromoName", query = "SELECT t FROM TblPromotions t WHERE t.promoName = :promoName"),
    @NamedQuery(name = "TblPromotions.findByPromoCode", query = "SELECT t FROM TblPromotions t WHERE t.promoCode = :promoCode"),
    @NamedQuery(name = "TblPromotions.findByDiscountType", query = "SELECT t FROM TblPromotions t WHERE t.discountType = :discountType"),
    @NamedQuery(name = "TblPromotions.findByDiscountValue", query = "SELECT t FROM TblPromotions t WHERE t.discountValue = :discountValue"),
    @NamedQuery(name = "TblPromotions.findByStartDate", query = "SELECT t FROM TblPromotions t WHERE t.startDate = :startDate"),
    @NamedQuery(name = "TblPromotions.findByEndDate", query = "SELECT t FROM TblPromotions t WHERE t.endDate = :endDate"),
    @NamedQuery(name = "TblPromotions.findByMinNights", query = "SELECT t FROM TblPromotions t WHERE t.minNights = :minNights"),
    @NamedQuery(name = "TblPromotions.findByMaxUses", query = "SELECT t FROM TblPromotions t WHERE t.maxUses = :maxUses"),
    @NamedQuery(name = "TblPromotions.findByUsedCount", query = "SELECT t FROM TblPromotions t WHERE t.usedCount = :usedCount"),
    @NamedQuery(name = "TblPromotions.findByAppliesTo", query = "SELECT t FROM TblPromotions t WHERE t.appliesTo = :appliesTo"),
    @NamedQuery(name = "TblPromotions.findByIsActive", query = "SELECT t FROM TblPromotions t WHERE t.isActive = :isActive")})
public class TblPromotions implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "promo_id")
    private Integer promoId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "promo_name")
    private String promoName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 30)
    @Column(name = "promo_code")
    private String promoCode;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "discount_type")
    private String discountType;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "discount_value")
    private BigDecimal discountValue;
    @Basic(optional = false)
    @NotNull
    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;
    @Basic(optional = false)
    @NotNull
    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;
    @Basic(optional = false)
    @NotNull
    @Column(name = "min_nights")
    private int minNights;
    @Column(name = "max_uses")
    private Integer maxUses;
    @Basic(optional = false)
    @NotNull
    @Column(name = "used_count")
    private int usedCount;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "applies_to")
    private String appliesTo;
    @Basic(optional = false)
    @NotNull
    @Column(name = "is_active")
    private boolean isActive;

    public TblPromotions() {
    }

    public TblPromotions(Integer promoId) {
        this.promoId = promoId;
    }

    public TblPromotions(Integer promoId, String promoName, String promoCode, String discountType, BigDecimal discountValue, Date startDate, Date endDate, int minNights, int usedCount, String appliesTo, boolean isActive) {
        this.promoId = promoId;
        this.promoName = promoName;
        this.promoCode = promoCode;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.startDate = startDate;
        this.endDate = endDate;
        this.minNights = minNights;
        this.usedCount = usedCount;
        this.appliesTo = appliesTo;
        this.isActive = isActive;
    }

    public Integer getPromoId() {
        return promoId;
    }

    public void setPromoId(Integer promoId) {
        this.promoId = promoId;
    }

    public String getPromoName() {
        return promoName;
    }

    public void setPromoName(String promoName) {
        this.promoName = promoName;
    }

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getMinNights() {
        return minNights;
    }

    public void setMinNights(int minNights) {
        this.minNights = minNights;
    }

    public Integer getMaxUses() {
        return maxUses;
    }

    public void setMaxUses(Integer maxUses) {
        this.maxUses = maxUses;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public String getAppliesTo() {
        return appliesTo;
    }

    public void setAppliesTo(String appliesTo) {
        this.appliesTo = appliesTo;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (promoId != null ? promoId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TblPromotions)) {
            return false;
        }
        TblPromotions other = (TblPromotions) object;
        if ((this.promoId == null && other.promoId != null) || (this.promoId != null && !this.promoId.equals(other.promoId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TblPromotions[ promoId=" + promoId + " ]";
    }
    
}
