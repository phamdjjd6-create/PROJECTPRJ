<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${empty sessionScope.account}">
    <c:redirect url="/login"/>
</c:if>
<c:set var="currentUser" value="${sessionScope.account}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Azure Resort & Spa — Hồ Sơ Của Tôi</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --gold: #c9a84c;
            --gold-light: #e8cc82;
            --dark: #0a0a0f;
            --navy: #0d1526;
            --text: #e8e8e8;
            --text-muted: rgba(255,255,255,0.5);
            --bg-glass: rgba(255, 255, 255, 0.05);
            --border-glass: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark);
            color: var(--text);
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* NAVBAR */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
            padding: 0 60px; height: 72px;
            display: flex; align-items: center; justify-content: space-between;
            background: rgba(10,10,15,0.9);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(201,168,76,0.15);
        }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 36px; list-style: none; }
        .nav-links a {
            color: rgba(255,255,255,0.75); text-decoration: none; font-size: 13.5px; 
            font-weight: 500; letter-spacing: 0.5px; transition: color 0.2s; position: relative;
        }
        .nav-links a::after {
            content: ''; position: absolute; bottom: -4px; left: 0; right: 100%;
            height: 1px; background: var(--gold); transition: right 0.25s;
        }
        .nav-links a:hover { color: #fff; }
        .nav-links a:hover::after { right: 0; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-greeting { color: rgba(255,255,255,0.5); font-size: 13px; }
        .nav-greeting strong { color: var(--gold); }
        .btn-nav-logout {
            padding: 8px 20px; border-radius: 50px; font-size: 13px; font-family: 'Inter', sans-serif; 
            cursor: pointer; transition: all 0.25s; text-decoration: none;
            border: 1px solid rgba(201,168,76,0.4); background: transparent; color: var(--gold);
        }
        .btn-nav-logout:hover { background: var(--gold); color: var(--dark); }

        /* PROFILE SECTION */
        .profile-page-wrap {
            flex: 1; padding: 120px 20px 60px;
            display: flex; justify-content: center; align-items: center;
            background: linear-gradient(to bottom, var(--dark), var(--navy));
        }

        .profile-container {
            max-width: 800px; width: 100%;
            background: var(--bg-glass); border: 1px solid var(--border-glass);
            border-radius: 20px; padding: 50px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5); backdrop-filter: blur(10px);
            animation: fadeUp 0.8s ease-out forwards;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .profile-header { text-align: center; margin-bottom: 40px; }
        .profile-label {
            display: inline-block; color: var(--gold); font-size: 12px;
            letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 12px;
        }
        .profile-header h1 { font-family: 'Playfair Display', serif; font-size: 36px; color: #fff; margin-bottom: 15px; }
        .profile-header h1 em { color: var(--gold); font-style: italic; }
        .profile-header p { color: var(--text-muted); font-size: 14px; line-height: 1.6; }

        .profile-form { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group.full-width { grid-column: 1 / -1; }
        
        .form-group label {
            font-size: 11px; color: var(--text-muted); letter-spacing: 1.5px;
            text-transform: uppercase; font-weight: 600;
        }

        .form-control {
            background: rgba(0, 0, 0, 0.2); border: 1px solid var(--border-glass);
            border-radius: 12px; padding: 14px 18px; color: #fff;
            font-size: 14px; font-family: 'Inter', sans-serif; outline: none;
            transition: all 0.3s ease; width: 100%;
        }
        .form-control:focus { border-color: var(--gold); box-shadow: 0 0 0 2px rgba(201, 168, 76, 0.2); background: rgba(0, 0, 0, 0.4); }
        .form-control:disabled { background: rgba(255,255,255,0.02); color: rgba(255,255,255,0.4); cursor: not-allowed; }
        select.form-control option { background: var(--navy); color: #fff; }
        input[type="date"] { color-scheme: dark; }

        .submit-btn {
            grid-column: 1 / -1; padding: 18px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: var(--dark); border: none; border-radius: 12px;
            font-size: 14px; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; cursor: pointer; transition: all 0.3s;
            margin-top: 10px; box-shadow: 0 8px 20px rgba(201,168,76,0.25);
        }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 12px 28px rgba(201,168,76,0.35); }

        .alert {
            grid-column: 1 / -1; padding: 16px; border-radius: 12px; font-size: 14px;
            text-align: center; font-weight: 500;
        }
        .alert-success { background: rgba(46, 204, 113, 0.1); border: 1px solid rgba(46, 204, 113, 0.3); color: #2ecc71; }
        .alert-error { background: rgba(231, 76, 60, 0.1); border: 1px solid rgba(231, 76, 60, 0.3); color: #e74c3c; }

        /* FOOTER */
        footer { background: #060608; border-top: 1px solid rgba(201,168,76,0.1); padding: 60px; }
        .footer-inner { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 48px; }
        .footer-brand .logo { font-family: 'Playfair Display', serif; font-size: 26px; color: #fff; margin-bottom: 14px; }
        .footer-brand .logo span { color: var(--gold); }
        .footer-brand p { color: var(--text-muted); font-size: 13.5px; line-height: 1.7; }
        .footer-col h4 { color: #fff; font-size: 13px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 18px; }
        .footer-col a { display: block; color: var(--text-muted); text-decoration: none; font-size: 13.5px; margin-bottom: 10px; transition: color 0.2s; }
        .footer-col a:hover { color: var(--gold); }
        .footer-bottom { max-width: 1200px; margin: 40px auto 0; padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.06); display: flex; justify-content: space-between; align-items: center; color: rgba(255,255,255,0.25); font-size: 12.5px; }
        .footer-bottom span { color: var(--gold); }

        @media (max-width: 768px) {
            .navbar { padding: 0 24px; }
            .profile-container { padding: 30px 20px; }
            .profile-form { grid-template-columns: 1fr; }
            .footer-inner { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<nav class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/rooms.jsp">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/#promotions">Khuyến Mãi</a></li>
        <li><a href="${pageContext.request.contextPath}/booking">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/contracts">Hợp Đồng</a></li>
    </ul>
    <div class="nav-right">
        <span class="nav-greeting">Xin chào, <strong>${currentUser.fullName}</strong></span>
        <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Đăng xuất</a>
    </div>
</nav>

<div class="profile-page-wrap">
    <div class="profile-container">
        <div class="profile-header">
            <span class="profile-label">Trang Cá Nhân</span>
            <h1>Thông Tin <em>Hồ Sơ</em></h1>
            <p>Cập nhật thông tin cá nhân của bạn để chúng tôi có thể phục vụ tốt hơn.</p>
        </div>

        <form action="${pageContext.request.contextPath}/profile" method="POST" class="profile-form">
            <c:if test="${not empty requestScope.successMessage}">
                <div class="alert alert-success">${requestScope.successMessage}</div>
            </c:if>
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="alert alert-error">${requestScope.errorMessage}</div>
            </c:if>

            <div class="form-group full-width">
                <label>Tên Đăng Nhập (Username)</label>
                <input type="text" class="form-control" value="${currentUser.account}" disabled>
            </div>

            <div class="form-group full-width">
                <label>Mã Khách Hàng (Customer ID)</label>
                <input type="text" class="form-control" value="${currentUser.id}" disabled>
            </div>

            <div class="form-group full-width">
                <label for="fullName">Họ và Tên</label>
                <input type="text" name="fullName" id="fullName" class="form-control" value="${currentUser.fullName}" required>
            </div>

            <div class="form-group">
                <label for="dateOfBirth">Ngày Sinh</label>
                <fmt:formatDate var="dobFormatted" value="${currentUser.dateOfBirth}" pattern="yyyy-MM-dd"/>
                <input type="date" name="dateOfBirth" id="dateOfBirth" class="form-control" value="${dobFormatted}">
            </div>

            <div class="form-group">
                <label for="gender">Giới Tính</label>
                <select name="gender" id="gender" class="form-control">
                    <option value="" ${empty currentUser.gender ? 'selected' : ''}>Khác</option>
                    <option value="Male" ${currentUser.gender == 'Male' ? 'selected' : ''}>Nam</option>
                    <option value="Female" ${currentUser.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                </select>
            </div>

            <div class="form-group">
                <label for="phoneNumber">Số Điện Thoại</label>
                <input type="tel" name="phoneNumber" id="phoneNumber" class="form-control" value="${currentUser.phoneNumber}">
            </div>

            <div class="form-group">
                <label for="idCard">CMND / CCCD / Passport</label>
                <input type="text" name="idCard" id="idCard" class="form-control" value="${currentUser.idCard}">
            </div>

            <div class="form-group full-width">
                <label for="email">Địa Chỉ Email</label>
                <input type="email" name="email" id="email" class="form-control" value="${currentUser.email}">
            </div>

            <button type="submit" class="submit-btn">Lưu Thay Đổi</button>
        </form>
    </div>
</div>

<footer>
    <div class="footer-inner">
        <div class="footer-brand">
            <div class="logo">Azure <span>Resort</span> &amp; Spa</div>
            <p>Thiên đường nghỉ dưỡng 5 sao với vẻ đẹp thiên nhiên kỳ thú và dịch vụ đẳng cấp thế giới.</p>
        </div>
        <div class="footer-col">
            <h4>Khám Phá</h4>
            <a href="${pageContext.request.contextPath}/rooms.jsp">Phòng &amp; Villa</a>
            <a href="${pageContext.request.contextPath}/#promotions">Khuyến Mãi</a>
            <a href="${pageContext.request.contextPath}/booking">Đặt Phòng</a>
        </div>
        <div class="footer-col">
            <h4>Tài Khoản</h4>
            <a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a>
            <a href="${pageContext.request.contextPath}/contracts">Hợp Đồng</a>
            <a href="${pageContext.request.contextPath}/profile">Hồ Sơ</a>
        </div>
        <div class="footer-col">
            <h4>Liên Hệ</h4>
            <a href="#">📍 Đà Nẵng, Việt Nam</a>
            <a href="#">📞 1800 7777</a>
            <a href="#">✉️ info@azure-resort.vn</a>
        </div>
    </div>
    <div class="footer-bottom">
        <span>© 2026 <span>Azure Resort &amp; Spa</span>. All rights reserved.</span>
        <span>Made with ❤️ in Vietnam</span>
    </div>
</footer>

<script>
    const today = new Date();
    const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
    document.getElementById('dateOfBirth').setAttribute('max', maxDate.toISOString().split('T')[0]);
</script>

</body>
</html>
