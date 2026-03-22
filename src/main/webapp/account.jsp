<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%
    TblPersons currentUser = (TblPersons) session.getAttribute("account");
    if (currentUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    pageContext.setAttribute("currentUser", currentUser);
    boolean isEmployee = currentUser instanceof TblEmployees;
    pageContext.setAttribute("isEmployee", isEmployee);
    String dashboardUrl = "";
    if (isEmployee) {
        String role = ((TblEmployees) currentUser).getRole();
        dashboardUrl = "ADMIN".equals(role) ? request.getContextPath() + "/dashboard/admin" : request.getContextPath() + "/dashboard/staff";
    }
    pageContext.setAttribute("dashboardUrl", dashboardUrl);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài Khoản — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        :root{--gold:#c9a84c;--gold-light:#e8cc82;--dark:#0a0a0f;--navy:#0d1526;--card:rgba(255,255,255,0.025);--border:rgba(255,255,255,0.07);--text:#e8e8e8;--muted:rgba(255,255,255,0.35)}
        body{font-family:'Inter',sans-serif;background:var(--dark);color:var(--text);min-height:100vh}

        /* ── Navbar ── */
        .navbar{position:fixed;top:0;left:0;right:0;z-index:200;display:flex;align-items:center;justify-content:space-between;padding:0 48px;height:70px;background:rgba(10,10,15,0.88);backdrop-filter:blur(24px);border-bottom:1px solid rgba(255,255,255,0.05);transition:height 0.3s,background 0.3s}
        .brand{display:flex;align-items:center;gap:12px;text-decoration:none;font-family:'Playfair Display',serif;font-size:19px;font-weight:700;color:#fff}
        .brand-icon{width:34px;height:34px;border-radius:9px;background:var(--gold);display:flex;align-items:center;justify-content:center;color:var(--dark);font-style:italic;font-size:17px;font-weight:700;flex-shrink:0}
        .brand em{color:var(--gold);font-style:normal}
        .nav-links{display:flex;align-items:center;gap:32px;list-style:none}
        .nav-links a{color:rgba(255,255,255,0.38);text-decoration:none;font-size:10.5px;font-weight:700;text-transform:uppercase;letter-spacing:0.2em;transition:color 0.2s;padding:4px 0;position:relative}
        .nav-links a:hover{color:#fff}
        .nav-links a.active{color:var(--gold)}
        .nav-links a.active::after{content:'';position:absolute;bottom:-2px;left:0;right:0;height:1.5px;background:var(--gold);border-radius:2px}
        .nav-links a.btn-dash{padding:7px 18px;border:1.5px solid rgba(201,168,76,0.35);border-radius:50px;color:var(--gold)}
        .nav-links a.btn-dash:hover{background:var(--gold);color:var(--dark)}
        .nav-links a.btn-dash::after{display:none}
        .nav-right{display:flex;align-items:center;gap:14px}
        .nav-user-info{display:flex;flex-direction:column;align-items:flex-end}
        .nav-user-info .label{font-size:8.5px;color:rgba(255,255,255,0.18);text-transform:uppercase;letter-spacing:0.3em;font-weight:700}
        .nav-user-info .name{font-size:13px;font-weight:700;color:var(--gold)}
        .btn-logout-nav{width:34px;height:34px;border-radius:9px;border:1px solid rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;color:rgba(255,255,255,0.35);text-decoration:none;transition:all 0.2s;font-size:15px}
        .btn-logout-nav:hover{color:#f87171;border-color:rgba(248,113,113,0.3);background:rgba(248,113,113,0.06)}
        .hamburger{display:none;background:none;border:none;color:#fff;font-size:22px;cursor:pointer;padding:4px 8px;line-height:1}
        .mobile-nav{display:none;position:fixed;top:70px;left:0;right:0;background:rgba(10,10,15,0.97);backdrop-filter:blur(20px);border-bottom:1px solid rgba(201,168,76,0.15);z-index:999;padding:12px 20px 16px;flex-direction:column;gap:2px}
        .mobile-nav.open{display:flex}
        .mobile-nav a{color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;font-weight:500;padding:10px 0;border-bottom:1px solid rgba(255,255,255,0.05)}
        .mobile-nav a:last-child{border-bottom:none}
        .mobile-nav a:hover,.mobile-nav a.active{color:var(--gold)}

        /* ── Layout ── */
        main{max-width:1100px;margin:0 auto;padding:110px 28px 80px}

        /* ── Breadcrumb ── */
        .breadcrumb{display:flex;align-items:center;gap:8px;font-size:10px;color:rgba(255,255,255,0.22);text-transform:uppercase;letter-spacing:0.25em;font-weight:700;margin-bottom:40px}
        .breadcrumb a{color:rgba(255,255,255,0.22);text-decoration:none;transition:color 0.2s}
        .breadcrumb a:hover{color:var(--gold)}
        .breadcrumb .sep{opacity:0.3}
        .breadcrumb .current{color:var(--gold)}

        /* ── Hero Banner ── */
        .hero-banner{background:var(--card);border:1px solid var(--border);border-radius:28px;padding:36px 44px;margin-bottom:40px;display:flex;align-items:center;gap:28px;position:relative;overflow:hidden}
        .hero-banner::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,var(--gold),var(--gold-light),transparent)}
        .avatar{width:88px;height:88px;border-radius:20px;background:linear-gradient(135deg,var(--gold),var(--gold-light));display:flex;align-items:center;justify-content:center;font-family:'Playfair Display',serif;font-size:36px;font-weight:700;color:var(--dark);flex-shrink:0;box-shadow:0 8px 32px rgba(201,168,76,0.25)}
        .hero-info{flex:1}
        .hero-badge{display:inline-block;padding:4px 14px;border-radius:50px;background:rgba(201,168,76,0.1);border:1px solid rgba(201,168,76,0.2);color:var(--gold);font-size:9px;text-transform:uppercase;letter-spacing:0.3em;font-weight:700;margin-bottom:10px}
        .hero-name{font-family:'Playfair Display',serif;font-size:32px;font-weight:700;color:#fff;margin-bottom:8px;line-height:1.1}
        .hero-meta{display:flex;align-items:center;gap:20px;flex-wrap:wrap}
        .hero-meta span{font-size:13px;color:rgba(255,255,255,0.38);display:flex;align-items:center;gap:6px}
        .btn-edit-profile{padding:10px 24px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.1);border-radius:12px;color:rgba(255,255,255,0.6);font-size:12px;font-weight:600;text-decoration:none;transition:all 0.2s;white-space:nowrap;flex-shrink:0}
        .btn-edit-profile:hover{border-color:var(--gold);color:var(--gold);background:rgba(201,168,76,0.05)}

        /* ── Section header ── */
        .section-header{display:flex;align-items:center;gap:16px;margin-bottom:24px}
        .section-header span{font-size:10px;color:rgba(255,255,255,0.25);text-transform:uppercase;letter-spacing:0.35em;font-weight:700;white-space:nowrap}
        .section-header::after{content:'';flex:1;height:1px;background:rgba(255,255,255,0.05)}

        /* ── Cards grid ── */
        .cards-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
        @media(max-width:900px){.cards-grid{grid-template-columns:repeat(2,1fr)}}
        @media(max-width:560px){.cards-grid{grid-template-columns:1fr}}
        @media(max-width:1024px){
            main{padding:100px 20px 60px}
        }
        @media(max-width:768px){
            .navbar{padding:0 16px}
            .nav-links{display:none}
            .nav-right{gap:8px}
            .nav-user-info{display:none}
            main{padding:86px 14px 48px}
            .hero-banner{padding:24px 20px;flex-direction:column;align-items:flex-start;gap:16px}
            .avatar{width:64px;height:64px;font-size:26px;border-radius:14px}
            .hero-name{font-size:22px}
            .btn-edit-profile{width:100%}
            .cards-grid{grid-template-columns:1fr}
            footer{padding:24px 16px;flex-direction:column;gap:8px;text-align:center}
        }

        .card{background:var(--card);border:1px solid var(--border);border-radius:22px;padding:28px;text-decoration:none;display:block;transition:all 0.25s;position:relative;overflow:hidden}
        .card:hover{border-color:rgba(201,168,76,0.28);transform:translateY(-3px);box-shadow:0 16px 40px rgba(0,0,0,0.3),0 0 0 1px rgba(201,168,76,0.08)}
        .card-icon-wrap{width:52px;height:52px;border-radius:14px;background:rgba(201,168,76,0.08);display:flex;align-items:center;justify-content:center;font-size:22px;margin-bottom:20px;transition:all 0.25s}
        .card:hover .card-icon-wrap{background:var(--gold);transform:scale(1.05)}
        .card-arrow{position:absolute;top:28px;right:28px;color:var(--gold);font-size:16px;opacity:0.5;transition:all 0.25s}
        .card:hover .card-arrow{opacity:1;transform:translateX(3px)}
        .card-title{font-family:'Playfair Display',serif;font-size:17px;font-weight:700;color:#fff;margin-bottom:6px;transition:color 0.2s}
        .card:hover .card-title{color:var(--gold)}
        .card-desc{font-size:10.5px;color:rgba(255,255,255,0.3);text-transform:uppercase;letter-spacing:0.15em;font-weight:600}

        /* Special cards */
        .card-admin{border-color:rgba(201,168,76,0.18);background:rgba(201,168,76,0.04)}
        .card-admin .card-icon-wrap{background:var(--gold)}
        .card-admin .card-title{color:var(--gold)}
        .card-logout:hover{border-color:rgba(248,113,113,0.3);box-shadow:0 16px 40px rgba(0,0,0,0.3),0 0 0 1px rgba(248,113,113,0.08)}
        .card-logout .card-icon-wrap{background:rgba(248,113,113,0.08)}
        .card-logout:hover .card-icon-wrap{background:#f87171}
        .card-logout .card-arrow{color:#f87171}
        .card-logout:hover .card-title{color:#f87171}

        /* ── Footer ── */
        footer{border-top:1px solid rgba(255,255,255,0.05);padding:32px 48px;display:flex;justify-content:space-between;align-items:center;font-size:10px;color:rgba(255,255,255,0.15);text-transform:uppercase;letter-spacing:0.25em;font-weight:700}
        footer em{color:var(--gold);font-style:italic;font-family:'Playfair Display',serif}
    </style>
</head>
<body>

<nav class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/" class="brand">
        <div class="brand-icon">A</div>
        Azure <em>Resort</em>
    </a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="active">Tài Khoản</a></li>
        <c:if test="${isEmployee}">
            <li><a href="${dashboardUrl}" class="btn-dash">Dashboard</a></li>
        </c:if>
    </ul>
    <button class="hamburger" id="hamburgerBtn" onclick="document.getElementById('mobileNavAC').classList.toggle('open')" aria-label="Menu">☰</button>
    <div class="nav-right">
        <div class="nav-user-info">
            <span class="label">Logged in as</span>
            <span class="name">${currentUser.fullName}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout-nav" title="Đăng xuất">⎋</a>
    </div>
</nav>

<div class="mobile-nav" id="mobileNavAC">
    <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
    <a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a>
    <a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a>
    <a href="${pageContext.request.contextPath}/account.jsp" class="active">Tài Khoản</a>
    <c:if test="${isEmployee}"><a href="${dashboardUrl}">Dashboard</a></c:if>
    <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
</div>

<main>
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
        <span class="sep">/</span>
        <span class="current">Tài Khoản</span>
    </nav>

    <!-- Hero -->
    <div class="hero-banner">
        <div class="avatar">${fn:substring(currentUser.fullName, 0, 1)}</div>
        <div class="hero-info">
            <div class="hero-badge">${isEmployee ? 'Staff Member' : 'Elite Member'}</div>
            <div class="hero-name">${currentUser.fullName}</div>
            <div class="hero-meta">
                <span>✉️ ${not empty currentUser.email ? currentUser.email : 'Chưa cập nhật'}</span>
                <span>📱 ${not empty currentUser.phoneNumber ? currentUser.phoneNumber : 'Chưa cập nhật'}</span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/profile" class="btn-edit-profile">✏️ Chỉnh sửa hồ sơ</a>
    </div>

    <!-- Cards -->
    <div class="section-header"><span>Quản trị tài khoản</span></div>
    <div class="cards-grid">

        <a href="${pageContext.request.contextPath}/booking?view=my" class="card">
            <div class="card-icon-wrap">📋</div>
            <span class="card-arrow">→</span>
            <div class="card-title">Booking Của Tôi</div>
            <div class="card-desc">Lịch sử &amp; Trạng thái</div>
        </a>

        <a href="${pageContext.request.contextPath}/contracts" class="card">
            <div class="card-icon-wrap">📄</div>
            <span class="card-arrow">→</span>
            <div class="card-title">Hợp Đồng &amp; Thanh Toán</div>
            <div class="card-desc">Giao dịch &amp; Chứng từ</div>
        </a>

        <a href="${pageContext.request.contextPath}/profile" class="card">
            <div class="card-icon-wrap">👤</div>
            <span class="card-arrow">→</span>
            <div class="card-title">Hồ Sơ Cá Nhân</div>
            <div class="card-desc">Bảo mật &amp; Thông tin</div>
        </a>

        <a href="${pageContext.request.contextPath}/#promotions" class="card">
            <div class="card-icon-wrap">🎁</div>
            <span class="card-arrow">→</span>
            <div class="card-title">Ưu Đãi Đặc Quyền</div>
            <div class="card-desc">Voucher &amp; Rewards</div>
        </a>

        <a href="${pageContext.request.contextPath}/rooms" class="card">
            <div class="card-icon-wrap">🏖️</div>
            <span class="card-arrow">→</span>
            <div class="card-title">Đặt Phòng Mới</div>
            <div class="card-desc">Khám phá thiên đường</div>
        </a>

        <c:if test="${isEmployee}">
        <a href="${dashboardUrl}" class="card card-admin">
            <div class="card-icon-wrap">⌘</div>
            <span class="card-arrow">→</span>
            <div class="card-title">Bảng Điều Khiển</div>
            <div class="card-desc">Internal Access Only</div>
        </a>
        </c:if>

        <a href="${pageContext.request.contextPath}/logout" class="card card-logout">
            <div class="card-icon-wrap">🚪</div>
            <span class="card-arrow">→</span>
            <div class="card-title">Đăng Xuất</div>
            <div class="card-desc">Kết thúc phiên làm việc</div>
        </a>

    </div>
</main>

<footer>
    <span>© 2026 Azure Resort &amp; Spa</span>
    <span>Designed for <em>Excellence</em></span>
</footer>

<script>
    window.addEventListener('scroll', () => {
        const nav = document.getElementById('navbar');
        if (window.scrollY > 40) {
            nav.style.height = '58px';
            nav.style.background = 'rgba(10,10,15,0.97)';
        } else {
            nav.style.height = '70px';
            nav.style.background = 'rgba(10,10,15,0.88)';
        }
    });
</script>
</body>
</html>
