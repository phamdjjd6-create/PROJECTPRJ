<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký — Azure Resort & Spa</title>
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
            overflow-x: hidden;
        }

        /* ── Left panel: resort image ── */
        .panel-image {
            flex: 1;
            position: relative;
            background: url('assets/img/hero-bg.png') center 30%/cover no-repeat;
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
        .panel-image .brand { position: relative; z-index: 1; }
        .brand-stars { color: var(--gold); font-size: 18px; margin-bottom: 10px; letter-spacing: 4px; }
        .brand-logo {
            font-family: 'Playfair Display', serif;
            font-size: 38px; font-weight: 700;
            color: #fff; letter-spacing: 1px; line-height: 1.1;
        }
        .brand-logo span { color: var(--gold); }
        .brand-tagline {
            color: rgba(255,255,255,0.65);
            font-size: 14px; margin-top: 10px;
            letter-spacing: 3px; text-transform: uppercase; font-weight: 300;
        }
        .perks {
            margin-top: 32px;
            display: flex; flex-direction: column; gap: 12px;
        }
        .perk {
            display: flex; align-items: center; gap: 12px;
            color: rgba(255,255,255,0.75); font-size: 13.5px;
        }
        .perk-icon {
            width: 32px; height: 32px;
            background: rgba(201,168,76,0.15);
            border: 1px solid rgba(201,168,76,0.3);
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 15px; flex-shrink: 0;
        }

        /* ── Right panel: form ── */
        .panel-form {
            width: 520px; flex-shrink: 0;
            background: rgba(10,10,15,0.97);
            display: flex; align-items: center; justify-content: center;
            padding: 40px 44px;
            position: relative; overflow: hidden;
            overflow-y: auto;
        }
        .panel-form::before {
            content: '';
            position: absolute;
            width: 350px; height: 350px;
            background: radial-gradient(circle, rgba(201,168,76,0.07) 0%, transparent 70%);
            top: -80px; right: -80px;
            border-radius: 50%; pointer-events: none;
        }

        .form-wrapper { width: 100%; position: relative; z-index: 1; }

        .form-header { margin-bottom: 28px; }
        .form-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 28px; color: #fff; font-weight: 600;
        }
        .gold-line {
            width: 48px; height: 2px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            margin: 12px 0; border-radius: 2px;
        }
        .form-header p { color: rgba(255,255,255,0.4); font-size: 13.5px; }

        /* Alert */
        .alert {
            border-radius: 10px; padding: 12px 16px;
            font-size: 13px; margin-bottom: 20px;
            display: flex; align-items: flex-start; gap: 10px; line-height: 1.5;
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

        /* Two-column row */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        /* Form inputs */
        .form-group { margin-bottom: 16px; }
        label {
            display: block;
            color: rgba(255,255,255,0.5);
            font-size: 11px; font-weight: 600;
            letter-spacing: 1.5px; text-transform: uppercase;
            margin-bottom: 7px;
        }
        .required { color: #f87171; margin-left: 2px; }
        .input-wrap { position: relative; }
        .input-icon {
            position: absolute; left: 13px; top: 50%;
            transform: translateY(-50%);
            font-size: 15px; color: rgba(255,255,255,0.2);
            pointer-events: none; transition: color 0.2s;
        }
        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px 12px 40px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 11px; color: #fff;
            font-size: 13.5px; font-family: 'Inter', sans-serif;
            outline: none; transition: all 0.25s;
        }
        input::placeholder { color: rgba(255,255,255,0.2); }
        input:focus {
            border-color: rgba(201,168,76,0.5);
            background: rgba(255,255,255,0.08);
            box-shadow: 0 0 0 3px rgba(201,168,76,0.08);
        }
        .input-wrap:has(input:focus) .input-icon { color: var(--gold); }

        /* Password field with toggle */
        input[type="password"] { padding-right: 42px; }
        .toggle-pwd {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            color: rgba(255,255,255,0.3);
            cursor: pointer; font-size: 15px; padding: 4px;
            transition: color 0.2s;
        }
        .toggle-pwd:hover { color: rgba(255,255,255,0.7); }

        /* Password strength bar */
        .pwd-strength { margin-top: 6px; }
        .strength-bar {
            height: 3px; border-radius: 2px;
            background: rgba(255,255,255,0.08);
            overflow: hidden;
        }
        .strength-fill {
            height: 100%; width: 0%;
            border-radius: 2px;
            transition: width 0.3s, background 0.3s;
        }
        .strength-label {
            font-size: 11px; color: rgba(255,255,255,0.3);
            margin-top: 4px;
        }

        /* Hint text */
        .field-hint {
            font-size: 11px; color: rgba(255,255,255,0.25);
            margin-top: 5px;
        }

        /* Submit button */
        .btn-register {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--gold-light) 100%);
            color: var(--dark);
            border: none; border-radius: 12px;
            font-size: 14px; font-weight: 700;
            font-family: 'Inter', sans-serif;
            letter-spacing: 1.5px; text-transform: uppercase;
            cursor: pointer; margin-top: 6px;
            transition: all 0.25s;
            box-shadow: 0 6px 24px rgba(201,168,76,0.25);
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(201,168,76,0.35);
        }
        .btn-register:active { transform: translateY(0); }
        .btn-register:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }

        .divider {
            display: flex; align-items: center; gap: 12px;
            margin: 20px 0;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1;
            height: 1px; background: rgba(255,255,255,0.08);
        }
        .divider span { color: rgba(255,255,255,0.25); font-size: 12px; }

        .login-link {
            text-align: center;
            color: rgba(255,255,255,0.35); font-size: 13.5px;
        }
        .login-link a {
            color: var(--gold); text-decoration: none;
            font-weight: 600; transition: color 0.2s;
        }
        .login-link a:hover { color: var(--gold-light); }

        /* Mobile */
        @media (max-width: 900px) {
            .panel-image { display: none; }
            .panel-form { width: 100%; padding: 32px 24px; }
            .form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- Left: Resort Image + Perks -->
<div class="panel-image">
    <div class="brand">
        <div class="brand-stars">★ ★ ★ ★ ★</div>
        <div class="brand-logo">Azure<br><span>Resort</span> &amp; Spa</div>
        <div class="brand-tagline">Luxury · Nature · Serenity</div>
        <div class="perks">
            <div class="perk">
                <div class="perk-icon">🏖️</div>
                <span>Đặt phòng nhanh chóng, dễ dàng</span>
            </div>
            <div class="perk">
                <div class="perk-icon">🎁</div>
                <span>Nhận ưu đãi dành riêng cho thành viên</span>
            </div>
            <div class="perk">
                <div class="perk-icon">📄</div>
                <span>Quản lý hợp đồng &amp; booking mọi nơi</span>
            </div>
            <div class="perk">
                <div class="perk-icon">⭐</div>
                <span>Tích điểm đổi quà với mỗi kỳ nghỉ</span>
            </div>
        </div>
    </div>
</div>

<!-- Right: Register Form -->
<div class="panel-form">
    <div class="form-wrapper">
        <div class="form-header">
            <h2>Tạo Tài Khoản</h2>
            <div class="gold-line"></div>
            <p>Đăng ký miễn phí &amp; bắt đầu trải nghiệm nghỉ dưỡng đẳng cấp</p>
        </div>

        <%-- Alert messages từ server --%>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <span>⚠️</span>
            <span><%= request.getAttribute("error") %></span>
        </div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <span>✅</span>
            <span><%= request.getAttribute("success") %></span>
        </div>
        <% } %>

        <form action="register" method="POST" id="registerForm" novalidate>

            <%-- Hàng 1: Họ tên + Tên tài khoản --%>
            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">Họ và tên <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input type="text" id="fullName" name="fullName"
                               placeholder="Nguyễn Văn A"
                               value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>"
                               required maxlength="100" autocomplete="name">
                        <span class="input-icon">👤</span>
                    </div>
                </div>
                <div class="form-group">
                    <label for="username">Tên tài khoản <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input type="text" id="username" name="username"
                               placeholder="nguyenvana"
                               value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
                               required maxlength="50" autocomplete="username">
                        <span class="input-icon">🔖</span>
                    </div>
                    <div class="field-hint">Dùng để đăng nhập, không dấu</div>
                </div>
            </div>

            <%-- Hàng 2: Email + SĐT --%>
            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input type="email" id="email" name="email"
                               placeholder="email@gmail.com"
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                               required maxlength="100" autocomplete="email">
                        <span class="input-icon">✉️</span>
                    </div>
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <div class="input-wrap">
                        <input type="tel" id="phone" name="phone"
                               placeholder="0912 345 678"
                               value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>"
                               maxlength="20" autocomplete="tel">
                        <span class="input-icon">📱</span>
                    </div>
                </div>
            </div>

            <%-- Mật khẩu --%>
            <div class="form-group">
                <label for="password">Mật khẩu <span class="required">*</span></label>
                <div class="input-wrap">
                    <input type="password" id="password" name="password"
                           placeholder="Tối thiểu 6 ký tự"
                           required minlength="6" autocomplete="new-password"
                           oninput="checkStrength(this.value)">
                    <span class="input-icon">🔒</span>
                    <button type="button" class="toggle-pwd" onclick="togglePwd('password',this)">👁️</button>
                </div>
                <div class="pwd-strength">
                    <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                    <div class="strength-label" id="strengthLabel"></div>
                </div>
            </div>

            <%-- Xác nhận mật khẩu --%>
            <div class="form-group">
                <label for="confPass">Xác nhận mật khẩu <span class="required">*</span></label>
                <div class="input-wrap">
                    <%-- name="confPass" — phải khớp với request.getParameter("confPass") trong RegisterController --%>
                    <input type="password" id="confPass" name="confPass"
                           placeholder="Nhập lại mật khẩu"
                           required autocomplete="new-password">
                    <span class="input-icon">🔒</span>
                    <button type="button" class="toggle-pwd" onclick="togglePwd('confPass',this)">👁️</button>
                </div>
            </div>

            <button type="submit" class="btn-register" id="btnRegister">
                Tạo Tài Khoản
            </button>
        </form>

        <div class="divider"><span>hoặc</span></div>

        <div class="login-link">
            Đã có tài khoản? <a href="login">Đăng nhập</a>
        </div>
    </div>
