<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký — Azure Resort & Spa</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/drum-datepicker.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        gold: '#c9a84c',
                        'gold-light': '#e8cc82',
                        dark: '#0a0a0f',
                    },
                    animation: {
                        'ken-burns': 'kenBurns 30s ease-in-out infinite alternate',
                        'slide-in-right': 'slideInRight 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards',
                        'reveal-stagger': 'revealStagger 0.6s ease-out forwards',
                        'fade-up': 'fadeUp 1s ease-out forwards',
                    },
                    keyframes: {
                        kenBurns: {
                            '0%': { transform: 'scale(1) translate(0, 0)' },
                            '100%': { transform: 'scale(1.2) translate(-5%, -5%)' },
                        },
                        slideInRight: {
                            '0%': { opacity: '0', transform: 'translateX(50px)' },
                            '100%': { opacity: '1', transform: 'translateX(0)' },
                        },
                        revealStagger: {
                            '0%': { opacity: '0', transform: 'translateY(20px)' },
                            '100%': { opacity: '1', transform: 'translateY(0)' },
                        },
                        fadeUp: {
                            '0%': { opacity: '0', transform: 'translateY(30px)' },
                            '100%': { opacity: '1', transform: 'translateY(0)' },
                        }
                    }
                }
            }
        }
    </script>
    <style>
        :root {
            --gold: #c9a84c; --gold-light: #e8cc82;
            --dark: #0a0a0f;
        }
        body { background-color: var(--dark); color: white; font-family: 'Inter', sans-serif; margin: 0; }
        .panel-form { background: rgba(10, 10, 15, 0.7); backdrop-filter: blur(40px); border: 1px solid rgba(255, 255, 255, 0.1); }
    </style>
</head>
<body>

<div class="fixed inset-0 z-0">
    <div class="absolute inset-0 bg-cover bg-center animate-ken-burns" 
         style="background-image: url('https://images.unsplash.com/photo-1540541338287-41700207dee6?auto=format&fit=crop&w=1920&q=80')"></div>
    <div class="absolute inset-0 bg-gradient-to-r from-dark/60 to-dark/40"></div>
</div>

