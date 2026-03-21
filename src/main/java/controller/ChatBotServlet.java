package controller;

import DAO.FacilityDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.TblFacilities;
import okhttp3.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * ChatBot servlet — Groq API (llama-3.3-70b-versatile)
 *
 * Chỉ trả lời:
 *   1. Thời tiết Đà Nẵng và gợi ý phòng/villa phù hợp theo mùa/thời tiết
 *   2. Thông tin về các facility có trong DB (tên, loại, giá, diện tích, sức chứa, mô tả, trạng thái)
 *
 * Session:
 *   - Lưu lịch sử hội thoại dưới key "chatHistory" (JSONArray)
 *   - Session timeout 30 phút (1800 giây)
 *   - Tối đa 20 lượt gần nhất để tránh vượt token limit
 */
@WebServlet("/chatbot")
public class ChatBotServlet extends HttpServlet {

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
            "Bạn là trợ lý ảo của Azure Resort & Spa — khu nghỉ dưỡng 5 sao tại Đà Nẵng, Việt Nam.\n\n" +

            "PHẠM VI TRẢ LỜI — CHỈ được trả lời 2 chủ đề sau:\n" +
            "1. THỜI TIẾT BẤT KỲ ĐỊA ĐIỂM NÀO: Khi khách hỏi thời tiết ở một nơi nào đó " +
               "(ví dụ: Hà Nội, Hội An, Sài Gòn, Phú Quốc, nước ngoài...), hãy:\n" +
               "   a) Mô tả ngắn gọn thời tiết/khí hậu tại địa điểm đó.\n" +
               "   b) Nếu địa điểm đó GẦN hoặc THUỘC khu vực Đà Nẵng/miền Trung Việt Nam: " +
                  "giới thiệu trực tiếp các phòng/villa phù hợp trong danh sách bên dưới.\n" +
               "   c) Nếu địa điểm đó XA Đà Nẵng (tỉnh khác, nước ngoài): mô tả thời tiết ở đó, " +
                  "sau đó nói 'Nếu bạn muốn trải nghiệm khí hậu tương tự tại một khu nghỉ dưỡng đẳng cấp, " +
                  "Azure Resort tại Đà Nẵng có [gợi ý phòng phù hợp với khí hậu tương tự]' " +
                  "và giới thiệu các phòng/villa phù hợp nhất từ danh sách.\n" +
            "2. THÔNG TIN FACILITY: Trả lời câu hỏi về các phòng, villa, nhà trong danh sách bên dưới.\n\n" +

            "QUY TẮC BẮT BUỘC:\n" +
            "- Nếu câu hỏi KHÔNG liên quan đến thời tiết hoặc phòng/villa, trả lời: " +
              "\"Xin lỗi, tôi chỉ tư vấn về thời tiết và các phòng/villa tại Azure Resort. " +
              "Bạn muốn biết thời tiết ở đâu để tôi gợi ý phòng phù hợp?\"\n" +
            "- KHÔNG bịa thêm phòng/villa ngoài danh sách dưới đây.\n" +
            "- KHÔNG trả lời về chính trị, lập trình, tin tức, hay chủ đề không liên quan.\n" +
            "- Luôn trả lời bằng tiếng Việt, thân thiện, ngắn gọn.\n" +
            "- Khi gợi ý phòng, ưu tiên phòng có trạng thái 'Còn trống'.\n" +
            "- Luôn kết thúc bằng cách mời khách đặt phòng hoặc hỏi thêm thông tin.\n\n" +

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
