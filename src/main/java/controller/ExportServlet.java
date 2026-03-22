package controller;

import DAO.BookingDAO;
import DAO.ContractDAO;
import DAO.FacilityDAO;
import model.TblEmployees;
import model.TblPersons;
import model.VwBookings;
import model.VwContracts;
import model.TblFacilities;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/dashboard/export")
public class ExportServlet extends HttpServlet {

    private final BookingDAO  bookingDAO  = new BookingDAO();
    private final ContractDAO contractDAO = new ContractDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Auth check
        TblPersons acc = (TblPersons) req.getSession(false) != null
                ? (TblPersons) req.getSession(false).getAttribute("account") : null;
        if (acc == null || !(acc instanceof TblEmployees)
                || !"ADMIN".equals(((TblEmployees) acc).getRole())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String type = req.getParameter("type"); // bookings | contracts | facilities
        if (type == null) type = "bookings";

        String filename = "azure_" + type + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xlsx";
        res.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        res.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            switch (type) {
                case "contracts"  -> writeContracts(wb);
                case "facilities" -> writeFacilities(wb);
                default           -> writeBookings(wb);
            }
            wb.write(res.getOutputStream());
        }
    }

    // ── Styles ────────────────────────────────────────────────────────────────
    private CellStyle headerStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont();
        f.setBold(true); f.setFontHeightInPoints((short) 11);
        s.setFont(f);
        s.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        s.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font fh = wb.createFont(); fh.setBold(true); fh.setColor(IndexedColors.WHITE.getIndex());
        s.setFont(fh);
        s.setBorderBottom(BorderStyle.THIN);
        s.setAlignment(HorizontalAlignment.CENTER);
        return s;
    }

    private CellStyle moneyStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        DataFormat df = wb.createDataFormat();
        s.setDataFormat(df.getFormat("#,##0"));
        return s;
    }

    private CellStyle titleStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont();
        f.setBold(true); f.setFontHeightInPoints((short) 14);
        s.setFont(f);
        return s;
    }

    private Row header(Sheet sheet, CellStyle hs, String... cols) {
        Row r = sheet.createRow(sheet.getLastRowNum() + 1);
        for (int i = 0; i < cols.length; i++) {
            Cell c = r.createCell(i);
            c.setCellValue(cols[i]);
            c.setCellStyle(hs);
        }
        return r;
    }

    private void autoSize(Sheet sheet, int cols) {
        for (int i = 0; i < cols; i++) sheet.autoSizeColumn(i);
    }

    // ── Bookings sheet ────────────────────────────────────────────────────────
    private void writeBookings(XSSFWorkbook wb) {
        Sheet sheet = wb.createSheet("Bookings");
        CellStyle hs = headerStyle(wb);
        CellStyle ms = moneyStyle(wb);
        CellStyle ts = titleStyle(wb);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        // Title
        Row title = sheet.createRow(0);
        Cell tc = title.createCell(0);
        tc.setCellValue("BÁO CÁO BOOKING — Azure Resort & Spa");
        tc.setCellStyle(ts);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 8));

        Row sub = sheet.createRow(1);
        sub.createCell(0).setCellValue("Xuất ngày: " + sdf.format(new Date()));
        sheet.createRow(2); // blank

        header(sheet, hs, "Booking ID", "Khách Hàng", "Phòng/Villa", "Nhận Phòng",
                "Trả Phòng", "Số Khách", "Trạng Thái", "Ngày Đặt");

        List<VwBookings> list = bookingDAO.findAllView();
        for (VwBookings b : list) {
            Row r = sheet.createRow(sheet.getLastRowNum() + 1);
            r.createCell(0).setCellValue(b.getBookingId());
            r.createCell(1).setCellValue(b.getCustomerName() != null ? b.getCustomerName() : "");
            r.createCell(2).setCellValue(b.getFacilityName() != null ? b.getFacilityName() : "");
            r.createCell(3).setCellValue(b.getStartDate() != null ? sdf.format(b.getStartDate()) : "");
            r.createCell(4).setCellValue(b.getEndDate()   != null ? sdf.format(b.getEndDate())   : "");
            r.createCell(5).setCellValue((b.getAdults() + b.getChildren()) + " người");
            r.createCell(6).setCellValue(translateStatus(b.getStatus()));
            r.createCell(7).setCellValue(b.getDateBooking() != null ? sdf.format(b.getDateBooking()) : "");
        }
        autoSize(sheet, 8);
    }

    // ── Contracts sheet ───────────────────────────────────────────────────────
    private void writeContracts(XSSFWorkbook wb) {
        Sheet sheet = wb.createSheet("Hợp Đồng");
        CellStyle hs = headerStyle(wb);
        CellStyle ms = moneyStyle(wb);
        CellStyle ts = titleStyle(wb);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        Row title = sheet.createRow(0);
        Cell tc = title.createCell(0);
        tc.setCellValue("BÁO CÁO HỢP ĐỒNG — Azure Resort & Spa");
        tc.setCellStyle(ts);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 7));
        sheet.createRow(1).createCell(0).setCellValue("Xuất ngày: " + sdf.format(new Date()));
        sheet.createRow(2);

        header(sheet, hs, "Mã HĐ", "Booking ID", "Khách Hàng", "Phòng",
                "Tổng Tiền (đ)", "Đã Trả (đ)", "Còn Lại (đ)", "Trạng Thái");

        List<VwContracts> list = contractDAO.findAll_View();
        double grandTotal = 0, grandPaid = 0;
        for (VwContracts c : list) {
            Row r = sheet.createRow(sheet.getLastRowNum() + 1);
            r.createCell(0).setCellValue(c.getContractId() != null ? c.getContractId() : "");
            r.createCell(1).setCellValue(c.getBookingId()  != null ? c.getBookingId()  : "");
            r.createCell(2).setCellValue(c.getCustomerName() != null ? c.getCustomerName() : "");
            r.createCell(3).setCellValue(c.getFacilityId()   != null ? c.getFacilityId()   : "");
            double total   = c.getTotalPayment()    != null ? c.getTotalPayment().doubleValue()    : 0;
            double paid    = c.getPaidAmount()      != null ? c.getPaidAmount().doubleValue()      : 0;
            double remain  = c.getRemainingAmount() != null ? c.getRemainingAmount().doubleValue() : 0;
            Cell cTotal = r.createCell(4); cTotal.setCellValue(total);   cTotal.setCellStyle(ms);
            Cell cPaid  = r.createCell(5); cPaid.setCellValue(paid);     cPaid.setCellStyle(ms);
            Cell cRem   = r.createCell(6); cRem.setCellValue(remain);    cRem.setCellStyle(ms);
            r.createCell(7).setCellValue(c.getStatus() != null ? c.getStatus() : "");
            grandTotal += total; grandPaid += paid;
        }
        // Summary row
        sheet.createRow(sheet.getLastRowNum() + 1);
        Row sum = sheet.createRow(sheet.getLastRowNum() + 1);
        sum.createCell(3).setCellValue("TỔNG CỘNG:");
        Cell sTotal = sum.createCell(4); sTotal.setCellValue(grandTotal); sTotal.setCellStyle(ms);
        Cell sPaid  = sum.createCell(5); sPaid.setCellValue(grandPaid);   sPaid.setCellStyle(ms);
        autoSize(sheet, 8);
    }

    // ── Facilities sheet ──────────────────────────────────────────────────────
    private void writeFacilities(XSSFWorkbook wb) {
        Sheet sheet = wb.createSheet("Phòng & Villa");
        CellStyle hs = headerStyle(wb);
        CellStyle ms = moneyStyle(wb);
        CellStyle ts = titleStyle(wb);

        Row title = sheet.createRow(0);
        Cell tc = title.createCell(0);
        tc.setCellValue("DANH SÁCH PHÒNG & VILLA — Azure Resort & Spa");
        tc.setCellStyle(ts);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 6));
        sheet.createRow(1);

        header(sheet, hs, "Mã", "Tên", "Loại", "Giá/Đêm (đ)", "Sức Chứa", "Diện Tích (m²)", "Trạng Thái");

        List<TblFacilities> list = facilityDAO.findAll();
        for (TblFacilities f : list) {
            Row r = sheet.createRow(sheet.getLastRowNum() + 1);
            r.createCell(0).setCellValue(f.getServiceCode() != null ? f.getServiceCode() : "");
            r.createCell(1).setCellValue(f.getServiceName() != null ? f.getServiceName() : "");
            r.createCell(2).setCellValue(f.getFacilityType() != null ? f.getFacilityType() : "");
            Cell cPrice = r.createCell(3);
            cPrice.setCellValue(f.getCost() != null ? f.getCost().doubleValue() : 0);
            cPrice.setCellStyle(ms);
            r.createCell(4).setCellValue(f.getMaxPeople());
            r.createCell(5).setCellValue(f.getUsableArea() != null ? f.getUsableArea().toPlainString() : "");
            r.createCell(6).setCellValue(FacilityController.getStatusLabel(f.getStatus()));
        }
        autoSize(sheet, 7);
    }

    private String translateStatus(String s) {
        if (s == null) return "";
        return switch (s) {
            case "PENDING"     -> "Chờ Duyệt";
            case "CONFIRMED"   -> "Đã Xác Nhận";
            case "CHECKED_IN"  -> "Đang Lưu Trú";
            case "CHECKED_OUT" -> "Đã Trả Phòng";
            case "CANCELLED"   -> "Đã Hủy";
            default -> s;
        };
    }
}
