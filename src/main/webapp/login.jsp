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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
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
                        'slow-zoom': 'slowZoom 20s ease-in-out infinite alternate',
                        'blur-in': 'blurIn 0.8s ease-out forwards',
                        'fade-up': 'fadeUp 1s ease-out forwards',
                    },
                    keyframes: {
                        slowZoom: {
                            '0%': { transform: 'scale(1) translate(0, 0)' },
                            '100%': { transform: 'scale(1.1) translate(-2%, -2%)' },
                        },
                        blurIn: {
                            '0%': { opacity: '0', filter: 'blur(20px)', transform: 'scale(0.95)' },
                            '100%': { opacity: '1', filter: 'blur(0)', transform: 'scale(1)' },
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

    </style>
</head>
<body class="bg-dark overflow-x-hidden">

<!-- Custom Background Layer (Night Serenity) -->
<div class="fixed inset-0 z-0 overflow-hidden bg-dark">
    <div class="absolute inset-0 bg-cover bg-center animate-slow-zoom opacity-60" 
         style="background-image: url('https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?auto=format&fit=crop&w=1920&q=80')"></div>
    <div class="absolute inset-0 bg-gradient-to-tr from-dark via-dark/80 to-transparent"></div>
</div>

<div class="relative z-10 min-h-screen flex flex-col lg:flex-row items-center justify-center lg:justify-between p-6 lg:px-24">
    <!-- Brand Info (Restored from old design) -->
    <div class="hidden lg:block max-w-md animate-[fadeUp_1s_ease-out]">
        <div class="text-gold text-xl tracking-[0.5em] mb-4">★ ★ ★ ★ ★</div>
        <h1 class="font-serif text-5xl text-white font-bold leading-tight mb-4">Azure<br><span class="text-gold">Resort</span> &amp; Spa</h1>
        <p class="text-white/40 text-sm tracking-[0.3em] uppercase mb-12">Luxury · Nature · Serenity</p>
        
        <div class="space-y-6">
            <div class="flex items-center gap-4 text-white/70">
                <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold">✦</div>
                <p class="text-sm font-light">Đăng nhập để nhận ưu đãi thành viên Platinum.</p>
            </div>
            <div class="flex items-center gap-4 text-white/70">
                <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold">✦</div>
                <p class="text-sm font-light">Quản lý kỳ nghỉ và lịch sử đặt phòng dễ dàng.</p>
            </div>
            <div class="flex items-center gap-4 text-white/70">
                <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold">✦</div>
                <p class="text-sm font-light">Hỗ trợ khách hàng 24/7 cho mọi yêu cầu.</p>
            </div>
        </div>
    </div>

    <!-- Panel Container -->
    <div class="panel-form w-full max-w-[460px] animate-blur-in bg-[#0a0a0f]/80 backdrop-blur-3xl border border-white/10 rounded-[40px] overflow-hidden shadow-2xl p-10 relative">
        <div class="absolute -top-24 -right-24 w-48 h-48 bg-gold/10 rounded-full blur-3xl"></div>
        <div class="absolute -bottom-24 -left-24 w-48 h-48 bg-blue-500/10 rounded-full blur-3xl"></div>

        <div class="form-wrapper relative z-10">
            <a href="${pageContext.request.contextPath}/index.jsp" class="inline-flex items-center gap-2 text-white/40 hover:text-gold transition-colors text-sm mb-8 group">
                <span class="group-hover:-translate-x-1 transition-transform">←</span> Quay lại trang chủ
            </a>

            <div class="form-header mb-8">
                <h2 class="font-serif text-3xl text-white font-bold">Chào mừng trở lại</h2>
                <div class="w-12 h-0.5 bg-gradient-to-r from-gold to-gold-light my-4 rounded-full"></div>
                <p class="text-white/40 text-sm">Đăng nhập để tiếp tục hành trình nghỉ dưỡng của bạn</p>
            </div>

            <%-- Alert messages --%>
            <c:if test="${not empty requestScope.error}">
            <div class="bg-red-500/10 border border-red-500/30 text-red-200 p-4 rounded-xl text-sm flex items-center gap-3 mb-6">
                <span>⚠️</span>
                <span>${requestScope.error}</span>
            </div>
            </c:if>
            <c:if test="${not empty param.registered}">
            <div class="bg-gold/10 border border-gold/30 text-gold-light p-4 rounded-xl text-sm flex items-center gap-3 mb-6">
                <span>✅</span>
                <span>Đăng ký thành công! Vui lòng đăng nhập.</span>
            </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm" class="space-y-6">
                <div class="form-group">
                    <label class="block text-white/50 text-[10px] uppercase tracking-widest font-bold mb-2">Tên tài khoản</label>
                    <div class="relative group">
                        <span class="absolute left-4 top-1/2 -translate-y-1/2 text-white/40 group-focus-within:text-gold transition-colors">👤</span>
                        <input type="text" id="username" name="username"
                               placeholder="Tài khoản của bạn"
                               class="w-full bg-white/5 border border-white/10 rounded-2xl py-3.5 pl-12 pr-4 text-white placeholder-white/20 focus:outline-none focus:border-gold/50 focus:bg-white/10 transition-all shadow-inner"
                               value="${not empty param.username ? param.username : ''}"
                               required autocomplete="username">
                    </div>
                </div>

                <div class="form-group">
                    <label class="block text-white/50 text-[10px] uppercase tracking-widest font-bold mb-2">Mật khẩu</label>
                    <div class="relative group">
                        <span class="absolute left-4 top-1/2 -translate-y-1/2 text-white/40 group-focus-within:text-gold transition-colors">🔑</span>
                        <input type="password" id="password" name="password"
                               placeholder="••••••••"
                               class="w-full bg-white/5 border border-white/10 rounded-2xl py-3.5 pl-12 pr-12 text-white placeholder-white/20 focus:outline-none focus:border-gold/50 focus:bg-white/10 transition-all shadow-inner"
                               required autocomplete="current-password">
                        <button type="button" class="absolute right-4 top-1/2 -translate-y-1/2 text-white/20 hover:text-white transition-colors toggle-pwd" onclick="togglePwd()">👁️</button>
                    </div>
                </div>

                <div class="flex items-center justify-between text-sm">
                    <label class="flex items-center gap-2 text-white/40 cursor-pointer hover:text-white/60 transition-colors">
                        <input type="checkbox" name="remember" class="accent-gold w-4 h-4"> Ghi nhớ đăng nhập
                    </label>
                    <a href="#" class="text-gold hover:text-gold-light transition-colors">Quên mật khẩu?</a>
                </div>

                <button type="submit" id="btnLogin" class="group relative w-full py-4 bg-gradient-to-r from-gold to-gold-light hover:scale-[1.02] active:scale-100 text-dark font-bold rounded-2xl tracking-widest uppercase transition-all shadow-xl shadow-gold/20">
                    <span class="relative z-10 transition-colors group-hover:text-black">Đăng Nhập</span>
                    <div class="absolute inset-0 bg-white opacity-0 group-hover:opacity-10 transition-opacity rounded-2xl"></div>
                </button>
            </form>

            <div class="flex items-center gap-4 my-8">
                <div class="flex-1 h-px bg-white/10"></div>
                <span class="text-white/20 text-xs text-center">hoặc</span>
                <div class="flex-1 h-px bg-white/10"></div>
            </div>

            <div class="text-center text-white/40 text-sm">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register.jsp" class="text-gold font-bold hover:underline decoration-gold/30 underline-offset-4">Đăng ký ngay</a>
            </div>
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
</body>
</html>
