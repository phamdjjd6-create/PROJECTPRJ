<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%
    if (request.getAttribute("facility") == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    TblPersons acc = (TblPersons) session.getAttribute("account");
    boolean isEmp = acc instanceof TblEmployees;
    String dashUrl = "";
    if (isEmp) {
        String role = ((TblEmployees) acc).getRole();
        dashUrl = "ADMIN".equals(role) ? request.getContextPath() + "/dashboard/admin" : request.getContextPath() + "/dashboard/staff";
    }
    pageContext.setAttribute("isEmp", isEmp);
    pageContext.setAttribute("dashUrl", dashUrl);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${facility.serviceName} — Azure Resort &amp; Spa</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        :root{--gold:#c9a84c;--gold-light:#e8cc82;--dark:#0a0a0f;--navy:#0d1526;--text:#e8e8e8;--muted:rgba(255,255,255,0.35);--border:rgba(255,255,255,0.07)}
        body{background:var(--dark);color:var(--text);font-family:'Inter',sans-serif;min-height:100vh}
        /* Navbar */
        .navbar{position:fixed;top:0;left:0;right:0;z-index:1000;padding:0 48px;height:72px;display:flex;align-items:center;justify-content:space-between;background:rgba(10,10,15,0.0);backdrop-filter:blur(0px);border-bottom:1px solid transparent;transition:all 0.4s}
        .navbar.scrolled{background:rgba(10,10,15,0.95);backdrop-filter:blur(20px);border-bottom-color:rgba(201,168,76,0.1)}
        .nav-brand{font-family:'Playfair Display',serif;font-size:22px;font-weight:700;color:#fff;text-decoration:none}
        .nav-brand span{color:var(--gold)}
        .nav-links{display:flex;align-items:center;gap:28px;list-style:none}
        .nav-links a{color:rgba(255,255,255,0.6);text-decoration:none;font-size:13px;font-weight:500;transition:color 0.2s}
        .nav-links a:hover,.nav-links a.active{color:var(--gold)}
        .nav-links a.btn-dash{padding:6px 16px;border:1.5px solid rgba(201,168,76,0.35);border-radius:50px;color:var(--gold)}
        .nav-links a.btn-dash:hover{background:var(--gold);color:var(--dark)}
        .nav-right{display:flex;align-items:center;gap:14px}
        .nav-user{font-size:13px;color:rgba(255,255,255,0.4)}
        .nav-user strong{color:var(--gold)}
        .btn-nav-out{padding:7px 18px;border:1px solid rgba(201,168,76,0.3);border-radius:50px;color:var(--gold);font-size:12px;font-weight:600;text-decoration:none;transition:all 0.2s}
        .btn-nav-out:hover{background:var(--gold);color:var(--dark)}
        .btn-nav-login{padding:7px 18px;border:1px solid rgba(255,255,255,0.15);border-radius:50px;color:rgba(255,255,255,0.6);font-size:12px;font-weight:600;text-decoration:none;transition:all 0.2s}
        .btn-nav-login:hover{border-color:var(--gold);color:var(--gold)}
        /* Hero */
        .hero{position:relative;height:75vh;min-height:520px;overflow:hidden}
        .hero-img{width:100%;height:100%;object-fit:cover;transition:transform 8s ease;transform:scale(1.05)}
        .hero:hover .hero-img{transform:scale(1.1)}
        .hero-overlay{position:absolute;inset:0;background:linear-gradient(to bottom,rgba(10,10,15,0.15) 0%,rgba(10,10,15,0.5) 60%,var(--dark) 100%)}
        .hero-content{position:absolute;bottom:0;left:0;right:0;padding:0 60px 60px;max-width:1200px;margin:0 auto}
        .hero-breadcrumb{display:flex;align-items:center;gap:8px;font-size:10px;color:rgba(255,255,255,0.4);text-transform:uppercase;letter-spacing:0.2em;margin-bottom:16px}
        .hero-breadcrumb a{color:rgba(255,255,255,0.4);text-decoration:none;transition:color 0.2s}
        .hero-breadcrumb a:hover{color:var(--gold)}
        .hero-badge{display:inline-block;padding:5px 16px;background:rgba(201,168,76,0.2);border:1px solid rgba(201,168,76,0.35);border-radius:50px;font-size:10px;font-weight:700;color:var(--gold);text-transform:uppercase;letter-spacing:0.2em;margin-bottom:14px}
        .hero-title{font-family:'Playfair Display',serif;font-size:56px;font-weight:700;color:#fff;line-height:1.1;margin-bottom:16px}
        .hero-meta{display:flex;align-items:center;gap:16px;flex-wrap:wrap}
        .hero-status{display:flex;align-items:center;gap:8px;padding:6px 14px;background:rgba(255,255,255,0.06);backdrop-filter:blur(10px);border:1px solid rgba(255,255,255,0.1);border-radius:50px;font-size:12px;font-weight:500}
        .status-dot{width:7px;height:7px;border-radius:50%}
        .dot-available{background:#4ade80;box-shadow:0 0 8px rgba(74,222,128,0.6)}
        .dot-occupied{background:#f87171;box-shadow:0 0 8px rgba(248,113,113,0.6)}
        .hero-code{font-size:11px;color:rgba(255,255,255,0.3);font-family:monospace;letter-spacing:0.1em}
        /* Main layout */
        .main-wrap{max-width:1200px;margin:0 auto;padding:0 60px 80px;display:grid;grid-template-columns:1fr 380px;gap:48px;align-items:start}
        @media(max-width:1100px){.main-wrap{grid-template-columns:1fr;padding:0 24px 60px}}
        /* Left column */
        .left-col{padding-top:48px}
        .back-link{display:inline-flex;align-items:center;gap:10px;font-size:12px;font-weight:600;color:rgba(255,255,255,0.3);text-decoration:none;text-transform:uppercase;letter-spacing:0.15em;transition:color 0.2s;margin-bottom:40px}
        .back-link:hover{color:var(--gold)}
        .back-link .arrow{width:32px;height:32px;border-radius:50%;border:1px solid rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;transition:all 0.2s}
        .back-link:hover .arrow{border-color:var(--gold);background:var(--gold);color:var(--dark)}
        /* Section */
        .sec-label{font-size:9px;color:var(--gold);letter-spacing:3px;text-transform:uppercase;font-weight:700;margin-bottom:6px}
        .sec-title{font-family:'Playfair Display',serif;font-size:28px;font-weight:700;color:#fff;margin-bottom:20px}
        .sec-divider{height:1px;background:rgba(255,255,255,0.05);margin:40px 0}
        /* Description */
        .description{font-size:15px;color:rgba(255,255,255,0.55);line-height:1.9;font-weight:300}
        /* Specs grid */
        .specs-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:8px}
        @media(max-width:600px){.specs-grid{grid-template-columns:repeat(2,1fr)}}
        .spec-card{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.07);border-radius:16px;padding:20px;transition:all 0.2s}
        .spec-card:hover{border-color:rgba(201,168,76,0.2);background:rgba(201,168,76,0.03)}
        .spec-lbl{font-size:9px;color:rgba(255,255,255,0.25);text-transform:uppercase;letter-spacing:0.2em;font-weight:700;margin-bottom:8px}
        .spec-val{font-family:'Playfair Display',serif;font-size:22px;font-weight:700;color:#fff}
        .spec-unit{font-size:12px;font-family:'Inter',sans-serif;font-weight:400;color:rgba(255,255,255,0.3);margin-left:4px}
        /* Amenities */
        .amenities-grid{display:flex;flex-wrap:wrap;gap:10px}
        .amenity{display:flex;align-items:center;gap:8px;padding:8px 16px;background:rgba(201,168,76,0.06);border:1px solid rgba(201,168,76,0.15);border-radius:50px;font-size:12px;color:rgba(255,255,255,0.7);font-weight:500;transition:all 0.2s}
        .amenity:hover{background:rgba(201,168,76,0.12);border-color:rgba(201,168,76,0.3);color:#fff}
        .amenity-icon{font-size:14px}
        /* Gallery */
        .gallery-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:8px}
        .gallery-img{width:100%;height:180px;object-fit:cover;border-radius:12px;border:1px solid rgba(255,255,255,0.06);transition:all 0.3s;cursor:pointer}
        .gallery-img:hover{transform:scale(1.02);border-color:rgba(201,168,76,0.3)}
        .gallery-placeholder{width:100%;height:180px;background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:12px;display:flex;align-items:center;justify-content:center;color:rgba(255,255,255,0.1);font-size:32px}
        /* Booking widget */
        .booking-widget{position:sticky;top:100px;background:rgba(13,21,38,0.8);border:1px solid rgba(201,168,76,0.15);border-radius:28px;padding:32px;backdrop-filter:blur(20px);box-shadow:0 24px 60px rgba(0,0,0,0.4)}
        .widget-price-label{font-size:9px;color:var(--gold);letter-spacing:3px;text-transform:uppercase;font-weight:700;margin-bottom:6px}
        .widget-price{display:flex;align-items:baseline;gap:6px;margin-bottom:24px}
        .widget-price .amount{font-family:'Playfair Display',serif;font-size:36px;font-weight:700;color:#fff}
        .widget-price .unit{font-size:12px;color:rgba(255,255,255,0.3)}
        .form-group{margin-bottom:16px}
        .form-label{display:block;font-size:10px;color:rgba(255,255,255,0.3);text-transform:uppercase;letter-spacing:0.2em;font-weight:700;margin-bottom:8px}
        .form-input{width:100%;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.1);border-radius:12px;padding:12px 16px;color:#fff;font-size:13px;font-family:'Inter',sans-serif;outline:none;transition:border-color 0.2s;color-scheme:dark}
        .form-input:focus{border-color:rgba(201,168,76,0.4)}
        select.form-input{appearance:none;cursor:pointer}
        select.form-input option{background:#0d1526}
        .btn-book{width:100%;padding:16px;background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--dark);font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.25em;border:none;border-radius:14px;cursor:pointer;transition:all 0.25s;font-family:'Inter',sans-serif;margin-top:8px}
        .btn-book:hover{transform:scale(1.02);box-shadow:0 8px 28px rgba(201,168,76,0.3)}
        .btn-unavailable{width:100%;padding:16px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);color:rgba(255,255,255,0.25);font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.25em;border-radius:14px;cursor:not-allowed;font-family:'Inter',sans-serif;margin-top:8px}
        .widget-footer{margin-top:20px;padding-top:20px;border-top:1px solid rgba(255,255,255,0.05);text-align:center;font-size:11px;color:rgba(255,255,255,0.25);line-height:1.7}
        .widget-footer strong{color:var(--gold)}
        /* Night calc */
        .nights-preview{padding:12px 16px;background:rgba(201,168,76,0.06);border:1px solid rgba(201,168,76,0.15);border-radius:10px;margin-bottom:16px;font-size:12px;color:rgba(255,255,255,0.5);display:none}
        .nights-preview strong{color:var(--gold)}
        footer{background:#060608;border-top:1px solid rgba(255,255,255,0.05);padding:28px 60px}
        .footer-inner{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
        .footer-brand{font-family:'Playfair Display',serif;font-size:16px;color:#fff}
        .footer-brand span{color:var(--gold)}
        .footer-copy{font-size:11px;color:rgba(255,255,255,0.18)}
        @media(max-width:1024px){
            .main-wrap{grid-template-columns:1fr;padding:0 32px 60px}
            .hero-title{font-size:42px}
            .booking-widget{position:static;margin-top:0}
        }
        @media(max-width:768px){
            .navbar{padding:0 16px}
            .nav-links{display:none}
            .hero{height:55vh;min-height:380px}
            .hero-title{font-size:28px}
            .hero-content{padding:0 20px 32px}
            .main-wrap{grid-template-columns:1fr;padding:0 16px 48px;gap:28px}
            .booking-widget{position:static;border-radius:20px;padding:24px}
            .specs-grid{grid-template-columns:repeat(2,1fr)}
            .gallery-grid{grid-template-columns:1fr}
            .gallery-img,.gallery-placeholder{height:200px}
            .left-col{padding-top:28px}
        }
    </style>
</head>
<body>
<nav class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="active">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a></li>
        <c:if test="${isEmp}"><li><a href="${dashUrl}" class="btn-dash">Dashboard</a></li></c:if>
    </ul>
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <span class="nav-user">Xin chào, <strong>${sessionScope.account.fullName}</strong></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-nav-out">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-nav-login">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn-nav-out">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- Hero -->
<div class="hero">
    <img src="${imgSrc.startsWith('http') ? imgSrc : pageContext.request.contextPath.concat('/').concat(imgSrc)}"
         alt="${facility.serviceName}" class="hero-img" id="heroImg">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <nav class="hero-breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang Chủ</a><span>/</span>
            <a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a><span>/</span>
            <span style="color:var(--gold)">${facility.serviceName}</span>
        </nav>
        <div class="hero-badge">${facilityTypeLabel} — Azure Collection</div>
        <h1 class="hero-title">${facility.serviceName}</h1>
        <div class="hero-meta">
            <div class="hero-status">
                <span class="status-dot ${isAvailable ? 'dot-available' : 'dot-occupied'}"></span>
                <span>${statusLabel}</span>
            </div>
            <span class="hero-code">Mã: ${facility.serviceCode}</span>
        </div>
    </div>
</div>

<!-- Main -->
<div class="main-wrap">
    <!-- Left -->
    <div class="left-col">
        <a href="${pageContext.request.contextPath}/rooms" class="back-link">
            <span class="arrow">←</span> Trở lại danh sách
        </a>

        <!-- Description -->
        <div class="sec-label">Tổng quan</div>
        <div class="sec-title">Trải nghiệm nghỉ dưỡng <em style="color:var(--gold);font-style:italic">đẳng cấp</em></div>
        <p class="description">
            <c:choose>
                <c:when test="${not empty facility.description}">${facility.description}</c:when>
                <c:otherwise>Được bao quanh bởi cảnh quan thiên nhiên tuyệt mỹ, không gian nghỉ dưỡng tại Azure là sự giao thoa hoàn hảo giữa kiến trúc hiện đại và vẻ đẹp nguyên bản của biển cả. Mỗi chi tiết đều được chăm chút tỉ mỉ để tôn vinh sự riêng tư và sang trọng tuyệt đối của quý khách.</c:otherwise>
            </c:choose>
        </p>

        <div class="sec-divider"></div>

        <!-- Specs -->
        <div class="sec-label">Thông số</div>
        <div class="sec-title" style="margin-bottom:16px">Chi tiết không gian</div>
        <div class="specs-grid">
            <div class="spec-card">
                <div class="spec-lbl">Diện tích</div>
                <div class="spec-val">${facility.usableArea}<span class="spec-unit">m²</span></div>
            </div>
            <div class="spec-card">
                <div class="spec-lbl">Sức chứa</div>
                <div class="spec-val">${facility.maxPeople}<span class="spec-unit">người</span></div>
            </div>
            <div class="spec-card">
                <div class="spec-lbl">Loại hình</div>
                <div class="spec-val" style="font-size:16px">${facilityTypeLabel}</div>
            </div>
            <div class="spec-card">
                <div class="spec-lbl">Hình thức</div>
                <div class="spec-val" style="font-size:16px">${rentalTypeLabel}</div>
            </div>
            <div class="spec-card">
                <div class="spec-lbl">Tầm nhìn</div>
                <div class="spec-val" style="font-size:16px">Panorama</div>
            </div>
            <div class="spec-card">
                <div class="spec-lbl">Mã định danh</div>
                <div class="spec-val" style="font-size:14px;font-family:monospace">${facility.serviceCode}</div>
            </div>
        </div>

        <div class="sec-divider"></div>

        <!-- Amenities -->
        <div class="sec-label">Tiện nghi</div>
        <div class="sec-title" style="margin-bottom:16px">Đặc quyền dành riêng</div>
        <div class="amenities-grid">
            <span class="amenity"><span class="amenity-icon">Wifi</span> Wifi tốc độ cao</span>
            <span class="amenity"><span class="amenity-icon">AC</span> Điều hòa trung tâm</span>
            <span class="amenity"><span class="amenity-icon">TV</span> TV 4K OLED</span>
            <span class="amenity"><span class="amenity-icon">24/7</span> Dọn phòng 24/7</span>
            <span class="amenity"><span class="amenity-icon">Safe</span> Két sắt an toàn</span>
            <span class="amenity"><span class="amenity-icon">Bar</span> Minibar cao cấp</span>
            <c:choose>
                <c:when test="${facility.facilityType == 'VILLA'}">
                    <span class="amenity"><span class="amenity-icon">Pool</span> Hồ bơi riêng</span>
                    <span class="amenity"><span class="amenity-icon">BBQ</span> Khu BBQ ngoài trời</span>
                    <span class="amenity"><span class="amenity-icon">Butler</span> Butler riêng 24/7</span>
                    <span class="amenity"><span class="amenity-icon">Spa</span> Spa tại phòng</span>
                    <span class="amenity"><span class="amenity-icon">Car</span> Xe đưa đón sân bay</span>
                    <span class="amenity"><span class="amenity-icon">Chef</span> Đầu bếp riêng theo yêu cầu</span>
                </c:when>
                <c:when test="${facility.facilityType == 'HOUSE'}">
                    <span class="amenity"><span class="amenity-icon">Garden</span> Sân vườn riêng</span>
                    <span class="amenity"><span class="amenity-icon">Kitchen</span> Bếp đầy đủ tiện nghi</span>
                    <span class="amenity"><span class="amenity-icon">Laundry</span> Máy giặt riêng</span>
                    <span class="amenity"><span class="amenity-icon">Parking</span> Bãi đỗ xe riêng</span>
                </c:when>
                <c:otherwise>
                    <span class="amenity"><span class="amenity-icon">Pool</span> Hồ bơi chung</span>
                    <span class="amenity"><span class="amenity-icon">Gym</span> Phòng gym</span>
                    <span class="amenity"><span class="amenity-icon">Spa</span> Spa &amp; Wellness</span>
                    <span class="amenity"><span class="amenity-icon">Dining</span> Nhà hàng Pearl</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="sec-divider"></div>

        <!-- Gallery -->
        <div class="sec-label">Hình ảnh</div>
        <div class="sec-title" style="margin-bottom:16px">Không gian thực tế</div>
        <div class="gallery-grid">
            <img src="${imgSrc.startsWith('http') ? imgSrc : pageContext.request.contextPath.concat('/').concat(imgSrc)}"
                 alt="${facility.serviceName}" class="gallery-img">
            <div class="gallery-placeholder">+</div>
            <div class="gallery-placeholder">+</div>
            <div class="gallery-placeholder">+</div>
        </div>
    </div>

    <!-- Right: Booking Widget -->
    <div>
        <div class="booking-widget">
            <div class="widget-price-label">Giá từ</div>
            <div class="widget-price">
                <span class="amount">${formattedCost}</span>
                <span class="unit">đ / ${rentalTypeLabel}</span>
            </div>

            <c:choose>
                <c:when test="${isAvailable}">
                    <form action="${pageContext.request.contextPath}/booking" method="GET" id="bookingForm">
                        <input type="hidden" name="facility" value="${facility.serviceCode}">
                        <div class="form-group">
                            <label class="form-label">Ngày nhận phòng</label>
                            <input type="date" name="checkin" id="checkinInput" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Ngày trả phòng</label>
                            <input type="date" name="checkout" id="checkoutInput" class="form-input" required>
                        </div>
                        <div id="nightsPreview" class="nights-preview"></div>
                        <div class="form-group">
                            <label class="form-label">Số khách</label>
                            <select name="adults" class="form-input">
                                <c:forEach begin="1" end="${facility.maxPeople}" var="i">
                                    <option value="${i}">${i} người lớn</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn-book">Đặt phòng ngay</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center;padding:24px 0">
                        <div style="font-size:36px;opacity:0.15;margin-bottom:12px">X</div>
                        <div style="font-size:14px;color:rgba(255,255,255,0.3);font-weight:600">Tạm hết phòng</div>
                        <div style="font-size:11px;color:rgba(255,255,255,0.18);margin-top:6px">Vui lòng liên hệ hotline</div>
                    </div>
                    <button class="btn-unavailable" disabled>Không thể đặt</button>
                </c:otherwise>
            </c:choose>

            <div class="widget-footer">
                Miễn phí hủy trước 48 giờ<br>
                Hỗ trợ 24/7: <strong>1800 7777</strong>
            </div>
        </div>
    </div>
</div>

<footer>
    <div class="footer-inner">
        <div class="footer-brand">Azure <span>Resort</span> &amp; Spa</div>
        <div class="footer-copy">© 2026 Azure Resort &amp; Spa. All rights reserved.</div>
    </div>
</footer>

<script>
    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 60);
    });

    // Date logic
    var today = new Date().toISOString().split('T')[0];
    var ci = document.getElementById('checkinInput');
    var co = document.getElementById('checkoutInput');
    var preview = document.getElementById('nightsPreview');
    var cost = <c:out value="${facility.cost != null ? facility.cost : 0}"/>;

    if (ci) {
        ci.min = today;
        ci.addEventListener('change', function() {
            if (this.value) {
                var next = new Date(this.value);
                next.setDate(next.getDate() + 1);
                if (co) { co.min = next.toISOString().split('T')[0]; }
            }
            updateNightsPreview();
        });
    }
    if (co) {
        co.min = today;
        co.addEventListener('change', updateNightsPreview);
    }

    function updateNightsPreview() {
        if (!ci || !co || !ci.value || !co.value) { preview.style.display = 'none'; return; }
        var d1 = new Date(ci.value), d2 = new Date(co.value);
        var nights = Math.round((d2 - d1) / 86400000);
        if (nights <= 0) { preview.style.display = 'none'; return; }
        var total = nights * cost;
        preview.style.display = 'block';
        preview.innerHTML = '<strong>' + nights + ' đêm</strong> &nbsp;·&nbsp; Ước tính: <strong>' +
            new Intl.NumberFormat('vi-VN').format(total) + ' đ</strong>';
    }
</script>
</body>
</html>
