<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phòng &amp; Villa — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
            --card-bg: rgba(255,255,255,0.03);
            --card-border: rgba(255,255,255,0.08);
        }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); overflow-x: hidden; }
        
        /* Navbar */
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 48px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.85); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.1); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 32px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.6); text-decoration: none; font-size: 13px; font-weight: 500; letter-spacing: 0.5px; transition: color 0.2s; }
        .nav-links a:hover, .nav-links a.active { color: var(--gold); }
        .nav-right { display: flex; align-items: center; gap: 14px; }
        .btn-nav-auth { padding: 7px 20px; border-radius: 50px; font-size: 12.5px; font-weight: 600; text-decoration: none; transition: all 0.25s; }
        .btn-login { color: var(--gold); border: 1px solid rgba(201,168,76,0.3); }
        .btn-login:hover { background: var(--gold); color: var(--dark); }
        .btn-register { background: var(--gold); color: var(--dark); }
        .btn-register:hover { background: var(--gold-light); }
        .nav-greeting { color: rgba(255,255,255,0.4); font-size: 12px; }
        .nav-greeting strong { color: var(--gold); }

        /* Header */
        .page-header { background: linear-gradient(to bottom, rgba(13,21,38,0.8), var(--dark)), url('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1920&q=40'); background-size: cover; background-position: center; padding: 140px 48px 60px; text-align: center; }
        .page-title { font-family: 'Playfair Display', serif; font-size: 48px; font-weight: 700; color: #fff; margin-bottom: 12px; }
        .page-title em { color: var(--gold); font-style: italic; }
        .breadcrumb { display: flex; justify-content: center; gap: 8px; color: rgba(255,255,255,0.4); font-size: 11px; text-transform: uppercase; letter-spacing: 2px; }
        .breadcrumb a { color: inherit; text-decoration: none; }
        .breadcrumb span { color: var(--gold); }

        /* Filters */
        .filter-section { padding: 0 48px; margin-top: -30px; position: relative; z-index: 10; }
        .filter-bar { background: rgba(255,255,255,0.05); backdrop-filter: blur(30px); border: 1px solid var(--card-border); border-radius: 20px; padding: 24px 32px; display: flex; flex-wrap: wrap; gap: 24px; align-items: flex-end; justify-content: space-between; box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
        .filter-group { flex: 1; min-width: 200px; }
        .filter-label { display: block; color: var(--gold); font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; margin-bottom: 8px; }
        .filter-input { width: 100%; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; padding: 10px 14px; color: #fff; font-size: 13px; outline: none; transition: border-color 0.2s; }
        .filter-input:focus { border-color: var(--gold); }
        .btn-filter { background: var(--gold); color: var(--dark); font-weight: 700; font-size: 13px; padding: 11px 28px; border-radius: 12px; cursor: pointer; border: none; transition: all 0.2s; }
        .btn-filter:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(201,168,76,0.25); }

        /* Room Grid */
        .room-grid { padding: 60px 48px; display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 32px; }
        .room-card { background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 24px; overflow: hidden; transition: all 0.3s; position: relative; height: 100%; display: flex; flex-direction: column; }
        .room-card:hover { transform: translateY(-8px); border-color: rgba(201,168,76,0.3); box-shadow: 0 30px 60px rgba(0,0,0,0.5); }
        .room-img-wrap { position: relative; height: 260px; overflow: hidden; }
        .room-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s; }
        .room-card:hover .room-img { transform: scale(1.08); }
        .status-badge { position: absolute; top: 16px; right: 16px; padding: 6px 14px; border-radius: 50px; font-size: 10px; font-weight: 700; letter-spacing: 1px; z-index: 5; }
        .status-available { background: rgba(74,222,128,0.2); color: #4ade80; border: 1px solid rgba(74,222,128,0.3); }
        .status-occupied { background: rgba(248,113,113,0.2); color: #f87171; border: 1px solid rgba(248,113,113,0.3); }
        .room-info { padding: 24px; flex-grow: 1; display: flex; flex-direction: column; }
        .room-price { color: var(--gold); font-family: 'Playfair Display', serif; font-size: 24px; font-weight: 700; margin-bottom: 4px; }
        .room-price span { font-size: 12px; font-family: 'Inter', sans-serif; color: var(--text-muted); font-weight: 400; }
        .room-name { font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 600; color: #fff; margin-bottom: 12px; }
        .room-type { font-size: 10px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 2px; margin-bottom: 16px; display: block; }
        .room-details { display: flex; gap: 16px; margin-bottom: 20px; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 16px; }
        .detail-item { display: flex; align-items: center; gap: 6px; font-size: 12px; color: rgba(255,255,255,0.5); }
        .room-actions { display: flex; gap: 12px; margin-top: auto; }
        .btn-card { flex: 1; padding: 10px 16px; border-radius: 12px; font-size: 12.5px; font-weight: 600; text-align: center; text-decoration: none; transition: all 0.2s; }
        .btn-booking { background: var(--gold); color: var(--dark); border: 1.5px solid var(--gold); }
        .btn-booking:hover { background: var(--gold-light); border-color: var(--gold-light); }
        .btn-view-detail { background: transparent; color: #fff; border: 1.5px solid rgba(255,255,255,0.15); }
        .btn-view-detail:hover { border-color: var(--gold); color: var(--gold); }
        
        .no-results { grid-column: 1 / -1; text-align: center; padding: 100px 20px; }
        .no-results h3 { font-family: 'Playfair Display', serif; font-size: 28px; color: #fff; margin-bottom: 12px; }
        .no-results p { color: var(--text-muted); }

        /* Footer */
        footer { background: #060608; border-top: 1px solid rgba(201,168,76,0.1); padding: 40px 48px; text-align: center; }
        .footer-logo { font-family: 'Playfair Display', serif; font-size: 20px; color: #fff; margin-bottom: 12px; }
        .footer-logo span { color: var(--gold); }
        .footer-text { font-size: 12px; color: var(--text-muted); margin-bottom: 8px; }

        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .nav-links { display: none; }
            .page-header { padding: 120px 20px 40px; }
            .page-title { font-size: 32px; }
            .filter-section { padding: 0 20px; }
            .room-grid { padding: 40px 20px; grid-template-columns: 1fr; }
            .filter-bar { padding: 20px; flex-direction: column; align-items: stretch; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="active">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a></li>
    </ul>
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <span class="nav-greeting hidden sm:inline">Xin chào, <strong>${sessionScope.account.fullName}</strong></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-nav-auth btn-login">Đăng Xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-nav-auth btn-login">Đăng Nhập</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn-nav-auth btn-register">Đăng Ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<header class="page-header">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a> / <span>Danh sách phòng</span>
    </div>
    <h1 class="page-title">Khám Phá <em>Không Gian Nghỉ Dưỡng</em></h1>
</header>

<section class="filter-section">
    <form action="${pageContext.request.contextPath}/rooms" method="GET" class="filter-bar">
        <div class="filter-group">
            <span class="filter-label">Tìm kiếm</span>
            <input type="text" name="searchName" value="${param.searchName}" class="filter-input" placeholder="Tên phòng...">
        </div>
        <div class="filter-group">
            <span class="filter-label">Loại phòng</span>
            <select name="searchType" class="filter-input">
                <option value="">Tất cả loại phòng</option>
                <option value="Room" ${param.searchType == 'Room' ? 'selected' : ''}>Phòng (Room)</option>
                <option value="House" ${param.searchType == 'House' ? 'selected' : ''}>Nhà (House)</option>
                <option value="Villa" ${param.searchType == 'Villa' ? 'selected' : ''}>Biệt thự (Villa)</option>
            </select>
        </div>
        <div class="filter-group">
            <span class="filter-label">Trạng thái</span>
            <select name="searchStatus" class="filter-input">
                <option value="">Tất cả trạng thái</option>
                <option value="Available" ${param.searchStatus == 'Available' ? 'selected' : ''}>Còn trống</option>
                <option value="Occupied" ${param.searchStatus == 'Occupied' ? 'selected' : ''}>Đang ở</option>
                <option value="Maintenance" ${param.searchStatus == 'Maintenance' ? 'selected' : ''}>Bảo trì</option>
            </select>
        </div>
        <button type="submit" class="btn-filter">Tìm Kiếm</button>
    </form>
</section>

<div class="room-grid">
    <c:choose>
        <c:when test="${not empty pagedFacilities}">
            <c:forEach var="f" items="${pagedFacilities}">
                <div class="room-card">
                    <span class="status-badge ${f.status == 'Available' ? 'status-available' : 'status-occupied'}">
                        ${f.status == 'Available' ? 'Còn Trống' : (f.status == 'Occupied' ? 'Đã Đặt' : 'Bảo Trì')}
                    </span>
                    <div class="room-img-wrap">
                        <img src="${f.imageUrl}" alt="${f.serviceName}" class="room-img" onerror="this.src='https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=800&q=40'">
                        <div class="absolute inset-0 bg-gradient-to-t from-dark via-transparent to-transparent opacity-60"></div>
                    </div>
                    <div class="room-info">
                        <span class="room-type">${f.facilityType}</span>
                        <h3 class="room-name">${f.serviceName}</h3>
                        <div class="room-price">
                            <fmt:formatNumber value="${f.cost}" type="number" groupingUsed="true"/> đ <span>/ đêm</span>
                        </div>
                        <div class="room-details">
                            <div class="detail-item">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                                ${f.usableArea} m²
                            </div>
                            <div class="detail-item">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                                Tối đa ${f.maxPeople}
                            </div>
                        </div>
                        <div class="room-actions">
                            <a href="${pageContext.request.contextPath}/facility-detail?id=${f.serviceCode}" class="btn-card btn-view-detail">Chi Tiết</a>
                            <c:if test="${f.status == 'Available'}">
                                <a href="${pageContext.request.contextPath}/booking?id=${f.serviceCode}" class="btn-card btn-booking">Đặt Ngay</a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="no-results">
                <h3>Không tìm thấy phòng</h3>
                <p>Thử thay đổi bộ lọc hoặc tiêu chí tìm kiếm để có nhiều lựa chọn hơn.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer>
    <div class="footer-logo">Azure <span>Resort</span> &amp; Spa</div>
    <div class="footer-text">© 2026 Azure Resort &amp; Spa. Bản quyền được bảo lưu.</div>
    <div class="footer-text">Kiến tạo trải nghiệm đẳng cấp bởi Azure Team</div>
</footer>

</body>
</html>
