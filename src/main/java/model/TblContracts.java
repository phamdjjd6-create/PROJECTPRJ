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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author Pheo
 */
@Entity
@Table(name = "tbl_contracts")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TblContracts.findAll", query = "SELECT t FROM TblContracts t"),
    @NamedQuery(name = "TblContracts.findByContractId", query = "SELECT t FROM TblContracts t WHERE t.contractId = :contractId"),
    @NamedQuery(name = "TblContracts.findByDeposit", query = "SELECT t FROM TblContracts t WHERE t.deposit = :deposit"),
    @NamedQuery(name = "TblContracts.findByTotalPayment", query = "SELECT t FROM TblContracts t WHERE t.totalPayment = :totalPayment"),
    @NamedQuery(name = "TblContracts.findByPaidAmount", query = "SELECT t FROM TblContracts t WHERE t.paidAmount = :paidAmount"),
    @NamedQuery(name = "TblContracts.findByStatus", query = "SELECT t FROM TblContracts t WHERE t.status = :status"),
    @NamedQuery(name = "TblContracts.findBySignedDate", query = "SELECT t FROM TblContracts t WHERE t.signedDate = :signedDate"),
    @NamedQuery(name = "TblContracts.findByNotes", query = "SELECT t FROM TblContracts t WHERE t.notes = :notes")})
public class TblContracts implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "contract_id")
    private String contractId;
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
    @JoinColumn(name = "booking_id", referencedColumnName = "booking_id")
    @OneToOne(optional = false)
    private TblBookings bookingId;
    @JoinColumn(name = "employee_id", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees employeeId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "contractId")
    private Collection<TblPayments> tblPaymentsCollection;

    public TblContracts() {
    }

    public TblContracts(String contractId) {
        this.contractId = contractId;
    }

    public TblContracts(String contractId, BigDecimal deposit, BigDecimal totalPayment, BigDecimal paidAmount, String status) {
        this.contractId = contractId;
        this.deposit = deposit;
        this.totalPayment = totalPayment;
        this.paidAmount = paidAmount;
        this.status = status;
    }

    public String getContractId() {
        return contractId;
    }

    public void setContractId(String contractId) {
        this.contractId = contractId;
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

    public TblBookings getBookingId() {
        return bookingId;
    }

    public void setBookingId(TblBookings bookingId) {
        this.bookingId = bookingId;
    }

    public TblEmployees getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(TblEmployees employeeId) {
        this.employeeId = employeeId;
    }

    @XmlTransient
    public Collection<TblPayments> getTblPaymentsCollection() {
        return tblPaymentsCollection;
    }

    public void setTblPaymentsCollection(Collection<TblPayments> tblPaymentsCollection) {
        this.tblPaymentsCollection = tblPaymentsCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (contractId != null ? contractId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TblContracts)) {
            return false;
        }
        TblContracts other = (TblContracts) object;
        if ((this.contractId == null && other.contractId != null) || (this.contractId != null && !this.contractId.equals(other.contractId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TblContracts[ contractId=" + contractId + " ]";
    }
    
}
