package service;

import okhttp3.*;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.IOException;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Service trung tâm để tương tác với Grok API (qua Groq).
 * Hỗ trợ Phân tích cảm xúc, Tóm tắt hoạt động, và Gợi ý nội dung.
 */
public class AiService {

    private static final String GROQ_API_KEY;
    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final String DEFAULT_MODEL = "llama-3.3-70b-versatile";

    static {
        String key = System.getenv("GROQ_API_KEY");
        if (key == null || key.isBlank()) {
            try {
                javax.naming.Context ctx = new javax.naming.InitialContext();
                key = (String) ctx.lookup("java:comp/env/groq.api.key");
            } catch (Exception e) {
                System.err.println("[AiService] Could not lookup API key in JNDI: " + e.getMessage());
            }
        }
        if (key == null || key.isBlank()) {
            System.err.println("[AiService] WARNING: GROQ_API_KEY is not configured in Environment or JNDI.");
        }
        GROQ_API_KEY = (key != null && !key.isBlank()) ? key.trim() : "";
    }

    private final OkHttpClient http = new OkHttpClient.Builder()
            .connectTimeout(20, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .build();

    /**
     * Gọi Grok API với danh sách messages (Mặc định).
     */
    public String callGrok(JSONArray messages, double temperature, int maxTokens) throws IOException {
        return callGrok(messages, temperature, maxTokens, null);
    }

    /**
     * Gọi Grok API với danh sách messages và Custom API Key.
     */
    public String callGrok(JSONArray messages, double temperature, int maxTokens, String customApiKey) throws IOException {
        String apiKey = (customApiKey != null && !customApiKey.isBlank()) ? customApiKey.trim() : GROQ_API_KEY;
        if (apiKey.isEmpty()) throw new IOException("GROQ_API_KEY is not configured and no custom key provided.");

        String targetUrl = GROQ_URL;
        String targetModel = DEFAULT_MODEL;
        
        // Auto-detect Grok (xAI) API Key
        if (apiKey.startsWith("xai-")) {
            targetUrl = "https://api.x.ai/v1/chat/completions";
            targetModel = "grok-beta";
        }

        JSONObject body = new JSONObject()
                .put("model", targetModel)
                .put("messages", messages)
                .put("temperature", temperature)
                .put("max_tokens", maxTokens);

        RequestBody requestBody = RequestBody.create(
                MediaType.parse("application/json; charset=utf-8"), body.toString());

        Request request = new Request.Builder()
                .url(targetUrl)
                .addHeader("Authorization", "Bearer " + apiKey)
                .addHeader("Content-Type", "application/json")
                .post(requestBody).build();

        try (Response response = http.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                String error = response.body() != null ? response.body().string() : "Unknown error";
                throw new IOException("Groq API Error (" + response.code() + "): " + error);
            }
            return new JSONObject(response.body().string())
                    .getJSONArray("choices").getJSONObject(0)
                    .getJSONObject("message").getString("content");
        }
    }

    /**
     * Phân tích cảm xúc từ danh sách review.
     * Trả về kết quả dạng JSON: { "sentiment": "POSITIVE/NEGATIVE", "score": 0.8, "summary": "..." }
     */
    public JSONObject analyzeReviews(String reviewsText) {
        try {
            JSONArray messages = new JSONArray();
            messages.put(new JSONObject().put("role", "system").put("content",
                "Bạn là chuyên gia phân tích dữ liệu khách sạn. " +
                "Phân tích danh sách đánh giá sau đây và trả về DUY NHẤT một chuỗi JSON hợp lệ với các trường: " +
                "'sentiment' (POSITIVE/NEGATIVE/NEUTRAL), 'satisfaction_score' (0-10), " +
                "'key_themes' (mảng các chủ đề nổi bật), 'summary' (tóm tắt ngắn gọn tiếng Việt)."));
            messages.put(new JSONObject().put("role", "user").put("content", reviewsText));

            String reply = callGrok(messages, 0.3, 500);
            return new JSONObject(reply.substring(reply.indexOf("{"), reply.lastIndexOf("}") + 1));
        } catch (Exception e) {
            return new JSONObject().put("error", e.getMessage());
        }
    }

    /**
     * Tóm tắt hoạt động hệ thống (Audit Logs).
     */
    public String summarizeAuditLogs(String logsText) {
        try {
            JSONArray messages = new JSONArray();
            messages.put(new JSONObject().put("role", "system").put("content",
                "Bạn là trợ lý quản lý resort Azure. Hãy tóm tắt các hoạt động quan trọng nhất từ các nhật ký hệ thống (Audit Logs) sau đây. " +
                "Tập trung vào các thay đổi về giá, lượt book phòng mới, và các hành động quan trọng của nhân viên. " +
                "Trả lời ngắn gọn bằng tiếng Việt, dùng gạch đầu dòng."));
            messages.put(new JSONObject().put("role", "user").put("content", logsText));

            return callGrok(messages, 0.5, 800);
        } catch (Exception e) {
            return "Lỗi tóm tắt: " + e.getMessage();
        }
    }

