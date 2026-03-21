<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty sessionScope.account}">
    <c:redirect url="/login.jsp"/>
</c:if>
<c:set var="account" value="${sessionScope.account.fullName}"/>
<c:set var="currentUser" value="${sessionScope.account}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài Khoản — Azure Resort</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --gold: #c9a84c; --gold-light: #e8cc82; --dark: #0a0a0f; --navy: #0d1526; --text: #e8e8e8; --text-muted: rgba(255,255,255,0.5); }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); min-height: 100vh; }

        /* NAVBAR */
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 60px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.95); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.15); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 36px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.75); text-decoration: none; font-size: 13.5px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover, .nav-links a.active { color: var(--gold); }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-greeting { color: rgba(255,255,255,0.5); font-size: 13px; }
        .nav-greeting strong { color: var(--gold); }
        .btn-nav-logout { padding: 8px 20px; border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; background: transparent; color: var(--gold); font-size: 13px; text-decoration: none; transition: all 0.25s; }
        .btn-nav-logout:hover { background: var(--gold); color: var(--dark); }

        /* PAGE */
        .page-wrap { margin-top: 72px; padding: 56px 60px 80px; max-width: 1100px; margin-left: auto; margin-right: auto; }
        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--text-muted); margin-bottom: 32px; }
        .breadcrumb a { color: var(--text-muted); text-decoration: none; transition: color 0.2s; }
        .breadcrumb a:hover { color: var(--gold); }
        .breadcrumb .sep { color: rgba(255,255,255,0.2); }

        /* PROFILE BANNER */
        .profile-banner {
            background: linear-gradient(135deg, rgba(201,168,76,0.08), rgba(13,21,38,0.6));
            border: 1px solid rgba(201,168,76,0.15);
            border-radius: 24px;
            padding: 36px 40px;
            display: flex;
            align-items: center;
            gap: 28px;
            margin-bottom: 40px;
        }
        .avatar {
            width: 72px; height: 72px; border-radius: 50%;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            display: flex; align-items: center; justify-content: center;
            font-size: 28px; font-weight: 700; color: var(--dark);
            flex-shrink: 0;
        }
        .profile-info h2 { font-family: 'Playfair Display', serif; font-size: 24px; color: #fff; margin-bottom: 4px; }
        .profile-info p { color: var(--text-muted); font-size: 14px; }
        .profile-info .email { color: var(--gold); font-size: 13px; margin-top: 4px; }

        /* SECTION LABEL */
        .section-label { display: inline-block; color: var(--gold); font-size: 11px; letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 20px; }

        /* CARDS GRID */
        .account-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }
        .account-card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 20px;
            padding: 32px 24px;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
            display: block;
        }
        .account-card:hover {
            background: rgba(201,168,76,0.07);
            border-color: rgba(201,168,76,0.3);
            transform: translateY(-5px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.3);
        }
        .card-icon { font-size: 36px; margin-bottom: 14px; }
        .account-card h4 { color: #fff; font-size: 16px; font-weight: 600; margin-bottom: 8px; }
        .account-card p { color: var(--text-muted); font-size: 13px; line-height: 1.5; }
        .card-arrow { display: inline-block; color: var(--gold); font-size: 12px; font-weight: 600; margin-top: 14px; }

        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .page-wrap { padding: 40px 20px 60px; margin-top: 72px; }
            .profile-banner { flex-direction: column; text-align: center; padding: 28px 24px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="active">Tài Khoản</a></li>
    </ul>
    <div class="nav-right">
        <span class="nav-greeting">Xin chào, <strong>${account}</strong></span>
        <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Đăng xuất</a>
    </div>
</nav>

<div class="page-wrap">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
        <span class="sep">›</span>
        <span style="color:var(--gold)">Tài Khoản</span>
    </div>

    <!-- Profile Banner -->
    <div class="profile-banner">
        <div class="avatar">${fn:substring(account, 0, 1)}</div>
        <div class="profile-info">
            <h2>${account}</h2>
            <p>${currentUser.personType == 'EMPLOYEE' ? 'Nhân viên' : 'Khách hàng'}</p>
            <p class="email">${currentUser.email}</p>
        </div>
    </div>

    <!-- Menu Cards -->
    <span class="section-label">Quản Lý Tài Khoản</span>
    <div class="account-grid">
        <a href="${pageContext.request.contextPath}/booking?view=my" class="account-card">
            <div class="card-icon">📋</div>
            <h4>Booking Của Tôi</h4>
            <p>Xem lịch sử và trạng thái các đặt phòng</p>
            <span class="card-arrow">Xem ngay →</span>
        </a>
        <a href="${pageContext.request.contextPath}/contracts" class="account-card">
            <div class="card-icon">📄</div>
            <h4>Hợp Đồng</h4>
            <p>Tra cứu hợp đồng và theo dõi thanh toán</p>
            <span class="card-arrow">Xem ngay →</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile" class="account-card">
            <div class="card-icon">👤</div>
            <h4>Hồ Sơ Cá Nhân</h4>
            <p>Cập nhật thông tin và đổi mật khẩu</p>
            <span class="card-arrow">Chỉnh sửa →</span>
        </a>
        <a href="${pageContext.request.contextPath}/#promotions" class="account-card">
            <div class="card-icon">🎁</div>
            <h4>Ưu Đãi Của Tôi</h4>
            <p>Voucher, điểm thưởng và khuyến mãi</p>
            <span class="card-arrow">Xem ưu đãi →</span>
        </a>
        <a href="${pageContext.request.contextPath}/rooms" class="account-card">
            <div class="card-icon">🏖️</div>
            <h4>Đặt Phòng Mới</h4>
            <p>Khám phá và đặt phòng villa, bungalow</p>
            <span class="card-arrow">Khám phá →</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="account-card" style="border-color:rgba(248,113,113,0.15);">
            <div class="card-icon">🚪</div>
            <h4>Đăng Xuất</h4>
            <p>Thoát khỏi tài khoản hiện tại</p>
            <span class="card-arrow" style="color:#f87171;">Đăng xuất →</span>
        </a>
    </div>
</div>

<footer style="background:#060608;border-top:1px solid rgba(201,168,76,0.1);padding:28px 60px;">
    <div style="max-width:1100px;margin:0 auto;display:flex;justify-content:space-between;align-items:center;color:rgba(255,255,255,0.25);font-size:12.5px;">
        <span>© 2026 <span style="color:var(--gold)">Azure Resort &amp; Spa</span>. All rights reserved.</span>
        <span>Made with ❤️ in Vietnam</span>
    </div>
</footer>

<!-- CHATBOT WIDGET -->
<jsp:include page="/chat_widget.jsp"/>
</body>
</html>
