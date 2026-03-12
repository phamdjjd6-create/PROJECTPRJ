package DAO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;
import model.TblPromotions;

public class PromotionDAO {

    private static final EntityManagerFactory emf = 
            Persistence.createEntityManagerFactory("ResortPU");

    public List<TblPromotions> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT p FROM TblPromotions p WHERE p.isActive = true", TblPromotions.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public TblPromotions findById(Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(TblPromotions.class, id);
        } finally {
            em.close();
        }
    }

    public void save(TblPromotions promotion) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (promotion.getPromoId() == null || em.find(TblPromotions.class, promotion.getPromoId()) == null) {
                em.persist(promotion);
            } else {
                em.merge(promotion);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            TblPromotions promotion = em.find(TblPromotions.class, id);
            if (promotion != null) {
                promotion.setIsActive(false); // Soft delete
                em.merge(promotion);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
