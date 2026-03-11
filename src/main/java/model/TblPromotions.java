package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "tbl_promotions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TblPromotions implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;

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
}
