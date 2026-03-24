# Requirements Document

## Introduction

Tính năng **Verified Reviews** (Đánh giá đã xác minh) cho Azure Resort cho phép khách hàng đã hoàn thành kỳ lưu trú (trạng thái `CHECKED_OUT`) gửi đánh giá thực tế kèm ảnh. Hệ thống hiển thị badge "Đã xác minh" để tạo niềm tin, thay thế phần testimonial tĩnh hiện tại trên trang chủ và trang chi tiết cơ sở. Admin có thể kiểm duyệt và phản hồi đánh giá từ dashboard.

## Glossary

- **Review_System**: Hệ thống quản lý toàn bộ vòng đời đánh giá (tạo, kiểm duyệt, hiển thị, phản hồi).
- **Review**: Một đánh giá do khách hàng gửi, bao gồm rating (1–5 sao), tiêu đề, nội dung, và tùy chọn ảnh.
- **Verified_Review**: Đánh giá được xác minh — chỉ tồn tại khi booking liên kết có trạng thái `CHECKED_OUT`.
- **Review_Photo**: Ảnh thực tế do khách hàng upload kèm theo một Review.
- **Booking**: Bản ghi đặt phòng trong `tbl_bookings`, có trường `status` với các giá trị: `PENDING`, `CONFIRMED`, `CHECKED_IN`, `CHECKED_OUT`, `CANCELLED`.
- **Customer**: Khách hàng đã đăng nhập, được xác định qua `sessionScope.account`.
- **Admin**: Nhân viên có `personType = 'EMPLOYEE'` với quyền quản trị dashboard.
- **Review_DAO**: Lớp truy cập dữ liệu cho `tbl_reviews`.
- **Review_Service**: Lớp nghiệp vụ xử lý logic đánh giá.
- **Review_Controller**: Servlet xử lý HTTP request liên quan đến đánh giá.
- **Facility**: Cơ sở lưu trú trong `tbl_facilities`, được liên kết với Booking và Review.
- **isPublished**: Trường boolean trong `tbl_reviews` — `true` khi Admin đã duyệt, `false` khi chờ duyệt.

---

## Requirements

### Requirement 1: Kiểm soát quyền gửi đánh giá

**User Story:** Là khách hàng, tôi muốn chỉ có thể gửi đánh giá sau khi đã hoàn thành kỳ lưu trú, để đảm bảo đánh giá phản ánh trải nghiệm thực tế.

#### Acceptance Criteria

1. WHEN khách hàng truy cập trang "Booking Của Tôi", THE Review_System SHALL hiển thị nút "Viết đánh giá" chỉ với các booking có `status = 'CHECKED_OUT'` và chưa có Review liên kết.
2. WHEN khách hàng đã gửi đánh giá cho một booking, THE Review_System SHALL thay thế nút "Viết đánh giá" bằng nhãn "Đã đánh giá" cho booking đó.
3. IF khách hàng gửi request tạo Review với `bookingId` không thuộc về `customerId` trong session, THEN THE Review_Controller SHALL trả về HTTP 403 và không lưu dữ liệu.
4. IF khách hàng gửi request tạo Review với `bookingId` có `status` khác `CHECKED_OUT`, THEN THE Review_Controller SHALL trả về thông báo lỗi "Bạn chỉ có thể đánh giá sau khi hoàn thành kỳ lưu trú."
5. IF khách hàng chưa đăng nhập và truy cập form đánh giá, THEN THE Review_Controller SHALL chuyển hướng đến trang đăng nhập.

---

### Requirement 2: Form gửi đánh giá

**User Story:** Là khách hàng đã checkout, tôi muốn gửi đánh giá với rating sao, nội dung và ảnh thực tế, để chia sẻ trải nghiệm của mình.

#### Acceptance Criteria

