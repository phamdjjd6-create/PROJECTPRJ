package service;

import DAO.EmployeeDAO;
import java.util.List;
import util.ValidationUtils;
import model.TblEmployees;
import model.VwEmployees;

public class EmployeeService implements IService<TblEmployees, String> {
    private final EmployeeDAO employeeDAO;

    public EmployeeService() {
        this.employeeDAO = new EmployeeDAO();
    }

    @Override
    public List<TblEmployees> findAll() {
        return employeeDAO.findAllEntities();
    }
    
    public List<VwEmployees> findAllWithInfo() {
        return employeeDAO.findAll();
    }

    @Override
    public TblEmployees findById(String id) {
        return employeeDAO.findById(id);
    }

    @Override
    public void save(TblEmployees employee) {
        validateEmployee(employee);
        employeeDAO.save(employee);
    }

    @Override
    public void delete(String id) {
        TblEmployees employee = employeeDAO.findById(id);
        if (employee != null) {
            employee.setDeleted(true);
            employeeDAO.save(employee);
        } else {
            throw new IllegalArgumentException("Không tìm thấy nhân viên để xóa: " + id);
        }
    }

    public void update(String id, TblEmployees item) {
        TblEmployees existed = employeeDAO.findById(id);
        if (existed == null) {
            throw new IllegalArgumentException("Không tìm thấy nhân viên với ID: " + id);
        }
        item.setId(id);
        validateEmployee(item);
        employeeDAO.save(item);
    }

    private void validateEmployee(TblEmployees e) {
        if (e == null) throw new IllegalArgumentException("Dữ liệu nhân viên rỗng.");

        if (!ValidationUtils.isValidEmployeeId(e.getId())) {
            throw new IllegalArgumentException("Mã nhân viên phải theo định dạng NV-YYYY.");
        }

        if (!ValidationUtils.isValidFullName(e.getFullName())) {
            throw new IllegalArgumentException("Tên phải viết hoa ký tự đầu của mỗi từ (ví dụ: Nguyen Van A).");
        }

        if (!ValidationUtils.isOldEnough(e.getDateOfBirth().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate())) {
            throw new IllegalArgumentException("Nhân viên phải đủ 18 tuổi.");
        }

        if (!ValidationUtils.isValidIdCard(e.getIdCard())) {
            throw new IllegalArgumentException("CMND/CCCD phải gồm 9 hoặc 12 chữ số.");
        }

        if (!ValidationUtils.isValidPhoneNumber(e.getPhoneNumber())) {
            throw new IllegalArgumentException("Số điện thoại phải bắt đầu bằng 0 và có đủ 10 chữ số.");
        }

        if (e.getSalary() == null || e.getSalary().doubleValue() <= 0) {
            throw new IllegalArgumentException("Lương phải lớn hơn 0.");
        }
    }

    public void updateSalary(String id, java.math.BigDecimal salary) {
        employeeDAO.updateSalary(id, salary);
    }

    public void updatePosition(String id, String position) {
        employeeDAO.updatePosition(id, position);
    }

    public void updateRole(String id, String role) {
        employeeDAO.updateRole(id, role);
    }
}
