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
        :root { --gold: #c9a84c; --gold-light: #e8cc82; --dark: #0a0a0f; --navy: #0d1526; --text: #e8e8e8; --text-muted: rgba(255,255,255,0.5); --bg-glass: rgba(255,255,255,0.04); --border-glass: rgba(255,255,255,0.08); }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); min-height: 100vh; }

        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 60px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.95); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.15); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 36px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.75); text-decoration: none; font-size: 13.5px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover { color: var(--gold); }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-greeting { color: rgba(255,255,255,0.5); font-size: 13px; }
        .nav-greeting strong { color: var(--gold); }
        .btn-nav-logout { padding: 8px 20px; border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; background: transparent; color: var(--gold); font-size: 13px; text-decoration: none; transition: all 0.25s; }
        .btn-nav-logout:hover { background: var(--gold); color: var(--dark); }

        .page-wrap { margin-top: 72px; padding: 56px 60px 80px; max-width: 1100px; margin-left: auto; margin-right: auto; }

        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--text-muted); margin-bottom: 32px; }
        .breadcrumb a { color: var(--text-muted); text-decoration: none; transition: color 0.2s; }
        .breadcrumb a:hover { color: var(--gold); }
        .breadcrumb .sep { color: rgba(255,255,255,0.2); }

        .page-title { font-family: 'Playfair Display', serif; font-size: 32px; color: #fff; margin-bottom: 8px; }
        .page-title em { color: var(--gold); font-style: italic; }
        .page-subtitle { color: var(--text-muted); font-size: 14px; margin-bottom: 40px; }

        .btn-new-booking { display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border-radius: 50px; font-size: 13px; font-weight: 700; text-decoration: none; transition: all 0.25s; margin-bottom: 36px; }
        .btn-new-booking:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(201,168,76,0.3); }

        /* TABLE */
        .table-wrap { background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: 20px; overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: rgba(201,168,76,0.08); border-bottom: 1px solid rgba(201,168,76,0.15); }
        thead th { padding: 16px 20px; text-align: left; font-size: 11px; color: var(--gold); letter-spacing: 1.5px; text-transform: uppercase; font-weight: 600; }
        tbody tr { border-bottom: 1px solid var(--border-glass); transition: background 0.2s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: rgba(255,255,255,0.03); }
        tbody td { padding: 18px 20px; font-size: 13.5px; color: var(--text); vertical-align: middle; }

        .booking-id { font-family: monospace; color: var(--gold); font-size: 13px; font-weight: 600; }
        .facility-name { font-weight: 500; color: #fff; }
        .facility-type { font-size: 11px; color: var(--text-muted); margin-top: 3px; }
        .date-range { font-size: 13px; }
        .date-range .nights { font-size: 11px; color: var(--text-muted); margin-top: 3px; }
        .guests { font-size: 13px; }

        .status-badge { display: inline-block; padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 600; letter-spacing: 0.5px; text-transform: uppercase; }
        .status-PENDING { background: rgba(251,191,36,0.15); color: #fbbf24; border: 1px solid rgba(251,191,36,0.3); }
        .status-CONFIRMED { background: rgba(52,211,153,0.15); color: #34d399; border: 1px solid rgba(52,211,153,0.3); }
        .status-CANCELLED { background: rgba(248,113,113,0.15); color: #f87171; border: 1px solid rgba(248,113,113,0.3); }
        .status-COMPLETED { background: rgba(96,165,250,0.15); color: #60a5fa; border: 1px solid rgba(96,165,250,0.3); }
        .status-CHECKEDIN { background: rgba(167,139,250,0.15); color: #a78bfa; border: 1px solid rgba(167,139,250,0.3); }
        .status-CHECKED_IN { background: rgba(167,139,250,0.15); color: #a78bfa; border: 1px solid rgba(167,139,250,0.3); }
        .status-CHECKED_OUT { background: rgba(96,165,250,0.15); color: #60a5fa; border: 1px solid rgba(96,165,250,0.3); }
        .btn-cancel-booking { display: inline-flex; align-items: center; gap: 6px; padding: 5px 14px; border-radius: 50px; font-size: 11px; font-weight: 600; background: rgba(248,113,113,0.1); color: #f87171; border: 1px solid rgba(248,113,113,0.3); cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif; }
        .btn-cancel-booking:hover { background: #f87171; color: #fff; }
        .flash-toast { position: fixed; top: 88px; right: 24px; z-index: 3000; padding: 14px 20px; border-radius: 14px; font-size: 13.5px; font-weight: 600; max-width: 380px; }
        .flash-ok  { background: rgba(74,222,128,0.12); border: 1px solid rgba(74,222,128,0.3); color: #4ade80; }
        .flash-err { background: rgba(248,113,113,0.12); border: 1px solid rgba(248,113,113,0.3); color: #f87171; }

        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 80px 40px; }
        .empty-icon { font-size: 56px; margin-bottom: 20px; opacity: 0.5; }
        .empty-state h3 { font-family: 'Playfair Display', serif; font-size: 22px; color: #fff; margin-bottom: 10px; }
        .empty-state p { color: var(--text-muted); font-size: 14px; margin-bottom: 28px; }

        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .page-wrap { padding: 40px 16px 60px; }
            table { display: block; overflow-x: auto; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a></li>
    </ul>
    <div class="nav-right">
        <span class="nav-greeting">Xin chào, <strong>${sessionScope.account.fullName}</strong></span>
        <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Đăng xuất</a>
    </div>
</nav>

<div class="page-wrap">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
        <span class="sep">›</span>
        <a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a>
        <span class="sep">›</span>
        <span style="color:var(--gold)">Booking Của Tôi</span>
    </div>

    <h1 class="page-title">Booking <em>Của Tôi</em></h1>
    <p class="page-subtitle">Lịch sử và trạng thái các đặt phòng của bạn tại Azure Resort & Spa.</p>

    <a href="${pageContext.request.contextPath}/booking" class="btn-new-booking">
        ＋ Đặt Phòng Mới
    </a>

    <div class="table-wrap">
        <c:choose>
            <c:when test="${empty myBookings}">
                <div class="empty-state">
                    <div class="empty-icon">🏖️</div>
                    <h3>Chưa có booking nào</h3>
                    <p>Bạn chưa có đặt phòng nào. Hãy bắt đầu kỳ nghỉ đầu tiên của bạn!</p>
                    <a href="${pageContext.request.contextPath}/booking" class="btn-new-booking">Đặt Phòng Ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Mã Booking</th>
                            <th>Phòng / Villa</th>
                            <th>Check-in → Check-out</th>
                            <th>Khách</th>
                            <th>Trạng Thái</th>
                            <th>Ngày Đặt</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${myBookings}">
                            <tr>
                                <td><span class="booking-id">${b.bookingId}</span></td>
                                <td>
                                    <div class="facility-name">${b.facilityId.serviceName}</div>
                                    <div class="facility-type">${b.facilityId.facilityType}</div>
                                </td>
                                <td>
                                    <div class="date-range">
                                        <fmt:formatDate value="${b.startDate}" pattern="dd/MM/yyyy"/>
                                        →
                                        <fmt:formatDate value="${b.endDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </td>
                                <td class="guests">${b.adults} người lớn<c:if test="${b.children > 0}">, ${b.children} trẻ em</c:if></td>
                                <td><span class="status-badge status-${b.status}">
                                    <c:choose>
                                        <c:when test="${b.status == 'PENDING'}">Chờ Duyệt</c:when>
                                        <c:when test="${b.status == 'CONFIRMED'}">Đã Xác Nhận</c:when>
                                        <c:when test="${b.status == 'CANCELLED'}">Đã Hủy</c:when>
                                        <c:when test="${b.status == 'COMPLETED'}">Hoàn Thành</c:when>
                                        <c:when test="${b.status == 'CHECKED_IN'}">Đang Ở</c:when>
                                        <c:when test="${b.status == 'CHECKED_OUT'}">Đã Trả Phòng</c:when>
                                        <c:otherwise>${b.status}</c:otherwise>
                                    </c:choose>
                                </span></td>
                                <td><fmt:formatDate value="${b.dateBooking}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<footer style="background:#060608;border-top:1px solid rgba(201,168,76,0.1);padding:28px 60px;">
    <div style="max-width:1100px;margin:0 auto;display:flex;justify-content:space-between;align-items:center;color:rgba(255,255,255,0.25);font-size:12.5px;">
        <span>© 2026 <span style="color:var(--gold)">Azure Resort &amp; Spa</span>. All rights reserved.</span>
        <span>Made with ❤️ in Vietnam</span>
    </div>
</footer>

<c:if test="${not empty sessionScope.bookingFlash}">
    <div class="flash-toast ${sessionScope.bookingFlash.startsWith('✅') ? 'flash-ok' : 'flash-err'}" id="flashToast">
        ${sessionScope.bookingFlash}
    </div>
    <c:remove var="bookingFlash" scope="session"/>
    <script>
        setTimeout(() => {
            const t = document.getElementById('flashToast');
            if (t) { t.style.opacity='0'; t.style.transition='opacity 0.5s'; setTimeout(()=>t.remove(),500); }
        }, 4000);
    </script>
</c:if>

</body>
</html>
