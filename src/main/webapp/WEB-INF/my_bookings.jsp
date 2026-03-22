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
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --gold: #c9a84c; --gold-light: #e8cc82; --dark: #0a0a0f; --navy: #0d1526; }
        body { background: var(--dark); color: #e8e8e8; font-family: 'Inter', sans-serif; min-height: 100vh; }
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 48px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.9); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.12); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 28px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.55); text-decoration: none; font-size: 13px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover, .nav-links a.active { color: var(--gold); }
        .nav-right { display: flex; align-items: center; gap: 14px; }
        .nav-user { font-size: 13px; color: rgba(255,255,255,0.4); }
        .nav-user strong { color: var(--gold); }
        .btn-logout { padding: 7px 18px; border: 1px solid rgba(201,168,76,0.35); border-radius: 50px; color: var(--gold); font-size: 12px; font-weight: 600; text-decoration: none; transition: all 0.2s; }
        .btn-logout:hover { background: var(--gold); color: var(--dark); }
        .page-wrap { max-width: 1200px; margin: 0 auto; padding: 100px 24px 80px; }
        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.15em; color: rgba(255,255,255,0.3); margin-bottom: 36px; }
        .breadcrumb a { color: rgba(255,255,255,0.3); text-decoration: none; }
        .breadcrumb a:hover { color: var(--gold); }
        .breadcrumb .cur { color: var(--gold); }
        .page-header { display: flex; align-items: flex-end; justify-content: space-between; gap: 20px; margin-bottom: 36px; flex-wrap: wrap; }
        .page-title { font-family: 'Playfair Display', serif; font-size: 44px; font-weight: 700; color: #fff; line-height: 1.1; }
        .page-title em { color: var(--gold); font-style: italic; }
        .page-sub { color: rgba(255,255,255,0.35); font-size: 14px; margin-top: 8px; }
        .btn-new { display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 14px; color: rgba(255,255,255,0.65); font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.12em; text-decoration: none; transition: all 0.2s; white-space: nowrap; }
        .btn-new:hover { background: var(--gold); border-color: var(--gold); color: var(--dark); }
        .btn-new .plus { color: var(--gold); transition: color 0.2s; }
        .btn-new:hover .plus { color: var(--dark); }
        /* Stats */
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 28px; }
        .stat-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 18px; padding: 18px 22px; }
        .stat-num { font-family: 'Playfair Display', serif; font-size: 30px; font-weight: 700; color: var(--gold); line-height: 1; }
        .stat-lbl { font-size: 11px; color: rgba(255,255,255,0.3); text-transform: uppercase; letter-spacing: 0.12em; margin-top: 5px; }
        /* Booking Cards */
        .booking-list { display: flex; flex-direction: column; gap: 16px; }
        .booking-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 24px; overflow: hidden; transition: border-color 0.2s; }
        .booking-card:hover { border-color: rgba(201,168,76,0.2); }
        .card-main { display: grid; grid-template-columns: auto 1fr auto auto auto; align-items: center; gap: 0; padding: 0; }
        .card-accent { width: 5px; align-self: stretch; border-radius: 24px 0 0 24px; }
        .accent-pending  { background: linear-gradient(180deg, #f59e0b, #d97706); }
        .accent-confirmed{ background: linear-gradient(180deg, #10b981, #059669); }
        .accent-cancelled{ background: linear-gradient(180deg, #f87171, #ef4444); }
        .accent-checkin  { background: linear-gradient(180deg, #60a5fa, #3b82f6); }
        .accent-checkout { background: linear-gradient(180deg, rgba(255,255,255,0.2), rgba(255,255,255,0.1)); }
        .accent-completed{ background: linear-gradient(180deg, var(--gold), var(--gold-light)); }
        .card-info { padding: 20px 24px; display: flex; flex-direction: column; gap: 6px; }
        .card-id { font-family: 'Courier New', monospace; font-size: 12px; color: var(--gold); font-weight: 700; }
        .card-facility { font-size: 15px; font-weight: 600; color: #fff; }
        .card-type { font-size: 10px; color: rgba(201,168,76,0.6); text-transform: uppercase; letter-spacing: 0.2em; font-weight: 700; }
        .card-dates { padding: 20px 24px; display: flex; flex-direction: column; gap: 5px; border-left: 1px solid rgba(255,255,255,0.05); }
        .dates-label { font-size: 10px; color: rgba(255,255,255,0.3); text-transform: uppercase; letter-spacing: 0.15em; }
        .dates-val { font-size: 13px; color: rgba(255,255,255,0.8); font-weight: 500; }
        .dates-arrow { color: rgba(255,255,255,0.2); margin: 0 6px; }
        .card-finance { padding: 20px 24px; display: flex; flex-direction: column; gap: 5px; border-left: 1px solid rgba(255,255,255,0.05); min-width: 180px; }
        .finance-label { font-size: 10px; color: rgba(255,255,255,0.3); text-transform: uppercase; letter-spacing: 0.15em; }
        .finance-total { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 700; color: var(--gold); }
        .finance-row { display: flex; justify-content: space-between; font-size: 11px; color: rgba(255,255,255,0.4); margin-top: 2px; }
        .finance-row .paid { color: #10b981; }
        .finance-row .remain { color: #f59e0b; }
        .finance-no-contract { font-size: 11px; color: rgba(255,255,255,0.2); font-style: italic; }
        .card-actions { padding: 20px 24px; display: flex; flex-direction: column; align-items: flex-end; gap: 10px; border-left: 1px solid rgba(255,255,255,0.05); }
        /* Badges */
        .badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 50px; font-size: 10px; font-weight: 700; border: 1px solid; text-transform: uppercase; letter-spacing: 0.1em; white-space: nowrap; }
        .badge::before { content: ''; width: 5px; height: 5px; border-radius: 50%; background: currentColor; flex-shrink: 0; }
        .badge-pending  { color: #f59e0b; background: rgba(245,158,11,0.1);  border-color: rgba(245,158,11,0.25); }
        .badge-confirmed{ color: #10b981; background: rgba(16,185,129,0.1);  border-color: rgba(16,185,129,0.25); }
        .badge-cancelled{ color: #f87171; background: rgba(248,113,113,0.1); border-color: rgba(248,113,113,0.25); }
        .badge-checkin  { color: #60a5fa; background: rgba(96,165,250,0.1);  border-color: rgba(96,165,250,0.25); }
        .badge-checkout { color: rgba(255,255,255,0.35); background: rgba(255,255,255,0.04); border-color: rgba(255,255,255,0.1); }
        .badge-completed{ color: var(--gold); background: rgba(201,168,76,0.1); border-color: rgba(201,168,76,0.25); }
        .badge-contract-active { color: #10b981; background: rgba(16,185,129,0.08); border-color: rgba(16,185,129,0.2); }
        .badge-contract-draft  { color: rgba(255,255,255,0.4); background: rgba(255,255,255,0.04); border-color: rgba(255,255,255,0.1); }
        .btn-cancel { font-size: 11px; font-weight: 700; color: rgba(248,113,113,0.5); text-transform: uppercase; letter-spacing: 0.1em; background: none; border: 1px solid rgba(248,113,113,0.15); border-radius: 8px; cursor: pointer; padding: 5px 12px; transition: all 0.2s; }
        .btn-cancel:hover { color: #f87171; background: rgba(248,113,113,0.08); border-color: rgba(248,113,113,0.3); }
        .guest-pill { font-size: 11px; color: rgba(255,255,255,0.35); display: flex; align-items: center; gap: 5px; }
        .guest-num { width: 22px; height: 22px; border-radius: 6px; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; font-size: 10px; color: var(--gold); font-weight: 700; }
        /* Empty */
        .empty-state { padding: 80px 24px; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 18px; background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.06); border-radius: 24px; }
        .empty-icon { font-size: 52px; opacity: 0.15; }
        .empty-title { font-family: 'Playfair Display', serif; font-size: 24px; font-weight: 700; color: #fff; }
        .empty-sub { font-size: 13px; color: rgba(255,255,255,0.3); max-width: 280px; line-height: 1.7; }
        .btn-explore { padding: 12px 32px; background: var(--gold); color: var(--dark); border-radius: 50px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.12em; text-decoration: none; transition: all 0.2s; }
        .btn-explore:hover { background: var(--gold-light); }
        /* Toast */
        .toast { position: fixed; top: 84px; right: 20px; z-index: 2000; padding: 14px 20px; border-radius: 14px; background: rgba(13,21,38,0.97); border: 1px solid rgba(255,255,255,0.08); backdrop-filter: blur(20px); display: flex; align-items: center; gap: 12px; box-shadow: 0 12px 40px rgba(0,0,0,0.5); }
        .toast-icon { font-size: 18px; }
        .toast-msg { font-size: 13px; color: #fff; font-weight: 500; }
        footer { background: #060608; border-top: 1px solid rgba(255,255,255,0.05); padding: 32px 48px; }
        .footer-inner { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
        .footer-brand { font-family: 'Playfair Display', serif; font-size: 17px; color: #fff; }
        .footer-brand span { color: var(--gold); }
        .footer-copy { font-size: 11px; color: rgba(255,255,255,0.2); }
        @media (max-width: 900px) {
            .navbar { padding: 0 16px; } .nav-links { display: none; }
            .page-wrap { padding: 84px 14px 60px; }
            .stats-row { grid-template-columns: repeat(2,1fr); }
            .page-title { font-size: 32px; }
            .card-main { grid-template-columns: 5px 1fr; }
            .card-dates, .card-finance, .card-actions { border-left: none; border-top: 1px solid rgba(255,255,255,0.05); grid-column: 2; }
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
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
        </c:if>
    </div>
</nav>

<div class="page-wrap">
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang Chủ</a><span>/</span>
        <a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a><span>/</span>
        <span class="cur">Booking Của Tôi</span>
    </nav>

    <div class="page-header">
        <div>
            <h1 class="page-title">Booking <em>Của Tôi</em></h1>
            <p class="page-sub">Lịch sử đặt phòng và thông tin thanh toán của bạn tại Azure Resort.</p>
        </div>
        <a href="${pageContext.request.contextPath}/booking" class="btn-new"><span class="plus">+</span> Đặt phòng mới</a>
    </div>

    <c:if test="${not empty myBookings}">
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-num">${myBookings.size()}</div>
            <div class="stat-lbl">Tổng booking</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#10b981">
                <c:set var="cnt" value="0"/>
                <c:forEach var="b" items="${myBookings}"><c:if test="${b.status=='CONFIRMED' or b.status=='CHECKED_IN'}"><c:set var="cnt" value="${cnt+1}"/></c:if></c:forEach>${cnt}
            </div>
            <div class="stat-lbl">Đã xác nhận</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#f59e0b">
                <c:set var="cnt2" value="0"/>
                <c:forEach var="b" items="${myBookings}"><c:if test="${b.status=='PENDING'}"><c:set var="cnt2" value="${cnt2+1}"/></c:if></c:forEach>${cnt2}
            </div>
            <div class="stat-lbl">Chờ duyệt</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:rgba(255,255,255,0.35)">
                <c:set var="cnt3" value="0"/>
                <c:forEach var="b" items="${myBookings}"><c:if test="${b.status=='CHECKED_OUT' or b.status=='COMPLETED'}"><c:set var="cnt3" value="${cnt3+1}"/></c:if></c:forEach>${cnt3}
            </div>
            <div class="stat-lbl">Hoàn thành</div>
        </div>
    </div>
    </c:if>

    <c:choose>
        <c:when test="${empty myBookings}">
            <div class="empty-state">
                <div class="empty-icon">🏝️</div>
                <h3 class="empty-title">Chưa có booking nào</h3>
                <p class="empty-sub">Hành trình tuyệt vời của bạn vẫn đang chờ được viết tiếp.</p>
                <a href="${pageContext.request.contextPath}/booking" class="btn-explore">Khám phá ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="booking-list">
                <c:forEach var="b" items="${myBookings}">
                    <c:set var="contract" value="${contractMap[b.bookingId]}"/>
                    <c:set var="accentClass" value="${b.status=='PENDING'?'accent-pending':b.status=='CONFIRMED'?'accent-confirmed':b.status=='CANCELLED'?'accent-cancelled':b.status=='CHECKED_IN'?'accent-checkin':b.status=='CHECKED_OUT'?'accent-checkout':'accent-completed'}"/>
                    <c:set var="badgeClass" value="${b.status=='PENDING'?'badge-pending':b.status=='CONFIRMED'?'badge-confirmed':b.status=='CANCELLED'?'badge-cancelled':b.status=='CHECKED_IN'?'badge-checkin':b.status=='CHECKED_OUT'?'badge-checkout':'badge-completed'}"/>
                    <div class="booking-card">
                        <div class="card-main">
                            <div class="card-accent ${accentClass}"></div>

                            <!-- Booking info -->
                            <div class="card-info">
                                <div class="card-id">#${b.bookingId}</div>
                                <div class="card-facility">${b.facilityId.serviceName}</div>
                                <div class="card-type">${b.facilityId.facilityType}</div>
                                <div class="guest-pill" style="margin-top:4px">
                                    <span class="guest-num">${b.adults + b.children}</span> khách
                                    &nbsp;·&nbsp;
                                    <fmt:formatDate value="${b.dateBooking}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>

                            <!-- Dates -->
                            <div class="card-dates">
                                <div class="dates-label">Thời gian lưu trú</div>
                                <div class="dates-val">
                                    <fmt:formatDate value="${b.startDate}" pattern="dd/MM/yyyy"/>
                                    <span class="dates-arrow">→</span>
                                    <fmt:formatDate value="${b.endDate}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>

                            <!-- Finance (from contract) -->
                            <div class="card-finance">
                                <c:choose>
                                    <c:when test="${not empty contract}">
                                        <div class="finance-label">Thanh toán</div>
                                        <div class="finance-total">
                                            <fmt:formatNumber value="${contract.totalPayment}" type="number" groupingUsed="true"/> đ
                                        </div>
                                        <div class="finance-row">
                                            <span>Đã trả:</span>
                                            <span class="paid"><fmt:formatNumber value="${contract.paidAmount}" type="number" groupingUsed="true"/> đ</span>
                                        </div>
                                        <c:if test="${contract.remainingAmount > 0}">
                                        <div class="finance-row">
                                            <span>Còn lại:</span>
                                            <span class="remain"><fmt:formatNumber value="${contract.remainingAmount}" type="number" groupingUsed="true"/> đ</span>
                                        </div>
                                        </c:if>
                                        <div style="margin-top:6px">
                                            <c:choose>
                                                <c:when test="${contract.status=='ACTIVE'}"><span class="badge badge-contract-active">Hợp đồng: Hiệu lực</span></c:when>
                                                <c:otherwise><span class="badge badge-contract-draft">Hợp đồng: ${contract.status}</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="finance-label">Thanh toán</div>
                                        <div class="finance-no-contract">Chưa có hợp đồng</div>
                                        <div style="margin-top:6px;font-size:10px;color:rgba(255,255,255,0.2)">Chờ admin xác nhận</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Actions -->
                            <div class="card-actions">
                                <span class="badge ${badgeClass}">
                                    <c:choose>
                                        <c:when test="${b.status=='PENDING'}">Chờ Duyệt</c:when>
                                        <c:when test="${b.status=='CONFIRMED'}">Đã Xác Nhận</c:when>
                                        <c:when test="${b.status=='CANCELLED'}">Đã Hủy</c:when>
                                        <c:when test="${b.status=='CHECKED_IN'}">Đang Ở</c:when>
                                        <c:when test="${b.status=='CHECKED_OUT'}">Đã Trả Phòng</c:when>
                                        <c:when test="${b.status=='COMPLETED'}">Hoàn Thành</c:when>
                                        <c:otherwise>${b.status}</c:otherwise>
                                    </c:choose>
                                </span>
                                <c:if test="${b.status=='PENDING'}">
                                    <button onclick="confirmCancel('${b.bookingId}')" class="btn-cancel">Hủy đặt</button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer>
    <div class="footer-inner">
        <div class="footer-brand">Azure <span>Resort</span> &amp; Spa</div>
        <div class="footer-copy">© 2026 Azure Resort &amp; Spa. All rights reserved.</div>
    </div>
</footer>

<c:if test="${not empty sessionScope.bookingFlash}">
    <div id="flashToast" class="toast">
        <div class="toast-icon">${sessionScope.bookingFlash.startsWith('✅') ? '✨' : '⚠️'}</div>
        <div class="toast-msg">${sessionScope.bookingFlash}</div>
    </div>
    <c:remove var="bookingFlash" scope="session"/>
    <script>
        setTimeout(function() {
            var t = document.getElementById('flashToast');
            if (t) { t.style.opacity='0'; t.style.transform='translateY(-12px)'; t.style.transition='all 0.4s'; setTimeout(function(){ t.remove(); }, 400); }
        }, 5000);
    </script>
</c:if>

<script>
    function confirmCancel(id) {
        if (confirm('Bạn có chắc chắn muốn hủy booking này?')) {
            var f = document.createElement('form');
            f.method = 'POST'; f.action = '${pageContext.request.contextPath}/booking';
            var a = document.createElement('input'); a.type='hidden'; a.name='action'; a.value='cancel'; f.appendChild(a);
            var b = document.createElement('input'); b.type='hidden'; b.name='bookingId'; b.value=id; f.appendChild(b);
            document.body.appendChild(f); f.submit();
        }
    }
</script>
</body>
</html>
