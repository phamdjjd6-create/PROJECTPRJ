<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    TblPersons acc = (TblPersons) session.getAttribute("account");
    if (acc == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    boolean isAdmin = (acc instanceof TblEmployees) && "ADMIN".equals(((TblEmployees)acc).getRole());
    pageContext.setAttribute("isAdmin", isAdmin);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Phòng &amp; Villa — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        :root{--gold:#c9a84c;--gold-light:#e8cc82;--dark:#0a0a0f;--navy:#0d1526;--card:rgba(255,255,255,0.03);--border:rgba(255,255,255,0.07);--text:#e8e8e8;--muted:rgba(255,255,255,0.45);--sidebar-w:256px}
        body{font-family:'Inter',sans-serif;background:var(--dark);color:var(--text);min-height:100vh;display:flex}
        .sidebar{width:var(--sidebar-w);flex-shrink:0;background:#080c14;border-right:1px solid rgba(201,168,76,0.12);display:flex;flex-direction:column;position:fixed;top:0;left:0;bottom:0;z-index:100}
        .sidebar-brand{padding:28px 24px 22px;border-bottom:1px solid rgba(201,168,76,0.1)}
        .brand-logo{font-family:'Playfair Display',serif;font-size:19px;font-weight:700;color:#fff}
        .brand-logo span{color:var(--gold)}
        .brand-tag{display:inline-block;margin-top:8px;font-size:9px;letter-spacing:2.5px;text-transform:uppercase;color:var(--dark);background:var(--gold);padding:3px 10px;border-radius:4px;font-weight:700}
        .sidebar-user{padding:18px 24px;border-bottom:1px solid rgba(255,255,255,0.05);display:flex;align-items:center;gap:12px}
        .user-avatar{width:38px;height:38px;border-radius:10px;background:linear-gradient(135deg,var(--gold),var(--gold-light));display:flex;align-items:center;justify-content:center;font-size:15px;font-weight:700;color:var(--dark);flex-shrink:0}
        .user-name{font-size:13px;font-weight:600;color:#fff}
        .user-role{font-size:11px;color:var(--gold);margin-top:2px}
        .sidebar-nav{flex:1;padding:12px 0;overflow-y:auto}
        .nav-section{padding:16px 24px 6px;font-size:9.5px;color:rgba(255,255,255,0.25);letter-spacing:2px;text-transform:uppercase;font-weight:600}
        .nav-item{display:flex;align-items:center;gap:10px;padding:10px 24px;color:rgba(255,255,255,0.55);text-decoration:none;font-size:13px;font-weight:500;transition:all 0.18s;border-left:2px solid transparent}
        .nav-item:hover{background:rgba(255,255,255,0.04);color:rgba(255,255,255,0.9)}
        .nav-item.active{background:rgba(201,168,76,0.08);color:var(--gold);border-left-color:var(--gold)}
        .nav-dot{width:5px;height:5px;border-radius:50%;background:rgba(255,255,255,0.2);flex-shrink:0}
        .nav-item.active .nav-dot{background:var(--gold)}
        .sidebar-footer{padding:16px 24px;border-top:1px solid rgba(255,255,255,0.05)}
        .btn-logout{display:flex;align-items:center;gap:10px;color:rgba(248,113,113,0.6);font-size:13px;text-decoration:none;padding:8px 0;transition:color 0.2s}
        .btn-logout:hover{color:#f87171}
        .main{margin-left:var(--sidebar-w);flex:1;display:flex;flex-direction:column;min-height:100vh}
        .topbar{height:60px;background:rgba(8,12,20,0.97);border-bottom:1px solid rgba(201,168,76,0.08);display:flex;align-items:center;justify-content:space-between;padding:0 36px;position:sticky;top:0;z-index:50;backdrop-filter:blur(20px)}
        .topbar-title{font-family:'Playfair Display',serif;font-size:17px;color:#fff}
        .content{padding:32px 36px 60px;flex:1}
        .section-label{font-size:9.5px;color:var(--gold);letter-spacing:2.5px;text-transform:uppercase;font-weight:600;margin-bottom:4px}
        .section-title{font-family:'Playfair Display',serif;font-size:22px;color:#fff;margin-bottom:24px}
        .flash{padding:14px 20px;border-radius:10px;margin-bottom:20px;font-size:13.5px;font-weight:500}
        .flash-success{background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.25);color:#4ade80}
        .flash-error{background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.25);color:#f87171}
    </style>
    <style>
        .stats-row{display:flex;gap:16px;margin-bottom:24px;flex-wrap:wrap}
        .stat-pill{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:14px 22px;display:flex;align-items:center;gap:14px;cursor:pointer;text-decoration:none;transition:all 0.2s}
        .stat-pill:hover{border-color:rgba(201,168,76,0.3)}
        .stat-pill .num{font-family:'Playfair Display',serif;font-size:26px;font-weight:700}
        .stat-pill .lbl{font-size:12px;color:var(--muted)}
        .stat-pill.green .num{color:#4ade80}
        .stat-pill.red .num{color:#f87171}
        .stat-pill.yellow .num{color:#fbbf24}
        .stat-pill.blue .num{color:#60a5fa}
        .toolbar{display:flex;align-items:center;gap:12px;margin-bottom:20px;flex-wrap:wrap}
        .search-box{display:flex;align-items:center;gap:8px;background:rgba(255,255,255,0.05);border:1px solid var(--border);border-radius:10px;padding:8px 14px;flex:1;min-width:200px;max-width:360px}
        .search-box input{background:none;border:none;outline:none;color:#fff;font-size:13.5px;width:100%}
        .search-box input::placeholder{color:var(--muted)}
        .filter-tabs{display:flex;gap:8px;flex-wrap:wrap}
        .tab{padding:7px 16px;border-radius:50px;font-size:12.5px;font-weight:600;border:1.5px solid var(--border);color:var(--muted);background:transparent;cursor:pointer;transition:all 0.2s;text-decoration:none}
        .tab:hover{border-color:rgba(201,168,76,0.4);color:var(--gold)}
        .tab.active{background:var(--gold);color:var(--dark);border-color:var(--gold)}
        .facility-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:20px}
        .facility-card{background:var(--card);border:1px solid var(--border);border-radius:18px;overflow:hidden;transition:all 0.3s;position:relative}
        .facility-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:rgba(255,255,255,0.05);transition:background 0.3s}
        .facility-card.type-villa::before{background:linear-gradient(90deg,var(--gold),var(--gold-light))}
        .facility-card.type-house::before{background:linear-gradient(90deg,#60a5fa,#3b82f6)}
        .facility-card.type-room::before{background:linear-gradient(90deg,#a78bfa,#7c3aed)}
        .facility-card:hover{border-color:rgba(201,168,76,0.25);transform:translateY(-3px);box-shadow:0 12px 32px rgba(0,0,0,0.3)}
        .card-header{padding:18px 20px 14px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:flex-start}
        .facility-code{font-family:'Playfair Display',serif;font-size:18px;font-weight:700;color:#fff;letter-spacing:0.3px}
        .facility-name{font-size:11.5px;color:var(--muted);margin-top:3px}
        .badge{display:inline-block;padding:3px 9px;border-radius:4px;font-size:10px;font-weight:700;letter-spacing:0.5px}
        .badge-available{background:rgba(74,222,128,0.12);color:#4ade80}
        .badge-occupied{background:rgba(248,113,113,0.12);color:#f87171}
        .badge-maintenance{background:rgba(251,191,36,0.12);color:#fbbf24}
        .badge-cleaning{background:rgba(96,165,250,0.12);color:#60a5fa}
        .badge-villa{background:rgba(201,168,76,0.15);color:var(--gold);border:1px solid rgba(201,168,76,0.2)}
        .badge-house{background:rgba(96,165,250,0.12);color:#60a5fa}
        .badge-room{background:rgba(167,139,250,0.12);color:#a78bfa}
        .card-body{padding:16px 20px}
        .info-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:14px}
        .info-item{background:rgba(255,255,255,0.02);border-radius:8px;padding:8px 10px}
        .info-item .lbl{font-size:9px;color:rgba(255,255,255,0.3);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:4px;font-weight:600}
        .info-item .val{font-size:13px;color:#fff;font-weight:600}
        .info-item .val.gold{color:var(--gold);font-family:'Playfair Display',serif;font-size:14px}
        .card-actions{display:flex;gap:6px;flex-wrap:wrap;padding-top:12px;border-top:1px solid var(--border)}
        .btn-sm{padding:6px 13px;border-radius:6px;font-size:11.5px;font-weight:600;border:none;cursor:pointer;transition:all 0.2s;font-family:'Inter',sans-serif;letter-spacing:0.2px}
        .btn-available{background:rgba(74,222,128,0.1);color:#4ade80;border:1px solid rgba(74,222,128,0.25)}
        .btn-available:hover{background:#4ade80;color:#000;border-color:#4ade80}
        .btn-maintenance{background:rgba(251,191,36,0.1);color:#fbbf24;border:1px solid rgba(251,191,36,0.25)}
        .btn-maintenance:hover{background:#fbbf24;color:#000;border-color:#fbbf24}
        .btn-cleaning{background:rgba(96,165,250,0.1);color:#60a5fa;border:1px solid rgba(96,165,250,0.25)}
        .btn-cleaning:hover{background:#60a5fa;color:#000;border-color:#60a5fa}
        .btn-disabled{opacity:0.3;cursor:not-allowed;pointer-events:none}
        .status-notice{border-radius:8px;padding:9px 12px;font-size:11.5px;margin-bottom:12px;display:flex;align-items:center;gap:6px}
        .notice-red{background:rgba(248,113,113,0.06);border:1px solid rgba(248,113,113,0.18);color:#f87171}
        .notice-blue{background:rgba(96,165,250,0.06);border:1px solid rgba(96,165,250,0.18);color:#60a5fa}
        .notice-yellow{background:rgba(251,191,36,0.06);border:1px solid rgba(251,191,36,0.18);color:#fbbf24}
        .empty{padding:60px;text-align:center;color:var(--muted)}
        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .actions-grid { grid-template-columns: repeat(2, 1fr); }
            .facility-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; z-index: 200; }
            .sidebar.open { transform: translateX(0); }
            .main { margin-left: 0 !important; }
            .topbar { padding: 0 16px; }
            .content { padding: 20px 16px 40px; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
            .actions-grid { grid-template-columns: 1fr; }
            .stats-row { flex-direction: column; }
            .table-card { overflow-x: auto; }
            table { min-width: 600px; }
            .facility-grid { grid-template-columns: 1fr; }
            .section-title { font-size: 18px; }
            .topbar-title { font-size: 15px; }
            #menuToggle { display: block !important; }
            .filter-tabs { overflow-x: auto; flex-wrap: nowrap; padding-bottom: 4px; }
            .toolbar { flex-direction: column; align-items: stretch; }
            .search-box { max-width: 100%; }
        }
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-logo">Azure <span>Resort</span></div>
        <div class="brand-tag">${isAdmin ? 'Admin Panel' : 'Staff Portal'}</div>
    </div>
    <div class="sidebar-user">
        <div class="user-avatar">${acc.fullName.substring(0,1)}</div>
        <div>
            <div class="user-name">${acc.fullName}</div>
            <div class="user-role">${isAdmin ? 'Quản Trị Viên' : 'Nhân Viên'}</div>
        </div>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">Tổng Quan</div>
        <a href="${pageContext.request.contextPath}/dashboard/${isAdmin ? 'admin' : 'staff'}" class="nav-item">
            <span class="nav-dot"></span> Dashboard
        </a>
        <div class="nav-section">Vận Hành</div>
        <a href="${pageContext.request.contextPath}/dashboard/bookings" class="nav-item">
            <span class="nav-dot"></span> Booking
        </a>
        <a href="${pageContext.request.contextPath}/dashboard/contracts" class="nav-item">
            <span class="nav-dot"></span> Hợp Đồng
        </a>
        <div class="nav-section">Quản Lý</div>
        <a href="${pageContext.request.contextPath}/dashboard/users" class="nav-item">
            <span class="nav-dot"></span> Người Dùng
        </a>
        <a href="${pageContext.request.contextPath}/dashboard/facilities" class="nav-item active">
            <span class="nav-dot"></span> Phòng &amp; Villa
        </a>
        <div class="nav-section">Cá Nhân</div>
        <a href="${pageContext.request.contextPath}/profile" class="nav-item">
            <span class="nav-dot"></span> Hồ Sơ
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/" class="btn-logout" style="color:rgba(201,168,76,0.7);margin-bottom:6px">Trang Chủ</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng Xuất</a>
    </div>
</aside>

<div class="main">
    <div class="topbar">
        <button id="menuToggle" style="display:none;background:none;border:none;color:#fff;font-size:22px;cursor:pointer;padding:4px 8px">☰</button>
        <div class="topbar-title">Quản Lý Phòng &amp; Villa</div>
        <span style="font-size:12px;color:var(--muted)" id="topbarDate"></span>
    </div>
    <div class="content">
        <div class="section-label">Quản Lý</div>
        <div class="section-title">Phòng &amp; Villa</div>

        <c:if test="${not empty flashMsg}">
            <c:choose>
                <c:when test="${fn:startsWith(flashMsg, '✅')}"><div class="flash flash-success">${flashMsg}</div></c:when>
                <c:otherwise><div class="flash flash-error">${flashMsg}</div></c:otherwise>
            </c:choose>
        </c:if>

        <div class="stats-row">
            <a href="?type=ALL&status=AVAILABLE" class="stat-pill green">
                <div><div class="num">${cntAvailable}</div><div class="lbl">Trống</div></div>
            </a>
            <a href="?type=ALL&status=OCCUPIED" class="stat-pill red">
                <div><div class="num">${cntOccupied}</div><div class="lbl">Đang Thuê</div></div>
            </a>
            <a href="?type=ALL&status=MAINTENANCE" class="stat-pill yellow">
                <div><div class="num">${cntMaintenance}</div><div class="lbl">Bảo Trì</div></div>
            </a>
            <a href="?type=ALL&status=CLEANING" class="stat-pill blue">
                <div><div class="num">${cntCleaning}</div><div class="lbl">Dọn Dẹp</div></div>
            </a>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/dashboard/facilities">
            <div class="toolbar">
                <div class="search-box">
                    <span>🔍</span>
                    <input type="text" name="q" placeholder="Tìm mã phòng, tên..." value="${search}">
                </div>
                <div class="filter-tabs">
                    <a href="?type=ALL" class="tab ${(empty typeFilter || typeFilter == 'ALL') ? 'active' : ''}">Tất Cả</a>
                    <a href="?type=VILLA" class="tab ${typeFilter == 'VILLA' ? 'active' : ''}">Villa</a>
                    <a href="?type=HOUSE" class="tab ${typeFilter == 'HOUSE' ? 'active' : ''}">House</a>
                    <a href="?type=ROOM" class="tab ${typeFilter == 'ROOM' ? 'active' : ''}">Phòng</a>
                </div>
            </div>
        </form>

        <c:choose>
            <c:when test="${not empty facilities}">
                <div class="facility-grid">
                <c:forEach var="f" items="${facilities}">
                    <c:choose>
                        <c:when test="${f.status == 'AVAILABLE'}"><c:set var="badgeSt" value="badge-available"/><c:set var="stLbl" value="Trống"/></c:when>
                        <c:when test="${f.status == 'OCCUPIED'}"><c:set var="badgeSt" value="badge-occupied"/><c:set var="stLbl" value="Đang Thuê"/></c:when>
                        <c:when test="${f.status == 'MAINTENANCE'}"><c:set var="badgeSt" value="badge-maintenance"/><c:set var="stLbl" value="Bảo Trì"/></c:when>
                        <c:when test="${f.status == 'CLEANING'}"><c:set var="badgeSt" value="badge-cleaning"/><c:set var="stLbl" value="Dọn Dẹp"/></c:when>
                        <c:otherwise><c:set var="badgeSt" value="badge-available"/><c:set var="stLbl" value="${f.status}"/></c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${f.facilityType == 'VILLA'}"><c:set var="typeBadge" value="badge-villa"/><c:set var="typeLbl" value="Villa"/><c:set var="typeClass" value="type-villa"/></c:when>
                        <c:when test="${f.facilityType == 'HOUSE'}"><c:set var="typeBadge" value="badge-house"/><c:set var="typeLbl" value="House"/><c:set var="typeClass" value="type-house"/></c:when>
                        <c:otherwise><c:set var="typeBadge" value="badge-room"/><c:set var="typeLbl" value="Phòng"/><c:set var="typeClass" value="type-room"/></c:otherwise>
                    </c:choose>
                    <div class="facility-card ${typeClass}">
                        <div class="card-header">
                            <div>
                                <div class="facility-code">${f.serviceCode}</div>
                                <div class="facility-name">${f.serviceName}</div>
                            </div>
                            <div style="display:flex;flex-direction:column;gap:6px;align-items:flex-end">
                                <span class="badge ${badgeSt}">${stLbl}</span>
                                <span class="badge ${typeBadge}">${typeLbl}</span>
                            </div>
                        </div>
                        <div class="card-body">
                            <c:if test="${f.status == 'OCCUPIED'}">
                                <div class="status-notice notice-red">🔴 Đang có khách — không thể thay đổi trạng thái</div>
                            </c:if>
                            <c:if test="${f.status == 'MAINTENANCE'}">
                                <div class="status-notice notice-yellow">🔧 Đang bảo trì</div>
                            </c:if>
                            <c:if test="${f.status == 'CLEANING'}">
                                <div class="status-notice notice-blue">🧹 Đang dọn dẹp</div>
                            </c:if>
                            <div class="info-row">
                                <div class="info-item">
                                    <div class="lbl">Giá</div>
                                    <div class="val gold"><fmt:formatNumber value="${f.cost}" type="number" groupingUsed="true"/> đ</div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Sức Chứa</div>
                                    <div class="val">${f.maxPeople} người</div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Diện Tích</div>
                                    <div class="val">${f.usableArea} m²</div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Loại Thuê</div>
                                    <div class="val">${f.rentalType}</div>
                                </div>
                            </div>
                            <div class="card-actions">
                                <c:if test="${f.status != 'OCCUPIED'}">
                                <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                    <input type="hidden" name="action" value="facility_status">
                                    <input type="hidden" name="facilityId" value="${f.serviceCode}">
                                    <input type="hidden" name="status" value="AVAILABLE">
                                    <button type="submit" class="btn-sm btn-available ${f.status == 'AVAILABLE' ? 'btn-disabled' : ''}">✓ Trống</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                    <input type="hidden" name="action" value="facility_status">
                                    <input type="hidden" name="facilityId" value="${f.serviceCode}">
                                    <input type="hidden" name="status" value="MAINTENANCE">
                                    <button type="submit" class="btn-sm btn-maintenance ${f.status == 'MAINTENANCE' ? 'btn-disabled' : ''}">🔧 Bảo Trì</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                    <input type="hidden" name="action" value="facility_status">
                                    <input type="hidden" name="facilityId" value="${f.serviceCode}">
                                    <input type="hidden" name="status" value="CLEANING">
                                    <button type="submit" class="btn-sm btn-cleaning ${f.status == 'CLEANING' ? 'btn-disabled' : ''}">🧹 Dọn Dẹp</button>
                                </form>
                                </c:if>
                                <c:if test="${f.status == 'OCCUPIED'}">
                                    <span style="font-size:12px;color:var(--muted)">Không thể thay đổi khi đang có khách</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty"><p>Không có phòng/villa nào</p></div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div id="sidebarOverlay" onclick="document.querySelector('.sidebar').classList.remove('open');this.style.display='none'" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:199"></div>
<script>
    const d = new Date();
    document.getElementById('topbarDate').textContent = d.toLocaleDateString('vi-VN',{weekday:'long',year:'numeric',month:'long',day:'numeric'});
    const menuBtn = document.getElementById('menuToggle');
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    if (menuBtn) {
        menuBtn.addEventListener('click', function() {
            sidebar.classList.toggle('open');
            overlay.style.display = sidebar.classList.contains('open') ? 'block' : 'none';
        });
    }
</script>
</body>
</html>
