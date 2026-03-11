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
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;

/**
 *
 * @author Pheo
 */
@Entity
@Table(name = "vw_facility_ratings")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "VwFacilityRatings.findAll", query = "SELECT v FROM VwFacilityRatings v"),
    @NamedQuery(name = "VwFacilityRatings.findByFacilityId", query = "SELECT v FROM VwFacilityRatings v WHERE v.facilityId = :facilityId"),
    @NamedQuery(name = "VwFacilityRatings.findByServiceName", query = "SELECT v FROM VwFacilityRatings v WHERE v.serviceName = :serviceName"),
    @NamedQuery(name = "VwFacilityRatings.findByFacilityType", query = "SELECT v FROM VwFacilityRatings v WHERE v.facilityType = :facilityType"),
    @NamedQuery(name = "VwFacilityRatings.findByReviewCount", query = "SELECT v FROM VwFacilityRatings v WHERE v.reviewCount = :reviewCount"),
    @NamedQuery(name = "VwFacilityRatings.findByAvgRating", query = "SELECT v FROM VwFacilityRatings v WHERE v.avgRating = :avgRating"),
    @NamedQuery(name = "VwFacilityRatings.findByFiveStar", query = "SELECT v FROM VwFacilityRatings v WHERE v.fiveStar = :fiveStar")})
public class VwFacilityRatings implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "facility_id")
    private String facilityId;
    @Size(max = 150)
    @Column(name = "service_name")
    private String serviceName;
    @Size(max = 5)
    @Column(name = "facility_type")
    private String facilityType;
    @Column(name = "review_count")
    private Integer reviewCount;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "avg_rating")
    private BigDecimal avgRating;
    @Column(name = "five_star")
    private Integer fiveStar;

    public VwFacilityRatings() {
    }

    public String getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(String facilityId) {
        this.facilityId = facilityId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getFacilityType() {
        return facilityType;
    }

    public void setFacilityType(String facilityType) {
        this.facilityType = facilityType;
    }

    public Integer getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(Integer reviewCount) {
        this.reviewCount = reviewCount;
    }

    public BigDecimal getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(BigDecimal avgRating) {
        this.avgRating = avgRating;
    }

    public Integer getFiveStar() {
        return fiveStar;
    }

    public void setFiveStar(Integer fiveStar) {
        this.fiveStar = fiveStar;
    }
    
}
