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
    <script src="https://cdn.tailwindcss.com"></script>
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
        
        /* Layout */
        .page-wrap{max-width:1100px;margin:0 auto;padding:100px 24px 80px}
        .breadcrumb{display:flex;align-items:center;gap:8px;font-size:11px;text-transform:uppercase;letter-spacing:0.15em;color:rgba(255,255,255,0.25);margin-bottom:32px}
        .breadcrumb a{color:rgba(255,255,255,0.25);text-decoration:none}
        .breadcrumb span{color:var(--gold)}

        .page-header{display:flex;align-items:flex-end;justify-content:space-between;gap:20px;margin-bottom:32px;flex-wrap:wrap}
        .page-title{font-family:'Playfair Display',serif;font-size:42px;font-weight:700;color:#fff;line-height:1.1}
        .page-title em{color:var(--gold);font-style:italic}
        .btn-new{display:inline-flex;align-items:center;gap:8px;padding:11px 22px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.1);border-radius:12px;color:rgba(255,255,255,0.6);font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;text-decoration:none;transition:all 0.2s}
        .btn-new:hover{background:var(--gold);color:var(--dark)}

        /* Stats */
        .stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:28px}
        .stat-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:16px 20px}
        .stat-num{font-family:'Playfair Display',serif;font-size:28px;font-weight:700;color:var(--gold);line-height:1}
        .stat-lbl{font-size:10px;color:rgba(255,255,255,0.28);text-transform:uppercase;letter-spacing:0.12em;margin-top:4px}

        /* Filter tabs */
        .filter-bar{display:flex;align-items:center;gap:8px;margin-bottom:24px;flex-wrap:wrap}
        .ftab{padding:6px 16px;border-radius:50px;font-size:12px;font-weight:600;border:1.5px solid rgba(255,255,255,0.08);color:rgba(255,255,255,0.4);background:transparent;cursor:pointer;transition:all 0.2s;text-decoration:none}
        .ftab.active{background:var(--gold);color:var(--dark);border-color:var(--gold)}

        /* Cards */
        .booking-list{display:flex;flex-direction:column;gap:14px}
        .booking-card{background:var(--card);border:1px solid var(--border);border-radius:20px;overflow:hidden;transition:border-color 0.2s}
        .card-main{display:grid;grid-template-columns:5px 1fr auto auto auto;align-items:stretch}
        .card-accent{align-self:stretch}
        .accent-pending{background:linear-gradient(180deg,#f59e0b,#d97706)}
        .accent-confirmed{background:linear-gradient(180deg,#10b981,#059669)}
        .accent-cancelled{background:linear-gradient(180deg,#f87171,#ef4444)}
        .accent-checkin{background:linear-gradient(180deg,#60a5fa,#3b82f6)}
        .accent-completed{background:linear-gradient(180deg,var(--gold),var(--gold-light))}

        .card-info{padding:18px 22px}
        .card-id{font-family:'Courier New',monospace;font-size:11px;color:var(--gold);font-weight:700}
        .card-facility{font-size:15px;font-weight:600;color:#fff}
        .card-meta{font-size:11px;color:rgba(255,255,255,0.3);margin-top:3px}

        .card-dates{padding:18px 22px;border-left:1px solid rgba(255,255,255,0.05)}
        .dates-label{font-size:10px;color:rgba(255,255,255,0.25);text-transform:uppercase}
        .dates-val{font-size:13px;color:rgba(255,255,255,0.75)}

        .card-finance{padding:18px 22px;border-left:1px solid rgba(255,255,255,0.05);min-width:170px}
        .finance-total{font-family:'Playfair Display',serif;font-size:17px;font-weight:700;color:var(--gold)}
        
        .card-actions{padding:18px 22px;display:flex;flex-direction:column;align-items:flex-end;justify-content:center;gap:8px;border-left:1px solid rgba(255,255,255,0.05)}
        
        /* Badges */
        .badge{display:inline-flex;align-items:center;padding:4px 11px;border-radius:50px;font-size:10px;font-weight:700;border:1px solid;text-transform:uppercase}
        .badge-pending{color:#f59e0b;background:rgba(245,158,11,0.08);border-color:rgba(245,158,11,0.2)}
        .badge-confirmed{color:#10b981;background:rgba(16,185,129,0.08);border-color:rgba(16,185,129,0.2)}
        .btn-detail{font-size:11px;font-weight:600;color:var(--gold);border:1px solid rgba(201,168,76,0.2);padding:5px 12px;border-radius:8px;background:transparent;cursor:pointer}

        /* Modal */
        .modal-overlay{display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.8);z-index:2000;backdrop-filter:blur(6px);justify-content:center;align-items:center}
        .modal-overlay.open{display:flex}
        .modal-box{background:#0d1526;border:1px solid rgba(201,168,76,0.18);border-radius:24px;padding:36px;width:90%;max-width:520px}

        footer{background:#060608;border-top:1px solid rgba(255,255,255,0.05);padding:28px 48px;text-align:center;font-size:11px;color:rgba(255,255,255,0.18)}
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
    </div>
</nav>

<div class="page-wrap">
    <header class="page-header">
        <div>
            <h1 class="page-title">Booking <em>Của Tôi</em></h1>
            <p class="text-sm text-white/30">Lịch sử đặt phòng tại Azure Resort.</p>
        </div>
        <a href="${pageContext.request.contextPath}/rooms" class="btn-new">+ Đặt phòng mới</a>
    </header>

    <c:choose>
        <c:when test="${empty myBookings}">
            <div class="text-center py-20 bg-white/5 rounded-3xl border border-white/10">
                <p class="text-white/40">Bạn chưa có booking nào.</p>
                <a href="${pageContext.request.contextPath}/rooms" class="text-gold mt-4 inline-block hover:underline">Đặt phòng ngay ngay →</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="booking-list">
                <c:forEach var="b" items="${myBookings}">
                    <c:set var="accentCls" value="${b.status=='PENDING'?'accent-pending':b.status=='CONFIRMED'?'accent-confirmed':b.status=='CANCELLED'?'accent-cancelled':b.status=='CHECKED_IN'?'accent-checkin':'accent-completed'}"/>
                    <c:set var="statusTxt" value="${b.status=='PENDING'?'Chờ Duyệt':b.status=='CONFIRMED'?'Đã Xác Nhận':b.status=='CANCELLED'?'Đã Hủy':b.status=='CHECKED_IN'?'Đang Ở':'Hoàn Thành'}"/>
                    
                    <div class="booking-card">
                        <div class="card-main">
                            <div class="card-accent ${accentCls}"></div>
                            <div class="card-info">
                                <div class="card-id">#${b.bookingId}</div>
                                <div class="card-facility">${b.facilityId.serviceName}</div>
                                <div class="card-meta">${b.adults + b.children} khách · <fmt:formatDate value="${b.dateBooking}" pattern="dd/MM/yyyy"/></div>
                            </div>
                            <div class="card-dates">
                                <div class="dates-label">Lưu trú</div>
                                <div class="dates-val">
                                    <fmt:formatDate value="${b.startDate}" pattern="dd/MM/yyyy"/> → <fmt:formatDate value="${b.endDate}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>
                            <div class="card-finance">
                                <div class="dates-label">Thanh toán</div>
                                <div class="finance-total">
                                    <c:set var="contract" value="${contractMap[b.bookingId]}"/>
                                    <c:choose>
                                        <c:when test="${not empty contract}">
                                            <fmt:formatNumber value="${contract.totalPayment}" pattern="#,###"/> đ
                                        </c:when>
                                        <c:otherwise>Đang xử lý</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="card-actions">
                                <span class="badge ${b.status=='PENDING'?'badge-pending':'badge-confirmed'}">${statusTxt}</span>
                                <button class="btn-detail" onclick="alert('Đang phát triển tính năng chi tiết')">Xem chi tiết</button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer>
    © 2026 Azure Resort &amp; Spa. Bản quyền được bảo lưu.
</footer>

</body>
</html>
