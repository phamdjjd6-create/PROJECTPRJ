package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_reviews")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblReviews implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;

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

    @JoinColumn(name = "booking_id", referencedColumnName = "id")
    @OneToOne(optional = false)
    private TblBookings bookingId;

    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private TblCustomers customerId;
}
