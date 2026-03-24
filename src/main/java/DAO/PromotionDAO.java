package DAO;

import jakarta.persistence.EntityManager;
import java.util.List;
import model.TblPromotions;

public class PromotionDAO extends BaseDAO {

    public PromotionDAO() {
        super();
    }

    public PromotionDAO(EntityManager em) {
        super(em);
    }

    public List<TblPromotions> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT p FROM TblPromotions p WHERE p.isActive = true", TblPromotions.class)
                    .getResultList();
        } finally {
            closeIfLocal(em);
        }
    }

    public TblPromotions findById(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(TblPromotions.class, id);
        } finally {
            closeIfLocal(em);
        }
    }

    public TblPromotions findByCode(String code) {
        EntityManager em = getEntityManager();
        try {
            List<TblPromotions> list = em.createQuery("SELECT p FROM TblPromotions p WHERE p.promoCode = :code AND p.isActive = true", TblPromotions.class)
                    .setParameter("code", code.toUpperCase())
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            closeIfLocal(em);
        }
    }

    public void save(TblPromotions promotion) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            if (promotion.getPromoId() == null || em.find(TblPromotions.class, promotion.getPromoId()) == null) {
                em.persist(promotion);
            } else {
                em.merge(promotion);
            }
            if (isLocal) em.getTransaction().commit();
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            closeIfLocal(em);
        }
    }

    public void delete(Integer id) {
        EntityManager em = getEntityManager();
        boolean isLocal = (this.em == null);
        try {
            if (isLocal) em.getTransaction().begin();
            TblPromotions promotion = em.find(TblPromotions.class, id);
            if (promotion != null) {
                promotion.setIsActive(false); // Soft delete
                em.merge(promotion);
            }
            if (isLocal) em.getTransaction().commit();
        } catch (Exception e) {
            if (isLocal && em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            closeIfLocal(em);
        }
    }
}
