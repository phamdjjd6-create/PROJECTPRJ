package service;

import model.TblCustomers;
import java.math.BigDecimal;

public class LoyaltyService {

    // ── Định nghĩa các mốc chi tiêu (Ví dụ) ──
    private static final BigDecimal GOLD_THRESHOLD = new BigDecimal("50000000");    // 50 Triệu VNĐ
    private static final BigDecimal DIAMOND_THRESHOLD = new BigDecimal("150000000"); // 150 Triệu VNĐ

    public enum Tier {
        SILVER("Bạc", "#bec2cb", 0),
        GOLD("Vàng", "#ffd700", 5),
        DIAMOND("Kim Cương", "#b9f2ff", 10);

        private final String name;
        private final String color;
        private final int discountPercent;

        Tier(String name, String color, int discountPercent) {
            this.name = name;
            this.color = color;
            this.discountPercent = discountPercent;
        }

        public String getName() { return name; }
        public String getColor() { return color; }
        public int getDiscountPercent() { return discountPercent; }
    }

    /**
     * Xác định hạng thành viên dựa trên tổng chi tiêu
     */
    public Tier calculateTier(TblCustomers customer) {
        if (customer == null || customer.getTotalSpent() == null) return Tier.SILVER;
        
        BigDecimal spent = customer.getTotalSpent();
        if (spent.compareTo(DIAMOND_THRESHOLD) >= 0) return Tier.DIAMOND;
        if (spent.compareTo(GOLD_THRESHOLD) >= 0) return Tier.GOLD;
        return Tier.SILVER;
    }

    /**
     * Tính toán số điểm thưởng được cộng (Ví dụ: 5% giá trị giao dịch)
     */
    public int calculateAwardedPoints(BigDecimal totalPayment) {
        if (totalPayment == null) return 0;
        // 10,000 VNĐ = 1 điểm
        return totalPayment.divide(new BigDecimal("10000"), 0, java.math.RoundingMode.DOWN).intValue();
    }
}
