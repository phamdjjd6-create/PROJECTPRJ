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
@Table(name = "vw_contracts")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "VwContracts.findAll", query = "SELECT v FROM VwContracts v"),
    @NamedQuery(name = "VwContracts.findByContractId", query = "SELECT v FROM VwContracts v WHERE v.contractId = :contractId"),
    @NamedQuery(name = "VwContracts.findByBookingId", query = "SELECT v FROM VwContracts v WHERE v.bookingId = :bookingId"),
    @NamedQuery(name = "VwContracts.findByDeposit", query = "SELECT v FROM VwContracts v WHERE v.deposit = :deposit"),
    @NamedQuery(name = "VwContracts.findByTotalPayment", query = "SELECT v FROM VwContracts v WHERE v.totalPayment = :totalPayment"),
    @NamedQuery(name = "VwContracts.findByPaidAmount", query = "SELECT v FROM VwContracts v WHERE v.paidAmount = :paidAmount"),
    @NamedQuery(name = "VwContracts.findByRemainingAmount", query = "SELECT v FROM VwContracts v WHERE v.remainingAmount = :remainingAmount"),
    @NamedQuery(name = "VwContracts.findByStatus", query = "SELECT v FROM VwContracts v WHERE v.status = :status"),
    @NamedQuery(name = "VwContracts.findBySignedDate", query = "SELECT v FROM VwContracts v WHERE v.signedDate = :signedDate"),
    @NamedQuery(name = "VwContracts.findByNotes", query = "SELECT v FROM VwContracts v WHERE v.notes = :notes"),
    @NamedQuery(name = "VwContracts.findByEmployeeId", query = "SELECT v FROM VwContracts v WHERE v.employeeId = :employeeId"),
    @NamedQuery(name = "VwContracts.findByEmployeeName", query = "SELECT v FROM VwContracts v WHERE v.employeeName = :employeeName"),
    @NamedQuery(name = "VwContracts.findByCustomerId", query = "SELECT v FROM VwContracts v WHERE v.customerId = :customerId"),
    @NamedQuery(name = "VwContracts.findByStartDate", query = "SELECT v FROM VwContracts v WHERE v.startDate = :startDate"),
    @NamedQuery(name = "VwContracts.findByEndDate", query = "SELECT v FROM VwContracts v WHERE v.endDate = :endDate"),
    @NamedQuery(name = "VwContracts.findByCustomerName", query = "SELECT v FROM VwContracts v WHERE v.customerName = :customerName")})
public class VwContracts implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "contract_id")
    private String contractId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "booking_id")
    private String bookingId;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "deposit")
    private BigDecimal deposit;
    @Basic(optional = false)
    @NotNull
    @Column(name = "total_payment")
    private BigDecimal totalPayment;
    @Basic(optional = false)
    @NotNull
    @Column(name = "paid_amount")
    private BigDecimal paidAmount;
    @Column(name = "remaining_amount")
    private BigDecimal remainingAmount;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "status")
    private String status;
    @Column(name = "signed_date")
    @Temporal(TemporalType.DATE)
    private Date signedDate;
    @Size(max = 500)
    @Column(name = "notes")
    private String notes;
    @Size(max = 20)
    @Column(name = "employee_id")
    private String employeeId;
    @Size(max = 100)
    @Column(name = "employee_name")
    private String employeeName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "customer_id")
    private String customerId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "start_date")
    private String startDate;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "end_date")
    private String endDate;
    @Size(max = 20)
    @Column(name = "facility_id")
    private String facilityId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "customer_name")
    private String customerName;
    public VwContracts() {
    }

    public String getContractId() {
        return contractId;
    }

    public void setContractId(String contractId) {
        this.contractId = contractId;
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public BigDecimal getTotalPayment() {
        return totalPayment;
    }

    public void setTotalPayment(BigDecimal totalPayment) {
        this.totalPayment = totalPayment;
    }

    public BigDecimal getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount;
    }

    public BigDecimal getRemainingAmount() {
        return remainingAmount;
    }

    public void setRemainingAmount(BigDecimal remainingAmount) {
        this.remainingAmount = remainingAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getSignedDate() {
        return signedDate;
    }

    public void setSignedDate(Date signedDate) {
        this.signedDate = signedDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(String facilityId) {
        this.facilityId = facilityId;
    }

    /** Suy ra loại facility từ facilityId prefix */
    public String resolveFacilityType() {
        if (facilityId == null) return "ROOM";
        String id = facilityId.toUpperCase();
        if (id.startsWith("VL")) return "VILLA";
        if (id.startsWith("HS")) return "HOUSE";
        return "ROOM";
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
}
