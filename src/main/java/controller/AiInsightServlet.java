package controller;

import service.AuditLogService;
import service.ReviewService;
import service.FacilityService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.TblEmployees;
import org.json.JSONObject;
import java.io.IOException;

@WebServlet("/dashboard/ai-insights")
public class AiInsightServlet extends HttpServlet {

    private final ReviewService reviewService = new ReviewService();
    private final AuditLogService auditLogService = new AuditLogService();
    private final FacilityService facilityService = new FacilityService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        // Authorization check
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("account") instanceof TblEmployees)) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            res.getWriter().print("{\"error\": \"Unauthorized\"}");
            return;
        }

        String type = req.getParameter("type");
        res.setContentType("application/json; charset=UTF-8");
        JSONObject result = new JSONObject();
        
        try {
            if ("sentiment".equals(type)) {
                result = reviewService.getAiSentimentAnalysis();
            } else if ("activity".equals(type)) {
                String summary = auditLogService.getAiDailySummary();
                result.put("summary", summary);
            } else if ("facility_description".equals(type)) {
                String name = req.getParameter("name");
                String ftype = req.getParameter("facilityType");
                String desc = facilityService.generateAiDescription(name, ftype);
                result.put("description", desc);
            } else {
                result.put("error", "Invalid request type.");
            }
        } catch (Exception e) {
            result.put("error", "AI Error: " + e.getMessage());
        }
        res.getWriter().print(result.toString());
    }
}
