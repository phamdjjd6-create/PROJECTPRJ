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
import java.util.Date;

/**
 *
 * @author Pheo
 */
@Entity
@Table(name = "tbl_audit_log")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TblAuditLog.findAll", query = "SELECT t FROM TblAuditLog t"),
    @NamedQuery(name = "TblAuditLog.findByLogId", query = "SELECT t FROM TblAuditLog t WHERE t.logId = :logId"),
    @NamedQuery(name = "TblAuditLog.findByTableName", query = "SELECT t FROM TblAuditLog t WHERE t.tableName = :tableName"),
    @NamedQuery(name = "TblAuditLog.findByAction", query = "SELECT t FROM TblAuditLog t WHERE t.action = :action"),
    @NamedQuery(name = "TblAuditLog.findByRecordId", query = "SELECT t FROM TblAuditLog t WHERE t.recordId = :recordId"),
    @NamedQuery(name = "TblAuditLog.findByOldValue", query = "SELECT t FROM TblAuditLog t WHERE t.oldValue = :oldValue"),
    @NamedQuery(name = "TblAuditLog.findByNewValue", query = "SELECT t FROM TblAuditLog t WHERE t.newValue = :newValue"),
    @NamedQuery(name = "TblAuditLog.findByChangedBy", query = "SELECT t FROM TblAuditLog t WHERE t.changedBy = :changedBy"),
    @NamedQuery(name = "TblAuditLog.findByChangedAt", query = "SELECT t FROM TblAuditLog t WHERE t.changedAt = :changedAt"),
    @NamedQuery(name = "TblAuditLog.findByIpAddress", query = "SELECT t FROM TblAuditLog t WHERE t.ipAddress = :ipAddress")})
public class TblAuditLog implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "log_id")
    private Long logId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "table_name")
    private String tableName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "action")
    private String action;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "record_id")
    private String recordId;
    @Size(max = 2147483647)
    @Column(name = "old_value")
    private String oldValue;
    @Size(max = 2147483647)
    @Column(name = "new_value")
    private String newValue;
    @Size(max = 20)
    @Column(name = "changed_by")
    private String changedBy;
    @Basic(optional = false)
    @NotNull
    @Column(name = "changed_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date changedAt;
    @Size(max = 50)
    @Column(name = "ip_address")
    private String ipAddress;

    public TblAuditLog() {
    }

    public TblAuditLog(Long logId) {
        this.logId = logId;
    }

    public TblAuditLog(Long logId, String tableName, String action, String recordId, Date changedAt) {
        this.logId = logId;
        this.tableName = tableName;
        this.action = action;
        this.recordId = recordId;
        this.changedAt = changedAt;
    }

    public Long getLogId() {
        return logId;
    }

    public void setLogId(Long logId) {
        this.logId = logId;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getRecordId() {
        return recordId;
    }

    public void setRecordId(String recordId) {
        this.recordId = recordId;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public String getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(String changedBy) {
        this.changedBy = changedBy;
    }

    public Date getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Date changedAt) {
        this.changedAt = changedAt;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (logId != null ? logId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TblAuditLog)) {
            return false;
        }
        TblAuditLog other = (TblAuditLog) object;
        if ((this.logId == null && other.logId != null) || (this.logId != null && !this.logId.equals(other.logId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TblAuditLog[ logId=" + logId + " ]";
    }
    
}
