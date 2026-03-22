<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    TblPersons acc = (TblPersons) session.getAttribute("account");
    if (acc == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    TblEmployees emp = (acc instanceof TblEmployees) ? (TblEmployees) acc : null;
    String position = (emp != null && emp.getPosition() != null) ? emp.getPosition() : "Quản trị viên";
    pageContext.setAttribute("emp", emp);
    pageContext.setAttribute("position", position);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --gold: #c9a84c; --gold-light: #e8cc82;
            --dark: #0a0a0f; --navy: #0d1526;
            --card: rgba(255,255,255,0.03); --border: rgba(255,255,255,0.07);
            --text: #e8e8e8; --muted: rgba(255,255,255,0.45);
            --sidebar-w: 256px;
        }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); min-height: 100vh; display: flex; }

        /* SIDEBAR */
        .sidebar { width: var(--sidebar-w); flex-shrink: 0; background: #080c14; border-right: 1px solid rgba(201,168,76,0.12); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; bottom: 0; z-index: 100; }
        .sidebar-brand { padding: 28px 24px 22px; border-bottom: 1px solid rgba(201,168,76,0.1); }
        .brand-logo { font-family: 'Playfair Display', serif; font-size: 19px; font-weight: 700; color: #fff; letter-spacing: 0.3px; }
        .brand-logo span { color: var(--gold); }
        .brand-tag { display: inline-block; margin-top: 8px; font-size: 9px; letter-spacing: 2.5px; text-transform: uppercase; color: var(--dark); background: var(--gold); padding: 3px 10px; border-radius: 4px; font-weight: 700; }
        .sidebar-user { padding: 18px 24px; border-bottom: 1px solid rgba(255,255,255,0.05); display: flex; align-items: center; gap: 12px; }
        .user-avatar { width: 38px; height: 38px; border-radius: 10px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); display: flex; align-items: center; justify-content: center; font-size: 15px; font-weight: 700; color: var(--dark); flex-shrink: 0; }
        .user-name { font-size: 13px; font-weight: 600; color: #fff; }
        .user-role { font-size: 11px; color: var(--gold); margin-top: 2px; letter-spacing: 0.3px; }
        .sidebar-nav { flex: 1; padding: 12px 0; overflow-y: auto; }
        .nav-section { padding: 16px 24px 6px; font-size: 9.5px; color: rgba(255,255,255,0.25); letter-spacing: 2px; text-transform: uppercase; font-weight: 600; }
        .nav-item { display: flex; align-items: center; gap: 10px; padding: 10px 24px; color: rgba(255,255,255,0.55); text-decoration: none; font-size: 13px; font-weight: 500; transition: all 0.18s; border-left: 2px solid transparent; }
        .nav-item:hover { background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.9); }
        .nav-item.active { background: rgba(201,168,76,0.08); color: var(--gold); border-left-color: var(--gold); }
        .nav-dot { width: 5px; height: 5px; border-radius: 50%; background: rgba(255,255,255,0.2); flex-shrink: 0; }
        .nav-item.active .nav-dot { background: var(--gold); }
        .sidebar-footer { padding: 16px 24px; border-top: 1px solid rgba(255,255,255,0.05); }
        .btn-logout { display: flex; align-items: center; gap: 10px; color: rgba(248,113,113,0.6); font-size: 13px; text-decoration: none; padding: 8px 0; transition: color 0.2s; }
        .btn-logout:hover { color: #f87171; }

        /* MAIN */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .topbar { height: 60px; background: rgba(8,12,20,0.97); border-bottom: 1px solid rgba(201,168,76,0.08); display: flex; align-items: center; justify-content: space-between; padding: 0 36px; position: sticky; top: 0; z-index: 50; backdrop-filter: blur(20px); }
        .topbar-title { font-family: 'Playfair Display', serif; font-size: 17px; color: #fff; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .topbar-date { font-size: 12px; color: var(--muted); }
        .role-badge { background: rgba(201,168,76,0.12); color: var(--gold); font-size: 10px; font-weight: 700; padding: 4px 12px; border-radius: 4px; letter-spacing: 1.5px; text-transform: uppercase; border: 1px solid rgba(201,168,76,0.2); }
        .content { padding: 32px 36px 60px; flex: 1; }

        /* STATS */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--card); border: 1px solid var(--border); border-radius: 16px; padding: 22px 24px; transition: all 0.25s; }
        .stat-card:hover { border-color: rgba(201,168,76,0.18); transform: translateY(-2px); }
        .stat-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
        .stat-indicator { width: 8px; height: 8px; border-radius: 50%; margin-top: 4px; }
        .ind-gold { background: var(--gold); }
        .ind-blue { background: #60a5fa; }
        .ind-green { background: #4ade80; }
        .ind-red { background: #f87171; }
        .stat-trend { font-size: 10.5px; padding: 3px 8px; border-radius: 4px; font-weight: 600; }
        .trend-up { background: rgba(74,222,128,0.1); color: #4ade80; }
        .stat-num { font-family: 'Playfair Display', serif; font-size: 30px; font-weight: 700; color: #fff; line-height: 1; }
        .stat-label { font-size: 11.5px; color: var(--muted); margin-top: 6px; }

        /* REVENUE */
        .revenue-card { background: linear-gradient(135deg, rgba(201,168,76,0.07), rgba(13,21,38,0.6)); border: 1px solid rgba(201,168,76,0.18); border-radius: 16px; padding: 28px; margin-bottom: 28px; }
        .revenue-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .revenue-num { font-family: 'Playfair Display', serif; font-size: 38px; font-weight: 700; color: var(--gold); }
        .revenue-label { font-size: 11.5px; color: var(--muted); margin-top: 4px; }
        .revenue-bars { display: flex; gap: 6px; align-items: flex-end; height: 52px; }
        .rev-bar { flex: 1; background: rgba(201,168,76,0.1); border-radius: 3px 3px 0 0; min-height: 6px; }
        .rev-bar.active { background: linear-gradient(to top, var(--gold), var(--gold-light)); }

        /* SECTION */
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: 19px; color: #fff; }
        .section-label { font-size: 9.5px; color: var(--gold); letter-spacing: 2.5px; text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
        .link-more { color: var(--gold); font-size: 12.5px; text-decoration: none; opacity: 0.8; transition: opacity 0.2s; }
        .link-more:hover { opacity: 1; }

        /* ACTIONS GRID */
        .actions-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 28px; }
        .action-card { background: var(--card); border: 1px solid var(--border); border-radius: 14px; padding: 22px 18px; text-decoration: none; transition: all 0.25s; display: block; }
        .action-card:hover { background: rgba(201,168,76,0.05); border-color: rgba(201,168,76,0.22); transform: translateY(-3px); box-shadow: 0 10px 28px rgba(0,0,0,0.25); }
        .action-line { width: 28px; height: 2px; background: var(--gold); border-radius: 2px; margin-bottom: 14px; opacity: 0.6; }
        .action-title { font-size: 13px; font-weight: 600; color: #fff; margin-bottom: 5px; }
        .action-desc { font-size: 11.5px; color: var(--muted); line-height: 1.5; }
        .action-arrow { display: inline-block; color: var(--gold); font-size: 11px; font-weight: 600; margin-top: 10px; opacity: 0.7; }

        /* TABLE */
        .table-card { background: var(--card); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th { padding: 11px 20px; text-align: left; font-size: 9.5px; color: var(--muted); letter-spacing: 1.5px; text-transform: uppercase; font-weight: 600; border-bottom: 1px solid var(--border); }
        td { padding: 13px 20px; font-size: 13px; color: var(--text); border-bottom: 1px solid rgba(255,255,255,0.04); }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(255,255,255,0.02); }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 4px; font-size: 10.5px; font-weight: 600; letter-spacing: 0.5px; }
        .badge-admin { background: rgba(201,168,76,0.12); color: var(--gold); }
        .badge-staff { background: rgba(96,165,250,0.12); color: #60a5fa; }
        .badge-active { background: rgba(74,222,128,0.12); color: #4ade80; }

        /* MODAL */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.8); z-index: 999; backdrop-filter: blur(5px); justify-content: center; align-items: center; }
        .modal-overlay.active { display: flex; }
        .modal-content { background: var(--dark); border: 1px solid var(--border); border-radius: 16px; padding: 28px; width: 90%; max-width: 800px; position: relative; }
        .modal-close { position: absolute; top: 16px; right: 20px; color: var(--muted); font-size: 28px; cursor: pointer; border: none; background: none; transition: color 0.2s; }
        .modal-close:hover { color: #fff; }

        @media (max-width: 1200px) { .stats-grid { grid-template-columns: repeat(2,1fr); } .actions-grid { grid-template-columns: repeat(2,1fr); } }
        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .actions-grid { grid-template-columns: repeat(2, 1fr); }
            .revenue-top { flex-direction: column; gap: 16px; }
        }
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; z-index: 200; display: flex !important; }
            .sidebar.open { transform: translateX(0); }
            .main { margin-left: 0 !important; }
            .topbar { padding: 0 16px; }
            .topbar-right { gap: 8px; }
            .topbar-right .topbar-date { display: none; }
            .content { padding: 20px 16px 40px; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
            .actions-grid { grid-template-columns: 1fr; }
            .table-card { overflow-x: auto; }
            table { min-width: 600px; }
            .section-title { font-size: 18px; }
            .topbar-title { font-size: 15px; }
            #menuToggle { display: block !important; }
            .revenue-num { font-size: 28px; }
            .modal-content { padding: 20px 16px; }
            /* Report modal responsive */
            #reportModal > div { padding: 24px 16px !important; }
            #reportModal [style*="grid-template-columns:repeat(4"] { grid-template-columns: repeat(2,1fr) !important; }
            #reportModal [style*="grid-template-columns:repeat(2"] { grid-template-columns: 1fr !important; }
            #reportModal [style*="display:flex;justify-content:space-between"] { flex-direction: column !important; gap: 12px !important; }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-logo">Azure <span>Resort</span></div>
        <div class="brand-tag">Admin Panel</div>
    </div>
    <div class="sidebar-user">
        <div class="user-avatar">${acc.fullName.substring(0,1)}</div>
        <div>
            <div class="user-name">${acc.fullName}</div>
            <div class="user-role">Quản Trị Viên</div>
        </div>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">Tổng Quan</div>
        <a href="${pageContext.request.contextPath}/dashboard/admin" class="nav-item active">
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
        <a href="${pageContext.request.contextPath}/dashboard/facilities" class="nav-item">
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
        <div class="topbar-title">Admin Dashboard</div>
        <div class="topbar-right">
            <span class="topbar-date" id="topbarDate"></span>
            <div style="display:flex;gap:8px">
                <a href="${pageContext.request.contextPath}/dashboard/export?type=bookings"
                   style="padding:6px 14px;background:rgba(201,168,76,0.1);border:1px solid rgba(201,168,76,0.3);border-radius:8px;color:var(--gold);font-size:11.5px;font-weight:600;text-decoration:none;transition:all 0.2s"
                   onmouseover="this.style.background='rgba(201,168,76,0.2)'" onmouseout="this.style.background='rgba(201,168,76,0.1)'">
                    Xuất Booking
                </a>
                <a href="${pageContext.request.contextPath}/dashboard/export?type=contracts"
                   style="padding:6px 14px;background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.25);border-radius:8px;color:#4ade80;font-size:11.5px;font-weight:600;text-decoration:none;transition:all 0.2s"
                   onmouseover="this.style.background='rgba(74,222,128,0.15)'" onmouseout="this.style.background='rgba(74,222,128,0.08)'">
                    Xuất HĐ
                </a>
                <a href="${pageContext.request.contextPath}/dashboard/export?type=facilities"
                   style="padding:6px 14px;background:rgba(96,165,250,0.08);border:1px solid rgba(96,165,250,0.25);border-radius:8px;color:#60a5fa;font-size:11.5px;font-weight:600;text-decoration:none;transition:all 0.2s"
                   onmouseover="this.style.background='rgba(96,165,250,0.15)'" onmouseout="this.style.background='rgba(96,165,250,0.08)'">
                    Xuất Phòng
                </a>
            </div>
            <span class="role-badge">Admin</span>
        </div>
    </div>

    <div class="content">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-indicator ind-gold"></span>
                    <span class="stat-trend trend-up">Chờ xử lý</span>
                </div>
                <div class="stat-num">${cntPending != null ? cntPending : '0'}</div>
                <div class="stat-label">Booking Chờ Duyệt</div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-indicator ind-blue"></span>
                    <span class="stat-trend trend-up">Đang ở</span>
                </div>
                <div class="stat-num">${cntCheckedIn != null ? cntCheckedIn : '0'}</div>
                <div class="stat-label">Khách Đang Check-in</div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-indicator ind-green"></span>
                    <span class="stat-trend trend-up">Sẵn sàng</span>
                </div>
                <div class="stat-num">${cntAvailable != null ? cntAvailable : '0'}</div>
                <div class="stat-label">Phòng Khả Dụng</div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-indicator ind-red"></span>
                    <span class="stat-trend trend-up">Hiệu lực</span>
                </div>
                <div class="stat-num">${cntActiveContracts != null ? cntActiveContracts : '0'}</div>
                <div class="stat-label">Hợp Đồng Active</div>
            </div>
        </div>

        <div class="revenue-card">
            <div class="revenue-top">
                <div>
                    <div class="section-label">Doanh Thu</div>
                    <div class="revenue-num">
                        <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" pattern="#,###"/> đ
                    </div>
                    <div class="revenue-label">Tổng doanh thu · Azure Resort &amp; Spa</div>
                </div>
                <div style="display:flex;flex-direction:column;align-items:flex-end;gap:12px">
                    <a href="javascript:void(0)" onclick="openReport()" class="link-more">Xem báo cáo đầy đủ →</a>
                    <div style="display:flex;gap:20px;text-align:center">
                        <div><div style="font-family:'Playfair Display',serif;font-size:22px;color:#fff">${totalBookings != null ? totalBookings : '0'}</div><div style="font-size:10px;color:var(--muted);text-transform:uppercase;letter-spacing:1px;margin-top:2px">Booking</div></div>
                        <div><div style="font-family:'Playfair Display',serif;font-size:22px;color:#fff">${totalCustomers != null ? totalCustomers : '0'}</div><div style="font-size:10px;color:var(--muted);text-transform:uppercase;letter-spacing:1px;margin-top:2px">Khách hàng</div></div>
                        <div><div style="font-family:'Playfair Display',serif;font-size:22px;color:#fff">${totalEmployees != null ? totalEmployees : '0'}</div><div style="font-size:10px;color:var(--muted);text-transform:uppercase;letter-spacing:1px;margin-top:2px">Nhân viên</div></div>
                    </div>
                </div>
            </div>
            <div class="revenue-bars">
                <div class="rev-bar" style="height:30%"></div>
                <div class="rev-bar" style="height:55%"></div>
                <div class="rev-bar" style="height:40%"></div>
                <div class="rev-bar" style="height:70%"></div>
                <div class="rev-bar" style="height:60%"></div>
                <div class="rev-bar" style="height:85%"></div>
                <div class="rev-bar active" style="height:100%"></div>
            </div>
        </div>

        <div class="section-header">
            <div>
                <div class="section-label">Quản Trị</div>
                <div class="section-title">Chức Năng Nhanh</div>
            </div>
        </div>
        <div class="actions-grid">
            <a href="${pageContext.request.contextPath}/dashboard/users" class="action-card">
                <div class="action-line"></div>
                <div class="action-title">Người Dùng</div>
                <div class="action-desc">Quản lý khách hàng và nhân viên</div>
                <div class="action-arrow">Xem →</div>
            </a>
            <a href="${pageContext.request.contextPath}/dashboard/facilities" class="action-card">
                <div class="action-line"></div>
                <div class="action-title">Phòng &amp; Villa</div>
                <div class="action-desc">Cập nhật trạng thái và thông tin phòng</div>
                <div class="action-arrow">Quản lý →</div>
            </a>
            <a href="${pageContext.request.contextPath}/dashboard/bookings" class="action-card">
                <div class="action-line"></div>
                <div class="action-title">Booking</div>
                <div class="action-desc">Xem và xử lý toàn bộ đặt phòng</div>
                <div class="action-arrow">Xem →</div>
            </a>
            <a href="${pageContext.request.contextPath}/dashboard/contracts" class="action-card">
                <div class="action-line"></div>
                <div class="action-title">Hợp Đồng</div>
                <div class="action-desc">Duyệt và quản lý hợp đồng</div>
                <div class="action-arrow">Xem →</div>
            </a>
        </div>

        <div class="section-header">
            <div>
                <div class="section-label">Nhân Sự</div>
                <div class="section-title">Danh Sách Nhân Viên</div>
            </div>
            <a href="${pageContext.request.contextPath}/dashboard/users" class="link-more">Xem tất cả →</a>
        </div>
        <div class="table-card">
            <c:choose>
                <c:when test="${not empty employees}">
                    <table>
                        <thead><tr>
                            <th>ID</th><th>Họ Tên</th><th>Chức Vụ</th><th>Phòng Ban</th><th>Role</th><th>Trạng Thái</th>
                        </tr></thead>
                        <tbody>
                        <c:forEach var="e" items="${employees}">
                            <tr>
                                <td style="color:var(--gold);font-weight:600">${e.id}</td>
                                <td>${e.fullName}</td>
                                <td>${e.position}</td>
                                <td>${e.deptName}</td>
                                <td><span class="badge ${e.role == 'ADMIN' ? 'badge-admin' : 'badge-staff'}">${e.role}</span></td>
                                <td><span class="badge badge-active">Đang làm</span></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="padding:48px;text-align:center;color:var(--muted);font-size:13px;">Chưa có dữ liệu nhân viên</div>
                </c:otherwise>
            </c:choose>
        </div><!-- end employees table-card -->

        <!-- RECENT BOOKINGS -->
        <div class="section-header" style="margin-top:28px">
            <div>
                <div class="section-label">Hoạt Động</div>
                <div class="section-title">Booking Gần Đây</div>
            </div>
            <a href="${pageContext.request.contextPath}/dashboard/bookings" class="link-more">Xem tất cả →</a>
        </div>
        <div class="table-card">
            <c:choose>
                <c:when test="${not empty recentBookings}">
                    <table>
                        <thead><tr>
                            <th>Mã Booking</th><th>Khách Hàng</th><th>Phòng / Villa</th><th>Ngày Nhận</th><th>Ngày Trả</th><th>Trạng Thái</th>
                        </tr></thead>
                        <tbody>
                        <c:forEach var="b" items="${recentBookings}">
                            <tr>
                                <td style="color:var(--gold);font-weight:600;font-family:monospace">#${b.bookingId}</td>
                                <td>${b.customerName}</td>
                                <td>
                                    <div style="font-size:13px;color:#fff">${b.facilityName}</div>
                                    <div style="font-size:10px;color:rgba(201,168,76,0.6);text-transform:uppercase;letter-spacing:1px;margin-top:2px">${b.facilityType}</div>
                                </td>
                                <td><fmt:formatDate value="${b.startDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${b.endDate}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status == 'PENDING'}"><span class="badge" style="background:rgba(245,158,11,0.1);color:#f59e0b">Chờ Duyệt</span></c:when>
                                        <c:when test="${b.status == 'CONFIRMED'}"><span class="badge" style="background:rgba(16,185,129,0.1);color:#10b981">Xác Nhận</span></c:when>
                                        <c:when test="${b.status == 'CHECKED_IN'}"><span class="badge" style="background:rgba(96,165,250,0.1);color:#60a5fa">Đang Ở</span></c:when>
                                        <c:when test="${b.status == 'CHECKED_OUT'}"><span class="badge" style="background:rgba(255,255,255,0.05);color:rgba(255,255,255,0.4)">Trả Phòng</span></c:when>
                                        <c:when test="${b.status == 'CANCELLED'}"><span class="badge" style="background:rgba(248,113,113,0.1);color:#f87171">Đã Hủy</span></c:when>
                                        <c:otherwise><span class="badge badge-active">${b.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="padding:40px;text-align:center;color:var(--muted);font-size:13px;">Chưa có booking nào</div>
                </c:otherwise>
            </c:choose>
        </div><!-- end recent bookings table-card -->

    </div><!-- end .content -->
</div><!-- end .main -->

<!-- REPORT MODAL -->
<div class="modal-overlay" id="reportModal" onclick="if(event.target===this)closeReport()">
<div style="background:#0a0e1a;border:1px solid rgba(201,168,76,0.2);border-radius:24px;width:95%;max-width:960px;max-height:90vh;overflow-y:auto;position:relative;padding:36px 40px;">

    <!-- Header -->
    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:32px;padding-bottom:20px;border-bottom:1px solid rgba(255,255,255,0.07)">
        <div>
            <div style="font-size:10px;color:var(--gold);letter-spacing:3px;text-transform:uppercase;font-weight:700;margin-bottom:6px">Báo Cáo Tài Chính</div>
            <div style="font-family:'Playfair Display',serif;font-size:22px;font-weight:700;color:#fff">Doanh Thu &amp; Lợi Nhuận — Azure Resort &amp; Spa</div>
        </div>
        <button onclick="closeReport()" style="background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.1);color:rgba(255,255,255,0.6);width:32px;height:32px;border-radius:8px;cursor:pointer;font-size:16px;display:flex;align-items:center;justify-content:center;transition:all 0.2s;flex-shrink:0" onmouseover="this.style.background='rgba(248,113,113,0.15)';this.style.color='#f87171'" onmouseout="this.style.background='rgba(255,255,255,0.06)';this.style.color='rgba(255,255,255,0.6)'">✕</button>
    </div>

    <!-- KPI Row -->
    <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:28px">
        <div style="background:rgba(201,168,76,0.06);border:1px solid rgba(201,168,76,0.15);border-radius:14px;padding:18px 20px">
            <div style="font-size:10px;color:rgba(255,255,255,0.35);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:6px">Tổng Doanh Thu</div>
            <div style="font-family:'Playfair Display',serif;font-size:24px;font-weight:700;color:var(--gold)">103 tỷ</div>
            <div style="font-size:11px;color:#4ade80;margin-top:4px">▲ +145.6% YoY</div>
        </div>
        <div style="background:rgba(96,165,250,0.06);border:1px solid rgba(96,165,250,0.15);border-radius:14px;padding:18px 20px">
            <div style="font-size:10px;color:rgba(255,255,255,0.35);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:6px">Lợi Nhuận Sau Thuế</div>
            <div style="font-family:'Playfair Display',serif;font-size:24px;font-weight:700;color:#60a5fa">68.5 tỷ</div>
            <div style="font-size:11px;color:#4ade80;margin-top:4px">▲ +112.3% YoY</div>
        </div>
        <div style="background:rgba(248,113,113,0.06);border:1px solid rgba(248,113,113,0.15);border-radius:14px;padding:18px 20px">
            <div style="font-size:10px;color:rgba(255,255,255,0.35);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:6px">Lợi Nhuận Trước Thuế</div>
            <div style="font-family:'Playfair Display',serif;font-size:24px;font-weight:700;color:#f87171">82.1 tỷ</div>
            <div style="font-size:11px;color:#f87171;margin-top:4px">▼ −8.4% vs Q3</div>
        </div>
        <div style="background:rgba(74,222,128,0.06);border:1px solid rgba(74,222,128,0.15);border-radius:14px;padding:18px 20px">
            <div style="font-size:10px;color:rgba(255,255,255,0.35);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:6px">Lợi Nhuận 2026</div>
            <div style="font-family:'Playfair Display',serif;font-size:24px;font-weight:700;color:#4ade80">24.7 tỷ</div>
            <div style="font-size:11px;color:#4ade80;margin-top:4px">▲ +22.6% vs Q1/2025</div>
        </div>
    </div>

    <!-- Main Line Chart -->
    <div style="background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.06);border-radius:16px;padding:24px;margin-bottom:20px">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px">
            <div>
                <div style="font-size:10px;color:var(--gold);letter-spacing:2px;text-transform:uppercase;font-weight:600;margin-bottom:3px">Xu Hướng</div>
                <div style="font-family:'Playfair Display',serif;font-size:16px;color:#fff">Doanh Thu Theo Tháng — 2025</div>
            </div>
            <div style="display:flex;gap:16px;font-size:11px;color:rgba(255,255,255,0.4)">
                <span style="display:flex;align-items:center;gap:5px"><span style="width:12px;height:2px;background:var(--gold);display:inline-block;border-radius:2px"></span>Doanh thu</span>
                <span style="display:flex;align-items:center;gap:5px"><span style="width:12px;height:2px;background:#60a5fa;display:inline-block;border-radius:2px"></span>Lợi nhuận</span>
            </div>
        </div>
        <canvas id="mainLineChart" height="80"></canvas>
    </div>

    <!-- 2 Bar Charts -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
        <div style="background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.06);border-radius:16px;padding:20px">
            <div style="font-size:10px;color:rgba(255,255,255,0.35);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:4px">Theo Quý — 2025</div>
            <div style="font-family:'Playfair Display',serif;font-size:16px;color:#fff;margin-bottom:14px">Doanh Thu Quý</div>
            <canvas id="quarterChart" height="100"></canvas>
        </div>
        <div style="background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.06);border-radius:16px;padding:20px">
            <div style="font-size:10px;color:rgba(255,255,255,0.35);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:4px">Năm Hiện Tại — 2026</div>
            <div style="font-family:'Playfair Display',serif;font-size:16px;color:#fff;margin-bottom:14px">Lợi Nhuận T1–T3/2026</div>
            <canvas id="current2026Chart" height="100"></canvas>
        </div>
    </div>

</div>
</div>

<div id="sidebarOverlay" onclick="document.querySelector('.sidebar').classList.remove('open');this.style.display='none'" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:199"></div>
<script>
        new Date().toLocaleDateString('vi-VN', {weekday:'long', year:'numeric', month:'long', day:'numeric'});

    // Hamburger menu
    const menuBtn = document.getElementById('menuToggle');
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    if (menuBtn) {
        menuBtn.addEventListener('click', function() {
            sidebar.classList.toggle('open');
            overlay.style.display = sidebar.classList.contains('open') ? 'block' : 'none';
        });
    }

    function openReport() {
        document.getElementById('reportModal').classList.add('active');
        if (!window._chartsBuilt) { buildCharts(); window._chartsBuilt = true; }
    }
    function closeReport() {
        document.getElementById('reportModal').classList.remove('active');
    }

    function buildCharts() {
        const gold = '#c9a84c', blue = '#60a5fa', green = '#4ade80', red = '#f87171';
        const gridColor = 'rgba(255,255,255,0.05)';
        const tickColor = 'rgba(255,255,255,0.4)';
        const months = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];

        // Main line chart
        new Chart(document.getElementById('mainLineChart'), {
            type: 'line',
            data: {
                labels: months,
                datasets: [
                    {
                        label: 'Doanh thu (tỷ)',
                        data: [6.2,5.8,7.1,6.8,8.2,7.9,9.1,10.3,8.8,9.2,9.6,10.0],
                        borderColor: gold, backgroundColor: 'rgba(201,168,76,0.08)',
                        borderWidth: 2.5, fill: true, tension: 0.4,
                        pointBackgroundColor: gold, pointRadius: 3, pointHoverRadius: 6
                    },
                    {
                        label: 'Lợi nhuận (tỷ)',
                        data: [3.5,3.9,4.2,3.8,5.0,5.2,5.9,6.8,6.1,6.8,6.9,7.0],
                        borderColor: blue, backgroundColor: 'rgba(96,165,250,0.06)',
                        borderWidth: 2, fill: true, tension: 0.4,
                        pointBackgroundColor: blue, pointRadius: 3, pointHoverRadius: 6
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { color: gridColor }, ticks: { color: tickColor, font: { size: 11 } }, border: { display: false } },
                    y: { grid: { color: gridColor }, ticks: { color: tickColor, font: { size: 11 }, callback: v => v + ' tỷ' }, border: { display: false } }
                }
            }
        });

        // Quarter bar chart
        new Chart(document.getElementById('quarterChart'), {
            type: 'bar',
            data: {
                labels: ['Q1', 'Q2', 'Q3', 'Q4'],
                datasets: [{
                    data: [19.1, 22.9, 28.2, 28.8],
                    backgroundColor: ['rgba(201,168,76,0.15)','rgba(201,168,76,0.15)','rgba(201,168,76,0.15)',gold],
                    borderRadius: 6, borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false }, tooltip: { callbacks: { label: c => ' ' + c.parsed.y + ' tỷ' } } },
                scales: {
                    x: { grid: { display: false }, ticks: { color: tickColor }, border: { display: false } },
                    y: { grid: { color: gridColor }, ticks: { color: tickColor, callback: v => v + ' tỷ' }, border: { display: false } }
                }
            }
        });

        // 2026 bar chart
        new Chart(document.getElementById('current2026Chart'), {
            type: 'bar',
            data: {
                labels: ['Tháng 1', 'Tháng 2', 'Tháng 3'],
                datasets: [{
                    data: [8.4, 7.2, 9.1],
                    backgroundColor: ['rgba(74,222,128,0.15)','rgba(74,222,128,0.15)',green],
                    borderRadius: 6, borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false }, tooltip: { callbacks: { label: c => ' ' + c.parsed.y + ' tỷ' } } },
                scales: {
                    x: { grid: { display: false }, ticks: { color: tickColor }, border: { display: false } },
                    y: { grid: { color: gridColor }, ticks: { color: tickColor, callback: v => v + ' tỷ' }, border: { display: false } }
                }
            }
        });
    }
</script>
</body>
</html>
