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
    <title>Quản Lý Booking — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --gold: #c9a84c; --gold-light: #e8cc82; --dark: #0a0a0f; --navy: #0d1526; --card: rgba(255,255,255,0.03); --border: rgba(255,255,255,0.07); --text: #e8e8e8; --muted: rgba(255,255,255,0.45); --sidebar-w: 256px; }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); min-height: 100vh; display: flex; }
        .sidebar { width: var(--sidebar-w); flex-shrink: 0; background: #080c14; border-right: 1px solid rgba(201,168,76,0.12); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; bottom: 0; z-index: 100; }
        .sidebar-brand { padding: 28px 24px 22px; border-bottom: 1px solid rgba(201,168,76,0.1); }
        .brand-logo { font-family: 'Playfair Display', serif; font-size: 19px; font-weight: 700; color: #fff; }
        .brand-logo span { color: var(--gold); }
        .brand-tag { display: inline-block; margin-top: 8px; font-size: 9px; letter-spacing: 2.5px; text-transform: uppercase; color: var(--dark); background: var(--gold); padding: 3px 10px; border-radius: 4px; font-weight: 700; }
        .sidebar-user { padding: 18px 24px; border-bottom: 1px solid rgba(255,255,255,0.05); display: flex; align-items: center; gap: 12px; }
        .user-avatar { width: 38px; height: 38px; border-radius: 10px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); display: flex; align-items: center; justify-content: center; font-size: 15px; font-weight: 700; color: var(--dark); flex-shrink: 0; }
        .user-name { font-size: 13px; font-weight: 600; color: #fff; }
        .user-role { font-size: 11px; color: var(--gold); margin-top: 2px; }
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
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .topbar { height: 60px; background: rgba(8,12,20,0.97); border-bottom: 1px solid rgba(201,168,76,0.08); display: flex; align-items: center; justify-content: space-between; padding: 0 36px; position: sticky; top: 0; z-index: 50; backdrop-filter: blur(20px); }
        .topbar-title { font-family: 'Playfair Display', serif; font-size: 17px; color: #fff; }
        .content { padding: 32px 36px 60px; flex: 1; }
        .section-label { font-size: 9.5px; color: var(--gold); letter-spacing: 2.5px; text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: 22px; color: #fff; margin-bottom: 24px; }
        .stats-row{display:flex;gap:16px;margin-bottom:24px;flex-wrap:wrap}
        .stat-pill{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:14px 22px;display:flex;align-items:center;gap:14px;cursor:pointer;text-decoration:none;transition:all 0.2s}
        .stat-pill:hover{border-color:rgba(201,168,76,0.3)}
        .stat-pill .num{font-family:'Playfair Display',serif;font-size:26px;font-weight:700}
        .stat-pill .lbl{font-size:12px;color:var(--muted)}
        .stat-pill.yellow .num{color:#fbbf24}
        .stat-pill.green .num{color:#4ade80}
        .stat-pill.blue .num{color:#60a5fa}
        .toolbar{display:flex;align-items:center;gap:12px;margin-bottom:20px;flex-wrap:wrap}
        .search-box{display:flex;align-items:center;gap:8px;background:rgba(255,255,255,0.05);border:1px solid var(--border);border-radius:10px;padding:8px 14px;flex:1;min-width:200px;max-width:360px}
        .search-box input{background:none;border:none;outline:none;color:#fff;font-size:13.5px;width:100%}
        .search-box input::placeholder{color:var(--muted)}
        .filter-tabs{display:flex;gap:8px;flex-wrap:wrap}
        .tab{padding:7px 16px;border-radius:50px;font-size:12.5px;font-weight:600;border:1.5px solid var(--border);color:var(--muted);background:transparent;cursor:pointer;transition:all 0.2s;text-decoration:none}
        .tab:hover{border-color:rgba(201,168,76,0.4);color:var(--gold)}
        .tab.active{background:var(--gold);color:var(--dark);border-color:var(--gold)}
        .table-card{background:var(--card);border:1px solid var(--border);border-radius:16px;overflow:hidden}
        table{width:100%;border-collapse:collapse}
        th{padding:12px 20px;text-align:left;font-size:9.5px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;font-weight:600;border-bottom:1px solid var(--border)}
        td{padding:13px 20px;font-size:13px;color:var(--text);border-bottom:1px solid rgba(255,255,255,0.04)}
        tr:last-child td{border-bottom:none}
        tr:hover td{background:rgba(255,255,255,0.02)}
        .badge{display:inline-block;padding:3px 10px;border-radius:4px;font-size:10.5px;font-weight:600}
        .badge-confirmed{background:rgba(74,222,128,0.1);color:#4ade80}
        .badge-pending{background:rgba(251,191,36,0.1);color:#fbbf24}
        .badge-cancelled{background:rgba(248,113,113,0.1);color:#f87171}
        .badge-checkin{background:rgba(96,165,250,0.1);color:#60a5fa}
        .badge-checkout{background:rgba(148,163,184,0.1);color:#94a3b8}
        .actions{display:flex;gap:6px;flex-wrap:wrap}
        .btn-sm{padding:5px 12px;border-radius:4px;font-size:11px;font-weight:600;border:none;cursor:pointer;transition:all 0.2s;font-family:'Inter',sans-serif}
        .btn-approve{background:rgba(74,222,128,0.1);color:#4ade80;border:1px solid rgba(74,222,128,0.3)}
        .btn-approve:hover{background:#4ade80;color:#000}
        .btn-reject{background:rgba(248,113,113,0.1);color:#f87171;border:1px solid rgba(248,113,113,0.3)}
        .btn-reject:hover{background:#f87171;color:#fff}
        .btn-checkin{background:rgba(96,165,250,0.1);color:#60a5fa;border:1px solid rgba(96,165,250,0.3)}
        .btn-checkin:hover{background:#60a5fa;color:#000}
        .btn-checkout{background:rgba(148,163,184,0.1);color:#94a3b8;border:1px solid rgba(148,163,184,0.3)}
        .btn-checkout:hover{background:#94a3b8;color:#000}
        .empty{padding:60px;text-align:center;color:var(--muted)}
        .occupied-warn{color:#fbbf24;font-size:11px}
        .flash{padding:14px 20px;border-radius:10px;margin-bottom:20px;font-size:13.5px;font-weight:500}
        .flash-success{background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.25);color:#4ade80}
        .flash-error{background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.25);color:#f87171}
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
        <a href="${pageContext.request.contextPath}/dashboard/bookings" class="nav-item active">
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
        <a href="${pageContext.request.contextPath}/" class="btn-logout" style="color:rgba(201,168,76,0.7);margin-bottom:6px">🏖️ Trang Chủ</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng Xuất</a>
    </div>
</aside>

<div class="main">
    <div class="topbar">
        <div class="topbar-title">Quản Lý Booking</div>
        <span style="font-size:12px;color:var(--muted)" id="topbarDate"></span>
    </div>
    <div class="content">
        <div class="section-label">Nghiệp Vụ</div>
        <div class="section-title">Danh Sách Đặt Phòng</div>

        <c:if test="${not empty flashMsg}">
            <c:choose>
                <c:when test="${fn:startsWith(flashMsg, '✅')}"><div class="flash flash-success">${flashMsg}</div></c:when>
                <c:otherwise><div class="flash flash-error">${flashMsg}</div></c:otherwise>
            </c:choose>
        </c:if>

        <div class="stats-row">
            <a href="?status=PENDING" class="stat-pill yellow">
                <div><div class="num">${cntPending}</div><div class="lbl">Chờ Duyệt</div></div>
            </a>
            <a href="?status=CONFIRMED" class="stat-pill green">
                <div><div class="num">${cntConfirmed}</div><div class="lbl">Đã Xác Nhận</div></div>
            </a>
            <a href="?status=CHECKED_IN" class="stat-pill blue">
                <div><div class="num">${cntCheckedIn}</div><div class="lbl">Đang Lưu Trú</div></div>
            </a>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/dashboard/bookings">
            <div class="toolbar">
                <div class="search-box">
                    <input type="text" name="q" placeholder="Tìm booking ID, khách hàng, phòng..." value="${search}">
                </div>
                <div class="filter-tabs">
                    <a href="?status=ALL" class="tab ${statusFilter == 'ALL' ? 'active' : ''}">Tất Cả</a>
                    <a href="?status=PENDING" class="tab ${statusFilter == 'PENDING' ? 'active' : ''}">Chờ Duyệt</a>
                    <a href="?status=CONFIRMED" class="tab ${statusFilter == 'CONFIRMED' ? 'active' : ''}">Đã Xác Nhận</a>
                    <a href="?status=CHECKED_IN" class="tab ${statusFilter == 'CHECKED_IN' ? 'active' : ''}">Đang Ở</a>
                    <a href="?status=CHECKED_OUT" class="tab ${statusFilter == 'CHECKED_OUT' ? 'active' : ''}">Đã Trả</a>
                    <a href="?status=CANCELLED" class="tab ${statusFilter == 'CANCELLED' ? 'active' : ''}">Đã Hủy</a>
                </div>
            </div>
        </form>

        <div class="table-card">
            <c:choose>
                <c:when test="${not empty bookings}">
                    <table>
                        <thead><tr>
                            <th>Booking ID</th><th>Khách Hàng</th><th>Phòng / Villa</th>
                            <th>Nhận Phòng</th><th>Trả Phòng</th><th>Người</th>
                            <th>Trạng Thái</th><th>Thao Tác</th>
                        </tr></thead>
                        <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td style="color:var(--gold);font-weight:600">${b.bookingId}</td>
                                <td>${b.customerName}</td>
                                <td>
                                    <div>${b.facilityName}</div>
                                    <c:if test="${b.status == 'CHECKED_IN'}">
                                        <div class="occupied-warn">Phòng đang có người</div>
                                    </c:if>
                                </td>
                                <td><fmt:formatDate value="${b.startDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${b.endDate}" pattern="dd/MM/yyyy"/></td>
                                <td>${b.adults + b.children} người</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status == 'CONFIRMED'}"><span class="badge badge-confirmed">Đã xác nhận</span></c:when>
                                        <c:when test="${b.status == 'PENDING'}"><span class="badge badge-pending">Chờ duyệt</span></c:when>
                                        <c:when test="${b.status == 'CHECKED_IN'}"><span class="badge badge-checkin">Đang ở</span></c:when>
                                        <c:when test="${b.status == 'CHECKED_OUT'}"><span class="badge badge-checkout">Đã trả</span></c:when>
                                        <c:when test="${b.status == 'CANCELLED'}"><span class="badge badge-cancelled">Đã hủy</span></c:when>
                                        <c:otherwise><span class="badge">${b.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="actions">
                                        <c:if test="${b.status == 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                                <input type="hidden" name="action" value="approve_booking">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/bookings">
                                                <button type="submit" class="btn-sm btn-approve">Duyệt</button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                                <input type="hidden" name="action" value="reject_booking">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/bookings">
                                                <button type="submit" class="btn-sm btn-reject" onclick="return confirm('Từ chối booking này?')">Từ Chối</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${b.status == 'CONFIRMED'}">
                                            <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                                <input type="hidden" name="action" value="checkin_booking">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/bookings">
                                                <button type="submit" class="btn-sm btn-checkin">Check-in</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${b.status == 'CHECKED_IN'}">
                                            <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                                <input type="hidden" name="action" value="checkout_booking">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/bookings">
                                                <button type="submit" class="btn-sm btn-checkout">Check-out</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise><div class="empty"><p>Không có booking nào</p></div></c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script>
    document.getElementById('topbarDate').textContent =
        new Date().toLocaleDateString('vi-VN',{weekday:'long',year:'numeric',month:'long',day:'numeric'});
</script>
</body>
</html>