    /**
     * Tạo mô tả hấp dẫn cho phòng/villa.
     */
    public String generateFacilityDescription(String facilityDetails) {
        try {
            JSONArray messages = new JSONArray();
            messages.put(new JSONObject().put("role", "system").put("content",
                "Bạn là người viết nội dung marketing (Copywriter) chuyên nghiệp cho resort cao cấp. " +
                "Dựa trên các thông số kỹ thuật, hãy viết một đoạn mô tả ngắn (khoảng 150 chữ) cực kỳ hấp dẫn, sang trọng bằng tiếng Việt. " +
                "Sử dụng emoji tinh tế."));
            messages.put(new JSONObject().put("role", "user").put("content", facilityDetails));

            return callGrok(messages, 0.8, 1000);
        } catch (Exception e) {
            return "Lỗi tạo nội dung: " + e.getMessage();
        }
    }

    /**
     * Dùng AI để quyết định các nút bấm (actions) nên hiển thị cho khách.
     */
    public JSONArray detectActions(String userMsg, String botReply, String customApiKey) {
        try {
            JSONArray messages = new JSONArray();
            messages.put(new JSONObject().put("role", "system").put("content",
                "Phân tích đoạn chat sau và quyết định các nút bấm (actions) gợi ý cho người dùng. " +
                "Trả về DUY NHẤT một mảng JSON các đối tượng có 'label' và 'url'. " +
                "QUY TẮC URL:\n" +
                "- Nếu khách muốn đặt một phòng cụ thể (vd: Villa 1), dùng: 'booking:VIL001' (với VIL001 là Code phòng).\n" +
                "- Nếu khách muốn xem danh sách phòng chung, dùng: '/rooms'.\n" +
                "- Nếu khách cần hỗ trợ gấp/gọi điện, dùng: 'tel:18007777'.\n" +
                "- Nếu khách muốn xem booking của họ, dùng: '/booking?view=my'.\n" +
                "Ví dụ: [{\"label\": \"Đặt Villa 1 ngay\", \"url\": \"booking:VIL001\"}]"));
            messages.put(new JSONObject().put("role", "user").put("content", "User: " + userMsg + "\nBot: " + botReply));

            String reply = callGrok(messages, 0.1, 200, customApiKey);
            return new JSONArray(reply.substring(reply.indexOf("["), reply.lastIndexOf("]") + 1));
        } catch (Exception e) {
            return new JSONArray(); // Fallback empty
        }
    }

    /**
     * Giai đoạn 1: Hợp nhất Chat + Mood + Actions vào 1 lần gọi duy nhất.
     */
    public JSONObject getFullResponse(JSONArray history, String systemPrompt, String customApiKey) {
        try {
            JSONArray messages = new JSONArray();
            // Cấu trúc Prompt yêu cầu JSON chặt chẽ
            String jsonInstructions = "\n\n=== YÊU CẦU ĐỊNH DẠNG PHẢN HỒI ===\n" +
                "Bạn PHẢI trả lời DUY NHẤT một đối tượng JSON hợp lệ (không có text thừa bên ngoài) với cấu trúc:\n" +
                "{\n" +
                "  \"reply\": \"Nội dung phản hồi tinh tế bằng tiếng Việt (hỗ trợ Markdown)\",\n" +
                "  \"mood\": \"HAPPY | FRUSTRATED | NEUTRAL | CURIOUS\",\n" +
                "  \"actions\": [{\"label\": \"Tên nút\", \"url\": \"link_hoặc_booking:CODE\"}]\n" +
                "}\n";

            messages.put(new JSONObject().put("role", "system").put("content", systemPrompt + jsonInstructions));
            for (int i = 0; i < history.length(); i++) {
                messages.put(history.getJSONObject(i));
            }

            String rawReply = callGrok(messages, 0.7, 1200, customApiKey);
            
            // Trích xuất JSON từ chuỗi trả về (đề phòng AI thêm text thừa)
            int start = rawReply.indexOf("{");
            int end = rawReply.lastIndexOf("}");
            if (start != -1 && end != -1 && end > start) {
                return new JSONObject(rawReply.substring(start, end + 1));
            }
            
            // Fallback nếu không có JSON
            return new JSONObject()
                .put("reply", rawReply)
                .put("mood", "NEUTRAL")
                .put("actions", new JSONArray());

        } catch (Exception e) {
            return new JSONObject()
                .put("reply", "Xin lỗi, hệ thống AI đang gặp sự cố: " + e.getMessage())
                .put("mood", "NEUTRAL")
                .put("actions", new JSONArray());
        }
    }

    /**
     * Nhận diện tâm trạng của người dùng qua tin nhắn.
     * Trả về: "HAPPY", "FRUSTRATED", "NEUTRAL", "CURIOUS"
     */
    public String detectMood(String userMsg) {
        return detectMood(userMsg, null);
    }

    public String detectMood(String userMsg, String customApiKey) {
        try {
            JSONArray messages = new JSONArray();
            messages.put(new JSONObject().put("role", "system").put("content",
                "Phân tích tâm trạng của khách hàng qua tin nhắn sau. " +
                "Trả về DUY NHẤT một từ: HAPPY, FRUSTRATED, NEUTRAL, hoặc CURIOUS."));
            messages.put(new JSONObject().put("role", "user").put("content", userMsg));

            String reply = callGrok(messages, 0.1, 10, customApiKey).trim().toUpperCase();
            if (reply.contains("HAPPY")) return "HAPPY";
            if (reply.contains("FRUSTRATED")) return "FRUSTRATED";
            if (reply.contains("CURIOUS")) return "CURIOUS";
            return "NEUTRAL";
        } catch (Exception e) {
            return "NEUTRAL";
        }
    }
}
