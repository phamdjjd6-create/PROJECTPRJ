package controller;

import DAO.BookingDAO;
import DAO.FacilityDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.TblFacilities;
import model.TblPersons;
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

    private static final String GROQ_API_KEY = "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";
    private static final String GROQ_URL     = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL        = "llama-3.3-70b-versatile";
    private static final int    MAX_HISTORY  = 24;
    private static final int    SESSION_TIMEOUT = 1800;

    private final OkHttpClient http = new OkHttpClient.Builder()
        .connectTimeout(15, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .build();

    private final FacilityDAO facilityDAO = new FacilityDAO();
    private final BookingDAO  bookingDAO  = new BookingDAO();

    // ── System prompt ─────────────────────────────────────────────────────────
    private String buildSystemPrompt(String userName, long bookingCount) {
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

        String userCtx = userName != null
            ? "Khách đang đăng nhập: " + userName + " | Số booking đã có: " + bookingCount + "\n"
            : "Khách chưa đăng nhập.\n";

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

            "=== THÔNG TIN KHÁCH ===\n" + userCtx + "\n" +

            fc.toString() + "\n" +

            "=== PHONG CÁCH GIAO TIẾP ===\n" +
            "- Xưng là 'Azure', gọi khách là 'quý khách' hoặc tên nếu biết.\n" +
            "- Trả lời bằng tiếng Việt, chuyên nghiệp, ấm áp, súc tích.\n" +
            "- Dùng emoji phù hợp (không lạm dụng).\n" +
            "- Khi liệt kê phòng, dùng định dạng rõ ràng với tên, giá, trạng thái.\n" +
            "- Khi khách hỏi đặt phòng, hướng dẫn cụ thể và đề xuất đặt cọc 10%.\n" +
            "- Khi khách hỏi giá, luôn nêu rõ đơn vị đ/đêm và tổng ước tính nếu biết số đêm.\n" +
            "- Khi chào hỏi, chào lại nhiệt tình và hỏi có thể giúp gì.\n" +
            "- Khi cảm ơn, đáp lại lịch sự.\n\n" +

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
            case "AVAILABLE"   -> "Còn trống ✅";
            case "OCCUPIED"    -> "Đang có khách";
            case "MAINTENANCE" -> "Bảo trì";
            case "CLEANING"    -> "Đang dọn dẹp";
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

        // Lấy thông tin user từ session
        HttpSession session = req.getSession(true);
        session.setMaxInactiveInterval(SESSION_TIMEOUT);

        TblPersons account = (TblPersons) session.getAttribute("account");
        String userName = account != null ? account.getFullName() : null;
        long bookingCount = 0;
        if (account != null) {
            try { bookingCount = bookingDAO.findByCustomerId(account.getId()).size(); }
            catch (Exception ignored) {}
        }

        // Session timeout check
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
            messages.put(new JSONObject().put("role", "system").put("content", buildSystemPrompt(userName, bookingCount)));
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

                // Detect intent để trả về action buttons
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

    /** Trả về action buttons dựa trên nội dung tin nhắn */
    private JSONArray detectActions(String msg, String reply) {
        JSONArray actions = new JSONArray();
        String m = (msg + " " + reply).toLowerCase();

        if (m.contains("đặt phòng") || m.contains("booking") || m.contains("đặt cọc") || m.contains("đặt ngay")) {
            actions.put(new JSONObject().put("label", "🏨 Đặt phòng ngay").put("url", "/booking"));
        }
        if (m.contains("phòng") || m.contains("villa") || m.contains("house") || m.contains("xem phòng")) {
            actions.put(new JSONObject().put("label", "🔍 Xem tất cả phòng").put("url", "/rooms"));
        }
        if (m.contains("hợp đồng") || m.contains("thanh toán") || m.contains("contract")) {
            actions.put(new JSONObject().put("label", "📄 Hợp đồng của tôi").put("url", "/contracts"));
        }
        if (m.contains("hotline") || m.contains("liên hệ") || m.contains("1800")) {
            actions.put(new JSONObject().put("label", "📞 Gọi 1800 7777").put("url", "tel:18007777"));
        }
        return actions;
    }
}

    private static final String GROQ_API_KEY = "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";
    private static final String GROQ_URL     = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL        = "llama-3.3-70b-versatile";

    // Giữ tối đa 20 tin nhắn gần nhất trong session (10 lượt hỏi-đáp)
    private static final int MAX_HISTORY = 20;
    // Session timeout: 30 phút
    private static final int SESSION_TIMEOUT_SECONDS = 1800;

    private static final String SESSION_KEY_HISTORY   = "chatHistory";
    private static final String SESSION_KEY_TIMESTAMP = "chatTimestamp";

    private final OkHttpClient httpClient = new OkHttpClient.Builder()
        .connectTimeout(15, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .build();

    private final FacilityDAO facilityDAO = new FacilityDAO();

    // ── Build system prompt từ dữ liệu facility trong DB ─────────────────────
    private String buildSystemPrompt() {
        List<TblFacilities> facilities;
        try {
            facilities = facilityDAO.findAll();
        } catch (Exception e) {
            facilities = new ArrayList<>();
        }

        StringBuilder facilityContext = new StringBuilder();
        facilityContext.append("DANH SÁCH PHÒNG/VILLA/NHÀ TẠI AZURE RESORT (dữ liệu thực từ hệ thống):\n");

        for (TblFacilities f : facilities) {
            facilityContext.append(String.format(
                "- [%s] %s | Loại: %s | Giá: %,.0f đ/đêm | Diện tích: %s m² | Sức chứa: %d người | Trạng thái: %s%s\n",
                f.getServiceCode(),
                f.getServiceName(),
                f.getFacilityType(),
                f.getCost() != null ? f.getCost().doubleValue() : 0,
                f.getUsableArea() != null ? f.getUsableArea().toPlainString() : "?",
                f.getMaxPeople(),
                translateStatus(f.getStatus()),
                (f.getDescription() != null && !f.getDescription().isBlank())
                    ? " | Mô tả: " + f.getDescription()
                    : ""
            ));
        }

        return
            "Bạn là trợ lý ảo thân thiện của Azure Resort & Spa — khu nghỉ dưỡng 5 sao tại Đà Nẵng, Việt Nam.\n\n" +

            "PHONG CÁCH GIAO TIẾP:\n" +
            "- Luôn trả lời bằng tiếng Việt, thân thiện, ấm áp, ngắn gọn.\n" +
            "- Khi khách chào (xin chào, hello, hi, chào buổi sáng/chiều/tối...), hãy chào lại nhiệt tình, " +
              "giới thiệu bản thân là trợ lý của Azure Resort và hỏi bạn có thể giúp gì.\n" +
            "- Khi khách hỏi bạn là ai / bạn có thể làm gì, hãy giới thiệu ngắn gọn về khả năng tư vấn.\n" +
            "- Khi khách cảm ơn, hãy đáp lại lịch sự và mời hỏi thêm.\n\n" +

            "PHẠM VI TƯ VẤN CHÍNH:\n" +
            "1. THỜI TIẾT: Khi khách hỏi thời tiết ở bất kỳ đâu:\n" +
               "   - Mô tả ngắn gọn khí hậu/thời tiết tại địa điểm đó.\n" +
               "   - Nếu gần Đà Nẵng/miền Trung: giới thiệu phòng/villa phù hợp từ danh sách.\n" +
               "   - Nếu xa Đà Nẵng: mô tả thời tiết đó rồi gợi ý 'Nếu muốn nghỉ dưỡng đẳng cấp, " +
                  "Azure Resort tại Đà Nẵng có...' và giới thiệu phòng phù hợp.\n" +
            "2. PHÒNG & VILLA: Trả lời mọi câu hỏi về phòng, villa, nhà trong danh sách bên dưới.\n\n" +

            "QUY TẮC:\n" +
            "- KHÔNG bịa thêm phòng/villa ngoài danh sách.\n" +
            "- KHÔNG trả lời về chính trị, lập trình, tin tức hay chủ đề hoàn toàn không liên quan.\n" +
            "- Khi gợi ý phòng, ưu tiên phòng có trạng thái 'Còn trống'.\n" +
            "- Luôn kết thúc bằng cách mời khách đặt phòng hoặc hỏi thêm.\n\n" +

            facilityContext.toString();
    }

    private String translateStatus(String status) {
        if (status == null) return "Không rõ";
        return switch (status) {
            case "AVAILABLE"   -> "Còn trống";
            case "OCCUPIED"    -> "Đang có khách";
            case "MAINTENANCE" -> "Bảo trì";
            case "CLEANING"    -> "Đang dọn dẹp";
            default            -> status;
        };
    }

    // ── Servlet handler ───────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        req.setCharacterEncoding("UTF-8");
        res.setContentType("application/json; charset=UTF-8");
        res.setHeader("Cache-Control", "no-cache");

        PrintWriter out = res.getWriter();

        // Hỗ trợ cả form-urlencoded và multipart/form-data
        String userMessage = req.getParameter("message");

        // Fallback: đọc thẳng từ body nếu Content-Type là application/json
        if (userMessage == null || userMessage.isBlank()) {
            try {
                StringBuilder sb = new StringBuilder();
                String line;
                java.io.BufferedReader reader = req.getReader();
                while ((line = reader.readLine()) != null) sb.append(line);
                String rawBody = sb.toString().trim();
                if (rawBody.startsWith("{")) {
                    // JSON body
                    userMessage = new JSONObject(rawBody).optString("message", "");
                } else if (rawBody.contains("message=")) {
                    // URL-encoded fallback
                    for (String part : rawBody.split("&")) {
                        if (part.startsWith("message=")) {
                            userMessage = java.net.URLDecoder.decode(
                                part.substring(8), "UTF-8");
                            break;
                        }
                    }
                }
            } catch (Exception ignored) {}
        }

        if (userMessage == null || userMessage.isBlank()) {
            out.print("{\"reply\":\"Bạn muốn hỏi gì về thời tiết hoặc phòng tại Azure Resort?\"}");
            return;
        }

        // ── Session management ────────────────────────────────────────────────
        HttpSession session = req.getSession(true);
        session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);

        // Kiểm tra timeout thủ công (phòng trường hợp session server chưa expire)
        Long lastTime = (Long) session.getAttribute(SESSION_KEY_TIMESTAMP);
        long now = System.currentTimeMillis();
        if (lastTime != null && (now - lastTime) > SESSION_TIMEOUT_SECONDS * 1000L) {
            session.removeAttribute(SESSION_KEY_HISTORY);
        }
        session.setAttribute(SESSION_KEY_TIMESTAMP, now);

        // Lấy hoặc tạo mới lịch sử chat
        JSONArray history = (JSONArray) session.getAttribute(SESSION_KEY_HISTORY);
        if (history == null) history = new JSONArray();

        // Thêm tin nhắn user vào history
        history.put(new JSONObject().put("role", "user").put("content", userMessage));

        // Giới hạn history tối đa MAX_HISTORY tin nhắn
        while (history.length() > MAX_HISTORY) {
            history.remove(0);
        }

        // ── Build messages array cho Groq ─────────────────────────────────────
        try {
            JSONArray messages = new JSONArray();

            // System prompt với dữ liệu facility từ DB
            messages.put(new JSONObject()
                .put("role", "system")
                .put("content", buildSystemPrompt()));

            // Lịch sử hội thoại (không bao gồm tin nhắn user vừa thêm — sẽ thêm riêng)
            for (int i = 0; i < history.length() - 1; i++) {
                messages.put(history.getJSONObject(i));
            }

            // Tin nhắn user hiện tại
            messages.put(new JSONObject().put("role", "user").put("content", userMessage));

            JSONObject body = new JSONObject()
                .put("model", MODEL)
                .put("messages", messages)
                .put("temperature", 0.5)
                .put("max_tokens", 600);

            RequestBody requestBody = RequestBody.create(
                MediaType.parse("application/json; charset=utf-8"),
                body.toString()
            );

            Request request = new Request.Builder()
                .url(GROQ_URL)
                .addHeader("Authorization", "Bearer " + GROQ_API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(requestBody)
                .build();

            try (Response response = httpClient.newCall(request).execute()) {
                if (response.body() == null) {
                    out.print("{\"reply\":\"Xin lỗi, không nhận được phản hồi từ AI.\"}");
                    return;
                }

                String responseBody = response.body().string();

                if (!response.isSuccessful()) {
                    System.err.println("[ChatBot] Groq error " + response.code() + ": " + responseBody);
                    out.print("{\"reply\":\"Xin lỗi, dịch vụ AI tạm thời gián đoạn. Vui lòng thử lại sau.\"}");
                    return;
                }

                String reply = new JSONObject(responseBody)
                    .getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getString("content");

                // Lưu phản hồi của bot vào history
                history.put(new JSONObject().put("role", "assistant").put("content", reply));
                // Giới hạn lại sau khi thêm assistant message
                while (history.length() > MAX_HISTORY) history.remove(0);
                session.setAttribute(SESSION_KEY_HISTORY, history);

                out.print(new JSONObject().put("reply", reply).toString());
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"reply\":\"Xin lỗi, có lỗi xảy ra. Vui lòng thử lại sau.\"}");
        }
    }
}
