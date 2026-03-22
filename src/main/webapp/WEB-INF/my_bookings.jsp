<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Của Tôi — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        :root{--gold:#c9a84c;--gold-light:#e8cc82;--dark:#0a0a0f;--navy:#0d1526;--card:rgba(255,255,255,0.03);--border:rgba(255,255,255,0.07);--text:#e8e8e8;--muted:rgba(255,255,255,0.35)}
        body{background:var(--dark);color:var(--text);font-family:'Inter',sans-serif;min-height:100vh}
        /* Navbar */
        .navbar{position:fixed;top:0;left:0;right:0;z-index:1000;padding:0 48px;height:72px;display:flex;align-items:center;justify-content:space-between;background:rgba(10,10,15,0.92);backdrop-filter:blur(20px);border-bottom:1px solid rgba(201,168,76,0.1)}
        .nav-brand{font-family:'Playfair Display',serif;font-size:22px;font-weight:700;color:#fff;text-decoration:none}
        .nav-brand span{color:var(--gold)}
        .nav-links{display:flex;align-items:center;gap:28px;list-style:none}
        .nav-links a{color:rgba(255,255,255,0.5);text-decoration:none;font-size:13px;font-weight:500;transition:color 0.2s}
        .nav-links a:hover,.nav-links a.active{color:var(--gold)}
        .nav-right{display:flex;align-items:center;gap:14px}
        .nav-user{font-size:13px;color:rgba(255,255,255,0.4)}
        .nav-user strong{color:var(--gold)}
        .btn-nav-out{padding:7px 18px;border:1px solid rgba(201,168,76,0.3);border-radius:50px;color:var(--gold);font-size:12px;font-weight:600;text-decoration:none;transition:all 0.2s}
        .btn-nav-out:hover{background:var(--gold);color:var(--dark)}
        .hamburger{display:none;background:none;border:none;color:#fff;font-size:22px;cursor:pointer;padding:4px 8px;line-height:1}
        .mobile-nav{display:none;position:fixed;top:72px;left:0;right:0;background:rgba(10,10,15,0.97);backdrop-filter:blur(20px);border-bottom:1px solid rgba(201,168,76,0.15);z-index:999;padding:12px 20px 16px;flex-direction:column;gap:2px}
        .mobile-nav.open{display:flex}
        .mobile-nav a{color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;font-weight:500;padding:10px 0;border-bottom:1px solid rgba(255,255,255,0.05)}
        .mobile-nav a:last-child{border-bottom:none}
        .mobile-nav a:hover,.mobile-nav a.active{color:var(--gold)}
        /* Layout */
        .page-wrap{max-width:1100px;margin:0 auto;padding:100px 24px 80px}
        .breadcrumb{display:flex;align-items:center;gap:8px;font-size:11px;text-transform:uppercase;letter-spacing:0.15em;color:rgba(255,255,255,0.25);margin-bottom:32px}
        .breadcrumb a{color:rgba(255,255,255,0.25);text-decoration:none;transition:color 0.2s}
        .breadcrumb a:hover{color:var(--gold)}
        .breadcrumb .cur{color:var(--gold)}
        /* Header */
        .page-header{display:flex;align-items:flex-end;justify-content:space-between;gap:20px;margin-bottom:32px;flex-wrap:wrap}
        .page-title{font-family:'Playfair Display',serif;font-size:42px;font-weight:700;color:#fff;line-height:1.1}
        .page-title em{color:var(--gold);font-style:italic}
        .page-sub{color:rgba(255,255,255,0.3);font-size:13px;margin-top:6px}
        .btn-new{display:inline-flex;align-items:center;gap:8px;padding:11px 22px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.1);border-radius:12px;color:rgba(255,255,255,0.6);font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;text-decoration:none;transition:all 0.2s;white-space:nowrap}
        .btn-new:hover{background:var(--gold);border-color:var(--gold);color:var(--dark)}
        /* Filter tabs */
        .filter-bar{display:flex;align-items:center;gap:8px;margin-bottom:24px;flex-wrap:wrap}
        .ftab{padding:6px 16px;border-radius:50px;font-size:12px;font-weight:600;border:1.5px solid rgba(255,255,255,0.08);color:rgba(255,255,255,0.4);background:transparent;cursor:pointer;transition:all 0.2s;text-decoration:none}
        .ftab:hover{border-color:rgba(201,168,76,0.4);color:var(--gold)}
        .ftab.active{background:var(--gold);color:var(--dark);border-color:var(--gold)}
        /* Stats */
        .stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:28px}
        .stat-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:16px 20px}
        .stat-num{font-family:'Playfair Display',serif;font-size:28px;font-weight:700;color:var(--gold);line-height:1}
        .stat-lbl{font-size:10px;color:rgba(255,255,255,0.28);text-transform:uppercase;letter-spacing:0.12em;margin-top:4px}
        /* Booking Cards */
        .booking-list{display:flex;flex-direction:column;gap:14px}
        .booking-card{background:var(--card);border:1px solid var(--border);border-radius:20px;overflow:hidden;transition:border-color 0.2s}
        .booking-card:hover{border-color:rgba(201,168,76,0.18)}
        .card-main{display:grid;grid-template-columns:5px 1fr auto auto auto;align-items:stretch}
        .card-accent{align-self:stretch}
        .accent-pending{background:linear-gradient(180deg,#f59e0b,#d97706)}
        .accent-confirmed{background:linear-gradient(180deg,#10b981,#059669)}
        .accent-cancelled{background:linear-gradient(180deg,#f87171,#ef4444)}
        .accent-checkin{background:linear-gradient(180deg,#60a5fa,#3b82f6)}
        .accent-checkout{background:linear-gradient(180deg,rgba(255,255,255,0.15),rgba(255,255,255,0.05))}
        .accent-completed{background:linear-gradient(180deg,var(--gold),var(--gold-light))}
        .card-info{padding:18px 22px;display:flex;flex-direction:column;gap:5px}
        .card-id{font-family:'Courier New',monospace;font-size:11px;color:var(--gold);font-weight:700}
        .card-facility{font-size:15px;font-weight:600;color:#fff}
        .card-type{font-size:10px;color:rgba(201,168,76,0.55);text-transform:uppercase;letter-spacing:0.2em;font-weight:700}
        .card-meta{font-size:11px;color:rgba(255,255,255,0.3);margin-top:3px}
        .card-dates{padding:18px 22px;display:flex;flex-direction:column;gap:4px;border-left:1px solid rgba(255,255,255,0.05)}
        .dates-label{font-size:10px;color:rgba(255,255,255,0.25);text-transform:uppercase;letter-spacing:0.15em}
        .dates-val{font-size:13px;color:rgba(255,255,255,0.75);font-weight:500}
        .dates-nights{font-size:10px;color:rgba(201,168,76,0.5);margin-top:2px}
        .card-finance{padding:18px 22px;display:flex;flex-direction:column;gap:4px;border-left:1px solid rgba(255,255,255,0.05);min-width:170px}
        .finance-label{font-size:10px;color:rgba(255,255,255,0.25);text-transform:uppercase;letter-spacing:0.15em}
        .finance-total{font-family:'Playfair Display',serif;font-size:17px;font-weight:700;color:var(--gold)}
        .finance-row{display:flex;justify-content:space-between;font-size:11px;color:rgba(255,255,255,0.35);margin-top:2px}
        .finance-row .paid{color:#10b981}
        .finance-row .remain{color:#f59e0b}
        .finance-bar{height:3px;background:rgba(255,255,255,0.06);border-radius:2px;margin-top:6px;overflow:hidden}
        .finance-bar-fill{height:100%;background:linear-gradient(90deg,#10b981,#34d399);border-radius:2px;transition:width 0.6s}
        .finance-no-contract{font-size:11px;color:rgba(255,255,255,0.18);font-style:italic}
        .card-actions{padding:18px 22px;display:flex;flex-direction:column;align-items:flex-end;justify-content:center;gap:8px;border-left:1px solid rgba(255,255,255,0.05)}
        /* Badges */
        .badge{display:inline-flex;align-items:center;gap:4px;padding:4px 11px;border-radius:50px;font-size:10px;font-weight:700;border:1px solid;text-transform:uppercase;letter-spacing:0.08em;white-space:nowrap}
        .badge::before{content:'';width:5px;height:5px;border-radius:50%;background:currentColor;flex-shrink:0}
        .badge-pending{color:#f59e0b;background:rgba(245,158,11,0.08);border-color:rgba(245,158,11,0.2)}
        .badge-confirmed{color:#10b981;background:rgba(16,185,129,0.08);border-color:rgba(16,185,129,0.2)}
        .badge-cancelled{color:#f87171;background:rgba(248,113,113,0.08);border-color:rgba(248,113,113,0.2)}
        .badge-checkin{color:#60a5fa;background:rgba(96,165,250,0.08);border-color:rgba(96,165,250,0.2)}
        .badge-checkout{color:rgba(255,255,255,0.3);background:rgba(255,255,255,0.03);border-color:rgba(255,255,255,0.08)}
        .badge-completed{color:var(--gold);background:rgba(201,168,76,0.08);border-color:rgba(201,168,76,0.2)}
        .badge-contract-active{color:#10b981;background:rgba(16,185,129,0.06);border-color:rgba(16,185,129,0.15)}
        .badge-contract-draft{color:rgba(255,255,255,0.3);background:rgba(255,255,255,0.03);border-color:rgba(255,255,255,0.08)}
        /* Action buttons */
        .btn-detail{font-size:11px;font-weight:600;color:rgba(201,168,76,0.7);background:rgba(201,168,76,0.06);border:1px solid rgba(201,168,76,0.2);border-radius:8px;cursor:pointer;padding:5px 12px;transition:all 0.2s;text-decoration:none;display:inline-block}
        .btn-detail:hover{color:var(--gold);background:rgba(201,168,76,0.12);border-color:rgba(201,168,76,0.4)}
        .btn-cancel{font-size:11px;font-weight:600;color:rgba(248,113,113,0.5);background:none;border:1px solid rgba(248,113,113,0.15);border-radius:8px;cursor:pointer;padding:5px 12px;transition:all 0.2s}
        .btn-cancel:hover{color:#f87171;background:rgba(248,113,113,0.08);border-color:rgba(248,113,113,0.3)}
        /* Empty */
        .empty-state{padding:80px 24px;display:flex;flex-direction:column;align-items:center;text-align:center;gap:16px;background:var(--card);border:1px solid var(--border);border-radius:24px}
        .empty-icon{font-size:48px;opacity:0.12}
        .empty-title{font-family:'Playfair Display',serif;font-size:22px;font-weight:700;color:#fff}
        .empty-sub{font-size:13px;color:rgba(255,255,255,0.28);max-width:260px;line-height:1.7}
        .btn-explore{padding:11px 28px;background:var(--gold);color:var(--dark);border-radius:50px;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;text-decoration:none;transition:all 0.2s}
        .btn-explore:hover{background:var(--gold-light)}
        /* Detail Modal */
        .modal-overlay{display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.75);z-index:2000;backdrop-filter:blur(6px);justify-content:center;align-items:center}
        .modal-overlay.open{display:flex}
        .modal-box{background:#0d1526;border:1px solid rgba(201,168,76,0.18);border-radius:24px;padding:36px;width:90%;max-width:520px;position:relative;max-height:90vh;overflow-y:auto}
        .modal-close{position:absolute;top:16px;right:20px;color:rgba(255,255,255,0.3);font-size:24px;cursor:pointer;border:none;background:none;transition:color 0.2s}
        .modal-close:hover{color:#fff}
        .modal-label{font-size:9px;color:var(--gold);letter-spacing:2.5px;text-transform:uppercase;font-weight:700;margin-bottom:4px}
        .modal-title{font-family:'Playfair Display',serif;font-size:22px;color:#fff;margin-bottom:24px}
        .detail-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid rgba(255,255,255,0.05);font-size:13px}
        .detail-row:last-child{border-bottom:none}
        .detail-row .key{color:rgba(255,255,255,0.35);font-size:11px;text-transform:uppercase;letter-spacing:0.1em}
        .detail-row .val{color:#fff;font-weight:500;text-align:right}
        .timeline{margin-top:20px}
        .tl-step{display:flex;gap:14px;align-items:flex-start;padding:10px 0;position:relative}
        .tl-step:not(:last-child)::after{content:'';position:absolute;left:11px;top:28px;bottom:-10px;width:1px;background:rgba(255,255,255,0.08)}
        .tl-dot{width:22px;height:22px;border-radius:50%;border:2px solid rgba(255,255,255,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;margin-top:2px}
        .tl-dot.done{border-color:var(--gold);background:rgba(201,168,76,0.15)}
        .tl-dot.done::after{content:'';width:8px;height:8px;border-radius:50%;background:var(--gold)}
        .tl-dot.active{border-color:#60a5fa;background:rgba(96,165,250,0.15)}
        .tl-dot.active::after{content:'';width:8px;height:8px;border-radius:50%;background:#60a5fa}
        .tl-text{font-size:12px;color:rgba(255,255,255,0.5)}
        .tl-text strong{color:#fff;display:block;font-size:13px;margin-bottom:2px}
        /* Toast */
        .toast{position:fixed;top:84px;right:20px;z-index:3000;padding:14px 20px;border-radius:14px;background:rgba(13,21,38,0.97);border:1px solid rgba(255,255,255,0.08);backdrop-filter:blur(20px);display:flex;align-items:center;gap:12px;box-shadow:0 12px 40px rgba(0,0,0,0.5)}
        .toast-msg{font-size:13px;color:#fff;font-weight:500}
        footer{background:#060608;border-top:1px solid rgba(255,255,255,0.05);padding:28px 48px}
        .footer-inner{max-width:1100px;margin:0 auto;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
        .footer-brand{font-family:'Playfair Display',serif;font-size:16px;color:#fff}
        .footer-brand span{color:var(--gold)}
        .footer-copy{font-size:11px;color:rgba(255,255,255,0.18)}
        @media(max-width:1024px){
            .stats-row{grid-template-columns:repeat(2,1fr)}
            .card-main{grid-template-columns:5px 1fr 1fr}
            .card-actions{border-left:none;border-top:1px solid rgba(255,255,255,0.05)}
        }
        @media(max-width:768px){
            .navbar{padding:0 16px}
            .nav-links{display:none}
            .hamburger{display:block}
            .page-wrap{padding:84px 14px 60px}
            .stats-row{grid-template-columns:repeat(2,1fr);gap:8px}
            .page-title{font-size:28px}
            .card-main{grid-template-columns:5px 1fr}
            .card-dates,.card-finance,.card-actions{border-left:none;border-top:1px solid rgba(255,255,255,0.05);grid-column:2}
            .card-finance{min-width:unset}
            .modal-box{width:95%;padding:20px}
            .filter-bar{overflow-x:auto;flex-wrap:nowrap;padding-bottom:4px}
            .page-header{flex-direction:column;align-items:flex-start}
            .nav-user{display:none}
        }
    </style>
</head>
<body>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my" class="active">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a></li>
    </ul>
    <div class="nav-right">
        <c:if test="${not empty sessionScope.account}">
            <span class="nav-user">Xin chào, <strong>${sessionScope.account.fullName}</strong></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-nav-out">Đăng xuất</a>
        </c:if>
        <button class="hamburger" id="hamburgerBtn" onclick="document.getElementById('mobileNavMB').classList.toggle('open')" aria-label="Menu">☰</button>
    </div>
</nav>

<div class="mobile-nav" id="mobileNavMB">
    <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
    <a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a>
    <a href="${pageContext.request.contextPath}/booking?view=my" class="active">Booking Của Tôi</a>
    <a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a>
    <c:if test="${not empty sessionScope.account}">
        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
    </c:if>
</div>

<div class="page-wrap">
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang Chủ</a><span>/</span>
        <a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a><span>/</span>
        <span class="cur">Booking Của Tôi</span>
    </nav>

    <div class="page-header">
        <div>
            <h1 class="page-title">Booking <em>Của Tôi</em></h1>
            <p class="page-sub">Lịch sử đặt phòng và thông tin thanh toán tại Azure Resort.</p>
        </div>
        <a href="${pageContext.request.contextPath}/rooms" class="btn-new">+ Đặt phòng mới</a>
    </div>

    <c:if test="${not empty myBookings}">
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-num">${myBookings.size()}</div>
            <div class="stat-lbl">Tổng booking</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#10b981">
                <c:set var="cntOk" value="0"/>
                <c:forEach var="b" items="${myBookings}"><c:if test="${b.status=='CONFIRMED' or b.status=='CHECKED_IN'}"><c:set var="cntOk" value="${cntOk+1}"/></c:if></c:forEach>${cntOk}
            </div>
            <div class="stat-lbl">Đã xác nhận</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#f59e0b">
                <c:set var="cntPend" value="0"/>
                <c:forEach var="b" items="${myBookings}"><c:if test="${b.status=='PENDING'}"><c:set var="cntPend" value="${cntPend+1}"/></c:if></c:forEach>${cntPend}
            </div>
            <div class="stat-lbl">Chờ duyệt</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:rgba(255,255,255,0.3)">
                <c:set var="cntDone" value="0"/>
                <c:forEach var="b" items="${myBookings}"><c:if test="${b.status=='CHECKED_OUT' or b.status=='COMPLETED'}"><c:set var="cntDone" value="${cntDone+1}"/></c:if></c:forEach>${cntDone}
            </div>
            <div class="stat-lbl">Hoàn thành</div>
        </div>
    </div>

    <!-- Filter tabs -->
    <div class="filter-bar">
        <a href="?view=my" class="ftab ${empty param.filter ? 'active' : ''}">Tất cả</a>
        <a href="?view=my&filter=PENDING" class="ftab ${param.filter=='PENDING' ? 'active' : ''}">Chờ duyệt</a>
        <a href="?view=my&filter=CONFIRMED" class="ftab ${param.filter=='CONFIRMED' ? 'active' : ''}">Đã xác nhận</a>
        <a href="?view=my&filter=CHECKED_IN" class="ftab ${param.filter=='CHECKED_IN' ? 'active' : ''}">Đang ở</a>
        <a href="?view=my&filter=CHECKED_OUT" class="ftab ${param.filter=='CHECKED_OUT' ? 'active' : ''}">Đã trả phòng</a>
        <a href="?view=my&filter=CANCELLED" class="ftab ${param.filter=='CANCELLED' ? 'active' : ''}">Đã hủy</a>
    </div>
    </c:if>

    <c:choose>
        <c:when test="${empty myBookings}">
            <div class="empty-state">
                <div class="empty-icon">🏝</div>
                <h3 class="empty-title">Chưa có booking nào</h3>
                <p class="empty-sub">Hành trình tuyệt vời của bạn vẫn đang chờ được viết tiếp.</p>
                <a href="${pageContext.request.contextPath}/rooms" class="btn-explore">Khám phá ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="booking-list">
                <c:forEach var="b" items="${myBookings}">
                    <c:if test="${empty param.filter or param.filter == b.status}">
                    <c:set var="contract" value="${contractMap[b.bookingId]}"/>
                    <c:set var="accentCls" value="${b.status=='PENDING'?'accent-pending':b.status=='CONFIRMED'?'accent-confirmed':b.status=='CANCELLED'?'accent-cancelled':b.status=='CHECKED_IN'?'accent-checkin':b.status=='CHECKED_OUT'?'accent-checkout':'accent-completed'}"/>
                    <c:set var="badgeCls" value="${b.status=='PENDING'?'badge-pending':b.status=='CONFIRMED'?'badge-confirmed':b.status=='CANCELLED'?'badge-cancelled':b.status=='CHECKED_IN'?'badge-checkin':b.status=='CHECKED_OUT'?'badge-checkout':'badge-completed'}"/>
                    <c:set var="statusTxt" value="${b.status=='PENDING'?'Chờ Duyệt':b.status=='CONFIRMED'?'Đã Xác Nhận':b.status=='CANCELLED'?'Đã Hủy':b.status=='CHECKED_IN'?'Đang Ở':b.status=='CHECKED_OUT'?'Đã Trả Phòng':'Hoàn Thành'}"/>
                    <fmt:formatDate var="startFmt" value="${b.startDate}" pattern="dd/MM/yyyy"/>
                    <fmt:formatDate var="endFmt" value="${b.endDate}" pattern="dd/MM/yyyy"/>
                    <fmt:formatDate var="bookFmt" value="${b.dateBooking}" pattern="dd/MM/yyyy"/>

                    <div class="booking-card">
                        <div class="card-main">
                            <div class="card-accent ${accentCls}"></div>
                            <div class="card-info">
                                <div class="card-id">#${b.bookingId}</div>
                                <div class="card-facility">${b.facilityId.serviceName}</div>
                                <div class="card-type">${b.facilityId.facilityType}</div>
                                <div class="card-meta">${b.adults + b.children} khách &nbsp;·&nbsp; Đặt ngày ${bookFmt}</div>                            </div>
                            <div class="card-dates">
                                <div class="dates-label">Thời gian lưu trú</div>
                                <div class="dates-val">${startFmt} → ${endFmt}</div>
                                <div class="dates-nights">
                                    <c:set var="ms1" value="${b.endDate.time - b.startDate.time}"/>
                                    <c:set var="nights" value="${ms1 / 86400000}"/>
                                    <fmt:formatNumber value="${nights}" maxFractionDigits="0"/> đêm
                                </div>
                            </div>
                            <div class="card-finance">
                                <c:choose>
                                    <c:when test="${not empty contract}">
                                        <div class="finance-label">Thanh toán</div>
                                        <div class="finance-total"><fmt:formatNumber value="${contract.totalPayment}" pattern="#,###"/> đ</div>
                                        <div class="finance-row">
                                            <span>Đã trả:</span>
                                            <span class="paid"><fmt:formatNumber value="${contract.paidAmount}" pattern="#,###"/> đ</span>
                                        </div>
                                        <c:if test="${contract.remainingAmount > 0}">
                                        <div class="finance-row">
                                            <span>Còn lại:</span>
                                            <span class="remain"><fmt:formatNumber value="${contract.remainingAmount}" pattern="#,###"/> đ</span>
                                        </div>
                                        </c:if>
                                        <c:set var="pct" value="0"/>
                                        <c:if test="${contract.totalPayment > 0}">
                                            <c:set var="pct" value="${contract.paidAmount * 100 / contract.totalPayment}"/>
                                        </c:if>
                                        <div class="finance-bar"><div class="finance-bar-fill" id="bar-${b.bookingId}" style="width:0%" data-pct="${pct}"></div></div>
                                        <div style="margin-top:6px">
                                            <c:choose>
                                                <c:when test="${contract.status=='ACTIVE'}"><span class="badge badge-contract-active">Hợp đồng: Hiệu lực</span></c:when>
                                                <c:when test="${contract.status=='COMPLETED'}"><span class="badge badge-completed">Đã thanh toán đủ</span></c:when>
                                                <c:otherwise><span class="badge badge-contract-draft">Hợp đồng: ${contract.status}</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="finance-label">Thanh toán</div>
                                        <div class="finance-no-contract">Chưa có hợp đồng</div>
                                        <div style="margin-top:4px;font-size:10px;color:rgba(255,255,255,0.18)">Chờ admin xác nhận</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:set var="ctId"     value="${not empty contract ? contract.contractId : ''}"/>
                            <c:set var="ctTotal"  value="${not empty contract ? contract.totalPayment : 0}"/>
                            <c:set var="ctPaid"   value="${not empty contract ? contract.paidAmount : 0}"/>
                            <c:set var="ctRemain" value="${not empty contract ? contract.remainingAmount : 0}"/>
                            <c:set var="ctStatus" value="${not empty contract ? contract.status : ''}"/>
                            <c:set var="specReq"  value="${not empty b.specialReq ? b.specialReq : ''}"/>
                            <div class="card-actions">
                                <span class="badge ${badgeCls}">${statusTxt}</span>
                                <button class="btn-detail"
                                    data-id="${b.bookingId}"
                                    data-facility="<c:out value='${b.facilityId.serviceName}'/>"
                                    data-type="${b.facilityId.facilityType}"
                                    data-start="${startFmt}"
                                    data-end="${endFmt}"
                                    data-adults="${b.adults}"
                                    data-children="${b.children}"
                                    data-status="${b.status}"
                                    data-statustxt="${statusTxt}"
                                    data-ctid="${ctId}"
                                    data-cttotal="${ctTotal}"
                                    data-ctpaid="${ctPaid}"
                                    data-ctremain="${ctRemain}"
                                    data-ctstatus="${ctStatus}"
                                    data-specreq="<c:out value='${specReq}'/>"
                                    onclick="openDetailFromBtn(this)">Xem chi tiết</button>
                                <c:if test="${b.status=='PENDING'}">
                                    <button onclick="confirmCancel('${b.bookingId}')" class="btn-cancel">Hủy đặt</button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Detail Modal -->
<div class="modal-overlay" id="detailModal">
    <div class="modal-box">
        <button class="modal-close" onclick="closeDetail()">&times;</button>
        <div class="modal-label">Chi tiết booking</div>
        <div class="modal-title" id="dTitle"></div>
        <div id="dRows"></div>
        <!-- Booking flow timeline -->
        <div class="timeline" id="dTimeline"></div>
    </div>
</div>

<footer>
    <div class="footer-inner">
        <div class="footer-brand">Azure <span>Resort</span> &amp; Spa</div>
        <div class="footer-copy">© 2026 Azure Resort &amp; Spa. All rights reserved.</div>
    </div>
</footer>

<c:if test="${not empty sessionScope.bookingFlash}">
    <div id="flashToast" class="toast">
        <div class="toast-msg">${sessionScope.bookingFlash}</div>
    </div>
    <c:remove var="bookingFlash" scope="session"/>
    <script>
        setTimeout(function(){var t=document.getElementById('flashToast');if(t){t.style.opacity='0';t.style.transform='translateY(-10px)';t.style.transition='all 0.4s';setTimeout(function(){t.remove()},400)}},5000);
    </script>
</c:if>

<script>
// Animate finance bars
document.querySelectorAll('.finance-bar-fill[data-pct]').forEach(function(el) {
    el.style.width = el.getAttribute('data-pct') + '%';
});

function confirmCancel(id) {
    if (confirm('Bạn có chắc muốn hủy booking #' + id + '?')) {
        var f = document.createElement('form');
        f.method = 'POST'; f.action = '${pageContext.request.contextPath}/booking';
        ['action','bookingId'].forEach(function(n,i){
            var inp = document.createElement('input'); inp.type='hidden';
            inp.name = n; inp.value = i===0 ? 'cancel' : id;
            f.appendChild(inp);
        });
        document.body.appendChild(f); f.submit();
    }
}

var STATUS_FLOW = ['PENDING','CONFIRMED','CHECKED_IN','CHECKED_OUT'];
var STATUS_LABELS = {'PENDING':'Chờ Duyệt','CONFIRMED':'Đã Xác Nhận','CHECKED_IN':'Đang Lưu Trú','CHECKED_OUT':'Đã Trả Phòng','CANCELLED':'Đã Hủy','COMPLETED':'Hoàn Thành'};

function fmtMoney(v) {
    var n = parseFloat(v) || 0;
    return new Intl.NumberFormat('vi-VN').format(n) + ' đ';
}

function openDetailFromBtn(btn) {
    var d = btn.dataset;
    openDetail(d.id, d.facility, d.type, d.start, d.end, d.adults, d.children,
               d.status, d.statustxt, d.ctid, d.cttotal, d.ctpaid, d.ctremain, d.ctstatus, d.specreq);
}

function openDetail(id, facility, type, start, end, adults, children, status, statusTxt,
                    contractId, total, paid, remaining, contractStatus, specialReq) {
    document.getElementById('dTitle').textContent = facility;

    var rows = [
        ['Mã booking', '#' + id],
        ['Loại phòng', type],
        ['Nhận phòng', start],
        ['Trả phòng', end],
        ['Số khách', adults + ' người lớn, ' + children + ' trẻ em'],
        ['Trạng thái', statusTxt]
    ];
    if (contractId) {
        rows.push(['Mã hợp đồng', contractId]);
        rows.push(['Tổng tiền', fmtMoney(total)]);
        rows.push(['Đã thanh toán', fmtMoney(paid)]);
        if (parseFloat(remaining) > 0) rows.push(['Còn lại', fmtMoney(remaining)]);
    }
    if (specialReq && specialReq.trim()) rows.push(['Yêu cầu đặc biệt', specialReq]);

    var html = rows.map(function(r){
        return '<div class="detail-row"><span class="key">'+r[0]+'</span><span class="val">'+r[1]+'</span></div>';
    }).join('');
    document.getElementById('dRows').innerHTML = html;

    // Timeline
    var tlHtml = '<div style="font-size:10px;color:rgba(255,255,255,0.25);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:12px;margin-top:20px">Tiến trình booking</div>';
    if (status === 'CANCELLED') {
        tlHtml += '<div class="tl-step"><div class="tl-dot done"></div><div class="tl-text"><strong>Đã hủy</strong>Booking đã bị hủy</div></div>';
    } else {
        STATUS_FLOW.forEach(function(s) {
            var idx = STATUS_FLOW.indexOf(s);
            var curIdx = STATUS_FLOW.indexOf(status);
            var cls = idx < curIdx ? 'done' : idx === curIdx ? 'active' : '';
            tlHtml += '<div class="tl-step"><div class="tl-dot '+cls+'"></div><div class="tl-text"><strong>'+STATUS_LABELS[s]+'</strong>'+(idx <= curIdx ? (idx < curIdx ? 'Hoàn thành' : 'Trạng thái hiện tại') : 'Chưa đến')+'</div></div>';
        });
    }
    document.getElementById('dTimeline').innerHTML = tlHtml;
    document.getElementById('detailModal').classList.add('open');
}

function closeDetail() {
    document.getElementById('detailModal').classList.remove('open');
}
document.getElementById('detailModal').addEventListener('click', function(e){
    if(e.target === this) closeDetail();
});
</script>
</body>
</html>
