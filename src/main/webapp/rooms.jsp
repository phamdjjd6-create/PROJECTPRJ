<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="account" value="${sessionScope.account.fullName}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tất Cả Phòng &amp; Villa — Azure Resort</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        gold: '#c9a84c',
                        'gold-light': '#e8cc82',
                        dark: '#0a0a0f',
                        navy: '#0d1526',
                    },
                    fontFamily: {
                        serif: ['Playfair Display', 'serif'],
                        sans: ['Inter', 'sans-serif'],
                    },
                    animation: {
                        'reveal': 'reveal 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards',
                        'float': 'float 3s ease-in-out infinite',
                    },
                    keyframes: {
                        reveal: {
                            '0%': { opacity: '0', transform: 'translateY(20px)' },
                            '100%': { opacity: '1', transform: 'translateY(0)' },
                        },
                        float: {
                            '0%, 100%': { transform: 'translateY(0)' },
                            '50%': { transform: 'translateY(-10px)' },
                        }
                    }
                }
            }
        }
    </script>
    <style>
        :root {
            --gold: #c9a84c; --gold-light: #e8cc82;
            --dark: #0a0a0f; --navy: #0d1526;
        }
        body { background-color: var(--dark); color: white; font-family: 'Inter', sans-serif; margin: 0; }
        .glass-panel { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(40px); border: 1px solid rgba(255, 255, 255, 0.1); }
    </style>
    <style type="text/tailwindcss">
        @layer base {
            body { @apply bg-dark text-white font-sans antialiased selection:bg-gold/30; }
        }
        @layer components {
            .nav-link { @apply text-white/60 hover:text-gold transition-colors text-sm font-medium relative py-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-0 after:h-0.5 after:bg-gold after:transition-all hover:after:w-full; }
            .nav-link.active { @apply text-gold after:w-full; }
            .glass-panel { @apply bg-white/5 backdrop-blur-2xl border border-white/10; }
            .btn-premium { @apply px-8 py-3 bg-gradient-to-r from-gold to-gold-light text-dark font-bold rounded-full transition-all hover:scale-105 active:scale-95 shadow-lg shadow-gold/20 hover:shadow-gold/40 text-sm tracking-widest uppercase; }
            .btn-outline { @apply px-8 py-3 bg-transparent border border-gold/40 text-gold font-bold rounded-full transition-all hover:bg-gold hover:text-dark text-sm tracking-widest uppercase; }
        }
        .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(201,168,76,0.2); border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: rgba(201,168,76,0.4); }
    </style>
</head>
<body>

<!-- NAVBAR (Reusing Premium Design) -->
<nav id="navbar" class="fixed top-0 left-0 right-0 z-[1000] px-6 md:px-12 h-20 flex items-center justify-between transition-all duration-500 bg-dark/80 backdrop-blur-md border-b border-gold/10">
    <a href="${pageContext.request.contextPath}/" class="text-2xl font-serif font-bold tracking-tight text-white group">
        Azure <span class="text-gold group-hover:text-gold-light transition-colors">Resort</span>
    </a>
    
    <ul class="hidden md:flex items-center gap-10">
        <li><a href="${pageContext.request.contextPath}/" class="nav-link">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="nav-link active">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my" class="nav-link">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="nav-link">Tài Khoản</a></li>
        <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
            <li><a href="${pageContext.request.contextPath}/dashboard/admin" class="nav-link text-gold font-bold border border-gold/20 px-4 py-1.5 rounded-full hover:bg-gold hover:text-dark transition-all">Bảng điều khiển</a></li>
        </c:if>
    </ul>

    <div class="flex items-center gap-6">
        <c:choose>
            <c:when test="${not empty account}">
                <div class="hidden sm:flex flex-col items-end">
                    <span class="text-[10px] text-white/40 uppercase tracking-[0.2em]">Khách hàng</span>
                    <span class="text-sm font-medium text-gold">${account}</span>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="px-5 py-2 border border-gold/30 rounded-full text-xs font-bold text-gold uppercase tracking-widest hover:bg-gold hover:text-dark transition-all">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <div class="flex items-center gap-4">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="text-xs font-bold text-gold uppercase tracking-widest hover:text-white transition-colors">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="px-6 py-2 bg-gold text-dark text-xs font-bold rounded-full uppercase tracking-widest hover:bg-gold-light transition-all">Đăng ký</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- PAGE HEADER -->
