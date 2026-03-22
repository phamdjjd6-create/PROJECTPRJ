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
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        gold: '#c9a84c',
                        dark: '#0a0a0f',
                    }
                }
            }
        }
    </script>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --gold: #c9a84c; --gold-light: #e8cc82;
            --dark: #0a0a0f; --navy: #0d1526;
            --text: #e8e8e8; --text-muted: rgba(255,255,255,0.5);
        }
        @keyframes float { 0% { transform: translateY(0px); } 50% { transform: translateY(-15px); } 100% { transform: translateY(0px); } }
        .animate-float { animation: float 6s ease-in-out infinite; }
        .reveal { opacity: 0; transform: translateY(30px); transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1); }
        .reveal.active { opacity: 1; transform: translateY(0); }
        .delay-100 { transition-delay: 100ms; }
        .delay-200 { transition-delay: 200ms; }
        .delay-300 { transition-delay: 300ms; }

        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); overflow-x: hidden; }
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 60px; height: 80px; display: flex; align-items: center; justify-content: space-between; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); }
        .navbar.scrolled { height: 64px; background: rgba(10,10,15,0.8); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.2); box-shadow: 0 4px 30px rgba(0,0,0,0.5), 0 0 20px rgba(201,168,76,0.05); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 24px; font-weight: 700; color: #fff; text-decoration: none; transition: transform 0.3s; }
        .navbar.scrolled .nav-brand { transform: scale(0.9); }
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
        @keyframes fadeUp { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: translateY(0); } }

        .btn-primary { padding: 15px 40px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; border-radius: 50px; font-size: 14px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; cursor: pointer; transition: all 0.3s; box-shadow: 0 8px 28px rgba(201,168,76,0.3); }
        .btn-primary:hover { transform: translateY(-3px); box-shadow: 0 16px 40px rgba(201,168,76,0.4); }
        .btn-outline { padding: 14px 36px; background: transparent; border: 1.5px solid rgba(255,255,255,0.4); color: #fff; border-radius: 50px; font-size: 14px; font-weight: 500; text-decoration: none; transition: all 0.3s; }
        .btn-outline:hover { border-color: var(--gold); color: var(--gold); }

        @keyframes bounce { 0%,100% { transform: translateX(-50%) translateY(0); } 50% { transform: translateX(-50%) translateY(8px); } }

        section { padding: 96px 60px; }
        .section-inner { max-width: 1200px; margin: 0 auto; }
        .section-label { display: inline-block; color: var(--gold); font-size: 11px; letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 12px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: clamp(28px,4vw,44px); color: #fff; line-height: 1.2; margin-bottom: 16px; }
        .section-title em { color: var(--gold); font-style: italic; }
        .section-desc { color: var(--text-muted); font-size: 15px; line-height: 1.8; max-width: 560px; }
        .stats-bar {
            background: linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(201,168,76,0.04) 50%, rgba(0,0,0,0) 100%);
            border-top: 1px solid rgba(201,168,76,0.12);
            border-bottom: 1px solid rgba(201,168,76,0.12);
            padding: 52px 60px;
            position: relative;
            overflow: hidden;
        }
        .stats-bar::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse at 50% 50%, rgba(201,168,76,0.06) 0%, transparent 70%);
            pointer-events: none;
        }
        .stats-inner { max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-around; flex-wrap: wrap; gap: 32px; position: relative; z-index: 1; }
        .stat-item { text-align: center; position: relative; padding: 0 40px; }
        .stat-item:not(:last-child)::after {
            content: '';
            position: absolute;
            right: 0; top: 50%;
            transform: translateY(-50%);
            width: 1px; height: 40px;
            background: linear-gradient(180deg, transparent, rgba(201,168,76,0.25), transparent);
        }
        .stat-num {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            color: var(--gold);
            font-weight: 700;
            line-height: 1;
            letter-spacing: -1px;
            text-shadow: 0 0 40px rgba(201,168,76,0.3);
        }
        .stat-label {
            color: rgba(255,255,255,0.35);
            font-size: 10px;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            margin-top: 10px;
            font-weight: 600;
        }
        .features { background: var(--dark); position: relative; overflow: hidden; }
        .features::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse at 50% 100%, rgba(201,168,76,0.05) 0%, transparent 65%); pointer-events: none; }
        .features .section-inner { position: relative; z-index: 1; }
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
        .promotions { background: var(--dark); position: relative; overflow: hidden; }
        .promotions::before { content: ''; position: absolute; inset: 0; background-image: url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=1920&q=60'); background-size: cover; background-position: center; opacity: 0.07; z-index: 0; }
        .promotions::after { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse at 50% 0%, rgba(201,168,76,0.08) 0%, transparent 70%); z-index: 0; pointer-events: none; }
        .promotions .section-inner { position: relative; z-index: 1; }
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
        /* ── Hamburger ── */
        .hamburger { display: none; background: none; border: none; color: #fff; font-size: 24px; cursor: pointer; padding: 4px 8px; line-height: 1; }
        .mobile-nav { display: none; position: fixed; top: 80px; left: 0; right: 0; background: rgba(10,10,15,0.97); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.15); z-index: 999; padding: 16px 24px 20px; flex-direction: column; gap: 4px; }
        .mobile-nav.open { display: flex; }
        .mobile-nav a { color: rgba(255,255,255,0.75); text-decoration: none; font-size: 14px; font-weight: 500; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .mobile-nav a:last-child { border-bottom: none; }
        .mobile-nav a:hover { color: var(--gold); }

        @media (max-width: 1024px) {
            .stats-inner { gap: 20px; }
            .rooms-grid { grid-template-columns: repeat(2, 1fr); }
            .promo-grid { grid-template-columns: repeat(2, 1fr); }
            .features-grid { grid-template-columns: repeat(2, 1fr); }
            .footer-inner { grid-template-columns: 1fr 1fr; gap: 32px; }
        }
        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .nav-links { display: none; }
            .hamburger { display: block; }
            section { padding: 48px 20px; }
            .stats-bar { padding: 36px 20px; }
            .stats-inner { display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; justify-items: center; }
            .stat-item { padding: 0 16px; }
            .stat-item:not(:last-child)::after { display: none; }
            .stat-num { font-size: 36px; }
            .rooms-grid { grid-template-columns: 1fr; }
            .promo-grid { grid-template-columns: 1fr; }
            .features-grid { grid-template-columns: 1fr; }
            .footer-inner { grid-template-columns: 1fr; gap: 28px; }
            footer { padding: 40px 20px; }
            .footer-bottom { flex-direction: column; gap: 8px; text-align: center; }
            .nav-right { gap: 8px; }
            .nav-greeting { display: none; }
            .btn-nav-login, .btn-nav-register { padding: 7px 14px; font-size: 12px; }
        }
    </style>
