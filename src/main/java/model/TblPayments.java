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
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "tbl_payments")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TblPayments.findAll", query = "SELECT t FROM TblPayments t"),
    @NamedQuery(name = "TblPayments.findByPaymentId", query = "SELECT t FROM TblPayments t WHERE t.paymentId = :paymentId"),
    @NamedQuery(name = "TblPayments.findByAmount", query = "SELECT t FROM TblPayments t WHERE t.amount = :amount"),
    @NamedQuery(name = "TblPayments.findByPaymentDate", query = "SELECT t FROM TblPayments t WHERE t.paymentDate = :paymentDate"),
    @NamedQuery(name = "TblPayments.findByPaymentMethod", query = "SELECT t FROM TblPayments t WHERE t.paymentMethod = :paymentMethod"),
    @NamedQuery(name = "TblPayments.findByTransactionRef", query = "SELECT t FROM TblPayments t WHERE t.transactionRef = :transactionRef"),
    @NamedQuery(name = "TblPayments.findByNote", query = "SELECT t FROM TblPayments t WHERE t.note = :note")})
public class TblPayments implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "payment_id")
    private Integer paymentId;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "amount")
    private BigDecimal amount;
    @Basic(optional = false)
    @NotNull
    @Column(name = "payment_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date paymentDate;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 30)
    @Column(name = "payment_method")
    private String paymentMethod;
    @Size(max = 100)
    @Column(name = "transaction_ref")
    private String transactionRef;
    @Size(max = 200)
    @Column(name = "note")
    private String note;
    @JoinColumn(name = "contract_id", referencedColumnName = "contract_id")
    @ManyToOne(optional = false)
    private TblContracts contractId;
    @JoinColumn(name = "received_by", referencedColumnName = "id")
    @ManyToOne
    private TblEmployees receivedBy;

    public TblPayments() {
    }

    public TblPayments(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public TblPayments(Integer paymentId, BigDecimal amount, Date paymentDate, String paymentMethod) {
        this.paymentId = paymentId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentMethod = paymentMethod;
    }

    public Integer getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getTransactionRef() {
        return transactionRef;
    }

    public void setTransactionRef(String transactionRef) {
        this.transactionRef = transactionRef;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public TblContracts getContractId() {
        return contractId;
    }

    public void setContractId(TblContracts contractId) {
        this.contractId = contractId;
    }

    public TblEmployees getReceivedBy() {
        return receivedBy;
    }

    public void setReceivedBy(TblEmployees receivedBy) {
        this.receivedBy = receivedBy;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (paymentId != null ? paymentId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TblPayments)) {
            return false;
        }
        TblPayments other = (TblPayments) object;
        if ((this.paymentId == null && other.paymentId != null) || (this.paymentId != null && !this.paymentId.equals(other.paymentId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TblPayments[ paymentId=" + paymentId + " ]";
    }
    
}
