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
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: { gold: '#c9a84c', dark: '#0a0a0f', navy: '#0d1526', azure: '#3b82f6' },
                    fontFamily: { serif: ['Playfair Display', 'serif'], sans: ['Inter', 'sans-serif'] }
                }
            }
        }
    </script>
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
        <c:choose>
            <c:when test="${sessionScope.account.personType == 'EMPLOYEE'}">
                <li><a href="${pageContext.request.contextPath}/dashboard/admin" class="px-6 py-2.5 bg-white/5 border border-gold/30 rounded-full text-[10px] font-bold text-gold uppercase tracking-[0.2em] hover:bg-gold hover:text-dark transition-all">Bảng Điều Khiển</a></li>
            </c:when>
            <c:otherwise>
                 <li><a href="${pageContext.request.contextPath}/account.jsp" class="text-gold transition-all text-[11px] font-bold uppercase tracking-[0.2em] relative py-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-full after:h-px after:bg-gold">Tài Khoản</a></li>
            </c:otherwise>
        </c:choose>
    </ul>

    <div class="flex items-center gap-8">
        <div class="hidden sm:flex flex-col items-end">
            <span class="text-[9px] text-white/20 uppercase tracking-[0.3em] font-bold">Authenticated as</span>
            <span class="text-sm font-bold text-gold tracking-tight">${currentUser.fullName}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="w-10 h-10 rounded-xl border border-white/10 flex items-center justify-center text-white/40 hover:text-red-400 hover:border-red-400/30 hover:bg-red-500/5 transition-all" title="Đăng xuất">⎋</a>
    </div>
</nav>