</head>
<body>

<!-- MOBILE NAV -->
<div class="mobile-nav" id="mobileNav">
    <a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a>
    <a href="#promotions">Khuyến Mãi</a>
    <a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a>
    <a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a>
    <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
        <a href="${pageContext.request.contextPath}/dashboard/admin">Bảng điều khiển</a>
    </c:if>
    <c:choose>
        <c:when test="${not empty sessionScope.account}">
            <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
            <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký</a>
        </c:otherwise>
    </c:choose>
</div>

<!-- NAVBAR -->
<nav class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <button class="hamburger" id="hamburgerBtn" onclick="document.getElementById('mobileNav').classList.toggle('open')" aria-label="Menu">☰</button>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a></li>
        <li><a href="#promotions">Khuyến Mãi</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a></li>
        <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
            <li><a href="${pageContext.request.contextPath}/dashboard/admin" class="text-gold font-bold hover:text-white transition-colors">Bảng điều khiển</a></li>
        </c:if>
    </ul>
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <span class="nav-greeting">Xin chào, <strong>${sessionScope.account.fullName}</strong></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-nav-login">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn-nav-register">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- HERO -->
<section class="relative h-screen overflow-hidden flex items-center justify-center">
    <!-- Background Slider -->
    <div id="hero-slider" class="absolute inset-0 z-0">
        <div class="slide absolute inset-0 bg-cover bg-center transition-opacity duration-1000 opacity-100" 
             style="background-image: url('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1920&q=80')"></div>
        <div class="slide absolute inset-0 bg-cover bg-center transition-opacity duration-1000 opacity-0" 
             style="background-image: url('https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=1920&q=80')"></div>
        <div class="slide absolute inset-0 bg-cover bg-center transition-opacity duration-1000 opacity-0" 
             style="background-image: url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=1920&q=80')"></div>
    </div>
    
    <!-- Gradient Overlay -->
    <div class="absolute inset-0 z-10 bg-gradient-to-b from-black/40 via-black/60 to-[#0a0a0f]"></div>

    <div class="hero-content relative z-20 text-center max-w-4xl px-6 animate-float">
        <div class="hero-badge inline-flex items-center gap-2 bg-gold/10 border border-gold/30 px-5 py-2 rounded-full text-gold text-xs tracking-[0.2em] uppercase mb-8 backdrop-blur-sm animate-pulse">
            ✦ Luxury 5-Star Resort ✦
        </div>
        <h1 class="font-serif text-5xl md:text-7xl lg:text-8xl text-white font-bold leading-tight mb-6 animate-[fadeUp_1s_ease-out]">
            Thiên Đường Nghỉ Dưỡng<br><em class="text-gold italic">Giữa Biển Xanh</em>
        </h1>
        <p class="text-white/70 text-lg md:text-xl font-light leading-relaxed mb-10 max-w-2xl mx-auto animate-[fadeUp_1.2s_ease-out]">
            Trải nghiệm kỳ nghỉ đẳng cấp thế giới tại Azure Resort &amp; Spa —<br>nơi thiên nhiên hòa quyện cùng sự xa xỉ tuyệt đích.
        </p>
        <div class="hero-actions flex flex-wrap justify-center gap-4 animate-[fadeUp_1.4s_ease-out]">
            <a href="${pageContext.request.contextPath}/rooms" class="btn-primary hover:scale-105 transition-transform">Khám Phá Phòng</a>
            <a href="${pageContext.request.contextPath}/booking" class="btn-outline border-white/40 hover:border-gold hover:text-gold hover:bg-gold/5 transition-all">Đặt Phòng Ngay</a>
        </div>
    </div>
    
    <div class="hero-scroll absolute bottom-10 left-1/2 -translate-x-1/2 z-20 flex flex-col items-center gap-2 text-white/40 text-[10px] tracking-widest uppercase animate-bounce">
        <span>Cuộn xuống</span>
        <span class="text-lg">↓</span>
    </div>
