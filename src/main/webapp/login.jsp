<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập — Azure Resort & Spa</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --gold: #c9a84c;
            --gold-light: #e8cc82;
            --dark: #0a0a0f;
            --card-bg: rgba(255,255,255,0.06);
        }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            background: var(--dark);
            overflow: hidden;
        }

        /* ── Left panel: resort image ── */
        .panel-image {
            flex: 1;
            position: relative;
            background: url('assets/img/login-bg.png') center/cover no-repeat;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 48px;
        }
        .panel-image::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, rgba(0,0,0,0.1) 0%, rgba(0,0,0,0.65) 100%);
        }
        .panel-image .brand {
            position: relative;
            z-index: 1;
        }
        .brand-logo {
            font-family: 'Playfair Display', serif;
            font-size: 38px;
            font-weight: 700;
            color: #fff;
            letter-spacing: 1px;
            line-height: 1.1;
        }
        .brand-logo span { color: var(--gold); }
        .brand-tagline {
            color: rgba(255,255,255,0.65);
            font-size: 15px;
            margin-top: 10px;
            letter-spacing: 3px;
            text-transform: uppercase;
            font-weight: 300;
        }
        .brand-stars {
            color: var(--gold);
            font-size: 18px;
            margin-top: 8px;
            letter-spacing: 4px;
        }

        /* ── Right panel: login form ── */
        .panel-form {
            width: 460px;
            flex-shrink: 0;
            background: rgba(10,10,15,0.95);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 48px 44px;
            position: relative;
            overflow: hidden;
        }
        .panel-form::before {
            content: '';
            position: absolute;
            width: 350px; height: 350px;
            background: radial-gradient(circle, rgba(201,168,76,0.08) 0%, transparent 70%);
            top: -80px; right: -80px;
            border-radius: 50%;
        }

        .form-wrapper { width: 100%; position: relative; z-index: 1; }

        .form-header { margin-bottom: 36px; }
        .form-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 30px;
            color: #fff;
            font-weight: 600;
        }
        .form-header p {
            color: rgba(255,255,255,0.4);
            font-size: 14px;
            margin-top: 6px;
        }
        .gold-line {
            width: 48px; height: 2px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            margin: 14px 0;
            border-radius: 2px;
        }

        /* Alert */
        .alert {
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 13.5px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
            line-height: 1.5;
        }
        .alert-error {
            background: rgba(239,68,68,0.1);
            border: 1px solid rgba(239,68,68,0.3);
            color: #fca5a5;
        }
        .alert-success {
            background: rgba(201,168,76,0.1);
            border: 1px solid rgba(201,168,76,0.35);
            color: var(--gold-light);
        }

        /* Form inputs */
        .form-group { margin-bottom: 20px; }
        label {
            display: block;
            color: rgba(255,255,255,0.5);
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .input-wrap { position: relative; }
        .input-icon {
            position: absolute;
            left: 14px; top: 50%;
            transform: translateY(-50%);
            font-size: 16px;
            color: rgba(255,255,255,0.2);
            pointer-events: none;
            transition: color 0.2s;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 13px 14px 13px 42px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            color: #fff;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            outline: none;
            transition: all 0.25s;
        }
        input::placeholder { color: rgba(255,255,255,0.2); }
        input:focus {
            border-color: rgba(201,168,76,0.5);
            background: rgba(255,255,255,0.08);
            box-shadow: 0 0 0 3px rgba(201,168,76,0.08);
        }
        .input-wrap:has(input:focus) .input-icon { color: var(--gold); }
        .toggle-pwd {
            position: absolute;
            right: 12px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            color: rgba(255,255,255,0.3);
            cursor: pointer; font-size: 16px;
            padding: 4px;
            transition: color 0.2s;
        }
        .toggle-pwd:hover { color: rgba(255,255,255,0.7); }

        /* Remember + forgot */
        .form-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .remember {
            display: flex;
            align-items: center;
            gap: 8px;
            color: rgba(255,255,255,0.4);
            font-size: 13px;
            cursor: pointer;
        }
        .remember input[type="checkbox"] { accent-color: var(--gold); width: 15px; height: 15px; }
        .forgot-link {
            color: var(--gold);
            font-size: 13px;
            text-decoration: none;
            transition: color 0.2s;
        }
        .forgot-link:hover { color: var(--gold-light); }

        /* Button */
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--gold-light) 100%);
            color: #0a0a0f;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.25s;
            box-shadow: 0 6px 24px rgba(201,168,76,0.25);
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(201,168,76,0.35);
        }
        .btn-login:active { transform: translateY(0); }

        .divider {
            display: flex; align-items: center; gap: 12px;
            margin: 24px 0;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1;
            height: 1px; background: rgba(255,255,255,0.08);
        }
        .divider span { color: rgba(255,255,255,0.25); font-size: 12px; }

        .register-link {
            text-align: center;
            color: rgba(255,255,255,0.35);
            font-size: 13.5px;
        }
        .register-link a {
            color: var(--gold);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .register-link a:hover { color: var(--gold-light); }

        /* Mobile responsive */
        @media (max-width: 768px) {
            .panel-image { display: none; }
            .panel-form { width: 100%; }
        }
    </style>
</head>
<body>

<!-- Left: Resort Image -->
<div class="panel-image">
    <div class="brand">
        <div class="brand-stars">★ ★ ★ ★ ★</div>
        <div class="brand-logo">Azure<br><span>Resort</span> &amp; Spa</div>
        <div class="brand-tagline">Luxury · Nature · Serenity</div>
    </div>
</div>

<!-- Right: Login Form -->
<div class="panel-form">
    <div class="form-wrapper">
        <div class="form-header">
            <h2>Chào mừng trở lại</h2>
            <div class="gold-line"></div>
            <p>Đăng nhập để tiếp tục hành trình nghỉ dưỡng của bạn</p>
        </div>

        <%-- Alert messages --%>
        <c:if test="${not empty requestScope.error}">
        <div class="alert alert-error">
            <span>⚠️</span>
            <span>${requestScope.error}</span>
        </div>
        </c:if>
        <c:if test="${not empty param.registered}">
        <div class="alert alert-success">
            <span>✅</span>
            <span>Đăng ký thành công! Vui lòng đăng nhập.</span>
        </div>
        </c:if>

        <form action="login" method="POST" id="loginForm">

            <div class="form-group">
                <label for="username">Tên tài khoản</label>
                <div class="input-wrap">
                    <input type="text" id="username" name="username"
                           placeholder="Nhập tên tài khoản"
                           value="${not empty param.username ? param.username : ''}"
                           required autocomplete="username">
                    <span class="input-icon">👤</span>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <div class="input-wrap">
                    <input type="password" id="password" name="password"
                           placeholder="Nhập mật khẩu"
                           required autocomplete="current-password">
                    <span class="input-icon">🔑</span>
                    <button type="button" class="toggle-pwd" onclick="togglePwd()">👁️</button>
                </div>
            </div>

            <div class="form-meta">
                <label class="remember">
                    <input type="checkbox" name="remember"> Ghi nhớ đăng nhập
                </label>
                <a href="#" class="forgot-link">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="btn-login" id="btnLogin">Đăng Nhập</button>
        </form>

        <div class="divider"><span>hoặc</span></div>

        <div class="register-link">
            Chưa có tài khoản? <a href="register">Đăng ký ngay</a>
        </div>
    </div>
</div>

<script>
    function togglePwd() {
        const inp = document.getElementById('password');
        const btn = document.querySelector('.toggle-pwd');
        if (inp.type === 'password') { inp.type = 'text'; btn.textContent = '🙈'; }
        else { inp.type = 'password'; btn.textContent = '👁️'; }
    }
    document.getElementById('loginForm').addEventListener('submit', function() {
        const btn = document.getElementById('btnLogin');
        btn.textContent = 'Đang xử lý...';
        btn.disabled = true;
    });
</script>
<!-- CHATBOT WIDGET -->
<jsp:include page="/chat_widget.jsp"/>
</body>
</html>
