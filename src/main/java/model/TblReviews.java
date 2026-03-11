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
import jakarta.persistence.OneToOne;
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
@Table(name = "tbl_reviews")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TblReviews.findAll", query = "SELECT t FROM TblReviews t"),
    @NamedQuery(name = "TblReviews.findByReviewId", query = "SELECT t FROM TblReviews t WHERE t.reviewId = :reviewId"),
    @NamedQuery(name = "TblReviews.findByRating", query = "SELECT t FROM TblReviews t WHERE t.rating = :rating"),
    @NamedQuery(name = "TblReviews.findByTitle", query = "SELECT t FROM TblReviews t WHERE t.title = :title"),
    @NamedQuery(name = "TblReviews.findByContent", query = "SELECT t FROM TblReviews t WHERE t.content = :content"),
    @NamedQuery(name = "TblReviews.findByReviewDate", query = "SELECT t FROM TblReviews t WHERE t.reviewDate = :reviewDate"),
    @NamedQuery(name = "TblReviews.findByIsPublished", query = "SELECT t FROM TblReviews t WHERE t.isPublished = :isPublished"),
    @NamedQuery(name = "TblReviews.findByReply", query = "SELECT t FROM TblReviews t WHERE t.reply = :reply")})
public class TblReviews implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "review_id")
    private Integer reviewId;
    @Basic(optional = false)
    @NotNull
    @Column(name = "rating")
    private short rating;
    @Size(max = 150)
    @Column(name = "title")
    private String title;
    @Size(max = 1000)
    @Column(name = "content")
    private String content;
    @Basic(optional = false)
    @NotNull
    @Column(name = "review_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date reviewDate;
    @Basic(optional = false)
    @NotNull
    @Column(name = "is_published")
    private boolean isPublished;
    @Size(max = 500)
    @Column(name = "reply")
    private String reply;
    @JoinColumn(name = "booking_id", referencedColumnName = "booking_id")
    @OneToOne(optional = false)
    private TblBookings bookingId;
    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblCustomers customerId;

    public TblReviews() {
    }

    public TblReviews(Integer reviewId) {
        this.reviewId = reviewId;
    }

    public TblReviews(Integer reviewId, short rating, Date reviewDate, boolean isPublished) {
        this.reviewId = reviewId;
        this.rating = rating;
        this.reviewDate = reviewDate;
        this.isPublished = isPublished;
    }

    public Integer getReviewId() {
        return reviewId;
    }

    public void setReviewId(Integer reviewId) {
        this.reviewId = reviewId;
    }

    public short getRating() {
        return rating;
    }

    public void setRating(short rating) {
        this.rating = rating;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    public boolean getIsPublished() {
        return isPublished;
    }

    public void setIsPublished(boolean isPublished) {
        this.isPublished = isPublished;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public TblBookings getBookingId() {
        return bookingId;
    }

    public void setBookingId(TblBookings bookingId) {
        this.bookingId = bookingId;
    }

    public TblCustomers getCustomerId() {
        return customerId;
    }

    public void setCustomerId(TblCustomers customerId) {
        this.customerId = customerId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (reviewId != null ? reviewId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TblReviews)) {
            return false;
        }
        TblReviews other = (TblReviews) object;
        if ((this.reviewId == null && other.reviewId != null) || (this.reviewId != null && !this.reviewId.equals(other.reviewId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TblReviews[ reviewId=" + reviewId + " ]";
    }
    
}
