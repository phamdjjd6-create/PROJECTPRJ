package DAO;

import jakarta.persistence.EntityManager;
import model.TblServices;
import java.util.List;
import java.util.ArrayList;

public class ServiceDAO extends BaseDAO {

    public List<TblServices> findAllActive() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT s FROM TblServices s WHERE s.isActive = true", TblServices.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            closeIfLocal(em);
        }
    }
}
