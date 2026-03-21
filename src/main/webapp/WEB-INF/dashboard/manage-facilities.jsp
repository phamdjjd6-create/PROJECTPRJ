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
        .facility-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:20px}
        .facility-card{background:var(--card);border:1px solid var(--border);border-radius:16px;overflow:hidden;transition:all 0.3s}
        .facility-card:hover{border-color:rgba(201,168,76,0.2);transform:translateY(-2px)}
        .card-header{padding:20px 22px 16px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:flex-start}
        .facility-code{font-family:'Playfair Display',serif;font-size:17px;font-weight:600;color:#fff}
        .facility-name{font-size:12px;color:var(--muted);margin-top:3px}
        .badge{display:inline-block;padding:4px 10px;border-radius:4px;font-size:10.5px;font-weight:700}
        .badge-available{background:rgba(74,222,128,0.12);color:#4ade80}
        .badge-occupied{background:rgba(248,113,113,0.12);color:#f87171}
        .badge-maintenance{background:rgba(251,191,36,0.12);color:#fbbf24}
        .badge-cleaning{background:rgba(96,165,250,0.12);color:#60a5fa}
        .badge-villa{background:rgba(201,168,76,0.12);color:var(--gold)}
        .badge-house{background:rgba(96,165,250,0.12);color:#60a5fa}
        .badge-room{background:rgba(167,139,250,0.12);color:#a78bfa}
        .card-body{padding:16px 22px}
        .info-row{display:flex;gap:20px;flex-wrap:wrap;margin-bottom:14px}
        .info-item .lbl{font-size:10px;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:3px}
        .info-item .val{font-size:13.5px;color:#fff;font-weight:500}
        .info-item .val.gold{color:var(--gold);font-family:'Playfair Display',serif}
        .usage-bar-wrap{margin-bottom:14px}
        .usage-label{display:flex;justify-content:space-between;font-size:11px;color:var(--muted);margin-bottom:5px}
        .usage-bar{height:5px;background:rgba(255,255,255,0.08);border-radius:3px;overflow:hidden}
        .usage-fill{height:100%;border-radius:3px;transition:width 0.5s}
        .fill-green{background:linear-gradient(90deg,#4ade80,#22c55e)}
        .fill-yellow{background:linear-gradient(90deg,#fbbf24,#f59e0b)}
        .fill-red{background:linear-gradient(90deg,#f87171,#ef4444)}
        .card-actions{display:flex;gap:8px;flex-wrap:wrap;padding-top:14px;border-top:1px solid var(--border)}
        .btn-sm{padding:6px 14px;border-radius:4px;font-size:12px;font-weight:600;border:none;cursor:pointer;transition:all 0.2s;font-family:'Inter',sans-serif}
        .btn-available{background:rgba(74,222,128,0.1);color:#4ade80;border:1px solid rgba(74,222,128,0.3)}
        .btn-available:hover{background:#4ade80;color:#000}
        .btn-occupied{background:rgba(248,113,113,0.1);color:#f87171;border:1px solid rgba(248,113,113,0.3)}
        .btn-occupied:hover{background:#f87171;color:#fff}
        .btn-maintenance{background:rgba(251,191,36,0.1);color:#fbbf24;border:1px solid rgba(251,191,36,0.3)}
        .btn-maintenance:hover{background:#fbbf24;color:#000}
        .btn-cleaning{background:rgba(96,165,250,0.1);color:#60a5fa;border:1px solid rgba(96,165,250,0.3)}
        .btn-cleaning:hover{background:#60a5fa;color:#000}
        .btn-disabled{opacity:0.35;cursor:not-allowed;pointer-events:none}
        .status-notice{border-radius:8px;padding:10px 14px;font-size:12px;margin-bottom:12px}
        .notice-red{background:rgba(248,113,113,0.06);border:1px solid rgba(248,113,113,0.2);color:#f87171}
        .notice-blue{background:rgba(96,165,250,0.06);border:1px solid rgba(96,165,250,0.2);color:#60a5fa}
        .notice-yellow{background:rgba(251,191,36,0.06);border:1px solid rgba(251,191,36,0.2);color:#fbbf24}
        .empty{padding:60px;text-align:center;color:var(--muted)}
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
        <div class="nav-section">Quản Lý</div>
        <a href="${pageContext.request.contextPath}/dashboard/users" class="nav-item">
            <span class="nav-dot"></span> Người Dùng
        </a>
        <a href="${pageContext.request.contextPath}/dashboard/bookings" class="nav-item">
            <span class="nav-dot"></span> Booking
        </a>
        <a href="${pageContext.request.contextPath}/dashboard/contracts" class="nav-item">
            <span class="nav-dot"></span> Hợp Đồng
        </a>
        <a href="${pageContext.request.contextPath}/dashboard/facilities" class="nav-item active">
            <span class="nav-dot"></span> Phòng &amp; Villa
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng Xuất</a>
    </div>
</aside>