</section>

<!-- STATS -->
<div class="stats-bar reveal">
    <div class="stats-inner">
        <div class="stat-item reveal delay-100">
            <div class="stat-num">50+</div>
            <div class="stat-label">Villa &amp; Phòng Sang Trọng</div>
        </div>
        <div class="stat-item reveal delay-200">
            <div class="stat-num">5★</div>
            <div class="stat-label">Xếp Hạng Resort</div>
        </div>
        <div class="stat-item reveal delay-300">
            <div class="stat-num">15K+</div>
            <div class="stat-label">Khách Hàng Hài Lòng</div>
        </div>
        <div class="stat-item reveal delay-400">
            <div class="stat-num">10+</div>
            <div class="stat-label">Năm Kinh Nghiệm</div>
        </div>
    </div>
</div>

<!-- PROMOTIONS -->
<section class="promotions reveal" id="promotions">
    <div class="section-inner">
        <span class="section-label">Ưu Đãi Đặc Biệt</span>
        <h2 class="section-title"><em>Khuyến Mãi</em> Hấp Dẫn</h2>
        <p class="section-desc">Tiết kiệm hơn với những ưu đãi độc quyền dành cho khách hàng thân thiết.</p>
        <div class="promo-grid">
            <div class="promo-card reveal delay-100 hover:border-gold/50 transition-all duration-500">
                <div class="promo-discount">20%</div>
                <div class="promo-title">Đặt Sớm 30 Ngày</div>
                <div class="promo-desc">Đặt phòng trước 30 ngày để nhận ưu đãi giảm 20% cho tất cả các loại phòng và villa.</div>
                <div class="promo-code"><span>EARLYBIRD20</span><button onclick="copyCode('EARLYBIRD20',this)">Sao chép</button></div>
                <div class="promo-expiry">Hết hạn: 31/05/2026</div>
            </div>
            <div class="promo-card reveal delay-200 hover:border-gold/50 transition-all duration-500">
                <div class="promo-discount">15%</div>
                <div class="promo-title">Gói Cuối Tuần</div>
                <div class="promo-desc">Đặt phòng vào thứ 6, thứ 7 nhận ngay ưu đãi 15% kèm bữa ăn sáng miễn phí cho 2 người.</div>
                <div class="promo-code"><span>WEEKEND15</span><button onclick="copyCode('WEEKEND15',this)">Sao chép</button></div>
                <div class="promo-expiry">Hết hạn: 30/06/2026</div>
            </div>
            <div class="promo-card reveal delay-300 hover:border-gold/50 transition-all duration-500">
                <div class="promo-discount">30%</div>
                <div class="promo-title">Khách Hàng VIP</div>
                <div class="promo-desc">Danh hiệu Diamond/Gold được hưởng ưu đãi 30% cho lần đặt phòng tiếp theo.</div>
                <div class="promo-code"><span>VIP2026</span><button onclick="copyCode('VIP2026',this)">Sao chép</button></div>
                <div class="promo-expiry">Hết hạn: 31/12/2026</div>
            </div>
        </div>
    </div>
