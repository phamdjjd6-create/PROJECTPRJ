<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${empty facility}">
    <c:redirect url="/"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${facility.serviceName} — Azure Resort &amp; Spa</title>
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
                    },
                    keyframes: {
                        reveal: {
                            '0%': { opacity: '0', transform: 'translateY(20px)' },
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
            --dark: #0a0a0f; --navy: #0d1526;
        }
        body { background-color: var(--dark); color: white; font-family: 'Inter', sans-serif; margin: 0; }
        .glass-panel { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(40px); border: 1px solid rgba(255, 255, 255, 0.1); }
        .spec-card { background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 16px; padding: 24px; }
    </style>
    <style type="text/tailwindcss">
        @layer base {
            body { @apply bg-dark text-white font-sans antialiased selection:bg-gold/30; }
        }
        @layer components {
            .nav-link { @apply text-white/60 hover:text-gold transition-colors text-sm font-medium relative py-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-0 after:h-0.5 after:bg-gold after:transition-all hover:after:w-full; }
            .nav-link.active { @apply text-gold after:w-full; }
            .glass-panel { @apply bg-white/5 backdrop-blur-2xl border border-white/10; }
            .spec-card { @apply bg-white/5 border border-white/10 rounded-2xl p-6 transition-all hover:bg-white/10 hover:border-gold/30; }
            .amenity-tag { @apply px-4 py-2 bg-gold/10 border border-gold/20 rounded-full text-xs text-gold-light font-medium; }
        }
        [color-scheme="dark"]::-webkit-calendar-picker-indicator { filter: invert(1); }
    </style>
</head>
<body>

<!-- NAVBAR (Premium Design) -->
<nav id="navbar" class="fixed top-0 left-0 right-0 z-[1000] px-6 md:px-12 h-20 flex items-center justify-between transition-all duration-500 bg-dark/80 backdrop-blur-md border-b border-gold/10">
    <a href="${pageContext.request.contextPath}/" class="text-2xl font-serif font-bold tracking-tight text-white group">
        Azure <span class="text-gold group-hover:text-gold-light transition-colors">Resort</span>
    </a>
    
    <ul class="hidden md:flex items-center gap-10">
        <li><a href="${pageContext.request.contextPath}/" class="nav-link">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="nav-link active">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking" class="nav-link">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="nav-link">Tài Khoản</a></li>
        <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
            <li><a href="${pageContext.request.contextPath}/dashboard/admin" class="nav-link text-gold font-bold border border-gold/20 px-4 py-1.5 rounded-full hover:bg-gold hover:text-dark transition-all">Bảng điều khiển</a></li>
        </c:if>
    </ul>

    <div class="flex items-center gap-6">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <div class="hidden sm:flex flex-col items-end">
                    <span class="text-[10px] text-white/40 uppercase tracking-[0.2em]">Khách hàng</span>
                    <span class="text-sm font-medium text-gold">${sessionScope.account.fullName}</span>
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

<!-- IMMERSIVE HERO -->
<div class="relative h-[70vh] min-h-[500px] overflow-hidden group">
    <img src="${imgSrc.startsWith('http') ? imgSrc : pageContext.request.contextPath.concat('/').concat(imgSrc)}" alt="${facility.serviceName}" class="w-full h-full object-cover transition-transform duration-[2000ms] scale-105 group-hover:scale-110">
    <div class="absolute inset-0 bg-gradient-to-b from-dark/20 via-dark/40 to-dark"></div>
    
    <div class="absolute inset-0 flex flex-col justify-end px-6 md:px-12 pb-24">
        <div class="max-w-7xl mx-auto w-full animate-reveal">
            <!-- Breadcrumbs -->
            <nav class="flex items-center gap-2 text-[10px] text-white/50 uppercase tracking-[0.2em] mb-8">
                <a href="${pageContext.request.contextPath}/" class="hover:text-gold transition-colors">Trang Chủ</a>
                <span>/</span>
                <a href="${pageContext.request.contextPath}/rooms" class="hover:text-gold transition-colors">Phòng &amp; Villa</a>
                <span>/</span>
                <span class="text-gold">${facility.serviceName}</span>
            </nav>

            <span class="inline-block px-5 py-1.5 bg-gold/20 border border-gold/30 rounded-full text-[10px] font-bold text-gold uppercase tracking-[0.2em] mb-6">
                ${facilityTypeLabel} - Azure Collection
            </span>

            <h1 class="text-5xl md:text-7xl font-serif font-bold text-white mb-6 leading-tight max-w-4xl">
                ${facility.serviceName}
            </h1>

            <div class="flex items-center gap-4">
                <div class="flex items-center gap-3 px-4 py-2 bg-white/5 backdrop-blur-md rounded-full border border-white/10 text-xs font-medium">
                    <span class="w-2 h-2 rounded-full ${facility.status == 'AVAILABLE' ? 'bg-green-500 shadow-[0_0_10px_rgba(34,197,94,0.5)]' : 'bg-red-500 shadow-[0_0_10px_rgba(239,68,68,0.5)]'}"></span>
                    ${statusLabel}
                </div>
                <div class="h-px w-12 bg-gold/30"></div>
                <span class="text-white/40 text-xs uppercase tracking-widest">Mã định danh: ${facility.serviceCode}</span>
            </div>
        </div>
    </div>
</div>

<!-- MAIN CONTENT -->
<main class="max-w-7xl mx-auto px-6 md:px-12 -mt-16 relative z-10 pb-32">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
        
        <!-- Left Column (Details) -->
        <div class="lg:col-span-2 space-y-16">
            
            <!-- Quick Back Button -->
            <a href="${pageContext.request.contextPath}/rooms" class="inline-flex items-center gap-3 text-xs font-bold text-white/40 uppercase tracking-widest hover:text-gold transition-all group">
                <span class="w-8 h-8 rounded-full border border-white/10 flex items-center justify-center group-hover:border-gold group-hover:bg-gold group-hover:text-dark transition-all">←</span>
                Trở lại danh sách phòng
            </a>

            <!-- Description -->
            <section class="animate-reveal" style="animation-delay: 100ms">
                <span class="block text-gold text-[10px] uppercase tracking-[0.4em] font-bold mb-4">Tổng quan không gian</span>
                <h2 class="text-4xl font-serif font-bold text-white mb-8">Trải nghiệm nghỉ dưỡng <br> <span class="italic text-gold italic">đẳng cấp tinh hoa</span></h2>
                <div class="text-white/60 text-lg font-light leading-relaxed prose prose-invert">
                    <c:choose>
                        <c:when test="${not empty facility.description}">${facility.description}</c:when>
                        <c:otherwise>Được bao quanh bởi cảnh quan thiên nhiên tuyệt mỹ, không gian nghỉ dưỡng tại Azure là sự giao thoa hoàn hảo giữa kiến trúc hiện đại và vẻ đẹp nguyên bản của biển cả. Mỗi chi tiết đều được chăm chút tỉ mỉ để tôn vinh sự riêng tư và sang trọng tuyệt đối của quý khách.</c:otherwise>
                    </c:choose>
                </div>
            </section>

            <!-- Specifications Grid -->
            <section class="animate-reveal" style="animation-delay: 200ms">
                <h3 class="text-xs font-bold text-white/30 uppercase tracking-[0.3em] mb-10 pb-4 border-b border-white/5">Thông số kỹ thuật</h3>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-6">
                    <div class="spec-card">
                        <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-3">Diện tích</span>
                        <div class="text-2xl font-serif font-bold text-white">${facility.usableArea} <span class="text-sm font-sans font-normal opacity-40 italic">m²</span></div>
                    </div>
                    <div class="spec-card">
                        <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-3">Sức chứa</span>
                        <div class="text-2xl font-serif font-bold text-white">${facility.maxPeople} <span class="text-sm font-sans font-normal opacity-40 italic">Người</span></div>
                    </div>
                    <div class="spec-card">
                        <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-3">Tầm nhìn</span>
                        <div class="text-2xl font-serif font-bold text-white">Panorama <span class="text-sm font-sans font-normal opacity-40 italic">View</span></div>
                    </div>
                    <div class="spec-card">
                        <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-3">Loại hình</span>
                        <div class="text-xl font-serif font-bold text-white">${facilityTypeLabel}</div>
                    </div>
                    <div class="spec-card">
                        <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-3">Hình thức thuê</span>
                        <div class="text-xl font-serif font-bold text-white">${rentalTypeLabel}</div>
                    </div>
                    <div class="spec-card">
                        <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-3">Định danh</span>
                        <div class="text-xl font-serif font-bold text-white">${facility.serviceCode}</div>
                    </div>
                </div>
            </section>

            <!-- Amenities -->
            <section class="animate-reveal" style="animation-delay: 300ms">
                <h3 class="text-xs font-bold text-white/30 uppercase tracking-[0.3em] mb-8 pb-4 border-b border-white/5">Tiện nghi đặc quyền</h3>
                <div class="flex flex-wrap gap-4">
                    <span class="amenity-tag">✦ Wifi tốc độ cao</span>
                    <span class="amenity-tag">✦ Điều hòa trung tâm</span>
                    <span class="amenity-tag">✦ Dọn phòng 24/7</span>
                    <span class="amenity-tag">✦ TV 4K OLED</span>
                    <span class="amenity-tag">✦ Két sắt an toàn</span>
                    <span class="amenity-tag">✦ Minibar cao cấp</span>
                    <span class="amenity-tag">✦ Hệ thống âm thanh Bang & Olufsen</span>
                </div>
            </section>
        </div>

        <!-- Right Column (Booking Widget) -->
        <div class="lg:block">
            <div class="sticky top-32 glass-panel rounded-[40px] p-10 shadow-2xl animate-reveal border-white/10 ring-1 ring-gold/10" style="animation-delay: 400ms">
                <div class="mb-10 text-center lg:text-left">
                    <span class="block text-[10px] text-gold uppercase tracking-[0.3em] font-bold mb-3">Ưu đãi hôm nay</span>
                    <div class="flex items-baseline gap-2 justify-center lg:justify-start">
                        <span class="text-xs text-gold uppercase tracking-widest font-bold">đ</span>
                        <h2 class="text-5xl font-serif font-bold text-white">${formattedCost}</h2>
                        <span class="text-xs text-white/30 font-medium">/ ${rentalTypeLabel}</span>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${isAvailable}">
                        <form action="${pageContext.request.contextPath}/booking" method="GET" class="space-y-6">
                            <input type="hidden" name="facility" value="${facility.serviceCode}">
                            
                            <div class="space-y-2">
                                <label class="block text-[10px] text-white/40 uppercase tracking-[0.2em] font-bold ml-1">Lịch nhận phòng</label>
                                <input type="date" name="checkin" id="checkinInput" class="w-full bg-white/5 border border-white/10 rounded-2xl px-5 py-4 text-sm text-white focus:outline-none focus:border-gold/50 transition-all [color-scheme:dark]">
                            </div>

                            <div class="space-y-2">
                                <label class="block text-[10px] text-white/40 uppercase tracking-[0.2em] font-bold ml-1">Lịch trả phòng</label>
                                <input type="date" name="checkout" id="checkoutInput" class="w-full bg-white/5 border border-white/10 rounded-2xl px-5 py-4 text-sm text-white focus:outline-none focus:border-gold/50 transition-all [color-scheme:dark]">
                            </div>

                            <div class="space-y-2 pb-6">
                                <label class="block text-[10px] text-white/40 uppercase tracking-[0.2em] font-bold ml-1">Số lượng khách</label>
                                <select name="adults" class="w-full bg-white/5 border border-white/10 rounded-2xl px-5 py-4 text-sm text-white focus:outline-none focus:border-gold/50 transition-all appearance-none cursor-pointer">
                                    <c:forEach begin="1" end="${facility.maxPeople}" var="i">
                                        <option value="${i}" class="bg-navy">${i} người lớn</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <button type="submit" class="w-full py-5 bg-gradient-to-r from-gold to-gold-light text-dark font-bold rounded-2xl uppercase tracking-[0.2em] transition-all hover:scale-[1.02] active:scale-95 shadow-xl shadow-gold/20 flex items-center justify-center gap-3 group">
                                <span>✦</span> Đặt Phòng Ngay
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="py-12 text-center space-y-4">
                            <div class="text-4xl opacity-20">🔇</div>
                            <h3 class="text-xl font-serif font-bold text-white/60">Tạm hết phòng</h3>
                            <button class="w-full py-5 bg-white/5 border border-white/10 text-white/30 font-bold rounded-2xl uppercase tracking-[0.2em] cursor-not-allowed">
                                Không thể đặt
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="mt-10 pt-10 border-t border-white/5 text-center">
                    <p class="text-[10px] text-white/30 leading-relaxed tracking-wider uppercase">
                        Miễn phí hủy phòng trước 48 giờ <br>
                        Hỗ trợ 24/7: <span class="text-gold font-bold">1800 7777</span>
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="bg-[#060608] border-t border-white/5 py-12 px-6 md:px-12 text-center md:text-left">
    <div class="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-8">
        <div class="text-white/20 text-xs tracking-wider">
            © 2026 <span class="text-gold font-bold">Azure Resort &amp; Spa</span>. Bản quyền được bảo lưu.
        </div>
        <div class="flex items-center gap-1">
            <span class="text-white/20 text-xs tracking-wider font-light">Tuyệt phẩm nghỉ dưỡng bởi</span>
            <span class="text-gold font-serif italic ml-1">Azure Team</span>
        </div>
    </div>
</footer>

<script>
    var today = new Date().toISOString().split('T')[0];
    var ci = document.getElementById('checkinInput');
    var co = document.getElementById('checkoutInput');
    if (ci) { ci.min = today; ci.addEventListener('change', function() { if (this.value) { var n = new Date(this.value); n.setDate(n.getDate()+1); if(co) co.min = n.toISOString().split('T')[0]; } }); }
    if (co) co.min = today;
</script>
</body>
</html>