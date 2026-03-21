<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${empty facility}">
    <c:redirect url="/"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${facility.serviceName} — Azure Resort &amp; Spa</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --gold: #c9a84c; --gold-light: #e8cc82; --dark: #0a0a0f; --navy: #0d1526; --text: #e8e8e8; --text-muted: rgba(255,255,255,0.5); }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); overflow-x: hidden; }
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 60px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.92); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.15); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 36px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.75); text-decoration: none; font-size: 13.5px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover { color: #fff; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-greeting { color: rgba(255,255,255,0.5); font-size: 13px; }
        .nav-greeting strong { color: var(--gold); }
        .btn-nav-logout { padding: 8px 20px; border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; background: transparent; color: var(--gold); font-size: 13px; cursor: pointer; transition: all 0.25s; text-decoration: none; }
        .btn-nav-logout:hover { background: var(--gold); color: var(--dark); }
        .btn-nav-login { padding: 8px 24px; background: var(--gold); color: var(--dark); border: 1px solid var(--gold); border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; }
        .btn-nav-register { padding: 8px 24px; background: transparent; color: var(--gold); border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; }
        .breadcrumb-wrap { margin-top: 72px; padding: 20px 60px; background: rgba(255,255,255,0.02); border-bottom: 1px solid rgba(255,255,255,0.05); }
        .breadcrumb { max-width: 1200px; margin: 0 auto; display: flex; align-items: center; gap: 10px; font-size: 13px; color: var(--text-muted); }
        .breadcrumb a { color: var(--text-muted); text-decoration: none; }
        .breadcrumb a:hover { color: var(--gold); }
        .breadcrumb .sep { color: rgba(255,255,255,0.2); }
        .breadcrumb .current { color: var(--gold); }
        .detail-hero { position: relative; height: 500px; overflow: hidden; }
        .detail-hero img { width: 100%; height: 100%; object-fit: cover; }
        .detail-hero-overlay { position: absolute; inset: 0; background: linear-gradient(to bottom, rgba(0,0,0,0.15) 0%, rgba(0,0,0,0.25) 50%, rgba(10,10,15,0.95) 100%); }
        .detail-hero-info { position: absolute; bottom: 40px; left: 60px; z-index: 2; }
        .facility-badge { display: inline-block; background: rgba(201,168,76,0.15); border: 1px solid rgba(201,168,76,0.4); color: var(--gold-light); font-size: 11px; letter-spacing: 2.5px; text-transform: uppercase; font-weight: 600; padding: 6px 18px; border-radius: 50px; margin-bottom: 14px; }
        .detail-hero-info h1 { font-family: 'Playfair Display', serif; font-size: clamp(30px, 4vw, 52px); font-weight: 700; color: #fff; line-height: 1.15; }
        .status-pill { display: inline-flex; align-items: center; gap: 7px; padding: 6px 16px; border-radius: 50px; font-size: 12px; font-weight: 600; margin-top: 14px; }
        .status-dot { width: 8px; height: 8px; border-radius: 50%; }
        .status-available { background: rgba(74,222,128,0.12); border: 1px solid rgba(74,222,128,0.3); color: #4ade80; }
        .status-available .status-dot { background: #4ade80; }
        .status-occupied { background: rgba(248,113,113,0.12); border: 1px solid rgba(248,113,113,0.3); color: #f87171; }
        .status-occupied .status-dot { background: #f87171; }
        .status-maintenance { background: rgba(251,191,36,0.12); border: 1px solid rgba(251,191,36,0.3); color: #fbbf24; }
        .status-maintenance .status-dot { background: #fbbf24; }
        .detail-main { max-width: 1200px; margin: 0 auto; padding: 56px 60px 80px; display: grid; grid-template-columns: 1fr 380px; gap: 48px; align-items: start; }
        .section-label { display: inline-block; color: var(--gold); font-size: 11px; letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 12px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: clamp(24px, 3vw, 36px); color: #fff; line-height: 1.2; margin-bottom: 20px; }
        .section-title em { color: var(--gold); font-style: italic; }
        .detail-desc { color: rgba(255,255,255,0.65); font-size: 15px; line-height: 1.85; margin-bottom: 40px; }
        .specs-title { font-size: 13px; font-weight: 700; color: var(--gold); letter-spacing: 2px; text-transform: uppercase; margin-bottom: 20px; }
        .specs-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 40px; }
        .spec-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 14px; padding: 20px 22px; }
        .spec-label { font-size: 10.5px; color: var(--text-muted); letter-spacing: 1.5px; text-transform: uppercase; font-weight: 600; margin-bottom: 6px; }
        .spec-value { font-size: 18px; font-weight: 700; color: #fff; }
        .spec-value span { font-size: 13px; font-weight: 400; color: var(--text-muted); }
        .services-section { margin-bottom: 40px; }
        .services-heading { font-size: 13px; font-weight: 700; color: var(--gold); letter-spacing: 2px; text-transform: uppercase; margin-bottom: 16px; }
        .services-tags { display: flex; flex-wrap: wrap; gap: 10px; }
        .service-tag { background: rgba(201,168,76,0.07); border: 1px solid rgba(201,168,76,0.18); border-radius: 50px; padding: 7px 18px; font-size: 13px; color: rgba(255,255,255,0.75); }
        .booking-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 24px; padding: 36px 32px; position: sticky; top: 96px; }
        .booking-card-price { display: flex; align-items: baseline; gap: 8px; margin-bottom: 8px; }
        .price-main { font-family: 'Playfair Display', serif; font-size: 38px; font-weight: 700; color: var(--gold); }
        .price-currency { font-size: 18px; color: var(--gold); margin-right: 2px; }
        .price-type-badge { display: inline-block; background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.25); border-radius: 50px; padding: 4px 14px; font-size: 11px; color: var(--gold); font-weight: 600; margin-bottom: 28px; }
        .booking-divider { height: 1px; background: rgba(255,255,255,0.06); margin: 24px 0; }
        .booking-form-label { font-size: 10.5px; color: var(--text-muted); letter-spacing: 1.5px; text-transform: uppercase; font-weight: 600; margin-bottom: 6px; display: block; }
        .booking-input { width: 100%; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; padding: 11px 14px; color: #fff; font-size: 14px; font-family: 'Inter', sans-serif; outline: none; margin-bottom: 16px; }
        .booking-input:focus { border-color: rgba(201,168,76,0.5); }
        .btn-book-now { width: 100%; padding: 15px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; border-radius: 12px; font-size: 15px; font-weight: 700; font-family: 'Inter', sans-serif; cursor: pointer; box-shadow: 0 8px 24px rgba(201,168,76,0.25); text-decoration: none; display: block; text-align: center; }
        .btn-book-now.disabled { background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.3); cursor: not-allowed; box-shadow: none; pointer-events: none; }
        .booking-note { margin-top: 14px; text-align: center; color: var(--text-muted); font-size: 12px; line-height: 1.6; }
        .code-chip { display: inline-flex; align-items: center; gap: 8px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 8px; padding: 10px 16px; margin-top: 10px; }
        .code-chip span { color: var(--text-muted); font-size: 12px; }
        .code-chip strong { color: #fff; font-size: 13px; letter-spacing: 1px; }
        .btn-back { display: inline-flex; align-items: center; gap: 8px; color: var(--text-muted); font-size: 13px; text-decoration: none; margin-bottom: 32px; }
        .btn-back:hover { color: var(--gold); }
        footer { background: #060608; border-top: 1px solid rgba(201,168,76,0.1); padding: 40px 60px; }
        .footer-bottom { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; color: rgba(255,255,255,0.25); font-size: 12.5px; }
        .footer-bottom .gold { color: var(--gold); }
        @media (max-width: 960px) { .detail-main { grid-template-columns: 1fr; padding: 40px 24px; } .booking-card { position: static; } .navbar { padding: 0 24px; } .specs-grid { grid-template-columns: 1fr; } footer { padding: 32px 24px; } }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/rooms">Phong &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/#promotions">Khuyen Mai</a></li>
        <li><a href="${pageContext.request.contextPath}/booking">Dat Phong</a></li>
        <li><a href="${pageContext.request.contextPath}/contracts">Hop Dong</a></li>
    </ul>
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <span class="nav-greeting">Xin chao, <strong>${sessionScope.account.fullName}</strong></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Dang xuat</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-nav-login">Dang nhap</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-nav-register">Dang ky</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="breadcrumb-wrap">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang Chu</a>
        <span class="sep">&#8250;</span>
        <a href="${pageContext.request.contextPath}/rooms">Phong &amp; Villa</a>
        <span class="sep">&#8250;</span>
        <span class="current">${facility.serviceName}</span>
    </div>
</div>

<div class="detail-hero">
    <img src="${imgSrc}" alt="${facility.serviceName}">
    <div class="detail-hero-overlay"></div>
    <div class="detail-hero-info">
        <div class="facility-badge">${facilityTypeLabel} - Azure Resort &amp; Spa</div>
        <h1>${facility.serviceName}</h1>
        <div class="status-pill ${statusClass}">
            <span class="status-dot"></span>
            ${statusLabel}
        </div>
    </div>
</div>

<div class="detail-main">
    <div class="detail-left">
        <a href="${pageContext.request.contextPath}/rooms" class="btn-back">
            &#8592; Quay lai danh sach phong
        </a>
        <span class="section-label">Thong Tin Chi Tiet</span>
        <h2 class="section-title">${facility.serviceName} <em>${facilityTypeLabel}</em></h2>
        <p class="detail-desc">
            <c:choose>
                <c:when test="${not empty facility.description}">${facility.description}</c:when>
                <c:otherwise>Khong gian nghi duong sang trong tai Azure Resort &amp; Spa.</c:otherwise>
            </c:choose>
        </p>
        <div class="specs-title">Thong So Ky Thuat</div>
        <div class="specs-grid">
            <div class="spec-card"><div class="spec-label">Dien Tich</div><div class="spec-value">${facility.usableArea} <span>m2</span></div></div>
            <div class="spec-card"><div class="spec-label">Suc Chua Toi Da</div><div class="spec-value">${facility.maxPeople} <span>nguoi</span></div></div>
            <div class="spec-card"><div class="spec-label">Loai Hinh</div><div class="spec-value">${facilityTypeLabel}</div></div>
            <div class="spec-card"><div class="spec-label">Hinh Thuc Thue</div><div class="spec-value">${rentalTypeLabel}</div></div>
            <div class="spec-card"><div class="spec-label">Trang Thai</div><div class="spec-value">${statusLabel}</div></div>
            <div class="spec-card"><div class="spec-label">Ma Phong</div><div class="spec-value" style="font-size:15px;">${facility.serviceCode}</div></div>
        </div>
        <div class="services-section">
            <div class="services-heading">Tien Nghi Bao Gom</div>
            <div class="services-tags">
                <span class="service-tag">Wifi toc do cao</span>
                <span class="service-tag">Dieu hoa trung tam</span>
                <span class="service-tag">Don phong hang ngay</span>
                <span class="service-tag">Tivi man hinh phang</span>
                <span class="service-tag">Ket an toan</span>
                <span class="service-tag">Minibar</span>
            </div>
        </div>
    </div>

    <div class="detail-right">
        <div class="booking-card">
            <div class="booking-card-price">
                <span class="price-currency">d</span>
                <span class="price-main">${formattedCost}</span>
            </div>
            <div style="margin-bottom:10px;color:var(--text-muted);font-size:13px;">/ ${rentalTypeLabel}</div>
            <div class="price-type-badge">${facilityTypeLabel} - ${rentalTypeLabel}</div>
            <c:choose>
                <c:when test="${isAvailable}">
                    <form action="${pageContext.request.contextPath}/booking" method="GET">
                        <input type="hidden" name="facility" value="${facility.serviceCode}">
                        <label class="booking-form-label">Ngay Nhan Phong</label>
                        <input type="date" name="checkin" class="booking-input" id="checkinInput">
                        <label class="booking-form-label">Ngay Tra Phong</label>
                        <input type="date" name="checkout" class="booking-input" id="checkoutInput">
                        <label class="booking-form-label">So Khach</label>
                        <select name="adults" class="booking-input">
                            <c:forEach begin="1" end="${facility.maxPeople}" var="i">
                                <option value="${i}">${i} nguoi</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn-book-now">Dat Phong Ngay</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <button class="btn-book-now disabled">${statusLabel} - Khong The Dat</button>
                </c:otherwise>
            </c:choose>
            <div class="booking-divider"></div>
            <div class="code-chip"><span>Ma:</span><strong>${facility.serviceCode}</strong></div>
            <p class="booking-note">Mien phi huy phong truoc 48 gio.<br>Ho tro 24/7 - Hotline: <strong>1800 7777</strong></p>
        </div>
    </div>
</div>

<footer>
    <div class="footer-bottom">
        <span>&#169; 2026 <span class="gold">Azure Resort &amp; Spa</span>. All rights reserved.</span>
        <span>Made with love in Vietnam</span>
    </div>
</footer>

<script>
    var today = new Date().toISOString().split('T')[0];
    var ci = document.getElementById('checkinInput');
    var co = document.getElementById('checkoutInput');
    if (ci) { ci.min = today; ci.addEventListener('change', function() { if (this.value) { var n = new Date(this.value); n.setDate(n.getDate()+1); if(co) co.min = n.toISOString().split('T')[0]; } }); }
    if (co) co.min = today;
</script>
</body>
</html>