</section>

<!-- FEATURES -->
<section class="features reveal">
    <div class="section-inner">
        <span class="section-label">Dịch Vụ Của Chúng Tôi</span>
        <h2 class="section-title">Mọi Thứ Bạn <em>Cần</em></h2>
        <p class="section-desc">Từ đặt phòng đến quản lý hợp đồng, tất cả trong một nơi.</p>
        <div class="features-grid">
            <a href="${pageContext.request.contextPath}/rooms" class="feature-card reveal delay-100 group">
                <div class="flex flex-col items-center">
                    <h3 class="group-hover:text-gold transition-colors">Đặt Phòng</h3>
                    <p>Chọn villa hoặc phòng yêu thích và đặt ngay trong vài bước đơn giản.</p>
                    <span class="feature-arrow group-hover:translate-x-2 transition-transform">Đặt ngay →</span>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/booking?view=my" class="feature-card reveal delay-200 group">
                <div class="flex flex-col items-center">
                    <h3 class="group-hover:text-gold transition-colors">Booking Của Tôi</h3>
                    <p>Xem lịch sử đặt phòng, trạng thái và chi tiết các booking của bạn.</p>
                    <span class="feature-arrow group-hover:translate-x-2 transition-transform">Xem ngay →</span>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/contracts" class="feature-card reveal delay-300 group">
                <div class="flex flex-col items-center">
                    <h3 class="group-hover:text-gold transition-colors">Hợp Đồng</h3>
                    <p>Tra cứu và quản lý hợp đồng, theo dõi tình trạng thanh toán.</p>
                    <span class="feature-arrow group-hover:translate-x-2 transition-transform">Xem ngay →</span>
                </div>
            </a>
            <a href="#promotions" class="feature-card reveal delay-400 group">
                <div class="flex flex-col items-center">
                    <h3 class="group-hover:text-gold transition-colors">Khuyến Mãi</h3>
                    <p>Khám phá ưu đãi đặc biệt và mã giảm giá dành riêng cho bạn.</p>
                    <span class="feature-arrow group-hover:translate-x-2 transition-transform">Xem ưu đãi →</span>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer>
    <div class="footer-inner">
        <div class="footer-brand">
            <div class="logo">Azure <span>Resort</span> &amp; Spa</div>
            <p>Thiên đường nghỉ dưỡng 5 sao với vẻ đẹp thiên nhiên kỳ thú và dịch vụ đẳng cấp thế giới.</p>
        </div>
        <div class="footer-col">
            <h4>Khám Phá</h4>
            <a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a>
            <a href="#promotions">Khuyến Mãi</a>
            <a href="${pageContext.request.contextPath}/booking">Đặt Phòng</a>
        </div>
        <div class="footer-col">
            <h4>Tài Khoản</h4>
            <a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a>
            <a href="${pageContext.request.contextPath}/profile">Hồ Sơ</a>
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

