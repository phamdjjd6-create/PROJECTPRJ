package service;

import DAO.FacilityDAO;
import java.util.List;
import model.TblFacilities;

public class FacilityService implements IService<TblFacilities, String> {
    private final FacilityDAO facilityDAO;

    public FacilityService() {
        this.facilityDAO = new FacilityDAO();
    }

    @Override
    public List<TblFacilities> findAll() {
        return facilityDAO.findAll();
    }

    @Override
    public TblFacilities findById(String id) {
        return facilityDAO.findByCode(id);
    }

    @Override
    public void save(TblFacilities facility) {
        facilityDAO.save(facility);
    }

    @Override
    public void delete(String id) {
        facilityDAO.delete(id);
    }

    // --- Specific methods ---

    public void increaseUsage(String code) {
        facilityDAO.increaseUsage(code);
    }

    public void resetUsageAfterMaintenance(String code) {
        facilityDAO.resetUsage(code);
    }

    public List<TblFacilities> getFacilitiesNeedingMaintenance() {
        return facilityDAO.findAll().stream()
                .filter(f -> f.getUsageCount() >= 5 || "MAINTENANCE".equalsIgnoreCase(f.getStatus()))
                .toList();
    }
}
