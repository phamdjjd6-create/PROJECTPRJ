package service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import model.TblBookings;
import model.TblFacilities;
import java.util.Properties;

public class EmailService {

    // ── Cấu hình SMTP (Ví dụ dùng Gmail) ──
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    // Khuyến nghị dùng App Password nếu dùng Gmail
    private static final String SMTP_USER = System.getProperty("resort.email.user", "azure.resort.vn@gmail.com");
    private static final String SMTP_PASS = System.getProperty("resort.email.pass", "your-app-password");

    public void sendBookingConfirmation(TblBookings booking, TblFacilities facility, java.math.BigDecimal total) {
        if (booking.getCustomerId() == null || booking.getCustomerId().getTblPersons() == null) {
            System.err.println("[EmailService] Không thể gửi mail: Khách hàng không có hồ sơ cá nhân.");
            return;
        }
        
        String recipientEmail = booking.getCustomerId().getTblPersons().getEmail();
        if (recipientEmail == null) {
            System.err.println("[EmailService] Không thể gửi mail: Khách hàng không có email.");
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, "Azure Resort & Spa"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("确认预订 / Booking Confirmation: " + booking.getBookingId());

            String htmlBody = buildBookingHtml(booking, facility, total);
            message.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[EmailService] Đã gửi mail xác nhận đến: " + recipientEmail);

        } catch (Exception e) {
            System.err.println("[EmailService] Lỗi gửi mail: " + e.getMessage());
        }
    }

    private String buildBookingHtml(TblBookings b, TblFacilities f, java.math.BigDecimal total) {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
        String name = b.getCustomerId().getTblPersons().getFullName();
        
        return 
            "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #eee; padding: 20px;'>" +
            "  <div style='text-align: center; margin-bottom: 20px;'>" +
            "    <h1 style='color: #c9a84c; margin: 0;'>AZURE RESORT & SPA</h1>" +
            "    <p style='color: #888; font-size: 12px;'>Thiên đường nghỉ dưỡng tại Đà Nẵng</p>" +
            "  </div>" +
            "  <hr style='border: 0; border-top: 1px solid #eee;' />" +
            "  <p>Xin chào <strong>" + name + "</strong>,</p>" +
            "  <p>Cảm ơn Quý khách đã tin tưởng lựa chọn Azure Resort & Spa. Chúng tôi xin xác nhận thông tin đặt phòng của Quý khách như sau:</p>" +
            "  <div style='background: #f9f9f9; padding: 15px; border-radius: 8px; margin: 20px 0;'>" +
            "    <table style='width: 100%; border-collapse: collapse;'>" +
            "      <tr><td style='padding: 5px 0; color: #666;'>Mã đặt phòng:</td><td style='text-align: right;'><strong>" + b.getBookingId() + "</strong></td></tr>" +
            "      <tr><td style='padding: 5px 0; color: #666;'>Hạng phòng:</td><td style='text-align: right;'>" + f.getServiceName() + "</td></tr>" +
            "      <tr><td style='padding: 5px 0; color: #666;'>Ngày Check-in:</td><td style='text-align: right;'>" + sdf.format(b.getStartDate()) + "</td></tr>" +
            "      <tr><td style='padding: 5px 0; color: #666;'>Ngày Check-out:</td><td style='text-align: right;'>" + sdf.format(b.getEndDate()) + "</td></tr>" +
            "      <tr><td style='padding: 5px 0; color: #666;'>Số khách:</td><td style='text-align: right;'>" + b.getAdults() + " Người lớn, " + b.getChildren() + " Trẻ em</td></tr>" +
            "      <tr style='border-top: 1px solid #ddd;'><td style='padding: 10px 0; font-weight: bold;'>Tổng cộng:</td><td style='text-align: right; color: #c9a84c; font-size: 18px;'><strong>" + String.format("%,.0f đ", total.doubleValue()) + "</strong></td></tr>" +
            "    </table>" +
            "  </div>" +
            "  <p>Trạng thái: <span style='color: " + ("CONFIRMED".equals(b.getStatus()) ? "#28a745" : "#ffc107") + "; font-weight: bold;'>" + 
                 ("CONFIRMED".equals(b.getStatus()) ? "Đã xác nhận & Thanh toán cọc" : "Chờ xác nhận") + "</span></p>" +
            "  <p style='font-size: 13px; color: #555;'>* Nếu Quý khách cần hỗ trợ, vui lòng liên hệ hotline <strong>1800 7777</strong> hoặc trả lời email này.</p>" +
            "  <div style='text-align: center; margin-top: 30px; color: #999; font-size: 11px;'>" +
            "    <p>© 2026 Azure Resort & Spa. All rights reserved.</p>" +
            "    <p>Trường Sa, Hòa Hải, Ngũ Hành Sơn, Đà Nẵng</p>" +
            "  </div>" +
            "</div>";
    }
}
