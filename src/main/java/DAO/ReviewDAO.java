package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblReviews;

public class ReviewDAO extends BaseDAO {

    public ReviewDAO() { super(); }
    public ReviewDAO(EntityManager em) { super(em); }

    public List<TblReviews> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT r FROM TblReviews r ORDER BY r.reviewDate DESC", TblReviews.class)
                    .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public List<TblReviews> findByFacilityId(String facilityId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT r FROM TblReviews r WHERE r.facilityId.serviceCode = :fid ORDER BY r.reviewDate DESC", TblReviews.class)
                    .setParameter("fid", facilityId)
                    .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }
}
