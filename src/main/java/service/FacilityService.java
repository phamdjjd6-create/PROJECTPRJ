package service;

import DAO.FacilityDAO;
import java.util.List;
import model.TblFacilities;

public class FacilityService implements IService<TblFacilities, String> {
    private final FacilityDAO facilityDAO;
    private final AiService aiService;

    public FacilityService() {
        this.facilityDAO = new FacilityDAO();
        this.aiService = new AiService();
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

    public void updateStatus(String code, String status) {
        facilityDAO.updateStatus(code, status);
    }

    public void resetUsage(String code) {
        facilityDAO.resetUsage(code);
    }

    public long countByStatus(String status) {
        return facilityDAO.countByStatus(status);
    }

    /**
     * Dùng AI để tạo mô tả hấp dẫn cho phòng/villa.
     */
    public String generateAiDescription(String name, String type) {
        return aiService.generateFacilityDescription("Phòng/Villa: " + name + " (Loại: " + type + ")");
    }
}
