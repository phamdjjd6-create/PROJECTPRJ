<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%
    TblPersons currentUser = (TblPersons) session.getAttribute("account");
    if (currentUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    pageContext.setAttribute("currentUser", currentUser);
    boolean isEmployee = currentUser instanceof TblEmployees;
    pageContext.setAttribute("isEmployee", isEmployee);
    String dashboardUrl = "";
    if (isEmployee) {
        String role = ((TblEmployees) currentUser).getRole();
        dashboardUrl = "ADMIN".equals(role) ? request.getContextPath() + "/dashboard/admin" : request.getContextPath() + "/dashboard/staff";
    }
    pageContext.setAttribute("dashboardUrl", dashboardUrl);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        :root{--gold:#c9a84c;--gold-light:#e8cc82;--dark:#0a0a0f;--navy:#0d1526;--text:#e8e8e8;--muted:rgba(255,255,255,0.35);--border:rgba(255,255,255,0.07)}
        body{font-family:'Inter',sans-serif;background:var(--dark);color:var(--text);min-height:100vh}

        /* Navbar */
        nav{position:fixed;top:0;left:0;right:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:0 48px;height:72px;background:rgba(10,10,15,0.85);backdrop-filter:blur(20px);border-bottom:1px solid rgba(255,255,255,0.05);transition:all 0.3s}
        .brand{display:flex;align-items:center;gap:12px;text-decoration:none;font-family:'Playfair Display',serif;font-size:20px;font-weight:700;color:#fff}
        .brand-icon{width:36px;height:36px;border-radius:10px;background:var(--gold);display:flex;align-items:center;justify-content:center;color:var(--dark);font-style:italic;font-size:18px;font-weight:700}
        .brand span{color:var(--gold)}
        .nav-links{display:flex;align-items:center;gap:36px;list-style:none}
        .nav-links a{color:rgba(255,255,255,0.4);text-decoration:none;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.2em;transition:color 0.2s}
        .nav-links a:hover,.nav-links a.active{color:var(--gold)}
        .nav-user{display:flex;align-items:center;gap:16px}
        .nav-user-name{display:flex;flex-direction:column;align-items:flex-end}
        .nav-user-name span:first-child{font-size:9px;color:rgba(255,255,255,0.2);text-transform:uppercase;letter-spacing:0.3em;font-weight:700}
        .nav-user-name span:last-child{font-size:13px;font-weight:700;color:var(--gold)}
        .btn-logout-nav{width:36px;height:36px;border-radius:10px;border:1px solid rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;color:rgba(255,255,255,0.4);text-decoration:none;transition:all 0.2s;font-size:16px}
        .nav-links a.btn-dash{padding:7px 18px;border:1.5px solid rgba(201,168,76,0.35);border-radius:50px;color:var(--gold)}
        .nav-links a.btn-dash:hover{background:var(--gold);color:var(--dark)}
        .hamburger{display:none;background:none;border:none;color:#fff;font-size:22px;cursor:pointer;padding:4px 8px;line-height:1}
        .mobile-nav{display:none;position:fixed;top:72px;left:0;right:0;background:rgba(10,10,15,0.97);backdrop-filter:blur(20px);border-bottom:1px solid rgba(201,168,76,0.15);z-index:999;padding:12px 20px 16px;flex-direction:column;gap:2px}
        .mobile-nav.open{display:flex}
        .mobile-nav a{color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;font-weight:500;padding:10px 0;border-bottom:1px solid rgba(255,255,255,0.05)}
        .mobile-nav a:last-child{border-bottom:none}
        .mobile-nav a:hover,.mobile-nav a.active{color:var(--gold)}

        /* Main */
        main{max-width:860px;margin:0 auto;padding:120px 24px 80px}

        /* Breadcrumb */
        .breadcrumb{display:flex;align-items:center;gap:10px;font-size:10px;color:rgba(255,255,255,0.2);text-transform:uppercase;letter-spacing:0.3em;font-weight:700;margin-bottom:48px}
        .breadcrumb a{color:rgba(255,255,255,0.2);text-decoration:none;transition:color 0.2s}
        .breadcrumb a:hover{color:var(--gold)}
        .breadcrumb .current{color:var(--gold)}

        /* Card */
        .profile-card{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.06);border-radius:32px;padding:56px;backdrop-filter:blur(10px)}

        /* Header */
        .card-header{text-align:center;margin-bottom:48px}
        .header-tag{display:inline-block;padding:6px 16px;border-radius:50px;background:rgba(201,168,76,0.1);border:1px solid rgba(201,168,76,0.2);color:var(--gold);font-size:9px;text-transform:uppercase;letter-spacing:0.4em;font-weight:700;margin-bottom:16px}
        .card-header h1{font-family:'Playfair Display',serif;font-size:48px;font-weight:700;color:#fff;line-height:1.1;margin-bottom:12px}
        .card-header h1 em{color:var(--gold);font-style:italic}
        .card-header p{font-size:11px;color:rgba(255,255,255,0.25);text-transform:uppercase;letter-spacing:0.2em;font-weight:500}

        /* Flash */
        .flash-success{padding:16px 20px;background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.2);border-radius:16px;color:#4ade80;font-size:13px;font-weight:600;text-align:center;margin-bottom:32px}
        .flash-error{padding:16px 20px;background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);border-radius:16px;color:#f87171;font-size:13px;font-weight:600;text-align:center;margin-bottom:32px}

        /* Form */
        .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:28px;margin-bottom:28px}
        .form-grid.single{grid-template-columns:1fr}
        @media(max-width:640px){.form-grid{grid-template-columns:1fr}}
        @media(max-width:1024px){
            main{max-width:100%}
            .profile-card{padding:36px 28px}
        }
        @media(max-width:768px){
            nav{padding:0 16px}
            .nav-links{display:none}
            main{padding:90px 16px 60px}
            .profile-card{padding:28px 18px;border-radius:20px}
            .card-header h1{font-size:32px}
            .form-grid{grid-template-columns:1fr}
            .form-grid.single{grid-template-columns:1fr}
            .nav-user{display:none}
            .hamburger{display:block}
        }
        .form-group{display:flex;flex-direction:column;gap:8px}
        .form-label{font-size:10px;color:rgba(255,255,255,0.3);text-transform:uppercase;letter-spacing:0.2em;font-weight:700}
        .form-input{width:100%;background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:14px 18px;color:#fff;font-size:14px;font-family:'Inter',sans-serif;outline:none;transition:border-color 0.2s,background 0.2s}
        .form-input:focus{border-color:rgba(201,168,76,0.4);background:rgba(255,255,255,0.05)}
        .form-input:disabled{opacity:0.35;cursor:not-allowed;border-style:dashed}
        .form-input-readonly{position:relative}
        .form-input-readonly .readonly-tag{position:absolute;right:16px;top:50%;transform:translateY(-50%);font-size:8px;color:rgba(255,255,255,0.1);text-transform:uppercase;letter-spacing:0.2em;font-weight:700}
        select.form-input{appearance:none;cursor:pointer}
        select.form-input option{background:#0d1526;color:#fff}

        /* Submit */
        .form-footer{padding-top:36px;display:flex;flex-direction:column;gap:16px}
        .btn-submit{width:100%;padding:18px;background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--dark);font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.3em;border:none;border-radius:16px;cursor:pointer;transition:all 0.25s;font-family:'Inter',sans-serif}
        .btn-submit:hover{transform:scale(1.01);box-shadow:0 0 30px rgba(201,168,76,0.25)}
        .form-links{display:flex;align-items:center;justify-content:center;gap:24px}
        .form-links a{font-size:9px;color:rgba(255,255,255,0.2);text-transform:uppercase;letter-spacing:0.3em;font-weight:700;text-decoration:none;transition:color 0.2s}
        .form-links a:hover{color:var(--gold)}
        .form-links .sep{width:4px;height:4px;border-radius:50%;background:rgba(255,255,255,0.05)}

        /* Footer */
        footer{padding:48px;border-top:1px solid rgba(255,255,255,0.05);text-align:center;font-size:10px;color:rgba(255,255,255,0.15);text-transform:uppercase;letter-spacing:0.3em;font-weight:700}
    </style>
</head>
<body>

<nav id="navbar">
    <a href="${pageContext.request.contextPath}/" class="brand">
        <div class="brand-icon">A</div>
        Azure <span>Resort</span>
    </a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="active">Tài Khoản</a></li>
        <c:if test="${isEmployee}">
            <li><a href="${dashboardUrl}" class="btn-dash">Dashboard</a></li>
        </c:if>
    </ul>
    <button class="hamburger" id="hamburgerBtn" onclick="document.getElementById('mobileNavPF').classList.toggle('open')" aria-label="Menu">☰</button>
    <div class="nav-user">
        <div class="nav-user-name">
            <span>Authenticated as</span>
            <span>${currentUser.fullName}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout-nav" title="Đăng xuất">⎋</a>
    </div>
</nav>

<main>
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Azure Resort</a>
        <span>/</span>
        <a href="${pageContext.request.contextPath}/account.jsp">Tài khoản</a>
        <span>/</span>
        <span class="current">Hồ sơ cá nhân</span>
    </nav>

    <div class="profile-card">
        <div class="card-header">
            <div class="header-tag">Hồ sơ định danh</div>
            <h1>Chi tiết <em>Cá nhân</em></h1>
            <p>Quản lý thông tin bảo mật của bạn tại Azure</p>
        </div>

        <form action="${pageContext.request.contextPath}/profile" method="POST">

            <c:if test="${not empty requestScope.successMessage}">
                <div class="flash-success">✦ ${requestScope.successMessage}</div>
            </c:if>
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="flash-error">⚠️ ${requestScope.errorMessage}</div>
            </c:if>

            <!-- Read-only fields -->
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Tài khoản đăng nhập</label>
                    <div class="form-input-readonly">
                        <input type="text" class="form-input" value="${currentUser.account}" disabled>
                        <span class="readonly-tag">Read Only</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Mã số định danh (UID)</label>
                    <div class="form-input-readonly">
                        <input type="text" class="form-input" value="AZ-${currentUser.id}" disabled style="font-family:monospace">
                        <span class="readonly-tag">System Key</span>
                    </div>
                </div>
            </div>

            <!-- Full name -->
            <div class="form-grid single" style="margin-bottom:28px">
                <div class="form-group">
                    <label for="fullName" class="form-label">Họ và Tên đầy đủ</label>
                    <input type="text" name="fullName" id="fullName" class="form-input"
                        value="${currentUser.fullName}" required placeholder="Vui lòng nhập họ tên...">
                </div>
            </div>

            <!-- DOB + Gender -->
            <div class="form-grid">
                <div class="form-group">
                    <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                    <fmt:formatDate var="dobFormatted" value="${currentUser.dateOfBirth}" pattern="yyyy-MM-dd"/>
                    <input type="date" name="dateOfBirth" id="dateOfBirth" class="form-input"
                        value="${dobFormatted}" style="color-scheme:dark">
                </div>
                <div class="form-group">
                    <label for="gender" class="form-label">Giới tính</label>
                    <div style="position:relative">
                        <select name="gender" id="gender" class="form-input" style="padding-right:40px">
                            <option value="" ${empty currentUser.gender ? 'selected' : ''}>Chưa xác định</option>
                            <option value="Male"   ${currentUser.gender == 'Male'   ? 'selected' : ''}>Nam</option>
                            <option value="Female" ${currentUser.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                        </select>
                        <span style="position:absolute;right:16px;top:50%;transform:translateY(-50%);color:rgba(201,168,76,0.4);pointer-events:none;font-size:11px">▼</span>
                    </div>
                </div>
            </div>

            <!-- Phone + ID Card -->
            <div class="form-grid" style="margin-top:28px">
                <div class="form-group">
                    <label for="phoneNumber" class="form-label">Số điện thoại</label>
                    <input type="tel" name="phoneNumber" id="phoneNumber" class="form-input"
                        value="${currentUser.phoneNumber}" placeholder="09xx xxx xxx">
                </div>
                <div class="form-group">
                    <label for="idCard" class="form-label">CCCD / Passport</label>
                    <input type="text" name="idCard" id="idCard" class="form-input"
                        value="${currentUser.idCard}" placeholder="Nhập số giấy tờ...">
                </div>
            </div>

            <!-- Email -->
            <div class="form-grid single" style="margin-top:28px">
                <div class="form-group">
                    <label for="email" class="form-label">Địa chỉ Email</label>
                    <input type="email" name="email" id="email" class="form-input"
                        value="${currentUser.email}" required placeholder="example@azure.com">
                </div>
            </div>

            <div class="form-footer">
                <button type="submit" class="btn-submit">✦ Cập nhật hồ sơ Azure</button>
                <div class="form-links">
                    <a href="${pageContext.request.contextPath}/account.jsp">Trở về tài khoản</a>
                    <div class="sep"></div>
                    <a href="${pageContext.request.contextPath}/password_change">Đổi mật khẩu</a>
                    <c:if test="${isEmployee}">
                        <div class="sep"></div>
                        <a href="${dashboardUrl}">Quay về Dashboard</a>
                    </c:if>
                </div>
            </div>
        </form>
    </div>
</main>

<footer>© 2026 Azure Resort &amp; Spa — Personal Security</footer>

<script>
    // Set max date for DOB (must be 18+)
    const maxDate = new Date();
    maxDate.setFullYear(maxDate.getFullYear() - 18);
    const dobInput = document.getElementById('dateOfBirth');
    if (dobInput) dobInput.setAttribute('max', maxDate.toISOString().split('T')[0]);

    // Navbar shrink on scroll
    window.addEventListener('scroll', () => {
        const nav = document.getElementById('navbar');
        if (window.scrollY > 50) {
            nav.style.height = '60px';
            nav.style.background = 'rgba(10,10,15,0.95)';
        } else {
            nav.style.height = '72px';
            nav.style.background = 'rgba(10,10,15,0.85)';
        }
    });
</script>
</body>
</html>
