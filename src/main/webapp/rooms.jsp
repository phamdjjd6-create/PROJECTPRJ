<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="account" value="${sessionScope.account.fullName}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tất Cả Phòng &amp; Villa — Azure Resort</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --gold: #c9a84c; --gold-light: #e8cc82; --dark: #0a0a0f; --navy: #0d1526; --text: #e8e8e8; --text-muted: rgba(255,255,255,0.5); }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); }

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
        .btn-nav-logout { padding: 8px 20px; border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; background: transparent; color: var(--gold); font-size: 13px; cursor: pointer; transition: all 0.25s; text-decoration: none; }
        .btn-nav-logout:hover { background: var(--gold); color: var(--dark); }
        .btn-nav-login { padding: 8px 24px; background: var(--gold); color: var(--dark); border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; }
        .btn-nav-register { padding: 8px 24px; background: transparent; color: var(--gold); border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; }

        /* PAGE HEADER */
        .page-header { margin-top: 72px; padding: 56px 60px 40px; background: linear-gradient(to bottom, var(--navy), var(--dark)); border-bottom: 1px solid rgba(201,168,76,0.1); }
        .page-header-inner { max-width: 1200px; margin: 0 auto; }
        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--text-muted); margin-bottom: 20px; }
        .breadcrumb a { color: var(--text-muted); text-decoration: none; transition: color 0.2s; }
        .breadcrumb a:hover { color: var(--gold); }
        .breadcrumb .sep { color: rgba(255,255,255,0.2); }
        .section-label { display: inline-block; color: var(--gold); font-size: 11px; letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 10px; }
        .page-title { font-family: 'Playfair Display', serif; font-size: clamp(28px,4vw,44px); color: #fff; margin-bottom: 8px; }
        .page-title em { color: var(--gold); font-style: italic; }
        .page-desc { color: var(--text-muted); font-size: 15px; }

        /* FILTER TABS */
        /* SEARCH BAR */
        .search-bar { background: var(--navy); border-bottom: 1px solid rgba(201,168,76,0.1); padding: 20px 60px; }
        .search-bar-inner { max-width: 1200px; margin: 0 auto; display: flex; align-items: flex-end; gap: 16px; flex-wrap: wrap; }
        .search-field { display: flex; flex-direction: column; gap: 4px; flex: 1; min-width: 130px; }
        .search-field label { font-size: 10px; color: var(--text-muted); letter-spacing: 1.5px; text-transform: uppercase; font-weight: 600; }
        .search-field input, .search-field select { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; padding: 9px 13px; color: #fff; font-size: 13px; font-family: 'Inter', sans-serif; outline: none; width: 100%; transition: border-color 0.2s; }
        .search-field input:focus, .search-field select:focus { border-color: rgba(201,168,76,0.5); }
        .search-field select option { background: var(--navy); }
        .btn-search { padding: 10px 28px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; border-radius: 10px; font-size: 13px; font-weight: 700; font-family: 'Inter', sans-serif; cursor: pointer; white-space: nowrap; transition: all 0.25s; }
        .btn-search:hover { transform: translateY(-2px); }

        /* FILTER TABS */
        .filter-bar { max-width: 1200px; margin: 0 auto; padding: 28px 60px 0; display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .filter-tab { padding: 9px 24px; border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; border: 1.5px solid rgba(255,255,255,0.12); color: rgba(255,255,255,0.6); transition: all 0.25s; }
        .filter-tab:hover { border-color: rgba(201,168,76,0.4); color: var(--gold); }
        .filter-tab.active { background: var(--gold); color: var(--dark); border-color: var(--gold); }
        .filter-count { font-size: 11px; background: rgba(255,255,255,0.1); border-radius: 50px; padding: 2px 8px; margin-left: 6px; }
        .filter-tab.active .filter-count { background: rgba(0,0,0,0.2); }

        /* GRID */
        .rooms-section { max-width: 1200px; margin: 0 auto; padding: 32px 60px 80px; }
        .rooms-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 28px; }

        /* CARD */
        .room-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 20px; overflow: hidden; transition: all 0.35s; }
        .room-card:hover { transform: translateY(-6px); box-shadow: 0 24px 48px rgba(0,0,0,0.4); border-color: rgba(201,168,76,0.2); }
        .room-img-wrap { overflow: hidden; position: relative; height: 220px; }
        .room-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s; }
        .room-card:hover .room-img { transform: scale(1.05); }
        .room-badge { position: absolute; top: 14px; left: 14px; background: var(--gold); color: var(--dark); font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 50px; }
        .status-tag { position: absolute; top: 14px; right: 14px; font-size: 10px; font-weight: 700; padding: 4px 12px; border-radius: 50px; }
        .status-tag.available   { background: rgba(74,222,128,0.15); color: #4ade80; border: 1px solid rgba(74,222,128,0.3); }
        .status-tag.occupied    { background: rgba(248,113,113,0.15); color: #f87171; border: 1px solid rgba(248,113,113,0.3); }
        .status-tag.maintenance { background: rgba(251,191,36,0.15);  color: #fbbf24; border: 1px solid rgba(251,191,36,0.3); }
        .room-body { padding: 22px; }
        .room-type { color: var(--gold); font-size: 11px; letter-spacing: 2px; text-transform: uppercase; font-weight: 600; margin-bottom: 6px; }
        .room-name { font-family: 'Playfair Display', serif; font-size: 20px; color: #fff; margin-bottom: 8px; }
        .room-desc { color: var(--text-muted); font-size: 13px; line-height: 1.6; margin-bottom: 14px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .room-amenities { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px; }
        .amenity { background: rgba(255,255,255,0.05); border-radius: 50px; padding: 3px 12px; font-size: 12px; color: rgba(255,255,255,0.55); }
        .room-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.06); }
        .room-price .price { font-family: 'Playfair Display', serif; font-size: 22px; color: var(--gold); font-weight: 700; }
        .room-price .per { color: var(--text-muted); font-size: 12px; margin-left: 3px; }
        .room-footer-btns { display: flex; gap: 8px; }
        .btn-detail { padding: 8px 16px; background: transparent; border: 1.5px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7); border-radius: 50px; font-size: 12px; font-weight: 500; text-decoration: none; transition: all 0.25s; }
        .btn-detail:hover { border-color: var(--gold); color: var(--gold); }
        .btn-book { padding: 8px 18px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; border-radius: 50px; font-size: 12px; font-weight: 700; text-decoration: none; transition: all 0.25s; }
        .btn-book:hover { transform: scale(1.05); }

        /* EMPTY / ERROR */
        .no-rooms { grid-column: 1/-1; text-align: center; padding: 80px 24px; color: var(--text-muted); }
        .no-rooms p { font-size: 15px; margin-top: 10px; }

        /* STATS */
        .result-info { color: var(--text-muted); font-size: 13px; margin-bottom: 24px; }
        .result-info strong { color: var(--gold); }

        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .page-header { padding: 40px 20px 28px; }
            .filter-bar { padding: 24px 20px 0; }
            .rooms-section { padding: 24px 20px 60px; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="active">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a></li>
    </ul>
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty account}">
                <span class="nav-greeting">Xin chào, <strong>${account}</strong></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-nav-login">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-nav-register">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- PAGE HEADER -->
<div class="page-header">
    <div class="page-header-inner">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
            <span class="sep">›</span>
            <span style="color:var(--gold)">Phòng &amp; Villa</span>
        </div>
        <span class="section-label">Không Gian Nghỉ Dưỡng</span>
        <h1 class="page-title">Tất Cả Phòng &amp; <em>Villa</em></h1>
        <p class="page-desc">Khám phá toàn bộ không gian nghỉ dưỡng tại Azure Resort &amp; Spa</p>
    </div>
</div>

<!-- SEARCH BAR -->
<div class="search-bar">
    <form class="search-bar-inner" action="${pageContext.request.contextPath}/rooms" method="GET">
        <div class="search-field">
            <label>Loại Phòng</label>
            <select name="type">
                <option value="" ${empty filterType ? 'selected' : ''}>Tất cả</option>
                <option value="VILLA" ${filterType == 'VILLA' ? 'selected' : ''}>Villa</option>
                <option value="HOUSE" ${filterType == 'HOUSE' ? 'selected' : ''}>House</option>
                <option value="ROOM"  ${filterType == 'ROOM'  ? 'selected' : ''}>Phòng</option>
            </select>
        </div>
        <div class="search-field">
            <label>Nhận Phòng</label>
            <input type="date" name="checkin" value="${checkin}">
        </div>
        <div class="search-field">
            <label>Trả Phòng</label>
            <input type="date" name="checkout" value="${checkout}">
        </div>
        <div class="search-field">
            <label>Số Người</label>
            <select name="adults">
                <option value="1" ${adults <= 1 ? 'selected' : ''}>1 người</option>
                <option value="2" ${adults == 2 ? 'selected' : ''}>2 người</option>
                <option value="3" ${adults == 3 ? 'selected' : ''}>3 người</option>
                <option value="4" ${adults == 4 ? 'selected' : ''}>4 người</option>
                <option value="5" ${adults == 5 ? 'selected' : ''}>5 người</option>
                <option value="6" ${adults >= 6 ? 'selected' : ''}>6+</option>
            </select>
        </div>
        <button type="submit" class="btn-search">🔍 Tìm Phòng</button>
    </form>
</div>

<!-- FILTER TABS -->
<div class="filter-bar">
    <a href="${pageContext.request.contextPath}/rooms" class="filter-tab ${empty filterType ? 'active' : ''}">
        Tất Cả <span class="filter-count">${cntAll}</span>
    </a>
    <a href="${pageContext.request.contextPath}/rooms?type=VILLA" class="filter-tab ${filterType == 'VILLA' ? 'active' : ''}">
        Villa <span class="filter-count">${cntVilla}</span>
    </a>
    <a href="${pageContext.request.contextPath}/rooms?type=HOUSE" class="filter-tab ${filterType == 'HOUSE' ? 'active' : ''}">
        House <span class="filter-count">${cntHouse}</span>
    </a>
    <a href="${pageContext.request.contextPath}/rooms?type=ROOM" class="filter-tab ${filterType == 'ROOM' ? 'active' : ''}">
        Phòng <span class="filter-count">${cntRoom}</span>
    </a>
</div>

<!-- SEARCH SUMMARY -->
<c:if test="${isSearchMode}">
<div style="max-width:1200px;margin:0 auto;padding:20px 60px 0;display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
    <span style="color:var(--text-muted);font-size:13px;">Kết quả tìm kiếm:</span>
    <c:if test="${not empty checkin}">
        <span style="background:rgba(201,168,76,0.1);border:1px solid rgba(201,168,76,0.25);border-radius:50px;padding:4px 14px;font-size:12px;color:var(--gold)">
            Nhận: ${checkin}
        </span>
    </c:if>
    <c:if test="${not empty checkout}">
        <span style="background:rgba(201,168,76,0.1);border:1px solid rgba(201,168,76,0.25);border-radius:50px;padding:4px 14px;font-size:12px;color:var(--gold)">
            Trả: ${checkout}
        </span>
    </c:if>
    <c:if test="${adults > 1}">
        <span style="background:rgba(201,168,76,0.1);border:1px solid rgba(201,168,76,0.25);border-radius:50px;padding:4px 14px;font-size:12px;color:var(--gold)">
            ${adults} người
        </span>
    </c:if>
    <a href="${pageContext.request.contextPath}/rooms" style="color:rgba(255,255,255,0.4);font-size:12px;text-decoration:none;margin-left:4px;">✕ Xóa bộ lọc</a>
</div>
</c:if>

<!-- ROOMS GRID -->
<div class="rooms-section">
    <c:choose>
        <c:when test="${not empty facilityError}">
            <div class="no-rooms">
                <p style="color:#f87171;">Lỗi tải dữ liệu:</p>
                <p style="color:#fbbf24;font-size:12px;margin-top:8px;">${facilityError}</p>
            </div>
        </c:when>
        <c:otherwise>
            <p class="result-info">
                Tìm thấy <strong>${filteredFacilities.size()}</strong> phòng khả dụng
                <c:if test="${adults > 1}"> · phù hợp <strong>${adults}</strong> người</c:if>
            </p>
            <div class="rooms-grid">
                <c:choose>
                    <c:when test="${empty filteredFacilities}">
                        <div class="no-rooms">
                            <p>Không tìm thấy phòng phù hợp.</p>
                            <p style="font-size:13px;margin-top:8px;"><a href="rooms.jsp" style="color:var(--gold)">Xem tất cả phòng →</a></p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="f" items="${filteredFacilities}" varStatus="loop">
                            <c:set var="imgSrc" value="${not empty f.imageUrl ? f.imageUrl : 'assets/img/hero-bg.png'}"/>
                            <c:choose>
                                <c:when test="${f.facilityType == 'VILLA'}"><c:set var="fTypeLabel" value="Villa"/></c:when>
                                <c:when test="${f.facilityType == 'HOUSE'}"><c:set var="fTypeLabel" value="House"/></c:when>
                                <c:when test="${f.facilityType == 'ROOM'}"><c:set var="fTypeLabel" value="Phòng"/></c:when>
                                <c:otherwise><c:set var="fTypeLabel" value="${f.facilityType}"/></c:otherwise>
                            </c:choose>

                            <div class="room-card">
                                <div class="room-img-wrap">
                                    <img src="${imgSrc}" alt="${f.serviceName}" class="room-img">
                                    <c:if test="${loop.first && empty filterType}">
                                        <span class="room-badge">Phổ Biến Nhất</span>
                                    </c:if>
                                    <span class="status-tag available">Còn Trống</span>
                                </div>
                                <div class="room-body">
                                    <div class="room-type">${fTypeLabel} · ${f.serviceCode}</div>
                                    <h3 class="room-name">${f.serviceName}</h3>
                                    <p class="room-desc"><c:out value="${not empty f.description ? f.description : 'Không gian nghỉ dưỡng sang trọng tại Azure Resort & Spa.'}"/></p>
                                    <div class="room-amenities">
                                        <span class="amenity">${f.maxPeople} người</span>
                                        <span class="amenity">${f.usableArea} m²</span>
                                        <span class="amenity">
                                            <c:choose>
                                                <c:when test="${f.rentalType == 'MONTHLY'}">Theo Tháng</c:when>
                                                <c:when test="${f.rentalType == 'HOURLY'}">Theo Giờ</c:when>
                                                <c:otherwise>Theo Đêm</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="room-footer">
                                        <div class="room-price">
                                            <fmt:formatNumber var="priceStr" value="${f.cost}" type="number" groupingUsed="true"/>
                                            <span class="price">${priceStr}</span>
                                            <span class="per">đ/đêm</span>
                                        </div>
                                        <div class="room-footer-btns">
                                            <a href="facility-detail?code=${f.serviceCode}" class="btn-detail">Chi Tiết</a>
                                            <c:if test="${f.status == 'AVAILABLE'}">
                                                <a href="booking?facility=${f.serviceCode}" class="btn-book">Đặt Ngay</a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer style="background:#060608;border-top:1px solid rgba(201,168,76,0.1);padding:32px 60px;">
    <div style="max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center;color:rgba(255,255,255,0.25);font-size:12.5px;">
        <span>© 2026 <span style="color:var(--gold)">Azure Resort &amp; Spa</span>. All rights reserved.</span>
        <span>Made with ❤️ in Vietnam</span>
    </div>
</footer>

<script>
    window.addEventListener('scroll', () => {
        document.querySelector('.navbar').style.background =
            window.scrollY > 20 ? 'rgba(10,10,15,0.98)' : 'rgba(10,10,15,0.95)';
    });
</script>
</body>
</html>
