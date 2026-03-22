<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    TblPersons acc = (TblPersons) session.getAttribute("account");
    if (acc == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    TblEmployees emp = (acc instanceof TblEmployees) ? (TblEmployees) acc : null;
    String position = (emp != null && emp.getPosition() != null) ? emp.getPosition() : "Nhân viên";
    pageContext.setAttribute("emp", emp);
    pageContext.setAttribute("position", position);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard — Azure Resort</title>
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

        .sidebar { width: var(--sidebar-w); flex-shrink: 0; background: #080c14; border-right: 1px solid rgba(96,165,250,0.1); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; bottom: 0; z-index: 100; }
        .sidebar-brand { padding: 28px 24px 22px; border-bottom: 1px solid rgba(96,165,250,0.08); }
        .brand-logo { font-family: 'Playfair Display', serif; font-size: 19px; font-weight: 700; color: #fff; }
        .brand-logo span { color: var(--gold); }
        .brand-tag { display: inline-block; margin-top: 8px; font-size: 9px; letter-spacing: 2.5px; text-transform: uppercase; color: #fff; background: rgba(96,165,250,0.2); padding: 3px 10px; border-radius: 4px; font-weight: 700; border: 1px solid rgba(96,165,250,0.3); }
        .sidebar-user { padding: 18px 24px; border-bottom: 1px solid rgba(255,255,255,0.05); display: flex; align-items: center; gap: 12px; }
        .user-avatar { width: 38px; height: 38px; border-radius: 10px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); display: flex; align-items: center; justify-content: center; font-size: 15px; font-weight: 700; color: #fff; flex-shrink: 0; }
        .user-name { font-size: 13px; font-weight: 600; color: #fff; }
        .user-role { font-size: 11px; color: #60a5fa; margin-top: 2px; }
        .sidebar-nav { flex: 1; padding: 12px 0; overflow-y: auto; }
        .nav-section { padding: 16px 24px 6px; font-size: 9.5px; color: rgba(255,255,255,0.25); letter-spacing: 2px; text-transform: uppercase; font-weight: 600; }
        .nav-item { display: flex; align-items: center; gap: 10px; padding: 10px 24px; color: rgba(255,255,255,0.55); text-decoration: none; font-size: 13px; font-weight: 500; transition: all 0.18s; border-left: 2px solid transparent; }
        .nav-item:hover { background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.9); }
        .nav-item.active { background: rgba(96,165,250,0.07); color: #60a5fa; border-left-color: #60a5fa; }
        .nav-dot { width: 5px; height: 5px; border-radius: 50%; background: rgba(255,255,255,0.2); flex-shrink: 0; }
        .nav-item.active .nav-dot { background: #60a5fa; }
        .sidebar-footer { padding: 16px 24px; border-top: 1px solid rgba(255,255,255,0.05); }
        .btn-logout { display: flex; align-items: center; gap: 10px; color: rgba(248,113,113,0.6); font-size: 13px; text-decoration: none; padding: 8px 0; transition: color 0.2s; }
        .btn-logout:hover { color: #f87171; }

        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .topbar { height: 60px; background: rgba(8,12,20,0.97); border-bottom: 1px solid rgba(96,165,250,0.07); display: flex; align-items: center; justify-content: space-between; padding: 0 36px; position: sticky; top: 0; z-index: 50; backdrop-filter: blur(20px); }
        .topbar-title { font-family: 'Playfair Display', serif; font-size: 17px; color: #fff; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .topbar-date { font-size: 12px; color: var(--muted); }
        .role-badge { background: rgba(96,165,250,0.1); color: #60a5fa; font-size: 10px; font-weight: 700; padding: 4px 12px; border-radius: 4px; letter-spacing: 1.5px; text-transform: uppercase; border: 1px solid rgba(96,165,250,0.2); }
        .content { padding: 32px 36px 60px; flex: 1; }

        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--card); border: 1px solid var(--border); border-radius: 16px; padding: 22px 24px; transition: all 0.25s; }
        .stat-card:hover { border-color: rgba(96,165,250,0.18); transform: translateY(-2px); }
        .stat-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
        .stat-indicator { width: 8px; height: 8px; border-radius: 50%; margin-top: 4px; }
        .ind-blue { background: #60a5fa; }
        .ind-green { background: #4ade80; }
        .ind-gold { background: var(--gold); }
        .ind-purple { background: #a78bfa; }
        .stat-trend { font-size: 10.5px; padding: 3px 8px; border-radius: 4px; font-weight: 600; }
        .trend-up { background: rgba(74,222,128,0.1); color: #4ade80; }
        .stat-num { font-family: 'Playfair Display', serif; font-size: 30px; font-weight: 700; color: #fff; line-height: 1; }
        .stat-label { font-size: 11.5px; color: var(--muted); margin-top: 6px; }

        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: 19px; color: #fff; }
        .section-label { font-size: 9.5px; color: var(--gold); letter-spacing: 2.5px; text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
        .link-more { color: var(--gold); font-size: 12.5px; text-decoration: none; opacity: 0.8; transition: opacity 0.2s; }
        .link-more:hover { opacity: 1; }

        .actions-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; margin-bottom: 28px; }
        .action-card { background: var(--card); border: 1px solid var(--border); border-radius: 14px; padding: 22px 18px; text-decoration: none; transition: all 0.25s; display: block; }
        .action-card:hover { background: rgba(96,165,250,0.04); border-color: rgba(96,165,250,0.2); transform: translateY(-3px); box-shadow: 0 10px 28px rgba(0,0,0,0.25); }
        .action-line { width: 28px; height: 2px; background: #60a5fa; border-radius: 2px; margin-bottom: 14px; opacity: 0.6; }
        .action-title { font-size: 13px; font-weight: 600; color: #fff; margin-bottom: 5px; }
        .action-desc { font-size: 11.5px; color: var(--muted); line-height: 1.5; }
        .action-arrow { display: inline-block; color: #60a5fa; font-size: 11px; font-weight: 600; margin-top: 10px; opacity: 0.7; }

        .table-card { background: var(--card); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th { padding: 11px 20px; text-align: left; font-size: 9.5px; color: var(--muted); letter-spacing: 1.5px; text-transform: uppercase; font-weight: 600; border-bottom: 1px solid var(--border); }
        td { padding: 13px 20px; font-size: 13px; color: var(--text); border-bottom: 1px solid rgba(255,255,255,0.04); }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(255,255,255,0.02); }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 4px; font-size: 10.5px; font-weight: 600; }
        .badge-confirmed { background: rgba(74,222,128,0.1); color: #4ade80; }
        .badge-pending { background: rgba(251,191,36,0.1); color: #fbbf24; }
        .badge-cancelled { background: rgba(248,113,113,0.1); color: #f87171; }
        .badge-checkin { background: rgba(96,165,250,0.1); color: #60a5fa; }

        @media (max-width: 1200px) { .stats-grid { grid-template-columns: repeat(2,1fr); } .actions-grid { grid-template-columns: repeat(2,1fr); } }
        @media (max-width: 900px) { .sidebar { display: none; } .main { margin-left: 0; } }
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-logo">Azure <span>Resort</span></div>
        <div class="brand-tag">Staff Portal</div>
    </div>
    <div class="sidebar-user">
        <div class="user-avatar">${acc.fullName.substring(0,1)}</div>
        <div>
            <div class="user-name">${acc.fullName}</div>
            <div class="user-role">${position}</div>
        </div>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">Tổng Quan</div>
        <a href="${pageContext.request.contextPath}/dashboard/staff" class="nav-item active">
            <span class="nav-dot"></span> Dashboard
        </a>
        <div class="nav-section">Nghiệp Vụ</div>
        <a href="${pageContext.request.contextPath}/dashboard/bookings" class="nav-item">
            <span class="nav-dot"></span> Quản Lý Booking
        </a>
        <a href="${pageContext.request.contextPath}/dashboard/contracts" class="nav-item">
            <span class="nav-dot"></span> Hợp Đồng
        </a>
        <div class="nav-section">Cơ Sở Vật Chất</div>
        <a href="${pageContext.request.contextPath}/dashboard/facilities" class="nav-item">
            <span class="nav-dot"></span> Phòng &amp; Villa
        </a>
        <div class="nav-section">Cá Nhân</div>
        <a href="${pageContext.request.contextPath}/profile" class="nav-item">
            <span class="nav-dot"></span> Hồ Sơ
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng Xuất</a>
    </div>
</aside>

<div class="main">
    <div class="topbar">
        <div class="topbar-title">Dashboard Nhân Viên</div>
        <div class="topbar-right">
            <span class="topbar-date" id="topbarDate"></span>
            <span class="role-badge">Staff</span>
        </div>
    </div>

    <div class="content">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-indicator ind-blue"></span>
                    <span class="stat-trend trend-up">Chờ xử lý</span>
                </div>
                <div class="stat-num">${cntPending != null ? cntPending : '—'}</div>
                <div class="stat-label">Booking Đang Chờ</div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-indicator ind-green"></span>
                    <span class="stat-trend trend-up">Đang ở</span>
                </div>
                <div class="stat-num">${cntCheckedIn != null ? cntCheckedIn : '—'}</div>
                <div class="stat-label">Khách Đang Lưu Trú</div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-indicator ind-gold"></span>
                    <span class="stat-trend trend-up">Trống</span>
                </div>
                <div class="stat-num">${cntAvailable != null ? cntAvailable : '—'}</div>
                <div class="stat-label">Phòng Còn Trống</div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-indicator ind-purple"></span>
                    <span class="stat-trend trend-up">Hiệu lực</span>
                </div>
                <div class="stat-num">${cntActiveContracts != null ? cntActiveContracts : '—'}</div>
                <div class="stat-label">Hợp Đồng Đang Hiệu Lực</div>
            </div>
        </div>

        <div class="section-header">
            <div>
                <div class="section-label">Thao Tác Nhanh</div>
                <div class="section-title">Nghiệp Vụ Hàng Ngày</div>
            </div>
        </div>
        <div class="actions-grid">
            <a href="${pageContext.request.contextPath}/dashboard/bookings" class="action-card">
                <div class="action-line"></div>
                <div class="action-title">Xử Lý Booking</div>
                <div class="action-desc">Xem và xác nhận các đặt phòng mới từ khách hàng</div>
                <div class="action-arrow">Xem ngay →</div>
            </a>
            <a href="${pageContext.request.contextPath}/dashboard/contracts" class="action-card">
                <div class="action-line"></div>
                <div class="action-title">Hợp Đồng</div>
                <div class="action-desc">Tạo và quản lý hợp đồng, theo dõi thanh toán</div>
                <div class="action-arrow">Quản lý →</div>
            </a>
            <a href="${pageContext.request.contextPath}/dashboard/facilities" class="action-card">
                <div class="action-line"></div>
                <div class="action-title">Phòng &amp; Villa</div>
                <div class="action-desc">Xem trạng thái và cập nhật tình trạng phòng</div>
                <div class="action-arrow">Xem →</div>
            </a>
        </div>

        <div class="section-header">
            <div>
                <div class="section-label">Hôm Nay</div>
                <div class="section-title">Booking Gần Đây</div>
            </div>
            <a href="${pageContext.request.contextPath}/dashboard/bookings" class="link-more">Xem tất cả →</a>
        </div>
        <div class="table-card">
            <c:choose>
                <c:when test="${not empty recentBookings}">
                    <table>
                        <thead><tr>
                            <th>Booking ID</th><th>Khách Hàng</th><th>Phòng / Villa</th>
                            <th>Nhận Phòng</th><th>Trả Phòng</th><th>Trạng Thái</th>
                        </tr></thead>
                        <tbody>
                        <c:forEach var="b" items="${recentBookings}">
                            <tr>
                                <td style="color:var(--gold);font-weight:600">${b.bookingId}</td>
                                <td>${b.customerName}</td>
                                <td>${b.facilityName}</td>
                                <td>${b.startDate}</td>
                                <td>${b.endDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status == 'CONFIRMED'}"><span class="badge badge-confirmed">Đã xác nhận</span></c:when>
                                        <c:when test="${b.status == 'PENDING'}"><span class="badge badge-pending">Chờ xử lý</span></c:when>
                                        <c:when test="${b.status == 'CHECKED_IN'}"><span class="badge badge-checkin">Đang ở</span></c:when>
                                        <c:when test="${b.status == 'CANCELLED'}"><span class="badge badge-cancelled">Đã hủy</span></c:when>
                                        <c:otherwise><span class="badge">${b.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="padding:48px;text-align:center;color:var(--muted);font-size:13px;">Chưa có booking nào gần đây</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    document.getElementById('topbarDate').textContent =
        new Date().toLocaleDateString('vi-VN', {weekday:'long', year:'numeric', month:'long', day:'numeric'});
</script>
</body>
</html>