1. WHEN khách hàng mở form đánh giá, THE Review_System SHALL hiển thị form với các trường: rating (1–5 sao, bắt buộc), tiêu đề (tối đa 150 ký tự, tùy chọn), nội dung (tối đa 1000 ký tự, bắt buộc), và upload ảnh (tùy chọn, tối đa 5 ảnh).
2. WHEN khách hàng chọn rating, THE Review_System SHALL hiển thị trực quan số sao đã chọn bằng icon sao màu vàng (`#c9a84c`).
3. IF khách hàng submit form mà không chọn rating, THEN THE Review_System SHALL hiển thị thông báo lỗi "Vui lòng chọn số sao đánh giá."
4. IF khách hàng submit form mà không nhập nội dung, THEN THE Review_System SHALL hiển thị thông báo lỗi "Vui lòng nhập nội dung đánh giá."
5. WHEN khách hàng upload ảnh, THE Review_System SHALL chỉ chấp nhận file có định dạng JPEG, PNG hoặc WebP với kích thước tối đa 5MB mỗi file.
6. IF khách hàng upload file không đúng định dạng hoặc vượt quá 5MB, THEN THE Review_System SHALL hiển thị thông báo lỗi tương ứng và không upload file đó.
7. WHEN khách hàng submit form hợp lệ, THE Review_System SHALL lưu Review với `isPublished = false` và hiển thị thông báo "Đánh giá của bạn đã được gửi và đang chờ kiểm duyệt."

---

### Requirement 3: Lưu trữ ảnh đánh giá

**User Story:** Là khách hàng, tôi muốn đính kèm ảnh thực tế vào đánh giá, để minh chứng cho trải nghiệm của mình.

#### Acceptance Criteria

1. THE Review_System SHALL lưu trữ ảnh đánh giá trong bảng `tbl_review_photos` với các trường: `photo_id` (PK, auto-increment), `review_id` (FK → `tbl_reviews`), `photo_url` (VARCHAR 500), `uploaded_at` (TIMESTAMP).
2. WHEN ảnh được upload thành công, THE Review_System SHALL lưu đường dẫn file vào `tbl_review_photos` liên kết với `review_id` tương ứng.
3. WHEN một Review bị xóa, THE Review_System SHALL xóa tất cả `tbl_review_photos` liên kết theo cascade.
4. THE Review_System SHALL lưu file ảnh vào thư mục `uploads/reviews/{reviewId}/` trên server.

---

### Requirement 4: Kiểm duyệt đánh giá (Admin)

**User Story:** Là Admin, tôi muốn kiểm duyệt đánh giá trước khi hiển thị công khai, để đảm bảo nội dung phù hợp.

#### Acceptance Criteria

1. WHEN Admin truy cập trang quản lý đánh giá trong dashboard, THE Review_System SHALL hiển thị danh sách tất cả Review với thông tin: tên khách hàng, tên cơ sở, rating, nội dung tóm tắt, ngày gửi, trạng thái (`isPublished`).
2. WHEN Admin nhấn "Duyệt" trên một Review, THE Review_System SHALL cập nhật `isPublished = true` và hiển thị Review đó trên các trang công khai.
3. WHEN Admin nhấn "Ẩn" trên một Review đang được duyệt, THE Review_System SHALL cập nhật `isPublished = false` và ẩn Review khỏi các trang công khai.
4. WHEN Admin nhập phản hồi và nhấn "Gửi phản hồi", THE Review_System SHALL lưu nội dung vào trường `reply` (tối đa 500 ký tự) của Review tương ứng.
5. IF Admin gửi phản hồi rỗng, THEN THE Review_System SHALL hiển thị thông báo lỗi "Vui lòng nhập nội dung phản hồi."

---

### Requirement 5: Hiển thị đánh giá trên trang chi tiết cơ sở

**User Story:** Là khách hàng tiềm năng, tôi muốn xem đánh giá thực tế từ những người đã lưu trú, để đưa ra quyết định đặt phòng.

#### Acceptance Criteria