<header class="pt-32 pb-20 bg-gradient-to-b from-navy to-dark border-b border-gold/5 px-6 md:px-12">
    <div class="max-w-7xl mx-auto animate-reveal">
        <nav class="flex items-center gap-2 text-xs text-white/30 uppercase tracking-[0.2em] mb-6">
            <a href="${pageContext.request.contextPath}/" class="hover:text-gold transition-colors">Trang Chủ</a>
            <span>/</span>
            <span class="text-gold">Phòng &amp; Villa</span>
        </nav>
        <span class="block text-gold text-[10px] uppercase tracking-[0.4em] font-bold mb-3">Azure Signature Collection</span>
        <h1 class="text-5xl md:text-7xl font-serif font-bold text-white mb-6 leading-tight">
            Tất Cả Phòng <br class="hidden md:block"> &amp; <span class="italic text-gold italic">Villa</span>
        </h1>
        <p class="text-white/40 max-w-2xl text-lg font-light leading-relaxed">
            Khám phá tinh hoa kiến trúc kết hợp cùng thiên nhiên hùng vĩ. Mỗi không gian tại Azure Resort được thiết kế để mang lại sự tĩnh lặng tuyệt đối cho tâm hồn bạn.
        </p>
    </div>
</header>

<!-- SEARCH & FILTER (Glassmorphic Bar) -->
<section class="sticky top-20 z-50 px-6 md:px-12 -mt-10">
    <div class="max-w-7xl mx-auto glass-panel rounded-3xl p-6 shadow-2xl">
        <form class="flex flex-wrap items-end gap-6" action="${pageContext.request.contextPath}/rooms" method="GET">
            <div class="flex-1 min-w-[200px]">
                <label class="block text-[10px] text-white/40 uppercase tracking-[0.2em] font-bold mb-3">Loại Hình Nghỉ Dưỡng</label>
                <select name="type" class="w-full bg-white/10 border border-white/10 rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-gold/50 transition-all">
                    <option value="" ${empty filterType ? 'selected' : ''}>Tất cả tinh hoa</option>
                    <option value="VILLA" ${filterType == 'VILLA' ? 'selected' : ''}>Luxury Villa</option>
                    <option value="HOUSE" ${filterType == 'HOUSE' ? 'selected' : ''}>Signature House</option>
                    <option value="ROOM"  ${filterType == 'ROOM'  ? 'selected' : ''}>Infinity Room</option>
                </select>
            </div>
            
            <div class="flex-1 min-w-[150px]">
                <label class="block text-[10px] text-white/40 uppercase tracking-[0.2em] font-bold mb-3">Ngày Nhận Phòng</label>
                <input type="date" name="checkin" value="${checkin}" class="w-full bg-white/10 border border-white/10 rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-gold/50 transition-all [color-scheme:dark]">
            </div>

            <div class="flex-1 min-w-[150px]">
                <label class="block text-[10px] text-white/40 uppercase tracking-[0.2em] font-bold mb-3">Ngày Trả Phòng</label>
                <input type="date" name="checkout" value="${checkout}" class="w-full bg-white/10 border border-white/10 rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-gold/50 transition-all [color-scheme:dark]">
            </div>

            <div class="w-full sm:w-auto">
                <button type="submit" class="w-full sm:w-auto px-10 py-3.5 bg-gold text-dark font-bold rounded-xl uppercase tracking-widest text-xs hover:bg-gold-light transition-all shadow-lg shadow-gold/20 flex items-center justify-center gap-2">
                    <span>🔍</span> Tìm Phòng
                </button>
            </div>
        </form>
    </div>
</section>

