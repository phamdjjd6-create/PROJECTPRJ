package service;

import DAO.ReviewDAO;
import model.TblReviews;
import org.json.JSONObject;
import java.util.List;

public class ReviewService {
    private final ReviewDAO reviewDAO;
    private final AiService aiService;

    public ReviewService() {
        this.reviewDAO = new ReviewDAO();
        this.aiService = new AiService();
    }

    public List<TblReviews> findAll() {
        return reviewDAO.findAll();
    }

    /**
     * Lấy phân tích cảm xúc AI từ toàn bộ đánh giá.
     */
    public JSONObject getAiSentimentAnalysis() {
        List<TblReviews> reviews = reviewDAO.findAll();
        if (reviews.isEmpty()) {
            return new JSONObject().put("summary", "Chưa có đánh giá nào để phân tích.");
        }

        // Gom text đánh giá (giới hạn 50 cái gần nhất)
        StringBuilder sb = new StringBuilder();
        reviews.stream().limit(50).forEach(r -> {
            sb.append(String.format("[%d sao] %s\n", (int)r.getRating(), r.getContent()));
        });
        String reviewsText = sb.toString();

        return aiService.analyzeReviews(reviewsText);
    }
}