<div class="relative z-10 min-h-screen flex flex-col lg:flex-row items-center justify-center lg:justify-between p-6 lg:px-24">
    <!-- Brand Info (Restored) -->
    <div class="hidden lg:block max-w-md animate-[fadeUp_1s_ease-out]">
        <div class="text-gold text-xl tracking-[0.5em] mb-4">★ ★ ★ ★ ★</div>
        <h1 class="font-serif text-5xl text-white font-bold leading-tight mb-4">Azure<br><span class="text-gold">Resort</span> &amp; Spa</h1>
        <p class="text-white/40 text-sm tracking-[0.3em] uppercase mb-12">Luxury · Nature · Serenity</p>
        
        <div class="grid grid-cols-1 gap-6">
            <div class="flex items-center gap-4 text-white/70">
                <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold">✔</div>
                <p class="text-sm font-light leading-relaxed">Đặt phòng nhanh chóng, quy trình thanh toán bảo mật.</p>
            </div>
            <div class="flex items-center gap-4 text-white/70">
                <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold">✔</div>
                <p class="text-sm font-light leading-relaxed">Nhận ưu đãi độc quyền 15-30% cho khách hàng mới.</p>
            </div>
            <div class="flex items-center gap-4 text-white/70">
                <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold">✔</div>
                <p class="text-sm font-light leading-relaxed">Tích lũy điểm thưởng đổi lấy đêm nghỉ miễn phí.</p>
            </div>
        </div>
    </div>

    <!-- Panel Form -->
    <div class="panel-form w-full max-w-[580px] bg-dark/70 backdrop-blur-2xl border border-white/10 rounded-[40px] shadow-2xl p-8 md:p-12 animate-slide-in-right">
        <div class="form-wrapper">
            <a href="${pageContext.request.contextPath}/index.jsp" class="inline-flex items-center gap-2 text-white/30 hover:text-gold transition-colors text-sm mb-6 group">
                <span class="group-hover:-translate-x-1 transition-transform">←</span> Quay lại trang chủ
            </a>

            <div class="form-header mb-8">
                <h2 class="font-serif text-3xl text-white font-bold">Tạo Tài Khoản</h2>
                <div class="w-12 h-1 bg-gold my-4 rounded-full"></div>
                <p class="text-white/40 text-sm">Đăng ký miễn phí &amp; bắt đầu hành trình nghỉ dưỡng đẳng cấp</p>
            </div>

            <%-- Alert messages --%>
            <c:if test="${not empty requestScope.error}">
            <div class="bg-red-500/10 border border-red-500/20 text-red-300 p-4 rounded-2xl text-sm mb-6 flex items-start gap-3">
                <span>⚠️</span> <span>${requestScope.error}</span>
            </div>
            </c:if>
            <c:if test="${not empty requestScope.success}">
            <div class="bg-green-500/10 border border-green-500/20 text-green-300 p-4 rounded-2xl text-sm mb-6 flex items-start gap-3">
                <span>✅</span> <span>${requestScope.success}</span>
            </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm" novalidate class="space-y-5">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="form-group group">
                        <label class="block text-white/40 text-[10px] font-bold uppercase tracking-wider mb-2">Họ và tên <span class="text-red-500">*</span></label>
                        <input type="text" id="fullName" name="fullName" placeholder="Nguyễn Văn A" 
                               class="w-full bg-white/5 border border-white/10 rounded-2xl px-5 py-3.5 text-white focus:outline-none focus:border-gold/50 focus:bg-white/10 transition-all outline-none" required>
                    </div>
                    <div class="form-group group">
                        <label class="block text-white/40 text-[10px] font-bold uppercase tracking-wider mb-2">Tên tài khoản <span class="text-red-500">*</span></label>
                        <input type="text" id="username" name="username" placeholder="nguyenvana" 
                               class="w-full bg-white/5 border border-white/10 rounded-2xl px-5 py-3.5 text-white focus:outline-none focus:border-gold/50 focus:bg-white/10 transition-all outline-none" required>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="form-group relative">
                        <label class="block text-white/40 text-[10px] font-bold uppercase tracking-wider mb-2">Ngày Sinh <span class="text-red-500">*</span></label>
                        <span class="absolute left-4 bottom-3.5 text-white/20">📅</span>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" 
                               class="w-full bg-white/5 border border-white/10 rounded-2xl pl-12 pr-5 py-3.5 text-white focus:outline-none focus:border-gold/50 transition-all" required>
                    </div>
                    <div class="form-group relative">
                        <label class="block text-white/40 text-[10px] font-bold uppercase tracking-wider mb-2">Giới tính <span class="text-red-500">*</span></label>
                        <span class="absolute left-4 bottom-3.5 text-white/20">🚻</span>
                        <select id="gender" name="gender" 
                                class="w-full bg-white/5 border border-white/10 rounded-2xl pl-12 pr-5 py-3.5 text-white focus:outline-none focus:border-gold/50 transition-all appearance-none cursor-pointer" required>
                            <option value="" class="bg-dark">Chọn giới tính</option>
                            <option value="Male" class="bg-dark">Nam</option>
                            <option value="Female" class="bg-dark">Nữ</option>
                            <option value="Other" class="bg-dark">Khác</option>
                        </select>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="form-group">
                        <label class="block text-white/40 text-[10px] font-bold uppercase tracking-wider mb-2">Email <span class="text-red-500">*</span></label>
                        <input type="email" id="email" name="email" placeholder="example@gmail.com" 
                               class="w-full bg-white/5 border border-white/10 rounded-2xl px-5 py-3.5 text-white focus:outline-none focus:border-gold/50 transition-all" required>
                    </div>
                    <div class="form-group">
                        <label class="block text-white/40 text-[10px] font-bold uppercase tracking-wider mb-2">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" placeholder="09xx xxx xxx" 
                               class="w-full bg-white/5 border border-white/10 rounded-2xl px-5 py-3.5 text-white focus:outline-none focus:border-gold/50 transition-all">
                    </div>
                </div>

                <div class="form-group">
                    <label class="block text-white/40 text-[10px] font-bold uppercase tracking-wider mb-2">Mật khẩu <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <span class="absolute left-4 top-1/2 -translate-y-1/2 text-white/20">🔒</span>
                        <input type="password" id="password" name="password" placeholder="Tối thiểu 6 ký tự" 
                               class="w-full bg-white/5 border border-white/10 rounded-2xl pl-12 pr-12 py-3.5 text-white focus:outline-none focus:border-gold/50 transition-all" required oninput="checkStrength(this.value)">
                        <button type="button" class="absolute right-4 top-1/2 -translate-y-1/2 text-white/20 hover:text-white" onclick="togglePwd('password',this)">👁️</button>
                    </div>
                    <div class="mt-2 space-y-1">
                        <div class="h-1 w-full bg-white/5 rounded-full overflow-hidden"><div id="strengthFill" class="h-full w-0 transition-all duration-300"></div></div>
                        <div id="strengthLabel" class="text-[10px] text-white/30 text-right"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="block text-white/40 text-[10px] font-bold uppercase tracking-wider mb-2">Xác nhận mật khẩu <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <span class="absolute left-4 top-1/2 -translate-y-1/2 text-white/20">🔒</span>
                        <input type="password" id="confPass" name="confPass" placeholder="Nhập lại mật khẩu" 
                               class="w-full bg-white/5 border border-white/10 rounded-2xl pl-12 pr-12 py-3.5 text-white focus:outline-none focus:border-gold/50 transition-all" required>
                        <button type="button" class="absolute right-4 top-1/2 -translate-y-1/2 text-white/20 hover:text-white" onclick="togglePwd('confPass',this)">👁️</button>
                    </div>
                </div>

                <button type="submit" id="btnRegister" class="w-full py-4 bg-gold hover:bg-gold-light active:scale-95 text-dark font-bold rounded-2xl transition-all shadow-xl shadow-gold/10 uppercase tracking-widest mt-4">
                    Tạo Tài Khoản
                </button>
            </form>

            <div class="relative my-8 text-center">
                <div class="absolute inset-0 flex items-center"><div class="w-full border-t border-white/5"></div></div>
                <span class="relative bg-transparent px-4 text-white/20 text-xs">hoặc</span>
            </div>

            <div class="text-center text-white/40 text-sm">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-gold font-bold hover:underline">Đăng nhập ngay</a>
            </div>
        </div>
    </div>
</div>

<script src="assets/js/drum-datepicker.js"></script>
<script>
    const today = new Date();
    const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());

    new DrumDatePicker(document.getElementById('dateOfBirth'), {
        maxDate: maxDate
    });


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

    function calculateAge(dob) {
        const birthDate = new Date(dob);
        const diff = Date.now() - birthDate.getTime();
        const age = new Date(diff); 
        return Math.abs(age.getUTCFullYear() - 1970);
    }

    // ── Client-side validate trước khi submit ───────────────────
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const username = document.getElementById('username').value.trim();
        const fullName = document.getElementById('fullName').value.trim();
        const email    = document.getElementById('email').value.trim();
        const gender   = document.getElementById('gender').value.trim();
        const dob      = document.getElementById('dateOfBirth').value.trim();
        const pwd      = document.getElementById('password').value;
        const conf     = document.getElementById('confPass').value;

        if (!username || !fullName || !email || !gender || !dob) {
            e.preventDefault();
            showAlert('Vui lòng điền đầy đủ các trường bắt buộc!');
            return;
        }

        const age = calculateAge(dob);
        if (age < 18) {
            e.preventDefault();
            showAlert('Xin lỗi, bạn phải đủ 18 tuổi để thực hiện đăng ký!');
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