<!-- FILTER TABS (Pills) -->
<div class="max-w-7xl mx-auto px-6 md:px-12 mt-12 flex items-center gap-3 overflow-x-auto pb-4 custom-scrollbar">
    <a href="${pageContext.request.contextPath}/rooms" class="flex-shrink-0 px-6 py-2.5 rounded-full text-xs font-bold uppercase tracking-widest transition-all ${empty filterType ? 'bg-gold text-dark' : 'bg-white/5 border border-white/10 text-white/60 hover:border-gold/50'}">
        Tất Cả <span class="ml-2 opacity-60 font-normal">${cntAll}</span>
    </a>
    <a href="${pageContext.request.contextPath}/rooms?type=VILLA" class="flex-shrink-0 px-6 py-2.5 rounded-full text-xs font-bold uppercase tracking-widest transition-all ${filterType == 'VILLA' ? 'bg-gold text-dark' : 'bg-white/5 border border-white/10 text-white/60 hover:border-gold/50'}">
        Villa <span class="ml-2 opacity-60 font-normal">${cntVilla}</span>
    </a>
    <a href="${pageContext.request.contextPath}/rooms?type=HOUSE" class="flex-shrink-0 px-6 py-2.5 rounded-full text-xs font-bold uppercase tracking-widest transition-all ${filterType == 'HOUSE' ? 'bg-gold text-dark' : 'bg-white/5 border border-white/10 text-white/60 hover:border-gold/50'}">
        House <span class="ml-2 opacity-60 font-normal">${cntHouse}</span>
    </a>
    <a href="${pageContext.request.contextPath}/rooms?type=ROOM" class="flex-shrink-0 px-6 py-2.5 rounded-full text-xs font-bold uppercase tracking-widest transition-all ${filterType == 'ROOM' ? 'bg-gold text-dark' : 'bg-white/5 border border-white/10 text-white/60 hover:border-gold/50'}">
        Phòng <span class="ml-2 opacity-60 font-normal">${cntRoom}</span>
    </a>
</div>

<!-- SEARCH SUMMARY -->
<c:if test="${isSearchMode}">
<div class="max-w-7xl mx-auto px-6 md:px-12 mb-8 flex items-center flex-wrap gap-4 animate-reveal">
    <span class="text-sm text-white/40 italic">Đang hiển thị kết quả cho:</span>
    <c:forEach var="item" items="${[checkin, checkout]}">
        <c:if test="${not empty item}">
            <span class="px-4 py-1.5 bg-gold/10 border border-gold/20 rounded-full text-[10px] font-bold text-gold uppercase tracking-tighter">${item}</span>
        </c:if>
    </c:forEach>
    <a href="${pageContext.request.contextPath}/rooms" class="text-xs text-red-400 hover:text-red-300 transition-colors border-b border-red-400/30">Hủy bộ lọc</a>
</div>
</c:if>

