package service;

import DAO.ContractDAO;
import java.util.List;
import model.TblContracts;

public class ContractService implements IService<TblContracts, String> {
    private final ContractDAO contractDAO;

    public ContractService() {
        this.contractDAO = new ContractDAO();
    }

    @Override
    public List<TblContracts> findAll() {
        return contractDAO.findAll();
    }

    @Override
    public TblContracts findById(String id) {
        return contractDAO.findById(id);
    }

    @Override
    public void save(TblContracts contract) {
        contractDAO.save(contract);
    }

    @Override
    public void delete(String id) {
        TblContracts contract = contractDAO.findById(id);
        if (contract != null) {
            contract.setStatus("CANCELLED");
            contractDAO.save(contract);
        } else {
            throw new IllegalArgumentException("Không tìm thấy hợp đồng để xóa: " + id);
        }
    }

    public void update(String id, TblContracts item) {
        TblContracts existed = contractDAO.findById(id);
        if (existed == null) {
            throw new IllegalArgumentException("Không tìm thấy hợp đồng để cập nhật: " + id);
        }
        item.setContractId(id);
        contractDAO.save(item);
    }

    public List<model.VwContracts> findByCustomerId(String customerId) {
        return contractDAO.findByCustomerId(customerId);
    }

    public List<model.VwContracts> findAllView() {
        return contractDAO.findAll_View();
    }

    public List<model.VwContracts> findByStatus(String status) {
        return contractDAO.findByStatus(status);
    }

    public long countByStatus(String status) {
        return contractDAO.countByStatus(status);
    }

    public String addPayment(String id, java.math.BigDecimal amount, String method, String note) {
        return contractDAO.addPayment(id, amount, method, note);
    }

    public String confirmDeposit(String id, String employeeId) {
        return contractDAO.confirmDeposit(id, employeeId);
    }

    public String approve(String id, String employeeId) {
        return contractDAO.approve(id, employeeId);
    }
}