<!-- CHATBOT WIDGET -->
<style>
    #chat-bubble{position:fixed;bottom:28px;right:28px;z-index:9999;width:56px;height:56px;border-radius:50%;background:linear-gradient(135deg,#c9a84c,#e8cc82);border:none;cursor:pointer;box-shadow:0 8px 28px rgba(201,168,76,0.5);display:flex;align-items:center;justify-content:center;font-size:24px;transition:all 0.3s cubic-bezier(.34,1.56,.64,1)}
    #chat-bubble:hover{transform:scale(1.12);box-shadow:0 12px 36px rgba(201,168,76,0.65)}
    #chat-unread{position:absolute;top:-3px;right:-3px;min-width:18px;height:18px;background:#f87171;border-radius:9px;font-size:10px;font-weight:700;color:#fff;display:none;align-items:center;justify-content:center;padding:0 4px;border:2px solid #0a0a0f}
    @keyframes pulse-ring{0%{transform:scale(1);opacity:0.6}100%{transform:scale(1.5);opacity:0}}
    #chat-bubble::after{content:'';position:absolute;inset:0;border-radius:50%;background:rgba(201,168,76,0.4);animation:pulse-ring 2s ease-out infinite}
    #chat-bubble.open::after{display:none}
    #chat-box{position:fixed;bottom:96px;right:28px;z-index:9998;width:380px;background:#0d1117;border:1px solid rgba(201,168,76,0.18);border-radius:24px;box-shadow:0 24px 64px rgba(0,0,0,0.7),0 0 0 1px rgba(255,255,255,0.03);display:none;flex-direction:column;overflow:hidden;font-family:'Inter',sans-serif}
    #chat-box.open{display:flex}
    .ch{background:linear-gradient(135deg,#0d1526 0%,#080c14 100%);padding:16px 18px;display:flex;align-items:center;gap:12px;border-bottom:1px solid rgba(201,168,76,0.1);flex-shrink:0}
    .ch-av{width:40px;height:40px;border-radius:12px;background:linear-gradient(135deg,#c9a84c,#e8cc82);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0;box-shadow:0 4px 12px rgba(201,168,76,0.3)}
    .ch-info .ch-name{font-size:14px;font-weight:700;color:#fff}
    .ch-info .ch-sub{font-size:11px;color:rgba(255,255,255,0.4);margin-top:1px}
    .ch-status{display:inline-flex;align-items:center;gap:4px;font-size:10.5px;color:#4ade80;font-weight:600}
    .ch-status::before{content:'';width:6px;height:6px;border-radius:50%;background:#4ade80;display:inline-block;animation:blink 2s ease-in-out infinite}
    @keyframes blink{0%,100%{opacity:1}50%{opacity:0.4}}
    .ch-actions{margin-left:auto;display:flex;gap:4px}
    .ch-btn{background:none;border:none;color:rgba(255,255,255,0.35);font-size:16px;cursor:pointer;padding:6px;border-radius:8px;transition:all 0.15s;line-height:1}
    .ch-btn:hover{background:rgba(255,255,255,0.07);color:rgba(255,255,255,0.8)}
    #chat-msgs{flex:1;overflow-y:auto;padding:16px;display:flex;flex-direction:column;gap:12px;min-height:240px;max-height:360px;scroll-behavior:smooth}
    #chat-msgs::-webkit-scrollbar{width:3px}
    #chat-msgs::-webkit-scrollbar-thumb{background:rgba(201,168,76,0.15);border-radius:4px}
    .msg-row{display:flex;gap:8px;align-items:flex-end}
    .msg-row.user{flex-direction:row-reverse}
    .msg-av{width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#c9a84c,#e8cc82);display:flex;align-items:center;justify-content:center;font-size:13px;flex-shrink:0}
    .msg-av.user-av{background:rgba(201,168,76,0.15);border:1px solid rgba(201,168,76,0.3);font-size:11px;color:#c9a84c;font-weight:700}
    .msg-wrap{display:flex;flex-direction:column;gap:3px;max-width:78%}
    .msg-row.user .msg-wrap{align-items:flex-end}
    .msg-bubble{padding:10px 14px;border-radius:16px;font-size:13px;line-height:1.6;word-break:break-word}
    .msg-bubble.bot{background:rgba(255,255,255,0.06);color:#e8e8e8;border-bottom-left-radius:4px;border:1px solid rgba(255,255,255,0.05)}
    .msg-bubble.user{background:linear-gradient(135deg,rgba(201,168,76,0.28),rgba(201,168,76,0.18));color:#fff;border-bottom-right-radius:4px;border:1px solid rgba(201,168,76,0.25)}
    .msg-time{font-size:9.5px;color:rgba(255,255,255,0.2);padding:0 2px}
    .msg-bubble strong{color:#e8cc82;font-weight:700}
    .msg-bubble em{color:rgba(255,255,255,0.7);font-style:italic}
    .msg-bubble ul{padding-left:16px;margin:4px 0}
    .msg-bubble li{margin:2px 0}
    .typing-dots{display:flex;gap:4px;padding:12px 14px;align-items:center}
    .typing-dots span{width:7px;height:7px;border-radius:50%;background:rgba(255,255,255,0.3);animation:dot-bounce 1.2s ease-in-out infinite}
    .typing-dots span:nth-child(2){animation-delay:0.2s}
    .typing-dots span:nth-child(3){animation-delay:0.4s}
    @keyframes dot-bounce{0%,80%,100%{transform:translateY(0)}40%{transform:translateY(-6px)}}
    .msg-actions{display:flex;flex-wrap:wrap;gap:6px;margin-top:4px}
    .act-btn{padding:6px 13px;border-radius:50px;font-size:11.5px;font-weight:600;border:1px solid rgba(201,168,76,0.3);color:#c9a84c;background:rgba(201,168,76,0.07);cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.2s;text-decoration:none;display:inline-block}
    .act-btn:hover{background:rgba(201,168,76,0.18);border-color:rgba(201,168,76,0.6);color:#e8cc82}
    #chat-chips{padding:0 14px 10px;display:flex;gap:6px;flex-wrap:wrap;flex-shrink:0}
    .chip{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.1);color:rgba(255,255,255,0.6);border-radius:50px;padding:6px 13px;font-size:11.5px;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.2s;white-space:nowrap}
    .chip:hover{background:rgba(201,168,76,0.1);border-color:rgba(201,168,76,0.35);color:#c9a84c}
    .cf{padding:12px 14px;border-top:1px solid rgba(255,255,255,0.05);display:flex;gap:8px;align-items:flex-end;flex-shrink:0;background:rgba(0,0,0,0.2)}
    #chat-input{flex:1;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:10px 14px;color:#fff;font-size:13px;font-family:'Inter',sans-serif;outline:none;resize:none;max-height:100px;transition:border-color 0.2s;line-height:1.5}
    #chat-input:focus{border-color:rgba(201,168,76,0.4);background:rgba(255,255,255,0.07)}
    #chat-input::placeholder{color:rgba(255,255,255,0.25)}
    #chat-send{width:38px;height:38px;border-radius:12px;background:linear-gradient(135deg,#c9a84c,#e8cc82);border:none;cursor:pointer;display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:all 0.2s;color:#0a0a0f}
    #chat-send:hover{transform:scale(1.08);box-shadow:0 4px 12px rgba(201,168,76,0.4)}
    #chat-send:disabled{opacity:0.35;cursor:not-allowed;transform:none;box-shadow:none}
    .cf-hint{font-size:9.5px;color:rgba(255,255,255,0.15);text-align:center;padding:0 14px 8px;flex-shrink:0}
</style>

<button id="chat-bubble" onclick="chatToggle()" title="Chat với Azure Assistant" aria-label="Mở chat">
    <span id="chat-icon">💬</span>
    <span id="chat-unread"></span>
</button>

<div id="chat-box" role="dialog" aria-label="Azure Assistant Chat">
    <div class="ch">
        <div class="ch-av">🏖️</div>
        <div class="ch-info">
            <div class="ch-name">Azure Assistant</div>
            <div class="ch-sub"><span class="ch-status">Trực tuyến</span> · Azure Resort & Spa</div>
        </div>
        <div class="ch-actions">
            <button class="ch-btn" onclick="chatClear()" title="Xóa lịch sử">🗑</button>
            <button class="ch-btn" onclick="chatToggle()" title="Đóng">✕</button>
        </div>
    </div>
    <div id="chat-msgs" aria-live="polite"></div>
    <div id="chat-chips">
        <button class="chip" onclick="chipSend(this)">👋 Xin chào</button>
        <button class="chip" onclick="chipSend(this)">🌤️ Thời tiết Đà Nẵng</button>
        <button class="chip" onclick="chipSend(this)">🏡 Phòng còn trống</button>
        <button class="chip" onclick="chipSend(this)">💰 Bảng giá villa</button>
        <button class="chip" onclick="chipSend(this)">📋 Chính sách hủy</button>
        <button class="chip" onclick="chipSend(this)">🎁 Ưu đãi hiện có</button>
    </div>
    <div class="cf">
        <textarea id="chat-input" rows="1" placeholder="Nhập tin nhắn..." onkeydown="chatKey(event)" oninput="chatResize(this)"></textarea>
        <button id="chat-send" onclick="chatSend()" aria-label="Gửi">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
        </button>
    </div>
    <div class="cf-hint">Azure AI · Powered by Groq · Dữ liệu thực từ hệ thống</div>
</div>

<script>
(function(){
    const CTX = '${pageContext.request.contextPath}';
    const UNAME = '<c:out value="${sessionScope.account.fullName}" default=""/>';
    let isOpen = false, unread = 0;

    function init() {
        const greet = UNAME
            ? 'Xin ch\u00e0o <strong>' + esc(UNAME) + '</strong>! \uD83D\uDC4B T\u00f4i l\u00e0 <strong>Azure</strong>, tr\u1ee3 l\u00fd c\u1ee7a Azure Resort & Spa.<br>T\u00f4i c\u00f3 th\u1ec3 gi\u00fap b\u1ea1n t\u01b0 v\u1ea5n ph\u00f2ng, th\u1eddi ti\u1ebft, gi\u00e1 c\u1ea3 v\u00e0 \u0111\u1eb7t ph\u00f2ng. B\u1ea1n c\u1ea7n h\u1ed7 tr\u1ee3 g\u00ec?'
            : 'Xin ch\u00e0o! \uD83D\uDC4B T\u00f4i l\u00e0 <strong>Azure</strong>, tr\u1ee3 l\u00fd \u1ea3o c\u1ee7a <strong>Azure Resort & Spa</strong>.<br>T\u00f4i c\u00f3 th\u1ec3 t\u01b0 v\u1ea5n v\u1ec1 ph\u00f2ng/villa, th\u1eddi ti\u1ebft \u0110\u00e0 N\u1eb5ng, gi\u00e1 c\u1ea3 v\u00e0 h\u1ed7 tr\u1ee3 \u0111\u1eb7t ph\u00f2ng. B\u1ea1n c\u1ea7n h\u1ed7 tr\u1ee3 g\u00ec?';
        botMsg(greet);
        setTimeout(function(){ if (!isOpen) showBadge(1); }, 3500);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    window.chatToggle = function() {
        isOpen = !isOpen;
        document.getElementById('chat-box').classList.toggle('open', isOpen);
        document.getElementById('chat-icon').textContent = isOpen ? '\u2715' : '\uD83D\uDCAC';
        document.getElementById('chat-bubble').classList.toggle('open', isOpen);
        if (isOpen) { clearBadge(); setTimeout(function(){ document.getElementById('chat-input').focus(); }, 150); scrollBot(); }
    };

    window.chatClear = function() {
        document.getElementById('chat-msgs').innerHTML = '';
        document.getElementById('chat-chips').style.display = 'flex';
        botMsg('L\u1ecbch s\u1eed \u0111\u00e3 x\u00f3a. T\u00f4i c\u00f3 th\u1ec3 gi\u00fap g\u00ec cho b\u1ea1n? \uD83D\uDE0A');
    };

    window.chipSend = function(btn) {
        var t = btn.textContent.replace(/^\S+\s/, '').trim();
        document.getElementById('chat-input').value = t;
        document.getElementById('chat-chips').style.display = 'none';
        chatSend();
    };

    window.chatKey = function(e) { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); chatSend(); } };
    window.chatResize = function(el) { el.style.height = 'auto'; el.style.height = Math.min(el.scrollHeight, 100) + 'px'; };

    window.chatSend = async function() {
        var inp = document.getElementById('chat-input');
        var msg = inp.value.trim();
        if (!msg) return;
        userMsg(msg);
        inp.value = ''; inp.style.height = 'auto';
        document.getElementById('chat-send').disabled = true;
        var typing = typingMsg();
        try {
            var fd = new FormData(); fd.append('message', msg);
            var res = await fetch(CTX + '/chatbot', { method: 'POST', body: fd });
            var data = await res.json();
            typing.remove();
            botMsg(fmt(data.reply || 'Xin l\u1ed7i, c\u00f3 l\u1ed7i x\u1ea3y ra.'), data.actions || []);
        } catch(err) {
            typing.remove();
            botMsg('Kh\u00f4ng th\u1ec3 k\u1ebft n\u1ed1i. Vui l\u00f2ng th\u1eed l\u1ea1i ho\u1eb7c g\u1ecdi <strong>1800 7777</strong>.', [{label:'\uD83D\uDCDE G\u1ecdi ngay',url:'tel:18007777'}]);
        } finally {
            document.getElementById('chat-send').disabled = false;
            inp.focus();
        }
    };

    function userMsg(text) {
        var init = UNAME ? UNAME.charAt(0).toUpperCase() : '?';
        addRow('msg-row user',
            '<div class="msg-wrap">' +
            '<div class="msg-bubble user">' + esc(text) + '</div>' +
            '<div class="msg-time">' + now() + '</div>' +
            '</div>' +
            '<div class="msg-av user-av">' + init + '</div>');
    }

    function botMsg(html, actions) {
        actions = actions || [];
        var acts = '';
        if (actions.length) {
            acts = '<div class="msg-actions">' +
                actions.map(function(a){ return '<a class="act-btn" href="' + CTX + a.url + '">' + esc(a.label) + '</a>'; }).join('') +
                '</div>';
        }
        addRow('msg-row',
            '<div class="msg-av">\uD83C\uDFD6\uFE0F</div>' +
            '<div class="msg-wrap">' +
            '<div class="msg-bubble bot">' + html + '</div>' +
            acts +
            '<div class="msg-time">Azure \u00b7 ' + now() + '</div>' +
            '</div>');
        if (!isOpen) showBadge(++unread);
    }

    function typingMsg() {
        return addRow('msg-row',
            '<div class="msg-av">\uD83C\uDFD6\uFE0F</div>' +
            '<div class="msg-wrap"><div class="msg-bubble bot" style="padding:0">' +
            '<div class="typing-dots"><span></span><span></span><span></span></div>' +
            '</div></div>');
    }

    function addRow(cls, html) {
        var msgs = document.getElementById('chat-msgs');
        var el = document.createElement('div');
        el.className = cls; el.innerHTML = html;
        msgs.appendChild(el); scrollBot(); return el;
    }

    function fmt(t) {
        return t.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
            .replace(/\*\*(.+?)\*\*/g,'<strong>$1</strong>')
            .replace(/\*(.+?)\*/g,'<em>$1</em>')
            .replace(/^[-\u2022]\s(.+)/gm,'<li>$1</li>')
            .replace(/\n/g,'<br>');
    }
    function esc(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
    function now() { return new Date().toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit'}); }
    function scrollBot() { var m = document.getElementById('chat-msgs'); setTimeout(function(){ m.scrollTop = m.scrollHeight; }, 50); }
    function showBadge(n) { var b = document.getElementById('chat-unread'); b.textContent = n > 9 ? '9+' : n; b.style.display = 'flex'; }
    function clearBadge() { unread = 0; document.getElementById('chat-unread').style.display = 'none'; }
})();
</script>

<script>
    window.addEventListener('scroll', () => {
        document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 60);
    });

    // Background Slider Script
    const slides = document.querySelectorAll('.slide');
    let currentSlide = 0;
    function nextSlide() {
        slides[currentSlide].classList.replace('opacity-100', 'opacity-0');
        currentSlide = (currentSlide + 1) % slides.length;
        slides[currentSlide].classList.replace('opacity-0', 'opacity-100');
    }
    setInterval(nextSlide, 5000);

    // Scroll Reveal Observer
    const observerOptions = { threshold: 0.15 };
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
            }
        });
    }, observerOptions);

    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

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