<!-- ROOMS GRID -->
<main class="max-w-7xl mx-auto px-6 md:px-12 py-12">
    <c:choose>
        <c:when test="${not empty facilityError}">
            <div class="glass-panel rounded-3xl p-12 text-center">
                <div class="text-4xl mb-6">⚠️</div>
                <h3 class="text-2xl font-serif font-bold text-white mb-4">Lỗi Hệ Thống</h3>
                <p class="text-white/40 max-w-md mx-auto leading-relaxed">${facilityError}</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="flex items-center justify-between mb-10">
                <h2 class="text-sm text-white/40 uppercase tracking-[0.3em]">Kết quả: <span class="text-gold font-bold">${filteredFacilities.size()}</span> phòng khả dụng</h2>
                <div class="h-px flex-1 bg-white/5 mx-8"></div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-10">
                <c:choose>
                    <c:when test="${empty filteredFacilities}">
                        <div class="col-span-full py-32 text-center animate-reveal">
                            <div class="text-6xl mb-8 opacity-20">📭</div>
                            <h3 class="text-3xl font-serif font-bold text-white mb-4">Không tìm thấy phòng phù hợp</h3>
                            <p class="text-white/40 mb-10">Thử thay đổi bộ lọc hoặc xem danh sách đầy đủ của chúng tôi.</p>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn-premium inline-block">Xem tất cả phòng</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="f" items="${filteredFacilities}" varStatus="loop">
                            <c:set var="defaultImg" value="${f.facilityType == 'VILLA' ? 'assets/img/villa-ocean.png' : 'assets/img/hero-bg.png'}"/>
                            <c:set var="imgSrc" value="${not empty f.imageUrl ? f.imageUrl : defaultImg}"/>
                            <c:set var="isAvailable" value="${f.status == 'AVAILABLE'}"/>
                            
                            <article class="group animate-reveal" style="animation-delay: ${loop.index * 100}ms;">
                                <div class="relative aspect-[4/3] rounded-[32px] overflow-hidden mb-6 shadow-xl border border-white/5">
                                    <img src="${imgSrc.startsWith('http') ? imgSrc : pageContext.request.contextPath.concat('/').concat(imgSrc)}" alt="${f.serviceName}" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                                    <div class="absolute inset-0 bg-gradient-to-t from-dark/80 via-transparent to-transparent opacity-60"></div>
                                    
                                    <!-- Badges -->
                                    <div class="absolute top-6 left-6 space-y-2">
                                        <c:if test="${loop.first && empty filterType}">
                                            <span class="block px-4 py-1.5 bg-gold text-dark text-[10px] font-bold uppercase tracking-widest rounded-full shadow-lg">Bán chạy nhất</span>
                                        </c:if>
                                        <span class="block px-4 py-1.5 ${isAvailable ? 'bg-green-500/20 text-green-400 border-green-500/30' : 'bg-red-500/20 text-red-400 border-red-500/30'} border backdrop-blur-md text-[10px] font-bold uppercase tracking-widest rounded-full">
                                            ${isAvailable ? 'Sẵn sàng' : 'Hết phòng'}
                                        </span>
                                    </div>

                                    <!-- Price Overlay -->
                                    <div class="absolute bottom-6 right-6 text-right">
                                        <fmt:formatNumber var="priceStr" value="${f.cost}" type="number" groupingUsed="true"/>
                                        <div class="text-white text-3xl font-serif font-bold group-hover:text-gold transition-colors">${priceStr} <span class="text-xs font-sans uppercase tracking-widest ml-1 opacity-60">đ/đêm</span></div>
                                    </div>
                                </div>

                                <div class="px-2">
                                    <div class="flex items-center gap-2 mb-3">
                                        <span class="text-[10px] text-gold uppercase tracking-[0.3em] font-bold">${f.facilityType}</span>
                                        <span class="w-1 h-1 bg-white/20 rounded-full"></span>
                                        <span class="text-[10px] text-white/40 uppercase tracking-[0.2em] font-medium">${f.serviceCode}</span>
                                    </div>
                                    <h3 class="text-2xl font-serif font-bold text-white mb-4 group-hover:text-gold transition-colors">${f.serviceName}</h3>
                                    
                                    <div class="flex items-center gap-6 text-xs text-white/40 mb-8 pb-8 border-b border-white/5">
                                        <div class="flex items-center gap-2"><span>👤</span> ${f.maxPeople} Người</div>
                                        <div class="flex items-center gap-2"><span>📏</span> ${f.usableArea} m²</div>
                                        <div class="flex items-center gap-2"><span>🛌</span> ${f.rentalType}</div>
                                    </div>

                                    <div class="flex items-center gap-4">
                                        <a href="facility-detail?code=${f.serviceCode}" class="flex-1 text-center py-3.5 border border-white/10 rounded-2xl text-xs font-bold text-white uppercase tracking-widest hover:border-gold hover:text-gold transition-all">Chi tiết</a>
                                        <c:if test="${isAvailable}">
                                            <a href="${pageContext.request.contextPath}/booking?facility=${f.serviceCode}" class="flex-[1.5] text-center py-3.5 bg-gradient-to-r from-gold to-gold-light rounded-2xl text-xs font-bold text-dark uppercase tracking-widest hover:scale-105 active:scale-95 transition-all shadow-lg shadow-gold/20">Đặt ngay</a>
                                        </c:if>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<!-- FOOTER -->
<footer class="bg-[#060608] border-t border-white/5 py-12 px-6 md:px-12 text-center md:text-left">
    <div class="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-8">
        <div class="text-white/20 text-xs tracking-wider">
            © 2026 <span class="text-gold font-bold">Azure Resort &amp; Spa</span>. Bản quyền được bảo lưu.
        </div>
        <div class="flex items-center gap-1">
            <span class="text-white/20 text-xs tracking-wider font-light">Kiến tạo trải nghiệm đẳng cấp bởi</span>
            <span class="text-gold font-serif italic ml-1">Azure Team</span>
        </div>
    </div>
</footer>

<script>
    const nav = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            nav.classList.add('h-16', 'bg-dark/95', 'shadow-2xl');
            nav.classList.remove('h-20', 'bg-dark/80');
        } else {
            nav.classList.remove('h-16', 'bg-dark/95', 'shadow-2xl');
            nav.classList.add('h-20', 'bg-dark/80');
        }
    });
</script>
</body>
</html>
