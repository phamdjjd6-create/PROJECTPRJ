<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty sessionScope.account}">
    <c:redirect url="/login.jsp"/>
</c:if>
<c:set var="account" value="${sessionScope.account.fullName}"/>
<c:set var="currentUser" value="${sessionScope.account}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài Khoản — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script>
        window.tailwind = { config: {
            darkMode: 'class',
            theme: { extend: {
                colors: { gold: '#c9a84c', 'gold-light': '#e8cc82', dark: '#0a0a0f', navy: '#0d1526', azure: '#3b82f6' },
                fontFamily: { serif: ['Playfair Display', 'serif'], sans: ['Inter', 'sans-serif'] }
            }}
        }};
    </script>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #0a0a0f; }
        .nav-fixed { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; display: flex; align-items: center; justify-content: space-between; transition: all 0.5s; }
        .glass-panel { background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.07); backdrop-filter: blur(20px); }
        @keyframes reveal { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
        .animate-reveal { animation: reveal 0.6s ease forwards; opacity: 0; }
    </style>
</head>
<body class="dark font-sans antialiased">

<!-- NAVBAR -->
<nav id="navbar" class="nav-fixed px-12 h-24 bg-dark/40 backdrop-blur-2xl border-b border-white/5">
    <a href="${pageContext.request.contextPath}/" class="text-2xl font-serif font-bold tracking-tight text-white group flex items-center gap-3">
        <span class="w-10 h-10 rounded-xl bg-gold flex items-center justify-center text-dark italic text-xl">A</span>
        Azure <span class="text-gold group-hover:text-white transition-colors">Resort</span>
    </a>
    
    <ul class="hidden lg:flex items-center gap-12">
        <li><a href="${pageContext.request.contextPath}/" class="text-white/40 hover:text-gold transition-all text-[11px] font-bold uppercase tracking-[0.2em] relative py-2">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="text-white/40 hover:text-gold transition-all text-[11px] font-bold uppercase tracking-[0.2em] relative py-2">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking" class="text-white/40 hover:text-gold transition-all text-[11px] font-bold uppercase tracking-[0.2em] relative py-2">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="text-gold transition-all text-[11px] font-bold uppercase tracking-[0.2em] relative py-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-full after:h-px after:bg-gold">Tài Khoản</a></li>
        <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
            <li><a href="${pageContext.request.contextPath}/dashboard/admin" class="px-6 py-2.5 bg-white/5 border border-gold/30 rounded-full text-[10px] font-bold text-gold uppercase tracking-[0.2em] hover:bg-gold hover:text-dark transition-all">Bảng Điều Khiển</a></li>
        </c:if>
    </ul>

    <div class="flex items-center gap-8">
        <div class="hidden sm:flex flex-col items-end">
            <span class="text-[9px] text-white/20 uppercase tracking-[0.3em] font-bold">Authenticated as</span>
            <span class="text-sm font-bold text-gold tracking-tight">${account}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="w-10 h-10 rounded-xl border border-white/10 flex items-center justify-center text-white/40 hover:text-red-400 hover:border-red-400/30 hover:bg-red-500/5 transition-all" title="Đăng xuất">⎋</a>
    </div>
</nav>

<main class="max-w-6xl mx-auto px-6 md:px-12 pt-32 pb-24">
    <!-- Breadcrumbs -->
    <nav class="flex items-center gap-2 text-[10px] text-white/40 uppercase tracking-[0.2em] mb-12 animate-reveal">
        <a href="${pageContext.request.contextPath}/" class="hover:text-gold transition-colors">Trang Chủ</a>
        <span>/</span>
        <span class="text-gold">Trung tâm khách hàng</span>
    </nav>

    <!-- Profile Banner -->
    <div class="glass-panel rounded-[40px] p-10 md:p-14 mb-16 flex flex-col md:flex-row items-center gap-10 animate-reveal" style="animation-delay: 100ms">
        <div class="w-32 h-32 rounded-3xl bg-gradient-to-br from-gold to-gold-light flex items-center justify-center text-4xl font-serif font-bold text-dark shadow-2xl shadow-gold/20 flex-shrink-0">
            ${fn:substring(account, 0, 1)}
        </div>
        <div class="text-center md:text-left space-y-3">
            <span class="inline-block px-4 py-1.5 bg-gold/10 border border-gold/20 rounded-full text-[10px] font-bold text-gold uppercase tracking-widest">
                ${currentUser.personType == 'EMPLOYEE' ? 'Staff Member' : 'Elite Member'}
            </span>
            <h2 class="text-4xl md:text-5xl font-serif font-bold text-white tracking-tight">${account}</h2>
            <div class="flex flex-col md:flex-row md:items-center gap-4 text-white/40 text-sm">
                <div class="flex items-center gap-2"><span>✉️</span> ${currentUser.email}</div>
                <div class="hidden md:block w-1 h-1 bg-white/10 rounded-full"></div>
                <div class="flex items-center gap-2"><span>📱</span> ${not empty currentUser.phoneNumber ? currentUser.phoneNumber : 'Chưa cập nhật'}</div>
            </div>
        </div>
        <div class="md:ml-auto">
            <a href="${pageContext.request.contextPath}/profile" class="px-8 py-4 bg-white/5 border border-white/10 rounded-2xl text-xs font-bold text-white uppercase tracking-widest hover:border-gold hover:text-gold transition-all block text-center">Chỉnh sửa hồ sơ</a>
        </div>
    </div>

    <!-- Dashboard Tools -->
    <div class="space-y-10">
        <div class="flex items-center gap-4 animate-reveal" style="animation-delay: 200ms">
            <h3 class="text-xs font-bold text-white/30 uppercase tracking-[0.4em]">Quản trị tài khoản</h3>
            <div class="h-px flex-1 bg-white/5"></div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 animate-reveal" style="animation-delay: 300ms">
            <a href="${pageContext.request.contextPath}/booking?view=my" class="glass-panel rounded-[32px] p-8 transition-all duration-300 hover:bg-gold/5 hover:border-gold/30 hover:-translate-y-2 hover:shadow-2xl hover:shadow-gold/10 group">
                <div class="flex items-start justify-between mb-8">
                    <div class="w-14 h-14 rounded-2xl bg-gold/10 flex items-center justify-center text-2xl group-hover:bg-gold group-hover:text-dark transition-all duration-300">📋</div>
                    <span class="text-gold text-lg group-hover:translate-x-1 transition-transform">→</span>
                </div>
                <h4 class="text-xl font-serif font-bold text-white mb-3 group-hover:text-gold transition-colors">Booking Của Tôi</h4>
                <p class="text-xs text-white/40 leading-relaxed font-bold uppercase tracking-widest pt-2">Lịch sử & Trạng thái</p>
            </a>

            <a href="${pageContext.request.contextPath}/contracts" class="glass-panel rounded-[32px] p-8 transition-all duration-300 hover:bg-gold/5 hover:border-gold/30 hover:-translate-y-2 hover:shadow-2xl hover:shadow-gold/10 group">
                <div class="flex items-start justify-between mb-8">
                    <div class="w-14 h-14 rounded-2xl bg-gold/10 flex items-center justify-center text-2xl group-hover:bg-gold group-hover:text-dark transition-all duration-300">📄</div>
                    <span class="text-gold text-lg group-hover:translate-x-1 transition-transform">→</span>
                </div>
                <h4 class="text-xl font-serif font-bold text-white mb-3 group-hover:text-gold transition-colors">Hợp Đồng & Thanh Toán</h4>
                <p class="text-xs text-white/40 leading-relaxed font-bold uppercase tracking-widest pt-2">Giao dịch & Chứng từ</p>
            </a>

            <a href="${pageContext.request.contextPath}/profile" class="glass-panel rounded-[32px] p-8 transition-all duration-300 hover:bg-gold/5 hover:border-gold/30 hover:-translate-y-2 hover:shadow-2xl hover:shadow-gold/10 group">
                <div class="flex items-start justify-between mb-8">
                    <div class="w-14 h-14 rounded-2xl bg-gold/10 flex items-center justify-center text-2xl group-hover:bg-gold group-hover:text-dark transition-all duration-300">👤</div>
                    <span class="text-gold text-lg group-hover:translate-x-1 transition-transform">→</span>
                </div>
                <h4 class="text-xl font-serif font-bold text-white mb-3 group-hover:text-gold transition-colors">Hồ Sơ Cá Nhân</h4>
                <p class="text-xs text-white/40 leading-relaxed font-bold uppercase tracking-widest pt-2">Bảo mật & Thông tin</p>
            </a>

            <a href="${pageContext.request.contextPath}/#promotions" class="glass-panel rounded-[32px] p-8 transition-all duration-300 hover:bg-gold/5 hover:border-gold/30 hover:-translate-y-2 hover:shadow-2xl hover:shadow-gold/10 group">
                <div class="flex items-start justify-between mb-8">
                    <div class="w-14 h-14 rounded-2xl bg-gold/10 flex items-center justify-center text-2xl group-hover:bg-gold group-hover:text-dark transition-all duration-300">🎁</div>
                    <span class="text-gold text-lg group-hover:translate-x-1 transition-transform">→</span>
                </div>
                <h4 class="text-xl font-serif font-bold text-white mb-3 group-hover:text-gold transition-colors">Ưu Đãi Đặc Quyền</h4>
                <p class="text-xs text-white/40 leading-relaxed font-bold uppercase tracking-widest pt-2">Voucher & Rewards</p>
            </a>

            <a href="${pageContext.request.contextPath}/rooms" class="glass-panel rounded-[32px] p-8 transition-all duration-300 hover:bg-gold/5 hover:border-gold/30 hover:-translate-y-2 hover:shadow-2xl hover:shadow-gold/10 group">
                <div class="flex items-start justify-between mb-8">
                    <div class="w-14 h-14 rounded-2xl bg-gold/10 flex items-center justify-center text-2xl group-hover:bg-gold group-hover:text-dark transition-all duration-300">🏖️</div>
                    <span class="text-gold text-lg group-hover:translate-x-1 transition-transform">→</span>
                </div>
                <h4 class="text-xl font-serif font-bold text-white mb-3 group-hover:text-gold transition-colors">Đặt Phòng Mới</h4>
                <p class="text-xs text-white/40 leading-relaxed font-bold uppercase tracking-widest pt-2">Khám phá thiên đường</p>
            </a>

            <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
                <a href="${pageContext.request.contextPath}/dashboard/admin" class="glass-panel rounded-[32px] p-8 transition-all duration-300 hover:bg-gold/5 hover:border-gold/30 hover:-translate-y-2 hover:shadow-2xl hover:shadow-gold/10 ring-1 ring-gold/20 bg-gold/5 border-gold/20 border-dashed group">
                    <div class="flex items-start justify-between mb-8">
                        <div class="w-14 h-14 rounded-2xl bg-gold flex items-center justify-center text-dark font-bold text-lg transition-all duration-300">⌘</div>
                        <span class="text-gold text-lg group-hover:translate-x-1 transition-transform">→</span>
                    </div>
                    <h4 class="text-xl font-serif font-bold text-gold mb-3 transition-colors">Bản Điều Khiển Quản Trị</h4>
                    <p class="text-[10px] text-white/60 leading-relaxed font-bold uppercase tracking-widest italic pt-2">Internal Access Only</p>
                </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/logout" class="glass-panel rounded-[32px] p-8 transition-all duration-300 hover:bg-red-500/5 hover:border-red-500/30 hover:-translate-y-2 hover:shadow-2xl hover:shadow-red-500/10 group">
                <div class="flex items-start justify-between mb-8">
                    <div class="w-14 h-14 rounded-2xl bg-red-500/10 flex items-center justify-center text-2xl group-hover:bg-red-500 group-hover:text-white transition-all duration-300">🚪</div>
                    <span class="text-red-500 text-lg group-hover:translate-x-1 transition-transform">→</span>
                </div>
                <h4 class="text-xl font-serif font-bold text-white mb-3 group-hover:text-red-500 transition-colors">Đăng Xuất</h4>
                <p class="text-xs text-white/40 leading-relaxed font-bold uppercase tracking-widest pt-2">Kết thúc phiên làm việc</p>
            </a>
        </div>
    </div>
</main>

<footer class="bg-[#060608] border-t border-white/5 py-12 px-6 md:px-12">
    <div class="max-w-6xl mx-auto flex flex-col md:flex-row justify-between items-center gap-8">
        <div class="text-white/20 text-[10px] tracking-[0.2em] font-bold uppercase">
            © 2026 Azure Resort & Spa — Identity Central
        </div>
        <div class="flex items-center gap-1 text-white/20 text-[10px] tracking-[0.2em] font-bold uppercase">
            Designed for <span class="text-gold font-serif italic ml-1">Excellence</span>
        </div>
    </div>
</footer>

</body>
</html>
