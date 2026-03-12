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
}
