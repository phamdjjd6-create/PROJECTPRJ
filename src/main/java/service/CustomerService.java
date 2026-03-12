package service;

import DAO.CustomerDAO;
import java.util.List;
import util.ValidationUtils;
import model.TblCustomers;
import model.VwCustomers;

public class CustomerService implements IService<TblCustomers, String> {
    private final CustomerDAO customerDAO;

    public CustomerService() {
        this.customerDAO = new CustomerDAO();
    }

    @Override
    public List<TblCustomers> findAll() {
        return customerDAO.findAllEntities();
    }
    
    public List<VwCustomers> findAllWithInfo() {
        return customerDAO.findAll();
    }

    @Override
    public TblCustomers findById(String id) {
        return customerDAO.findById(id);
    }

    @Override
    public void save(TblCustomers customer) {
        validateCustomer(customer);
        customerDAO.save(customer);
    }

    @Override
    public void delete(String id) {
        TblCustomers customer = customerDAO.findById(id);
        if (customer != null) {
            customer.getTblPersons().setIsDeleted(true);
            customerDAO.save(customer);
        } else {
            throw new IllegalArgumentException("Không tìm thấy khách hàng để xóa: " + id);
        }
    }

    public void update(String id, TblCustomers item) {
        TblCustomers existed = customerDAO.findById(id);
        if (existed == null) {
            throw new IllegalArgumentException("Không tìm thấy khách hàng với ID: " + id);
        }
        item.setId(id);
        validateCustomer(item);
        customerDAO.save(item);
    }

    private void validateCustomer(TblCustomers c) {
        if (c == null) throw new IllegalArgumentException("Dữ liệu Khách hàng rỗng.");

        if (!ValidationUtils.isValidCustomerId(c.getId())) {
             throw new IllegalArgumentException("Mã khách hàng phải theo định dạng KH-YYYY.");
        }

        if (!ValidationUtils.isValidFullName(c.getTblPersons().getFullName())) {
            throw new IllegalArgumentException("Tên phải viết hoa ký tự đầu của mỗi từ (ví dụ: Nguyen Van A).");
        }

        if (!ValidationUtils.isOldEnough(c.getTblPersons().getDateOfBirth().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate())) {
            // Old code had 15 for customer, but method name is isOldEnough which usually means 18.
            // Let's stick to the validation util logic or adjust if needed.
            // Old code: Period.between(dob, LocalDate.now()).getYears() < 15
            throw new IllegalArgumentException("Khách hàng phải đủ 15 tuổi.");
        }

        if (!ValidationUtils.isValidIdCard(c.getTblPersons().getIdCard())) {
            throw new IllegalArgumentException("CMND/CCCD phải gồm 9 hoặc 12 chữ số.");
        }

        if (!ValidationUtils.isValidPhoneNumber(c.getTblPersons().getPhoneNumber())) {
            throw new IllegalArgumentException("Số điện thoại phải bắt đầu bằng 0 và có đủ 10 chữ số.");
        }
    }
}
