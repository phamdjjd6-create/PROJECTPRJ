<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <title>Quản Lý Người Dùng — Azure Resort</title>
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
        .stats-row{display:flex;gap:16px;margin-bottom:28px;flex-wrap:wrap}
        .stat-pill{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:16px 24px;display:flex;align-items:center;gap:14px}
        .stat-pill .num{font-family:'Playfair Display',serif;font-size:28px;font-weight:700}
        .stat-pill .lbl{font-size:12px;color:var(--muted)}
        .stat-pill.gold .num{color:var(--gold)}
        .stat-pill.blue .num{color:#60a5fa}
        .toolbar{display:flex;align-items:center;gap:12px;margin-bottom:20px;flex-wrap:wrap}
        .search-box{display:flex;align-items:center;gap:8px;background:rgba(255,255,255,0.05);border:1px solid var(--border);border-radius:10px;padding:8px 14px;flex:1;min-width:200px;max-width:360px}
        .search-box input{background:none;border:none;outline:none;color:#fff;font-size:13.5px;width:100%}
        .search-box input::placeholder{color:var(--muted)}
        .filter-tabs{display:flex;gap:8px}
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
        .badge-diamond{background:rgba(201,168,76,0.12);color:var(--gold)}
        .badge-normal{background:rgba(255,255,255,0.07);color:var(--muted)}
        .badge-admin{background:rgba(201,168,76,0.12);color:var(--gold)}
        .badge-staff{background:rgba(96,165,250,0.12);color:#60a5fa}
        .badge-active{background:rgba(74,222,128,0.12);color:#4ade80}
        .badge-locked{background:rgba(248,113,113,0.12);color:#f87171}
        .btn-sm{padding:5px 14px;border-radius:4px;font-size:11.5px;font-weight:600;border:none;cursor:pointer;transition:all 0.2s;font-family:'Inter',sans-serif}
        .btn-lock{background:rgba(248,113,113,0.1);color:#f87171;border:1px solid rgba(248,113,113,0.3)}
        .btn-lock:hover{background:#f87171;color:#fff}
        .empty{padding:60px;text-align:center;color:var(--muted)}
        .section-divider{margin:32px 0 20px;display:flex;align-items:center;gap:12px}
        .section-divider span{font-family:'Playfair Display',serif;font-size:17px;color:#fff}
        .section-divider::before,.section-divider::after{content:'';flex:1;height:1px;background:var(--border)}
        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .actions-grid { grid-template-columns: repeat(2, 1fr); }
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
            .filter-tabs { overflow-x: auto; flex-wrap: nowrap; }
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
        <a href="${pageContext.request.contextPath}/dashboard/users" class="nav-item active">
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
        <div class="topbar-title">Quản Lý Người Dùng</div>
        <span style="font-size:12px;color:var(--muted)" id="topbarDate"></span>
    </div>
    <div class="content">
        <div class="section-label">Hệ Thống</div>
        <div class="section-title">Danh Sách Người Dùng</div>

        <c:if test="${not empty flashMsg}">
            <div style="padding:14px 20px;border-radius:10px;margin-bottom:20px;font-size:13.5px;font-weight:500;background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.25);color:#4ade80;">${flashMsg}</div>
        </c:if>

        <div class="stats-row">
            <div class="stat-pill gold"><div class="num">${totalCustomers}</div><div class="lbl">Khách Hàng</div></div>
            <div class="stat-pill blue"><div class="num">${totalEmployees}</div><div class="lbl">Nhân Viên</div></div>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/dashboard/users">
            <div class="toolbar">
                <div class="search-box">
                    <input type="text" name="q" placeholder="Tìm tên, email, tài khoản..." value="<c:out value='${search}'/>">
                </div>
                <div class="filter-tabs">
                    <a href="?filter=ALL${not empty search ? '&q='.concat(search) : ''}" class="tab ${filter == 'ALL' ? 'active' : ''}">Tất Cả</a>
                    <a href="?filter=CUSTOMER${not empty search ? '&q='.concat(search) : ''}" class="tab ${filter == 'CUSTOMER' ? 'active' : ''}">Khách Hàng</a>
                    <c:if test="${isAdmin}">
                        <a href="?filter=EMPLOYEE${not empty search ? '&q='.concat(search) : ''}" class="tab ${filter == 'EMPLOYEE' ? 'active' : ''}">Nhân Viên</a>
                    </c:if>
                </div>
                <button type="submit" style="padding:8px 20px;background:var(--gold);color:var(--dark);border:none;border-radius:4px;font-size:13px;font-weight:700;cursor:pointer;">Tìm</button>
            </div>
        </form>

        <c:if test="${filter == 'ALL' || filter == 'CUSTOMER'}">
        <div class="section-divider"><span>Khách Hàng (${totalCustomers})</span></div>
        <div class="table-card" style="margin-bottom:28px">
            <c:choose>
                <c:when test="${not empty customers}">
                    <table>
                        <thead><tr>
                            <th>ID</th><th>Họ Tên</th><th>Email</th><th>Điện Thoại</th>
                            <th>Loại KH</th><th>Điểm</th><th>Tổng Chi Tiêu</th><th>Trạng Thái</th>
                            <c:if test="${isAdmin}"><th>Thao Tác</th></c:if>
                        </tr></thead>
                        <tbody>
                        <c:forEach var="c" items="${customers}">
                            <tr>
                                <td style="color:var(--gold);font-weight:600">${c.id}</td>
                                <td>${c.fullName}</td>
                                <td style="color:rgba(255,255,255,0.6)">${c.email}</td>
                                <td>${c.phoneNumber}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.typeCustomer == 'Diamond'}"><span class="badge badge-diamond">Kim Cương</span></c:when>
                                        <c:when test="${c.typeCustomer == 'Gold'}"><span class="badge" style="background:rgba(234,179,8,0.12);color:#eab308">Vàng</span></c:when>
                                        <c:when test="${c.typeCustomer == 'Silver'}"><span class="badge" style="background:rgba(148,163,184,0.12);color:#94a3b8">Bạc</span></c:when>
                                        <c:otherwise><span class="badge badge-normal">Thường</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="color:var(--gold)">${c.loyaltyPoints}</td>
                                <td style="color:#4ade80;font-weight:600;"><fmt:formatNumber value="${c.totalSpent}" pattern="#,###"/> đ</td>
                                <td><span class="badge badge-active">Hoạt động</span></td>
                                <c:if test="${isAdmin}">
                                <td>
                                    <button class="btn-sm" style="background:rgba(74,222,128,0.1);color:#4ade80;border:1px solid rgba(74,222,128,0.3);"
                                        onclick="openVoucherModal('${c.id}', '${c.fullName}', '${c.typeCustomer}')">Tặng Voucher</button>
                                    <a href="${pageContext.request.contextPath}/dashboard/bookings?q=${c.fullName}" class="btn-sm" style="background:rgba(96,165,250,0.1);color:#60a5fa;border:1px solid rgba(96,165,250,0.3);text-decoration:none">Booking</a>

                                    <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline;margin-left:4px;">
                                        <input type="hidden" name="action" value="lock_user">
                                        <input type="hidden" name="userId" value="${c.id}">
                                        <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users">
                                        <button type="submit" class="btn-sm btn-lock" onclick="return confirm('Khóa tài khoản ${c.fullName}?')">Khóa</button>
                                    </form>
                                </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise><div class="empty"><p>Không tìm thấy khách hàng</p></div></c:otherwise>
            </c:choose>
        </div>
        </c:if>

        <c:if test="${isAdmin && (filter == 'ALL' || filter == 'EMPLOYEE')}">
        <div class="section-divider" style="margin-top:32px">
            <span>Nhân Viên (${totalEmployees})</span>
            <button onclick="document.getElementById('addEmpModal').style.display='flex'"
                style="margin-left:auto;padding:7px 18px;background:var(--gold);color:var(--dark);border:none;border-radius:6px;font-size:12.5px;font-weight:700;cursor:pointer;">+ Thêm Nhân Viên</button>
        </div>
        <div class="table-card">
            <c:choose>
                <c:when test="${not empty employees}">
                    <table>
                        <thead><tr>
                            <th>ID</th><th>Họ Tên</th><th>Chức Vụ</th><th>Phòng Ban</th><th>Role</th><th>Email</th><th>Trạng Thái</th>
                            <c:if test="${isAdmin}"><th>Thao Tác</th></c:if>
                        </tr></thead>
                        <tbody>
                        <c:forEach var="e" items="${employees}">
                            <tr>
                                <td style="color:var(--gold);font-weight:600">${e.id}</td>
                                <td>${e.fullName}</td>
                                <td>${e.position}</td>
                                <td>${e.deptName}</td>
                                <td><span class="badge ${e.role == 'ADMIN' ? 'badge-admin' : 'badge-staff'}">${e.role}</span></td>
                                <td style="color:rgba(255,255,255,0.6)">${e.email}</td>
                                <td><span class="badge ${e.isActive ? 'badge-active' : 'badge-locked'}">${e.isActive ? 'Đang làm' : 'Nghỉ'}</span></td>
                                <c:if test="${isAdmin}">
                                <td>
                                    <button class="btn-sm" style="background:rgba(201,168,76,0.1);color:var(--gold);border:1px solid rgba(201,168,76,0.3);" onclick="openEmpModal('${e.id}', '${e.salary}', '${e.position}', '${e.role}', '${e.fullName}')">Sửa</button>
                                </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise><div class="empty"><p>Không tìm thấy nhân viên</p></div></c:otherwise>
            </c:choose>
        </div>
        </c:if>
    </div>
</div>

<!-- ── MODAL: Cập Nhật Nhân Viên ── -->
<div id="empModal" style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.8);z-index:999;backdrop-filter:blur(5px);justify-content:center;align-items:center;">
    <div style="background:#0d1526;border:1px solid rgba(201,168,76,0.2);border-radius:20px;padding:32px;width:90%;max-width:420px;position:relative;">
        <button style="position:absolute;top:16px;right:20px;color:var(--muted);font-size:26px;cursor:pointer;border:none;background:none;" onclick="document.getElementById('empModal').style.display='none'">&times;</button>
        <div style="font-size:10px;color:var(--gold);letter-spacing:2px;text-transform:uppercase;margin-bottom:6px;">NHÂN VIÊN</div>
        <div id="empModalName" style="font-family:'Playfair Display',serif;font-size:22px;color:#fff;margin-bottom:24px;"></div>
        <form method="post" action="${pageContext.request.contextPath}/dashboard/action">
            <input type="hidden" name="action" value="update_employee">
            <input type="hidden" name="empId" id="empIdInput">
            <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users?filter=EMPLOYEE">
            <div style="margin-bottom:16px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:8px;">Lương (VNĐ)</label>
                <input type="number" name="salary" id="empSalaryInput" style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;" required step="1000">
            </div>
            <div style="margin-bottom:16px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:8px;">Chức Vụ</label>
                <input type="text" name="position" id="empPosInput" style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;" required>
            </div>
            <div style="margin-bottom:20px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:8px;">Quyền (Role)</label>
                <select name="role" id="empRoleInput" style="width:100%;background:rgba(13,21,38,0.98);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;">
                    <option value="STAFF">STAFF</option>
                    <option value="ADMIN">ADMIN</option>
                </select>
                <div id="empRoleHint" style="font-size:11px;color:#fbbf24;margin-top:6px;">Đổi lên ADMIN sẽ cấp toàn quyền hệ thống</div>
            </div>
            <div style="display:flex;gap:10px;">
                <button type="button" onclick="document.getElementById('empModal').style.display='none'"
                    style="flex:1;padding:12px;border-radius:50px;background:transparent;border:1.5px solid rgba(255,255,255,0.15);color:var(--muted);font-size:13px;font-weight:600;cursor:pointer;">Hủy</button>
                <button type="submit"
                    style="flex:2;padding:12px;border-radius:50px;background:linear-gradient(135deg,var(--gold),#e8cc82);color:#0a0a0f;font-size:13px;font-weight:700;border:none;cursor:pointer;">Lưu Thay Đổi</button>
            </div>
        </form>
    </div>
</div>

<!-- ── MODAL: Tặng Voucher ── -->
<div id="voucherModal" style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.8);z-index:999;backdrop-filter:blur(5px);justify-content:center;align-items:center;">
    <div style="background:#0d1526;border:1px solid rgba(201,168,76,0.2);border-radius:20px;padding:32px;width:90%;max-width:480px;position:relative;">
        <button style="position:absolute;top:16px;right:20px;color:var(--muted);font-size:26px;cursor:pointer;border:none;background:none;" onclick="document.getElementById('voucherModal').style.display='none'">&times;</button>
        <div style="font-size:10px;color:var(--gold);letter-spacing:2px;text-transform:uppercase;margin-bottom:6px;">TẶNG ƯU ĐÃI</div>
        <div id="voucherModalName" style="font-family:'Playfair Display',serif;font-size:22px;color:#fff;margin-bottom:6px;"></div>
        <div style="font-size:13px;color:var(--muted);margin-bottom:20px;">Chọn voucher phù hợp với hạng thành viên</div>
        <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:20px;">
            <div onclick="selectVoucher('EARLYBIRD20','earlybird-card')" id="earlybird-card"
                style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);border-radius:12px;padding:16px 12px;cursor:pointer;transition:all 0.2s;text-align:center;">
                <div style="font-size:22px;font-weight:800;color:#60a5fa;margin-bottom:4px;">20%</div>
                <div style="font-size:12px;font-weight:700;color:#fff;margin-bottom:6px;">Đặt Sớm 30 Ngày</div>
                <div style="font-size:10px;color:var(--muted);margin-bottom:10px;">Giảm 20% cho mọi loại phòng &amp; villa</div>
                <div style="font-size:10px;font-weight:700;color:#60a5fa;background:rgba(96,165,250,0.1);padding:3px 8px;border-radius:4px;display:inline-block;">EARLYBIRD20</div>
            </div>
            <div onclick="selectVoucher('WEEKEND15','weekend-card')" id="weekend-card"
                style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);border-radius:12px;padding:16px 12px;cursor:pointer;transition:all 0.2s;text-align:center;">
                <div style="font-size:22px;font-weight:800;color:#4ade80;margin-bottom:4px;">15%</div>
                <div style="font-size:12px;font-weight:700;color:#fff;margin-bottom:6px;">Gói Cuối Tuần</div>
                <div style="font-size:10px;color:var(--muted);margin-bottom:10px;">Giảm 15% + tặng dịch vụ miễn phí 2 người</div>
                <div style="font-size:10px;font-weight:700;color:#4ade80;background:rgba(74,222,128,0.1);padding:3px 8px;border-radius:4px;display:inline-block;">WEEKEND15</div>
            </div>
            <div onclick="selectVoucher('VIP2026','vip-card')" id="vip-card"
                style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);border-radius:12px;padding:16px 12px;cursor:pointer;transition:all 0.2s;text-align:center;">
                <div style="font-size:22px;font-weight:800;color:var(--gold);margin-bottom:4px;">30%</div>
                <div style="font-size:12px;font-weight:700;color:#fff;margin-bottom:6px;">Khách VIP</div>
                <div style="font-size:10px;color:var(--muted);margin-bottom:10px;">Giảm 30% dành riêng cho Diamond/Gold</div>
                <div style="font-size:10px;font-weight:700;color:var(--gold);background:rgba(201,168,76,0.1);padding:3px 8px;border-radius:4px;display:inline-block;">VIP2026</div>
            </div>
        </div>
        <div id="voucherHint" style="font-size:12px;color:#fbbf24;margin-bottom:20px;padding:10px 14px;background:rgba(251,191,36,0.06);border:1px solid rgba(251,191,36,0.2);border-radius:8px;display:none;"></div>
        <form method="post" action="${pageContext.request.contextPath}/dashboard/action">
            <input type="hidden" name="action" value="give_voucher">
            <input type="hidden" name="userId" id="voucherUserId">
            <input type="hidden" name="voucherCode" id="voucherCodeInput">
            <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users">
            <div style="display:flex;gap:10px;">
                <button type="button" onclick="document.getElementById('voucherModal').style.display='none'"
                    style="flex:1;padding:12px;border-radius:50px;background:transparent;border:1.5px solid rgba(255,255,255,0.15);color:var(--muted);font-size:13px;font-weight:600;cursor:pointer;">Hủy</button>
                <button type="submit" id="voucherSubmitBtn" disabled
                    style="flex:2;padding:12px;border-radius:50px;background:#4ade80;color:#000;font-size:13px;font-weight:700;border:none;cursor:pointer;opacity:0.5;">Tặng Voucher</button>
            </div>
        </form>
    </div>
</div>

<!-- ── MODAL: Thêm Nhân Viên ── -->
<div id="addEmpModal" style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.8);z-index:999;backdrop-filter:blur(5px);justify-content:center;align-items:center;overflow-y:auto;">
    <div style="background:#0d1526;border:1px solid rgba(201,168,76,0.2);border-radius:20px;padding:32px;width:90%;max-width:460px;position:relative;margin:auto;">
        <button style="position:absolute;top:16px;right:20px;color:var(--muted);font-size:26px;cursor:pointer;border:none;background:none;" onclick="document.getElementById('addEmpModal').style.display='none'">&times;</button>
        <div style="font-size:10px;color:var(--gold);letter-spacing:2px;text-transform:uppercase;margin-bottom:6px;">NHÂN VIÊN MỚI</div>
        <div style="font-family:'Playfair Display',serif;font-size:22px;color:#fff;margin-bottom:24px;">Thêm Nhân Viên</div>
        <form method="post" action="${pageContext.request.contextPath}/dashboard/action">
            <input type="hidden" name="action" value="add_employee">
            <div style="margin-bottom:14px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:7px;">Họ Tên *</label>
                <input type="text" name="fullName" placeholder="Nguyễn Văn B" required
                    style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;">
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:7px;">Email *</label>
                <input type="email" name="email" placeholder="email@resort.com" required
                    style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;">
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:7px;">Số Điện Thoại</label>
                <input type="text" name="phone" placeholder="09xxxxxxxx"
                    style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;">
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:7px;">Tên Tài Khoản *</label>
                <input type="text" name="account" placeholder="username" required
                    style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;">
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:7px;">Mật Khẩu *</label>
                <input type="password" name="password" placeholder="••••••" required minlength="6"
                    style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;">
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:7px;">Chức Vụ *</label>
                <input type="text" name="position" placeholder="Lễ tân, Quản lý..." required
                    style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;">
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:7px;">Lương (VNĐ)</label>
                <input type="number" name="salary" placeholder="10000000" step="1000"
                    style="width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;">
            </div>
            <div style="margin-bottom:20px;">
                <label style="display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:7px;">Quyền</label>
                <select name="role" id="addEmpRole"
                    style="width:100%;background:rgba(13,21,38,0.98);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:11px 14px;color:#fff;font-size:14px;outline:none;"
                    onchange="document.getElementById('addRoleHint').style.display=this.value=='ADMIN'?'block':'none'">
                    <option value="STAFF">STAFF</option>
                    <option value="ADMIN">ADMIN</option>
                </select>
                <div id="addRoleHint" style="display:none;font-size:11px;color:#fbbf24;margin-top:6px;">ADMIN có toàn quyền hệ thống</div>
            </div>
            <div style="display:flex;gap:10px;">
                <button type="button" onclick="document.getElementById('addEmpModal').style.display='none'"
                    style="flex:1;padding:12px;border-radius:50px;background:transparent;border:1.5px solid rgba(255,255,255,0.15);color:var(--muted);font-size:13px;font-weight:600;cursor:pointer;">Hủy</button>
                <button type="submit"
                    style="flex:2;padding:12px;border-radius:50px;background:linear-gradient(135deg,var(--gold),#e8cc82);color:#0a0a0f;font-size:13px;font-weight:700;border:none;cursor:pointer;">+ Thêm Nhân Viên</button>
            </div>
        </form>
    </div>
</div>

<div id="sidebarOverlay" onclick="document.querySelector('.sidebar').classList.remove('open');this.style.display='none'" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:199"></div>
<script>
    document.getElementById('topbarDate').textContent =
        new Date().toLocaleDateString('vi-VN',{weekday:'long',year:'numeric',month:'long',day:'numeric'});

    const menuBtn = document.getElementById('menuToggle');
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    if (menuBtn) {
        menuBtn.addEventListener('click', function() {
            sidebar.classList.toggle('open');
            overlay.style.display = sidebar.classList.contains('open') ? 'block' : 'none';
        });
    }

    function openEmpModal(id, salary, pos, role, name) {
        document.getElementById('empIdInput').value = id;
        document.getElementById('empSalaryInput').value = salary;
        document.getElementById('empPosInput').value = pos;
        document.getElementById('empRoleInput').value = role;
        document.getElementById('empModalName').textContent = name || id;
        document.getElementById('empRoleHint').style.display = role === 'ADMIN' ? 'block' : 'none';
        document.getElementById('empModal').style.display = 'flex';
    }

    document.getElementById('empRoleInput').addEventListener('change', function() {
        document.getElementById('empRoleHint').style.display = this.value === 'ADMIN' ? 'block' : 'none';
    });

    var selectedVoucher = null;
    function openVoucherModal(userId, name, type) {
        document.getElementById('voucherUserId').value = userId;
        document.getElementById('voucherModalName').textContent = name;
        selectedVoucher = null;
        document.getElementById('voucherCodeInput').value = '';
        document.getElementById('voucherSubmitBtn').disabled = true;
        document.getElementById('voucherSubmitBtn').style.opacity = '0.5';
        // Reset card borders
        ['earlybird-card','weekend-card','vip-card'].forEach(function(id) {
            document.getElementById(id).style.borderColor = 'rgba(255,255,255,0.08)';
        });
        // Auto-suggest for Diamond
        var hint = document.getElementById('voucherHint');
        if (type === 'Diamond') {
            hint.textContent = '💎 Khách Diamond — Gợi ý tặng VIP2026 (30%) để tri ân khách hàng thân thiết nhất.';
            hint.style.display = 'block';
        } else {
            hint.style.display = 'none';
        }
        document.getElementById('voucherModal').style.display = 'flex';
    }

    function selectVoucher(code, cardId) {
        selectedVoucher = code;
        document.getElementById('voucherCodeInput').value = code;
        document.getElementById('voucherSubmitBtn').disabled = false;
        document.getElementById('voucherSubmitBtn').style.opacity = '1';
        ['earlybird-card','weekend-card','vip-card'].forEach(function(id) {
            document.getElementById(id).style.borderColor = 'rgba(255,255,255,0.08)';
            document.getElementById(id).style.background = 'rgba(255,255,255,0.04)';
        });
        var card = document.getElementById(cardId);
        card.style.borderColor = 'var(--gold)';
        card.style.background = 'rgba(201,168,76,0.08)';
    }
</script>
</body>
</html>
