<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Azure Resort &amp; Spa — Trang Chủ</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --gold: #c9a84c; --gold-light: #e8cc82;
            --dark: #0a0a0f; --navy: #0d1526;
            --text: #e8e8e8; --text-muted: rgba(255,255,255,0.5);
        }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); overflow-x: hidden; }
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 60px; height: 72px; display: flex; align-items: center; justify-content: space-between; transition: background 0.3s; }
        .navbar.scrolled { background: rgba(10,10,15,0.9); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.15); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 36px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.75); text-decoration: none; font-size: 13.5px; font-weight: 500; letter-spacing: 0.5px; transition: color 0.2s; position: relative; }
        .nav-links a::after { content: ''; position: absolute; bottom: -4px; left: 0; right: 100%; height: 1px; background: var(--gold); transition: right 0.25s; }
        .nav-links a:hover { color: #fff; }
        .nav-links a:hover::after { right: 0; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-greeting { color: rgba(255,255,255,0.5); font-size: 13px; }
        .nav-greeting strong { color: var(--gold); }
        .btn-nav-logout { padding: 8px 20px; border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; background: transparent; color: var(--gold); font-size: 13px; cursor: pointer; transition: all 0.25s; text-decoration: none; }
        .btn-nav-logout:hover { background: var(--gold); color: var(--dark); }
        .btn-nav-login { padding: 8px 24px; background: var(--gold); color: var(--dark); border: 1px solid var(--gold); border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.25s; }
        .btn-nav-login:hover { background: var(--gold-light); }
        .btn-nav-register { padding: 8px 24px; background: transparent; color: var(--gold); border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.25s; }
        .btn-nav-register:hover { background: var(--gold); color: var(--dark); }
        .hero { height: 100vh; position: relative; display: flex; align-items: center; justify-content: center; text-align: center; background: url('assets/img/hero-bg.png') center/cover no-repeat; overflow: hidden; }
        .hero::before { content: ''; position: absolute; inset: 0; background: linear-gradient(to bottom, rgba(0,0,0,0.35) 0%, rgba(0,0,0,0.6) 60%, var(--dark) 100%); }
        .hero-content { position: relative; z-index: 1; max-width: 780px; padding: 0 24px; animation: fadeUp 1s ease; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: translateY(0); } }
        .hero-badge { display: inline-flex; align-items: center; gap: 8px; background: rgba(201,168,76,0.12); border: 1px solid rgba(201,168,76,0.3); padding: 8px 20px; border-radius: 50px; color: var(--gold-light); font-size: 12px; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 24px; }
        .hero h1 { font-family: 'Playfair Display', serif; font-size: clamp(42px,6vw,76px); font-weight: 700; color: #fff; line-height: 1.1; margin-bottom: 20px; }
        .hero h1 em { color: var(--gold); font-style: italic; }
        .hero-sub { color: rgba(255,255,255,0.65); font-size: 17px; font-weight: 300; line-height: 1.7; margin-bottom: 40px; }
        .hero-actions { display: flex; gap: 16px; justify-content: center; flex-wrap: wrap; }
        .btn-primary { padding: 15px 40px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; border-radius: 50px; font-size: 14px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; cursor: pointer; transition: all 0.3s; box-shadow: 0 8px 28px rgba(201,168,76,0.3); }
        .btn-primary:hover { transform: translateY(-3px); box-shadow: 0 16px 40px rgba(201,168,76,0.4); }
        .btn-outline { padding: 14px 36px; background: transparent; border: 1.5px solid rgba(255,255,255,0.4); color: #fff; border-radius: 50px; font-size: 14px; font-weight: 500; text-decoration: none; transition: all 0.3s; }
        .btn-outline:hover { border-color: var(--gold); color: var(--gold); }
        .hero-scroll { position: absolute; bottom: 40px; left: 50%; transform: translateX(-50%); z-index: 1; display: flex; flex-direction: column; align-items: center; gap: 8px; color: rgba(255,255,255,0.4); font-size: 11px; letter-spacing: 2px; text-transform: uppercase; animation: bounce 2s infinite; }
        @keyframes bounce { 0%,100% { transform: translateX(-50%) translateY(0); } 50% { transform: translateX(-50%) translateY(8px); } }

        section { padding: 96px 60px; }
        .section-inner { max-width: 1200px; margin: 0 auto; }
        .section-label { display: inline-block; color: var(--gold); font-size: 11px; letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 12px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: clamp(28px,4vw,44px); color: #fff; line-height: 1.2; margin-bottom: 16px; }
        .section-title em { color: var(--gold); font-style: italic; }
        .section-desc { color: var(--text-muted); font-size: 15px; line-height: 1.8; max-width: 560px; }
        .stats-bar { background: linear-gradient(90deg, rgba(201,168,76,0.06) 0%, rgba(201,168,76,0.02) 100%); border-top: 1px solid rgba(201,168,76,0.1); border-bottom: 1px solid rgba(201,168,76,0.1); padding: 36px 60px; }
        .stats-inner { max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-around; flex-wrap: wrap; gap: 24px; }
        .stat-item { text-align: center; }
        .stat-num { font-family: 'Playfair Display', serif; font-size: 42px; color: var(--gold); font-weight: 700; line-height: 1; }
        .stat-label { color: var(--text-muted); font-size: 12px; letter-spacing: 1.5px; text-transform: uppercase; margin-top: 6px; }
        .features { background: var(--dark); }
        .features-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-top: 52px; }
        .feature-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 20px; padding: 36px 28px; text-align: center; cursor: pointer; transition: all 0.3s; text-decoration: none; display: block; }
        .feature-card:hover { background: rgba(201,168,76,0.06); border-color: rgba(201,168,76,0.25); transform: translateY(-6px); box-shadow: 0 20px 48px rgba(0,0,0,0.3); }
        .feature-card h3 { color: #fff; font-size: 16px; font-weight: 600; margin-bottom: 10px; }
        .feature-card p { color: var(--text-muted); font-size: 13px; line-height: 1.6; }
        .feature-arrow { display: inline-flex; align-items: center; gap: 6px; color: var(--gold); font-size: 12px; font-weight: 600; margin-top: 16px; letter-spacing: 0.5px; }
        .rooms { background: var(--navy); }
        .rooms-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 28px; margin-top: 52px; }
        .room-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 20px; overflow: hidden; transition: all 0.35s; cursor: pointer; }
        .room-card:hover { transform: translateY(-8px); box-shadow: 0 28px 56px rgba(0,0,0,0.4); border-color: rgba(201,168,76,0.2); }
        .room-img { width: 100%; height: 240px; object-fit: cover; transition: transform 0.5s; }
        .room-card:hover .room-img { transform: scale(1.05); }
        .room-img-wrap { overflow: hidden; position: relative; }
        .room-badge { position: absolute; top: 16px; left: 16px; background: var(--gold); color: var(--dark); font-size: 11px; font-weight: 700; padding: 5px 14px; border-radius: 50px; letter-spacing: 1px; }
        .room-body { padding: 24px; }
        .room-type { color: var(--gold); font-size: 11px; letter-spacing: 2px; text-transform: uppercase; font-weight: 600; margin-bottom: 8px; }
        .room-name { font-family: 'Playfair Display', serif; font-size: 22px; color: #fff; margin-bottom: 10px; }
        .room-desc { color: var(--text-muted); font-size: 13.5px; line-height: 1.6; margin-bottom: 18px; }
        .room-amenities { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 20px; }
        .amenity { background: rgba(255,255,255,0.05); border-radius: 50px; padding: 4px 14px; font-size: 12px; color: rgba(255,255,255,0.6); }
        .room-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 18px; border-top: 1px solid rgba(255,255,255,0.06); }
        .room-price .price { font-family: 'Playfair Display', serif; font-size: 26px; color: var(--gold); font-weight: 700; }
        .room-price .per { color: var(--text-muted); font-size: 12px; margin-left: 4px; }
        .btn-book { padding: 10px 24px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; border-radius: 50px; font-size: 13px; font-weight: 700; cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.25s; text-decoration: none; }
        .btn-book:hover { transform: scale(1.05); }
        .btn-detail { padding: 10px 20px; background: transparent; border: 1.5px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7); border-radius: 50px; font-size: 12.5px; font-weight: 500; cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.25s; text-decoration: none; }
        .btn-detail:hover { border-color: var(--gold); color: var(--gold); }
        .room-footer-btns { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        .status-tag { position: absolute; top: 16px; right: 16px; font-size: 10px; font-weight: 700; padding: 4px 12px; border-radius: 50px; letter-spacing: 0.5px; }
        .status-tag.available   { background: rgba(74,222,128,0.15); color: #4ade80; border: 1px solid rgba(74,222,128,0.3); }
        .status-tag.occupied    { background: rgba(248,113,113,0.15); color: #f87171; border: 1px solid rgba(248,113,113,0.3); }
        .status-tag.maintenance { background: rgba(251,191,36,0.15);  color: #fbbf24; border: 1px solid rgba(251,191,36,0.3); }
        .no-rooms { grid-column: 1 / -1; text-align: center; padding: 64px 24px; color: var(--text-muted); }
        .no-rooms p { font-size: 15px; margin-top: 12px; }
        .promotions { background: var(--dark); }
        .promo-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; margin-top: 52px; }
        .promo-card { background: linear-gradient(135deg, rgba(201,168,76,0.08), rgba(201,168,76,0.02)); border: 1px solid rgba(201,168,76,0.2); border-radius: 20px; padding: 32px; position: relative; overflow: hidden; transition: all 0.3s; }
        .promo-card::before { content: ''; position: absolute; right: -30px; top: -30px; width: 120px; height: 120px; border-radius: 50%; background: rgba(201,168,76,0.08); }
        .promo-card:hover { border-color: rgba(201,168,76,0.4); transform: translateY(-4px); }
        .promo-discount { font-family: 'Playfair Display', serif; font-size: 58px; font-weight: 700; color: var(--gold); line-height: 1; margin-bottom: 8px; }
        .promo-title { font-size: 17px; font-weight: 600; color: #fff; margin-bottom: 10px; }
        .promo-desc { font-size: 13px; color: var(--text-muted); line-height: 1.6; margin-bottom: 20px; }
        .promo-code { background: rgba(201,168,76,0.1); border: 1px dashed rgba(201,168,76,0.4); border-radius: 8px; padding: 10px 16px; display: flex; justify-content: space-between; align-items: center; }
        .promo-code span { font-weight: 700; color: var(--gold); letter-spacing: 2px; font-size: 15px; }
        .promo-code button { background: none; border: none; color: var(--text-muted); font-size: 12px; cursor: pointer; transition: color 0.2s; }
        .promo-code button:hover { color: var(--gold); }
        .promo-expiry { font-size: 12px; color: var(--text-muted); margin-top: 12px; }
        .my-account { background: linear-gradient(135deg, rgba(201,168,76,0.05), rgba(13,21,38,0.8)); border-top: 1px solid rgba(201,168,76,0.1); }
        .account-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 48px; }
        .account-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 28px 24px; text-align: center; text-decoration: none; transition: all 0.3s; display: block; }
        .account-card:hover { background: rgba(201,168,76,0.06); border-color: rgba(201,168,76,0.25); transform: translateY(-4px); }
        .account-card h4 { color: #fff; font-size: 15px; font-weight: 600; margin-bottom: 6px; }
        .account-card p { color: var(--text-muted); font-size: 12.5px; }
        footer { background: #060608; border-top: 1px solid rgba(201,168,76,0.1); padding: 60px; }
        .footer-inner { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 48px; }
        .footer-brand .logo { font-family: 'Playfair Display', serif; font-size: 26px; color: #fff; margin-bottom: 14px; }
        .footer-brand .logo span { color: var(--gold); }
        .footer-brand p { color: var(--text-muted); font-size: 13.5px; line-height: 1.7; }
        .footer-col h4 { color: #fff; font-size: 13px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 18px; }
        .footer-col a { display: block; color: var(--text-muted); text-decoration: none; font-size: 13.5px; margin-bottom: 10px; transition: color 0.2s; }
        .footer-col a:hover { color: var(--gold); }
        .footer-bottom { max-width: 1200px; margin: 40px auto 0; padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.06); display: flex; justify-content: space-between; align-items: center; color: rgba(255,255,255,0.25); font-size: 12.5px; }
        .footer-bottom span { color: var(--gold); }
        @media (max-width: 768px) { .navbar { padding: 0 24px; } section { padding: 64px 24px; } .booking-bar { padding: 24px; } .footer-inner { grid-template-columns: 1fr; } .hero h1 { font-size: 38px; } }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar" id="navbar">
    <a href="index.jsp" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="rooms">Phòng &amp; Villa</a></li>
        <li><a href="#promotions">Khuyến Mãi</a></li>
        <li><a href="booking">Đặt Phòng</a></li>
        <li><a href="contracts">Hợp Đồng</a></li>
        <li><a href="account.jsp">Tài Khoản</a></li>
    </ul>
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <span class="nav-greeting">Xin chào, <strong>${sessionScope.account.fullName}</strong></span>
                <a href="logout" class="btn-nav-logout">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="login.jsp" class="btn-nav-login">Đăng nhập</a>
                <a href="register" class="btn-nav-register">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-content">
        <div class="hero-badge">✦ Luxury 5-Star Resort ✦</div>
        <h1>Thiên Đường Nghỉ Dưỡng<br><em>Giữa Biển Xanh</em></h1>
        <p class="hero-sub">Trải nghiệm kỳ nghỉ đẳng cấp thế giới tại Azure Resort &amp; Spa —<br>nơi thiên nhiên hòa quyện cùng sự xa xỉ tuyệt đích.</p>
        <div class="hero-actions">
            <a href="rooms" class="btn-primary">Khám Phá Phòng</a>
            <a href="booking" class="btn-outline">Đặt Phòng Ngay</a>
        </div>
    </div>
    <div class="hero-scroll"><span>Cuộn xuống</span><span>↓</span></div>
</section>

<!-- STATS -->
<div class="stats-bar">
    <div class="stats-inner">
        <div class="stat-item"><div class="stat-num">50+</div><div class="stat-label">Villa &amp; Phòng Sang Trọng</div></div>
        <div class="stat-item"><div class="stat-num">5★</div><div class="stat-label">Xếp Hạng Resort</div></div>
        <div class="stat-item"><div class="stat-num">15K+</div><div class="stat-label">Khách Hàng Hài Lòng</div></div>
        <div class="stat-item"><div class="stat-num">10+</div><div class="stat-label">Năm Kinh Nghiệm</div></div>
    </div>
</div>

<!-- FEATURES -->
<section class="features">
    <div class="section-inner">
        <span class="section-label">Dịch Vụ Của Chúng Tôi</span>
        <h2 class="section-title">Mọi Thứ Bạn <em>Cần</em></h2>
        <p class="section-desc">Từ đặt phòng đến quản lý hợp đồng, tất cả trong một nơi.</p>
        <div class="features-grid">
            <a href="booking" class="feature-card"><h3>Đặt Phòng</h3><p>Chọn villa hoặc phòng yêu thích và đặt ngay trong vài bước đơn giản.</p><span class="feature-arrow">Đặt ngay →</span></a>
            <a href="booking?view=my" class="feature-card"><h3>Booking Của Tôi</h3><p>Xem lịch sử đặt phòng, trạng thái và chi tiết các booking của bạn.</p><span class="feature-arrow">Xem ngay →</span></a>
            <a href="contracts" class="feature-card"><h3>Hợp Đồng</h3><p>Tra cứu và quản lý hợp đồng, theo dõi tình trạng thanh toán.</p><span class="feature-arrow">Xem ngay →</span></a>
            <a href="#promotions" class="feature-card"><h3>Khuyến Mãi</h3><p>Khám phá ưu đãi đặc biệt và mã giảm giá dành riêng cho bạn.</p><span class="feature-arrow">Xem ưu đãi →</span></a>
        </div>
    </div>
</section>

<!-- PROMOTIONS -->
<section class="promotions" id="promotions">
    <div class="section-inner">
        <span class="section-label">Ưu Đãi Đặc Biệt</span>
        <h2 class="section-title"><em>Khuyến Mãi</em> Hấp Dẫn</h2>
        <p class="section-desc">Tiết kiệm hơn với những ưu đãi độc quyền dành cho khách hàng thân thiết.</p>
        <div class="promo-grid">
            <div class="promo-card">
                <div class="promo-discount">20%</div>
                <div class="promo-title">Đặt Sớm 30 Ngày</div>
                <div class="promo-desc">Đặt phòng trước 30 ngày để nhận ưu đãi giảm 20% cho tất cả các loại phòng và villa.</div>
                <div class="promo-code"><span>EARLYBIRD20</span><button onclick="copyCode('EARLYBIRD20',this)">Sao chép</button></div>
                <div class="promo-expiry">Hết hạn: 31/05/2026</div>
            </div>
            <div class="promo-card">
                <div class="promo-discount">15%</div>
                <div class="promo-title">Gói Cuối Tuần</div>
                <div class="promo-desc">Đặt phòng vào thứ 6, thứ 7 nhận ngay ưu đãi 15% kèm bữa ăn sáng miễn phí cho 2 người.</div>
                <div class="promo-code"><span>WEEKEND15</span><button onclick="copyCode('WEEKEND15',this)">Sao chép</button></div>
                <div class="promo-expiry">Hết hạn: 30/06/2026</div>
            </div>
            <div class="promo-card">
                <div class="promo-discount">30%</div>
                <div class="promo-title">Khách Hàng VIP</div>
                <div class="promo-desc">Danh hiệu Diamond/Gold được hưởng ưu đãi 30% cho lần đặt phòng tiếp theo.</div>
                <div class="promo-code"><span>VIP2026</span><button onclick="copyCode('VIP2026',this)">Sao chép</button></div>
                <div class="promo-expiry">Hết hạn: 31/12/2026</div>
            </div>
        </div>
    </div>
</section>

<!-- MY ACCOUNT -->
<!-- FOOTER -->
<footer>
    <div class="footer-inner">
        <div class="footer-brand">
            <div class="logo">Azure <span>Resort</span> &amp; Spa</div>
            <p>Thiên đường nghỉ dưỡng 5 sao với vẻ đẹp thiên nhiên kỳ thú và dịch vụ đẳng cấp thế giới.</p>
        </div>
        <div class="footer-col">
            <h4>Khám Phá</h4>
            <a href="#rooms">Phòng &amp; Villa</a>
            <a href="#promotions">Khuyến Mãi</a>
            <a href="booking">Đặt Phòng</a>
        </div>
        <div class="footer-col">
            <h4>Tài Khoản</h4>
            <a href="booking?view=my">Booking Của Tôi</a>
            <a href="contracts">Hợp Đồng</a>
            <a href="profile">Hồ Sơ</a>
        </div>
        <div class="footer-col">
            <h4>Liên Hệ</h4>
            <a href="#">📍 Đà Nẵng, Việt Nam</a>
            <a href="#">📞 1800 7777</a>
            <a href="#">✉️ info@azure-resort.vn</a>
        </div>
    </div>
    <div class="footer-bottom">
        <span>© 2026 <span>Azure Resort &amp; Spa</span>. All rights reserved.</span>
        <span>Made with ❤️ in Vietnam</span>
    </div>
</footer>

<script>
    window.addEventListener('scroll', () => {
        document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 60);
    });
    // Set min date for booking bar
    const _today = new Date().toISOString().split('T')[0];
    if (document.getElementById('checkinInput')) document.getElementById('checkinInput').min = _today;
    if (document.getElementById('checkoutInput')) document.getElementById('checkoutInput').min = _today;
    function copyCode(code, btn) {
        navigator.clipboard.writeText(code).then(() => {
            const orig = btn.textContent;
            btn.textContent = '✅ Đã sao chép';
            setTimeout(() => btn.textContent = orig, 2000);
        });
    }
</script>

</body>
</html>
