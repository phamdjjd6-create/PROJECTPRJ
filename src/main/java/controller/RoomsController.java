package controller;

import DAO.FacilityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TblFacilities;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RoomsController", urlPatterns = {"/rooms"})
public class RoomsController extends HttpServlet {

    private final FacilityDAO facilityDAO = new FacilityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<TblFacilities> allFacilities = null;
        try {
            allFacilities = facilityDAO.findAll();
        } catch (Throwable ex) {
            Throwable cause = ex.getCause() != null ? ex.getCause() : ex;
            request.setAttribute("facilityError", "[" + ex.getClass().getSimpleName() + "] " + cause.getMessage());
        }

        // Search params
        String filterType  = request.getParameter("type");
        String checkin     = request.getParameter("checkin");
        String checkout    = request.getParameter("checkout");
        String adultsParam = request.getParameter("adults");

        int adults = 1;
        boolean adultsSelected = false;
        if (adultsParam != null && !adultsParam.isEmpty()) {
            try { adults = Integer.parseInt(adultsParam); } catch (NumberFormatException ignored) {}
            adultsSelected = adults > 1;
        }

        boolean isSearchMode = (checkin != null && !checkin.isEmpty())
                || (checkout != null && !checkout.isEmpty())
                || (filterType != null && !filterType.isEmpty())
                || adultsSelected;

        // Filter facilities
        List<TblFacilities> filtered = new ArrayList<>();
        int cntAll = 0, cntVilla = 0, cntHouse = 0, cntRoom = 0;

        if (allFacilities != null) {
            for (TblFacilities f : allFacilities) {
                // Count available by type (for tabs)
                if ("AVAILABLE".equalsIgnoreCase(f.getStatus())) {
                    cntAll++;
                    if ("VILLA".equalsIgnoreCase(f.getFacilityType())) cntVilla++;
                    else if ("HOUSE".equalsIgnoreCase(f.getFacilityType())) cntHouse++;
                    else if ("ROOM".equalsIgnoreCase(f.getFacilityType())) cntRoom++;
                }

                // Apply filters
                if (!"AVAILABLE".equalsIgnoreCase(f.getStatus())) continue;
                if (filterType != null && !filterType.isEmpty()
                        && !filterType.equalsIgnoreCase(f.getFacilityType())) continue;
                if (adultsSelected && f.getMaxPeople() < adults) continue;

                filtered.add(f);
            }
        }

        request.setAttribute("facilities", allFacilities);
        request.setAttribute("filteredFacilities", filtered);
        request.setAttribute("filterType", filterType);
        request.setAttribute("checkin", checkin);
        request.setAttribute("checkout", checkout);
        request.setAttribute("adults", adults);
        request.setAttribute("isSearchMode", isSearchMode);
        request.setAttribute("cntAll", cntAll);
        request.setAttribute("cntVilla", cntVilla);
        request.setAttribute("cntHouse", cntHouse);
        request.setAttribute("cntRoom", cntRoom);

        request.getRequestDispatcher("/rooms.jsp").forward(request, response);
    }
}
