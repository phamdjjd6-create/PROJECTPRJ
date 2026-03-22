package controller;

import DAO.FacilityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TblFacilities;

import java.io.IOException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@WebServlet(name = "FacilityController", urlPatterns = {"/", "/index", "/facilities", "/facility-detail"})
public class FacilityController extends HttpServlet {

    private final FacilityDAO facilityDAO = new FacilityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/facility-detail".equals(path)) {
            String code = request.getParameter("code");
            if (code == null || code.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }
            TblFacilities facility = facilityDAO.findByCode(code.trim());
            if (facility == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phòng/villa!");
                return;
            }

            // Format giá
            NumberFormat fmt = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
            request.setAttribute("facility", facility);
            request.setAttribute("formattedCost", fmt.format(facility.getCost()));
            request.setAttribute("facilityTypeLabel", getFacilityTypeLabel(facility.getFacilityType()));
            request.setAttribute("statusLabel", getStatusLabel(facility.getStatus()));
            request.setAttribute("statusClass", getStatusClass(facility.getStatus()));
            request.setAttribute("rentalTypeLabel", getRentalTypeLabel(facility.getRentalType()));
            request.setAttribute("imgSrc", getImgSrc(facility.getImageUrl(), facility.getFacilityType()));
            request.setAttribute("isAvailable", "AVAILABLE".equalsIgnoreCase(facility.getStatus()));
            request.getRequestDispatcher("/facility-detail.jsp").forward(request, response);

        } else {
            // / hoặc /index hoặc /facilities — load danh sách cho index
            List<TblFacilities> facilities = null;
            String facilityError = null;
            try {
                String checkinStr  = request.getParameter("checkin");
                String checkoutStr = request.getParameter("checkout");
                if (checkinStr != null && !checkinStr.isEmpty() && checkoutStr != null && !checkoutStr.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date checkin  = sdf.parse(checkinStr);
                    Date checkout = sdf.parse(checkoutStr);
                    if (checkout.after(checkin)) {
                        facilities = facilityDAO.findAvailableBetween(checkin, checkout);
                        request.setAttribute("filterCheckin",  checkinStr);
                        request.setAttribute("filterCheckout", checkoutStr);
                    } else {
                        facilities = facilityDAO.findAll();
                    }
                } else {
                    facilities = facilityDAO.findAll();
                }
                System.out.println("[DEBUG] facilities loaded: " + (facilities != null ? facilities.size() : "null"));
            } catch (Throwable ex) {
                facilityError = ex.getClass().getSimpleName() + ": " + ex.getMessage();
                System.err.println("[DEBUG] Error loading facilities: " + facilityError);
                ex.printStackTrace();
            }
            request.setAttribute("facilities", facilities);
            request.setAttribute("facilityError", facilityError);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    // ── Helpers ──────────────────────────────────────────────────

    public static String getFacilityTypeLabel(String type) {
        if (type == null) return "";
        switch (type.toUpperCase()) {
            case "VILLA": return "Villa";
            case "HOUSE": return "House";
            case "ROOM":  return "Phòng";
            default:      return type;
        }
    }

    public static String getStatusLabel(String status) {
        if (status == null) return "";
        switch (status.toUpperCase()) {
            case "AVAILABLE":   return "Còn Trống";
            case "OCCUPIED":    return "Có Khách";
            case "MAINTENANCE": return "Bảo Trì";
            default:            return status;
        }
    }

    public static String getStatusClass(String status) {
        if (status == null) return "available";
        switch (status.toUpperCase()) {
            case "OCCUPIED":    return "occupied";
            case "MAINTENANCE": return "maintenance";
            default:            return "available";
        }
    }

    public static String getRentalTypeLabel(String type) {
        if ("MONTHLY".equalsIgnoreCase(type)) return "Theo Tháng";
        if ("HOURLY".equalsIgnoreCase(type))  return "Theo Giờ";
        return "Theo Đêm";
    }

    public static String getImgSrc(String imageUrl, String facilityType) {
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            return imageUrl;
        }
        if ("VILLA".equalsIgnoreCase(facilityType)) {
            return "assets/img/villa-ocean.png";
        }
        return "assets/img/hero-bg.png";
    }
}