</div>

<script>
    // ── Toggle password visibility ──────────────────────────────
    function togglePwd(fieldId, btn) {
        const inp = document.getElementById(fieldId);
        if (inp.type === 'password') { inp.type = 'text'; btn.textContent = '🙈'; }
        else { inp.type = 'password'; btn.textContent = '👁️'; }
    }

    // ── Password strength indicator ─────────────────────────────
    function checkStrength(pwd) {
        const fill  = document.getElementById('strengthFill');
        const label = document.getElementById('strengthLabel');
        let score = 0;
        if (pwd.length >= 6)  score++;
        if (pwd.length >= 10) score++;
        if (/[A-Z]/.test(pwd)) score++;
        if (/[0-9]/.test(pwd)) score++;
        if (/[^A-Za-z0-9]/.test(pwd)) score++;

        const levels = [
            { pct: '0%',  color: 'transparent', text: '' },
            { pct: '25%', color: '#ef4444',      text: 'Yếu' },
            { pct: '50%', color: '#f97316',      text: 'Trung bình' },
            { pct: '75%', color: '#eab308',      text: 'Khá' },
            { pct: '90%', color: '#22c55e',      text: 'Mạnh' },
            { pct: '100%',color: '#10b981',      text: 'Rất mạnh ✓' },
        ];
        const lvl = levels[Math.min(score, 5)];
        fill.style.width     = lvl.pct;
        fill.style.background = lvl.color;
        label.textContent    = lvl.text;
        label.style.color    = lvl.color;
    }

    // ── Client-side validate trước khi submit ───────────────────
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const username = document.getElementById('username').value.trim();
        const fullName = document.getElementById('fullName').value.trim();
        const email    = document.getElementById('email').value.trim();
        const pwd      = document.getElementById('password').value;
        const conf     = document.getElementById('confPass').value;

        if (!username || !fullName || !email) {
            e.preventDefault();
            showAlert('Vui lòng điền đầy đủ các trường bắt buộc!');
            return;
        }
        if (/\s/.test(username)) {
            e.preventDefault();
            showAlert('Tên tài khoản không được chứa khoảng trắng!');
            return;
        }
        if (pwd.length < 6) {
            e.preventDefault();
            showAlert('Mật khẩu phải có ít nhất 6 ký tự!');
            return;
        }
        if (pwd !== conf) {
            e.preventDefault();
            showAlert('Mật khẩu xác nhận không khớp!');
            return;
        }

        // Disable nút chống double-submit
        const btn = document.getElementById('btnRegister');
        btn.textContent = 'Đang xử lý...';
        btn.disabled = true;
    });

    function showAlert(msg) {
        // Xóa alert cũ (nếu có)
        const old = document.querySelector('.alert.alert-error.js-alert');
        if (old) old.remove();
        const div = document.createElement('div');
        div.className = 'alert alert-error js-alert';
        div.innerHTML = '<span>⚠️</span><span>' + msg + '</span>';
        document.querySelector('.form-header').insertAdjacentElement('afterend', div);
        div.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
</script>
</body>
</html>