1. WHEN khách hàng truy cập trang `facility-detail.jsp`, THE Review_System SHALL hiển thị tất cả Review có `isPublished = true` liên kết với cơ sở đó, sắp xếp theo `reviewDate` giảm dần.
2. THE Review_System SHALL hiển thị badge "✓ Đã xác minh" màu vàng (`#c9a84c`) bên cạnh tên người đánh giá cho mỗi Verified_Review.
3. WHEN một Review có ảnh, THE Review_System SHALL hiển thị thumbnail ảnh trong card đánh giá, có thể click để xem ảnh lớn hơn.
4. WHEN một Review có `reply` không rỗng, THE Review_System SHALL hiển thị phần phản hồi của resort bên dưới nội dung đánh giá với nhãn "Phản hồi từ Azure Resort".
5. THE Review_System SHALL hiển thị điểm đánh giá trung bình (trung bình cộng của tất cả `rating` đã được duyệt) và tổng số đánh giá ở đầu phần reviews.
6. WHEN không có Review nào được duyệt cho cơ sở đó, THE Review_System SHALL hiển thị thông báo "Chưa có đánh giá nào. Hãy là người đầu tiên đánh giá!"

---

### Requirement 6: Thay thế testimonial tĩnh trên trang chủ

**User Story:** Là khách truy cập trang chủ, tôi muốn thấy đánh giá thực từ khách hàng đã lưu trú thay vì nội dung tĩnh, để tin tưởng hơn vào chất lượng resort.

#### Acceptance Criteria

1. THE Review_System SHALL thay thế phần testimonial tĩnh trong `index.jsp` bằng carousel hiển thị tối đa 6 Review có `isPublished = true`, được chọn theo `rating` cao nhất và `reviewDate` gần nhất.
2. WHEN hiển thị Review trên trang chủ, THE Review_System SHALL hiển thị: tên khách hàng (ẩn họ, chỉ hiện tên), rating sao, nội dung đánh giá (tối đa 200 ký tự, cắt bớt nếu dài hơn), và badge "✓ Đã xác minh".
3. WHEN không có Review nào được duyệt, THE Review_System SHALL hiển thị carousel với nội dung placeholder mặc định (giữ nguyên testimonial tĩnh hiện tại).
4. THE Review_System SHALL load dữ liệu Review cho trang chủ thông qua `HomeController` hoặc `IndexServlet`, không dùng AJAX để đảm bảo SEO.

---

### Requirement 7: Tích hợp model và database

**User Story:** Là developer, tôi muốn schema database và JPA entity được cập nhật đúng cách, để hệ thống hoạt động nhất quán.

#### Acceptance Criteria

1. THE Review_System SHALL tạo bảng `tbl_review_photos` trong database với script SQL migration tương thích với schema hiện tại.
2. THE Review_System SHALL thêm JPA entity `TblReviewPhotos` với annotation `@OneToMany` từ `TblReviews` và `@ManyToOne` ngược lại.
3. THE Review_System SHALL cập nhật `TblReviews` để thêm quan hệ `@OneToMany(mappedBy = "review", cascade = CascadeType.ALL, orphanRemoval = true)` với `TblReviewPhotos`.
4. WHEN `ReviewDAO.findByFacilityId()` được gọi, THE Review_DAO SHALL chỉ trả về các Review có `isPublished = true` (thêm overload hoặc tham số filter).
5. THE Review_DAO SHALL cung cấp method `findCheckedOutBookingsWithoutReview(String customerId)` trả về danh sách `TblBookings` có `status = 'CHECKED_OUT'` và chưa có Review liên kết, thuộc về `customerId`.

---

### Requirement 8: Hiển thị đúng trong JSP với JSTL

**User Story:** Là developer, tôi muốn các trang JSP hiển thị dữ liệu đánh giá đúng cách với JSTL, để tránh lỗi EL expression.

#### Acceptance Criteria

1. THE Review_System SHALL sử dụng `pageContext.setAttribute()` trong Servlet để truyền tất cả biến cần thiết sang JSP, không dùng Java local variables trực tiếp trong EL.
2. WHEN hiển thị ảnh đánh giá trong JSP, THE Review_System SHALL dùng `<c:forEach>` để lặp qua danh sách `photoUrls`, không gọi Java methods trực tiếp trong EL.
3. WHEN kiểm tra chuỗi trong JSP, THE Review_System SHALL dùng `fn:length()`, `fn:startsWith()` từ JSTL functions (`<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>`), không gọi `.startsWith()` hay `.length()` trực tiếp trên EL expression.
4. WHEN render JavaScript trong JSP `<script>` block liên quan đến dữ liệu động, THE Review_System SHALL dùng string concatenation thay vì nested backtick template literals.