<main class="max-w-4xl mx-auto px-6 pt-40 pb-32">
    <!-- Breadcrumbs -->
    <nav class="flex items-center gap-3 text-[10px] text-white/20 uppercase tracking-[0.3em] mb-16 animate-reveal font-bold">
        <a href="${pageContext.request.contextPath}/" class="hover:text-gold transition-colors">Azure Resort</a>
        <span class="opacity-20">/</span>
        <a href="${pageContext.request.contextPath}/account.jsp" class="hover:text-gold transition-colors">Tài khoản</a>
        <span class="opacity-20">/</span>
        <span class="text-gold">Hồ sơ cá nhân</span>
    </nav>

    <div class="glass-panel rounded-[40px] p-10 md:p-20 animate-reveal" style="animation-delay: 100ms">
        <div class="text-center mb-16 space-y-4">
            <span class="inline-block px-4 py-1.5 rounded-full bg-gold/10 border border-gold/20 text-gold text-[9px] uppercase tracking-[0.4em] font-bold">Hồ sơ định danh</span>
            <h1 class="text-5xl md:text-6xl font-serif font-bold text-white tracking-tight">Chi tiết <span class="italic text-gold italic">Cá nhân</span></h1>
            <p class="text-white/30 text-xs max-w-sm mx-auto leading-relaxed font-medium uppercase tracking-widest pt-2">Quản lý thông tin bảo mật của bạn tại Azure</p>
        </div>

        <form action="${pageContext.request.contextPath}/profile" method="POST" class="space-y-12">
            <c:if test="${not empty requestScope.successMessage}">
                <div class="p-6 bg-emerald-500/10 border border-emerald-500/20 rounded-3xl text-emerald-400 text-xs font-bold text-center animate-reveal shadow-lg shadow-emerald-500/5 tracking-wider">
                    ✦ ${requestScope.successMessage}
                </div>
            </c:if>
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="p-6 bg-red-500/10 border border-red-500/20 rounded-3xl text-red-400 text-xs font-bold text-center animate-reveal shadow-lg shadow-red-500/5 tracking-wider">
                    ⚠️ ${requestScope.errorMessage}
                </div>
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div class="space-y-4">
                    <label class="block text-[10px] text-white/30 uppercase tracking-[0.2em] font-bold mb-3 ml-1">Tài khoản đăng nhập</label>
                    <div class="relative group">
                        <input type="text" class="form-input-base opacity-40 cursor-not-allowed bg-white/[0.01] border-dashed" value="${currentUser.account}" disabled>
                        <span class="absolute right-6 top-1/2 -translate-y-1/2 text-[8px] text-white/10 uppercase font-bold tracking-widest">Read Only</span>
                    </div>
                </div>
                <div class="space-y-4">
                    <label class="block text-[10px] text-white/30 uppercase tracking-[0.2em] font-bold mb-3 ml-1">Mã số định danh (UID)</label>
                    <div class="relative group">
                        <input type="text" class="form-input-base opacity-40 cursor-not-allowed bg-white/[0.01] border-dashed font-mono" value="AZ-${currentUser.id}" disabled>
                        <span class="absolute right-6 top-1/2 -translate-y-1/2 text-[8px] text-white/10 uppercase font-bold tracking-widest">System Key</span>
                    </div>
                </div>
            </div>

            <div class="space-y-4">
                <label for="fullName" class="block text-[10px] text-white/30 uppercase tracking-[0.2em] font-bold mb-3 ml-1">Họ và Tên đầy đủ</label>
                <div class="relative text-white">
                    <input type="text" name="fullName" id="fullName" class="form-input-base focus:border-gold/50 focus:bg-white/[0.05] outline-none" value="${currentUser.fullName}" required placeholder="Vui lòng nhập họ tên...">
                    <span class="absolute left-6 top-1/2 -translate-y-1/2 text-gold/20 pointer-events-none">👤</span>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div class="space-y-4">
                    <label for="dateOfBirth" class="block text-[10px] text-white/30 uppercase tracking-[0.2em] font-bold mb-3 ml-1">Ngày sinh</label>
                    <fmt:formatDate var="dobFormatted" value="${currentUser.dateOfBirth}" pattern="yyyy-MM-dd"/>
                    <input type="date" name="dateOfBirth" id="dateOfBirth" class="form-input-base [color-scheme:dark]" value="${dobFormatted}">
                </div>
                <div class="space-y-4">
                    <label for="gender" class="block text-[10px] text-white/30 uppercase tracking-[0.2em] font-bold mb-3 ml-1">Giới tính</label>
                    <div class="relative">
                        <select name="gender" id="gender" class="form-input-base appearance-none cursor-pointer pr-12 focus:border-gold/50 focus:bg-white/[0.05] outline-none">
                            <option value="" ${empty currentUser.gender ? 'selected' : ''}>Chưa xác định</option>
                            <option value="Male" ${currentUser.gender == 'Male' ? 'selected' : ''} class="bg-navy">Nam</option>
                            <option value="Female" ${currentUser.gender == 'Female' ? 'selected' : ''} class="bg-navy">Nữ</option>
                        </select>
                        <div class="absolute right-6 top-1/2 -translate-y-1/2 text-gold/40 pointer-events-none text-xs">▼</div>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div class="space-y-4">
                    <label for="phoneNumber" class="block text-[10px] text-white/30 uppercase tracking-[0.2em] font-bold mb-3 ml-1">Số điện thoại liên lạc</label>
                    <input type="tel" name="phoneNumber" id="phoneNumber" class="form-input-base focus:border-gold/50 focus:bg-white/[0.05] outline-none" value="${currentUser.phoneNumber}" placeholder="09xx xxx xxx">
                </div>
                <div class="space-y-4">
                    <label for="idCard" class="block text-[10px] text-white/30 uppercase tracking-[0.2em] font-bold mb-3 ml-1">CCCD / Passport</label>
                    <input type="text" name="idCard" id="idCard" class="form-input-base focus:border-gold/50 focus:bg-white/[0.05] outline-none" value="${currentUser.idCard}" placeholder="Nhập số giấy tờ...">
                </div>
            </div>

            <div class="space-y-4">
                <label for="email" class="block text-[10px] text-white/30 uppercase tracking-[0.2em] font-bold mb-3 ml-1">Địa chỉ thư điện tử (Email)</label>
                <input type="email" name="email" id="email" class="form-input-base focus:border-gold/50 focus:bg-white/[0.05] outline-none" value="${currentUser.email}" required placeholder="example@azure.com">
            </div>

            <div class="pt-12 space-y-6">
                <button type="submit" class="w-full bg-gradient-to-r from-gold to-gold-light text-dark font-bold text-[11px] uppercase tracking-[0.3em] rounded-2xl py-5 transition-all hover:shadow-[0_0_30px_rgba(201,168,76,0.3)] hover:scale-[1.01] active:scale-[0.98] flex items-center justify-center gap-4">
                    <span class="w-6 h-6 rounded-full bg-dark/10 flex items-center justify-center text-[8px]">✦</span>
                    Cập nhật hồ sơ Azure
                </button>
                <div class="flex items-center justify-center gap-8">
                    <a href="${pageContext.request.contextPath}/account.jsp" class="text-[9px] text-white/20 uppercase tracking-[0.3em] font-bold hover:text-gold transition-colors">Trở về tài khoản</a>
                    <span class="w-1 h-1 rounded-full bg-white/5"></span>
                    <a href="${pageContext.request.contextPath}/password_change" class="text-[9px] text-white/20 uppercase tracking-[0.3em] font-bold hover:text-gold transition-colors">Đổi mật khẩu</a>
                </div>
            </div>
        </form>
    </div>
</main>

<footer class="py-20 px-12 border-t border-white/5 bg-[#060608]">
    <div class="max-w-4xl mx-auto flex flex-col md:flex-row justify-between items-center gap-10 opacity-30 group hover:opacity-100 transition-opacity duration-700">
        <p class="text-[10px] uppercase tracking-[0.3em] font-bold font-sans">© 2026 Azure Resort & Spa — Personal Security</p>
        <div class="flex items-center gap-6">
            <span class="text-[10px] uppercase tracking-[0.3em] font-bold italic font-serif text-gold">Managed by Azure Identity Service</span>
        </div>
    </div>
</footer>

<script>
    const today = new Date();
    const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
    const dobInput = document.getElementById('dateOfBirth');
    if(dobInput) dobInput.setAttribute('max', maxDate.toISOString().split('T')[0]);
    
    // Smooth Navbar on scroll
    window.addEventListener('scroll', () => {
        const nav = document.getElementById('navbar');
        if (window.scrollY > 50) {
            nav.classList.add('h-20', 'bg-dark/80');
            nav.classList.remove('h-24', 'bg-dark/40');
        } else {
            nav.classList.remove('h-20', 'bg-dark/80');
            nav.classList.add('h-24', 'bg-dark/40');
        }
    });
</script>

</body>
</html>
