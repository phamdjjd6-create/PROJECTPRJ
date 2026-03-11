/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;

/**
 *
 * @author Pheo
 */
@Entity
@Table(name = "vw_monthly_revenue")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "VwMonthlyRevenue.findAll", query = "SELECT v FROM VwMonthlyRevenue v"),
    @NamedQuery(name = "VwMonthlyRevenue.findByYr", query = "SELECT v FROM VwMonthlyRevenue v WHERE v.yr = :yr"),
    @NamedQuery(name = "VwMonthlyRevenue.findByMo", query = "SELECT v FROM VwMonthlyRevenue v WHERE v.mo = :mo"),
    @NamedQuery(name = "VwMonthlyRevenue.findByPaymentCount", query = "SELECT v FROM VwMonthlyRevenue v WHERE v.paymentCount = :paymentCount"),
    @NamedQuery(name = "VwMonthlyRevenue.findByTotalRevenue", query = "SELECT v FROM VwMonthlyRevenue v WHERE v.totalRevenue = :totalRevenue"),
    @NamedQuery(name = "VwMonthlyRevenue.findByAvgPayment", query = "SELECT v FROM VwMonthlyRevenue v WHERE v.avgPayment = :avgPayment")})
public class VwMonthlyRevenue implements Serializable {

    private static final long serialVersionUID = 1L;
    @Column(name = "yr")
    private Integer yr;
    @Column(name = "mo")
    private Integer mo;
    @Column(name = "payment_count")
    private Integer paymentCount;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "total_revenue")
    private BigDecimal totalRevenue;
    @Column(name = "avg_payment")
    private BigDecimal avgPayment;

    public VwMonthlyRevenue() {
    }

    public Integer getYr() {
        return yr;
    }

    public void setYr(Integer yr) {
        this.yr = yr;
    }

    public Integer getMo() {
        return mo;
    }

    public void setMo(Integer mo) {
        this.mo = mo;
    }

    public Integer getPaymentCount() {
        return paymentCount;
    }

    public void setPaymentCount(Integer paymentCount) {
        this.paymentCount = paymentCount;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public BigDecimal getAvgPayment() {
        return avgPayment;
    }

    public void setAvgPayment(BigDecimal avgPayment) {
        this.avgPayment = avgPayment;
    }
    
}
