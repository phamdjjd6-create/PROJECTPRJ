<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Tin Cá Nhân — Azure Resort</title>
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
            --text: #e8e8e8; --text-muted: rgba(255,255,255,0.45);
        }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); min-height: 100vh; }
        .glass { background: rgba(255,255,255,0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.08); }
        
        /* Navbar */
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 48px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.85); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.1); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 32px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.6); text-decoration: none; font-size: 13px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover, .nav-links a.active { color: var(--gold); }

        /* Profile Layout */
        .profile-container { max-width: 1000px; margin: 0 auto; padding: 120px 24px 80px; }
        .profile-grid { display: grid; grid-template-columns: 280px 1fr; gap: 40px; }
        
        .sidebar-card { padding: 32px 24px; border-radius: 24px; text-align: center; }
        .avatar-wrap { width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, var(--gold), var(--gold-light)); margin: 0 auto 20px; display: flex; align-items: center; justify-content: center; font-size: 40px; color: var(--dark); font-weight: 700; border: 4px solid rgba(255,255,255,0.05); }
        .user-name { font-family: 'Playfair Display', serif; font-size: 20px; color: #fff; margin-bottom: 4px; }
        .user-role { font-size: 11px; color: var(--gold); text-transform: uppercase; letter-spacing: 2px; font-weight: 600; }
        
        .sidebar-nav { margin-top: 40px; text-align: left; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: rgba(255,255,255,0.5); text-decoration: none; font-size: 14px; transition: all 0.2s; margin-bottom: 6px; }
        .nav-item:hover, .nav-item.active { background: rgba(201,168,76,0.1); color: var(--gold); }
        .nav-item.logout { color: #f87171; }
        .nav-item.logout:hover { background: rgba(248,113,113,0.1); }

        .content-card { padding: 40px; border-radius: 32px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: 24px; color: #fff; margin-bottom: 30px; display: flex; align-items: center; gap: 12px; }
        
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .info-group label { display: block; font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; color: var(--gold); margin-bottom: 8px; }
        .info-val { font-size: 15px; color: #fff; padding-bottom: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }

        .btn-edit { display: inline-flex; align-items: center; gap: 8px; padding: 10px 24px; background: transparent; border: 1px solid rgba(201,168,76,0.4); color: var(--gold); border-radius: 50px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.3s; margin-top: 30px; }
        .btn-edit:hover { background: var(--gold); color: var(--dark); }

        @media (max-width: 768px) {
            .profile-grid { grid-template-columns: 1fr; }
            .info-grid { grid-template-columns: 1fr; }
            .navbar { padding: 0 20px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="active">Tài Khoản</a></li>
    </ul>
</nav>

<div class="profile-container">
    <div class="profile-grid">
        <!-- Sidebar -->
        <div class="sidebar-card glass">
            <div class="avatar-wrap">
                ${sessionScope.account.fullName.substring(0, 1)}
            </div>
            <h2 class="user-name">${sessionScope.account.fullName}</h2>
            <p class="user-role">${sessionScope.account.personType == 'EMPLOYEE' ? 'Nhân viên Azure' : 'Thành viên Azure'}</p>
            
            <div class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/account.jsp" class="nav-item active">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                    Thông tin cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/booking?view=my" class="nav-item">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                    Booking của tôi
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="nav-item logout">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                    Đăng xuất
                </a>
            </div>
        </div>

        <!-- Content -->
        <div class="content-card glass">
            <h3 class="section-title">Chi tiết tài khoản</h3>
            
            <div class="info-grid">
                <div class="info-group">
                    <label>Họ và tên</label>
                    <div class="info-val">${sessionScope.account.fullName}</div>
                </div>
                <div class="info-group">
                    <label>Tên đăng nhập</label>
                    <div class="info-val">${sessionScope.account.userName}</div>
                </div>
                <div class="info-group">
                    <label>Email</label>
                    <div class="info-val">${sessionScope.account.email}</div>
                </div>
                <div class="info-group">
                    <label>Số điện thoại</label>
                    <div class="info-val">${sessionScope.account.phone}</div>
                </div>
                <div class="info-group">
                    <label>Số CMND/CCCD</label>
                    <div class="info-val">${sessionScope.account.idCard}</div>
                </div>
                <div class="info-group">
                    <label>Giới tính</label>
                    <div class="info-val">${sessionScope.account.gender}</div>
                </div>
                <div class="info-group">
                    <label>Ngày sinh</label>
                    <div class="info-val">
                        <fmt:formatDate value="${sessionScope.account.dateOfBirth}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>
                <div class="info-group">
                    <label>Địa chỉ</label>
                    <div class="info-val">${sessionScope.account.address}</div>
                </div>
            </div>

            <button class="btn-edit">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                Chỉnh sửa thông tin
            </button>
        </div>
    </div>
</div>

</body>
</html>
