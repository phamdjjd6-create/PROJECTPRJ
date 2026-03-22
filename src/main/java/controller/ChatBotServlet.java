package controller;

import DAO.BookingDAO;
import DAO.ContractDAO;
import DAO.FacilityDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.TblFacilities;
import model.TblPersons;
import model.VwBookings;
import model.VwContracts;
import okhttp3.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

@WebServlet("/chatbot")
public class ChatBotServlet extends HttpServlet {

    private static final String GROQ_API_KEY;
    private static final String GROQ_URL     = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL        = "llama-3.3-70b-versatile";

    static {
        String key = System.getenv("GROQ_API_KEY");
        if (key == null || key.isBlank()) {
            try {
                javax.naming.Context ctx = new javax.naming.InitialContext();
                key = (String) ctx.lookup("java:comp/env/groq.api.key");
            } catch (Exception ignored) {}
        }
        GROQ_API_KEY = (key != null && !key.isBlank()) ? key : "";
    }
    private static final int    MAX_HISTORY  = 24;
    private static final int    SESSION_TIMEOUT = 1800;

    private final OkHttpClient http = new OkHttpClient.Builder()
        .connectTimeout(15, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .build();

    private final FacilityDAO  facilityDAO  = new FacilityDAO();
    private final BookingDAO   bookingDAO   = new BookingDAO();
    private final ContractDAO  contractDAO  = new ContractDAO();

    // ── System prompt ─────────────────────────────────────────────────────────
    private String buildSystemPrompt(TblPersons account) {
        List<TblFacilities> facilities;
        try { facilities = facilityDAO.findAll(); }
        catch (Exception e) { facilities = new ArrayList<>(); }

        StringBuilder fc = new StringBuilder();
        fc.append("=== DANH SÁCH PHÒNG/VILLA/NHÀ (dữ liệu thực) ===\n");
        for (TblFacilities f : facilities) {
            fc.append(String.format(
                "[%s] %s | %s | %,.0f đ/đêm | %s m² | %d người | %s%s\n",
                f.getServiceCode(), f.getServiceName(), f.getFacilityType(),
                f.getCost() != null ? f.getCost().doubleValue() : 0,
                f.getUsableArea() != null ? f.getUsableArea().toPlainString() : "?",
                f.getMaxPeople(), translateStatus(f.getStatus()),
                (f.getDescription() != null && !f.getDescription().isBlank())
                    ? " | " + f.getDescription() : ""
            ));
        }

        StringBuilder userCtx = new StringBuilder();
        if (account != null) {
            userCtx.append("=== THÔNG TIN KHÁCH ĐANG ĐĂNG NHẬP ===\n");
            userCtx.append("Tên: ").append(account.getFullName()).append("\n");
            userCtx.append("Email: ").append(account.getEmail() != null ? account.getEmail() : "chưa cập nhật").append("\n");

            // Load bookings
            try {
                List<VwBookings> bookings = bookingDAO.findAllView();
                List<VwBookings> myBookings = new ArrayList<>();
                for (VwBookings b : bookings) {
                    if (account.getId().equals(b.getCustomerId())) myBookings.add(b);
                }
                if (myBookings.isEmpty()) {
                    userCtx.append("Booking: Chưa có booking nào.\n");
                } else {
                    userCtx.append("Booking của khách (").append(myBookings.size()).append(" booking):\n");
                    for (VwBookings b : myBookings) {
                        userCtx.append(String.format("  - #%s | %s | %s → %s | Trạng thái: %s\n",
                            b.getBookingId(), b.getFacilityName(),
                            b.getStartDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(b.getStartDate()) : "?",
                            b.getEndDate()   != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(b.getEndDate())   : "?",
                            translateBookingStatus(b.getStatus())));
                    }
                }
            } catch (Exception ignored) {}

            // Load contracts
            try {
                List<VwContracts> contracts = contractDAO.findByCustomerId(account.getId());
                if (!contracts.isEmpty()) {
                    userCtx.append("Hợp đồng của khách:\n");
                    for (VwContracts c : contracts) {
                        userCtx.append(String.format("  - %s | Tổng: %,.0f đ | Đã trả: %,.0f đ | Còn lại: %,.0f đ | %s\n",
                            c.getContractId(),
                            c.getTotalPayment() != null ? c.getTotalPayment().doubleValue() : 0,
                            c.getPaidAmount()   != null ? c.getPaidAmount().doubleValue()   : 0,
                            c.getRemainingAmount() != null ? c.getRemainingAmount().doubleValue() : 0,
                            c.getStatus()));
                    }
                }
            } catch (Exception ignored) {}
        } else {
            userCtx.append("=== KHÁCH CHƯA ĐĂNG NHẬP ===\n");
        }

        return
            "Bạn là **Azure**, trợ lý ảo cao cấp của Azure Resort & Spa — khu nghỉ dưỡng 5 sao tại Đà Nẵng, Việt Nam.\n\n" +

            "=== THÔNG TIN RESORT ===\n" +
            "- Địa chỉ: Bãi biển Mỹ Khê, Đà Nẵng, Việt Nam\n" +
            "- Hotline: 1800 7777 (24/7)\n" +
            "- Email: info@azure-resort.vn\n" +
            "- Check-in: 14:00 | Check-out: 12:00\n" +
            "- Tiện ích: Hồ bơi vô cực, Spa 5 sao, Nhà hàng Pearl, Gym, Bãi biển riêng, Dịch vụ đưa đón sân bay\n" +
            "- Chính sách hủy: Miễn phí trước 7 ngày, phí 50% trong 3-7 ngày, không hoàn trong 3 ngày\n" +
            "- Đặt cọc: 10% khi đặt phòng online để xác nhận ngay\n\n" +

            userCtx.toString() + "\n" +
            fc.toString() + "\n" +

            "=== PHONG CÁCH GIAO TIẾP ===\n" +
            "- Xưng là 'Azure', gọi khách là 'quý khách' hoặc tên nếu biết.\n" +
            "- Trả lời bằng tiếng Việt, chuyên nghiệp, ấm áp, súc tích.\n" +
            "- Dùng emoji phù hợp (không lạm dụng).\n" +
            "- Khi liệt kê phòng, dùng định dạng rõ ràng với tên, giá, trạng thái.\n" +
            "- Khi khách hỏi về booking/hợp đồng của họ, trả lời dựa trên dữ liệu thực ở trên.\n" +
            "- Khi khách hỏi đặt phòng, hướng dẫn cụ thể và đề xuất đặt cọc 10%.\n" +
            "- Khi khách hỏi giá, luôn nêu rõ đơn vị đ/đêm và tổng ước tính nếu biết số đêm.\n\n" +

            "=== QUY TẮC ===\n" +
            "- KHÔNG bịa thêm phòng/villa ngoài danh sách.\n" +
            "- KHÔNG trả lời chính trị, lập trình, tin tức không liên quan.\n" +
            "- Ưu tiên gợi ý phòng 'Còn trống' khi tư vấn.\n" +
            "- Luôn kết thúc bằng câu hỏi mở hoặc CTA (đặt phòng, liên hệ hotline).\n" +
            "- Nếu không chắc, hướng dẫn khách gọi hotline 1800 7777.\n";
    }

    private String translateStatus(String s) {
        if (s == null) return "Không rõ";
        return switch (s) {
            case "AVAILABLE"   -> "Còn trống";
            case "OCCUPIED"    -> "Đang có khách";
            case "MAINTENANCE" -> "Bảo trì";
            case "CLEANING"    -> "Đang dọn dẹp";
            default -> s;
        };
    }

    private String translateBookingStatus(String s) {
        if (s == null) return "Không rõ";
        return switch (s) {
            case "PENDING"     -> "Chờ duyệt";
            case "CONFIRMED"   -> "Đã xác nhận";
            case "CHECKED_IN"  -> "Đang lưu trú";
            case "CHECKED_OUT" -> "Đã trả phòng";
            case "CANCELLED"   -> "Đã hủy";
            default -> s;
        };
    }

    // ── POST handler ──────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        req.setCharacterEncoding("UTF-8");
        res.setContentType("application/json; charset=UTF-8");
        res.setHeader("Cache-Control", "no-cache");
        PrintWriter out = res.getWriter();

        String userMessage = req.getParameter("message");
        if (userMessage == null || userMessage.isBlank()) {
            try {
                StringBuilder sb = new StringBuilder();
                String line;
                java.io.BufferedReader reader = req.getReader();
                while ((line = reader.readLine()) != null) sb.append(line);
                String raw = sb.toString().trim();
                if (raw.startsWith("{")) {
                    userMessage = new JSONObject(raw).optString("message", "");
                }
            } catch (Exception ignored) {}
        }

        if (userMessage == null || userMessage.isBlank()) {
            out.print(new JSONObject().put("reply", "Xin chào! Tôi có thể giúp gì cho quý khách? 🌊").toString());
            return;
        }

        HttpSession session = req.getSession(true);
        session.setMaxInactiveInterval(SESSION_TIMEOUT);

        TblPersons account = (TblPersons) session.getAttribute("account");

        Long lastTime = (Long) session.getAttribute("chatTimestamp");
        long now = System.currentTimeMillis();
        if (lastTime != null && (now - lastTime) > SESSION_TIMEOUT * 1000L) {
            session.removeAttribute("chatHistory");
        }
        session.setAttribute("chatTimestamp", now);

        JSONArray history = (JSONArray) session.getAttribute("chatHistory");
        if (history == null) history = new JSONArray();

        history.put(new JSONObject().put("role", "user").put("content", userMessage));
        while (history.length() > MAX_HISTORY) history.remove(0);

        try {
            JSONArray messages = new JSONArray();
            messages.put(new JSONObject().put("role", "system").put("content", buildSystemPrompt(account)));
            for (int i = 0; i < history.length() - 1; i++) messages.put(history.getJSONObject(i));
            messages.put(new JSONObject().put("role", "user").put("content", userMessage));

            JSONObject body = new JSONObject()
                .put("model", MODEL)
                .put("messages", messages)
                .put("temperature", 0.6)
                .put("max_tokens", 700);

            RequestBody requestBody = RequestBody.create(
                MediaType.parse("application/json; charset=utf-8"), body.toString());

            Request request = new Request.Builder()
                .url(GROQ_URL)
                .addHeader("Authorization", "Bearer " + GROQ_API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(requestBody).build();

            try (Response response = http.newCall(request).execute()) {
                if (response.body() == null) {
                    out.print(new JSONObject().put("reply", "Xin lỗi, không nhận được phản hồi từ AI.").toString());
                    return;
                }
                String responseBody = response.body().string();
                if (!response.isSuccessful()) {
                    System.err.println("[ChatBot] Groq error " + response.code() + ": " + responseBody);
                    out.print(new JSONObject().put("reply", "Dịch vụ AI tạm thời gián đoạn. Vui lòng thử lại sau hoặc gọi 1800 7777.").toString());
                    return;
                }

                String reply = new JSONObject(responseBody)
                    .getJSONArray("choices").getJSONObject(0)
                    .getJSONObject("message").getString("content");

                history.put(new JSONObject().put("role", "assistant").put("content", reply));
                while (history.length() > MAX_HISTORY) history.remove(0);
                session.setAttribute("chatHistory", history);

                JSONArray actions = detectActions(userMessage, reply);
                JSONObject result = new JSONObject().put("reply", reply);
                if (actions.length() > 0) result.put("actions", actions);
                out.print(result.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print(new JSONObject().put("reply", "Xin lỗi, có lỗi xảy ra. Vui lòng thử lại hoặc gọi hotline 1800 7777.").toString());
        }
    }

    private JSONArray detectActions(String msg, String reply) {
        JSONArray actions = new JSONArray();
        String m = (msg + " " + reply).toLowerCase();
        if (m.contains("đặt phòng") || m.contains("booking") || m.contains("đặt cọc") || m.contains("đặt ngay")) {
            actions.put(new JSONObject().put("label", "Đặt phòng ngay").put("url", "/booking"));
        }
        if (m.contains("phòng") || m.contains("villa") || m.contains("house") || m.contains("xem phòng")) {
            actions.put(new JSONObject().put("label", "Xem tất cả phòng").put("url", "/rooms"));
        }
        if (m.contains("hợp đồng") || m.contains("thanh toán") || m.contains("contract")) {
            actions.put(new JSONObject().put("label", "Hợp đồng của tôi").put("url", "/contracts"));
        }
        if (m.contains("hotline") || m.contains("liên hệ") || m.contains("1800")) {
            actions.put(new JSONObject().put("label", "Gọi 1800 7777").put("url", "tel:18007777"));
        }
        return actions;
    }
}
