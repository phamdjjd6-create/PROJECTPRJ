<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Của Tôi — Azure Resort</title>
    
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
<nav id="navbar" class="fixed top-0 left-0 right-0 z-[1000] px-6 md:px-12 h-20 flex items-center justify-between transition-all duration-500 bg-dark/80 backdrop-blur-md border-b border-gold/10">
    <a href="${pageContext.request.contextPath}/" class="text-2xl font-serif font-bold tracking-tight text-white group">
        Azure <span class="text-gold group-hover:text-gold-light transition-colors">Resort</span>
    </a>
    
    <ul class="hidden md:flex items-center gap-10">
        <li><a href="${pageContext.request.contextPath}/" class="nav-link-base">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="nav-link-base">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking" class="nav-link-base">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="nav-link-base nav-link-active">Tài Khoản</a></li>
        <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
            <li><a href="${pageContext.request.contextPath}/dashboard/admin" class="nav-link-base text-gold font-bold border border-gold/20 px-4 py-1.5 rounded-full hover:bg-gold hover:text-dark transition-all">Bảng điều khiền</a></li>
        </c:if>
    </ul>

    <div class="flex items-center gap-6">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <div class="hidden sm:flex flex-col items-end">
                    <span class="text-[10px] text-white/40 uppercase tracking-[0.2em]">Xin chào</span>
                    <span class="text-sm font-medium text-gold">${sessionScope.account.fullName}</span>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="px-5 py-2 border border-gold/30 rounded-full text-xs font-bold text-gold uppercase tracking-widest hover:bg-gold hover:text-dark transition-all">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="px-8 py-3 bg-gold text-dark text-xs font-bold uppercase tracking-widest rounded-full hover:bg-gold-light transition-all shadow-lg shadow-gold/20">Đăng nhập</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-6 pt-32 pb-24 min-h-[80vh]">
    <!-- Breadcrumbs -->
    <nav class="flex items-center gap-2 text-[10px] uppercase tracking-widest text-white/40 mb-12 animate-reveal">
        <a href="${pageContext.request.contextPath}/" class="hover:text-gold transition-colors">Trang Chủ</a>
        <span>/</span>
        <a href="${pageContext.request.contextPath}/account.jsp" class="hover:text-gold transition-colors">Tài Khoản</a>
        <span>/</span>
        <span class="text-gold">Booking Của Tôi</span>
    </nav>

    <div class="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-12 animate-reveal" style="animation-delay: 100ms">
        <div>
            <h1 class="text-5xl font-serif font-bold text-white mb-4">Lịch sử <span class="text-gold italic">Đặt phòng</span></h1>
            <p class="text-white/40 text-lg font-light leading-relaxed max-w-xl">Quản lý các yêu cầu đặt phòng và hành trình nghỉ dưỡng của bạn tại Azure.</p>
        </div>
        <a href="${pageContext.request.contextPath}/booking" class="px-8 py-4 bg-white/5 border border-white/10 rounded-2xl text-xs font-bold uppercase tracking-widest hover:bg-gold hover:text-dark transition-all flex items-center gap-3 group">
            <span class="text-gold group-hover:text-dark">+</span> Đặt phòng mới
        </a>
    </div>

    <!-- Bookings Table -->
    <div class="glass-panel rounded-[40px] overflow-hidden animate-reveal" style="animation-delay: 200ms">
        <c:choose>
            <c:when test="${empty myBookings}">
                <div class="py-32 flex flex-col items-center text-center space-y-6">
                    <div class="text-6xl opacity-20">🏝️</div>
                    <div class="space-y-2">
                        <h3 class="text-2xl font-serif font-bold text-white">Chưa có booking nào</h3>
                        <p class="text-white/30 text-sm max-w-xs mx-auto">Hành trình tuyệt vời của bạn vẫn đang chờ được viết tiếp. Hãy bắt đầu ngay hôm nay!</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking" class="px-10 py-4 bg-gold text-dark text-xs font-bold uppercase tracking-widest rounded-full hover:bg-gold-light transition-all shadow-xl shadow-gold/20">Khám phá ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-white/2">
                                <th class="px-8 py-6 text-[10px] font-bold text-white/30 uppercase tracking-[0.2em]">Thông tin / Ngày đặt</th>
                                <th class="px-8 py-6 text-[10px] font-bold text-white/30 uppercase tracking-[0.2em]">Loại không gian</th>
                                <th class="px-8 py-6 text-[10px] font-bold text-white/30 uppercase tracking-[0.2em]">Thời gian lưu trú</th>
                                <th class="px-8 py-6 text-[10px] font-bold text-white/30 uppercase tracking-[0.2em]">Trạng thái</th>
                                <th class="px-8 py-6 text-[10px] font-bold text-white/30 uppercase tracking-[0.2em]">Thành viên</th>
                                <th class="px-8 py-6"></th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-white/5">
                            <c:forEach var="b" items="${myBookings}">
                                <tr class="group hover:bg-white/[0.02] transition-colors">
                                    <td class="px-8 py-8">
                                        <div class="flex flex-col">
                                            <span class="text-xs font-mono text-gold mb-1">#${b.bookingId}</span>
                                            <span class="text-[10px] text-white/40 uppercase tracking-widest">
                                                <fmt:formatDate value="${b.dateBooking}" pattern="dd MMM, yyyy · HH:mm"/>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-8">
                                        <div class="flex flex-col">
                                            <span class="text-sm font-bold text-white mb-1">${b.facilityId.serviceName}</span>
                                            <span class="text-[10px] text-gold/60 uppercase tracking-widest font-medium">${b.facilityId.facilityType}</span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-8">
                                        <div class="flex flex-col">
                                            <span class="text-sm text-white/80 font-medium">
                                                <fmt:formatDate value="${b.startDate}" pattern="dd/MM/yyyy"/>
                                                <span class="mx-2 text-white/20">→</span>
                                                <fmt:formatDate value="${b.endDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                            <span class="text-[10px] text-white/30 mt-1 uppercase tracking-widest">Kỳ nghỉ tuyệt vời</span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-8">
                                        <c:set var="statusClass" value="${b.status == 'PENDING' ? 'border-amber-500/20 text-amber-500 bg-amber-500/10' : 
                                                                        b.status == 'CONFIRMED' ? 'border-emerald-500/20 text-emerald-500 bg-emerald-500/10' :
                                                                        b.status == 'CANCELLED' ? 'border-red-500/20 text-red-500 bg-red-500/10' :
                                                                        'border-blue-500/20 text-blue-500 bg-blue-500/10'}"/>
                                        <span class="status-badge-base ${statusClass}">
                                            <c:choose>
                                                <c:when test="${b.status == 'PENDING'}">Chờ Duyệt</c:when>
                                                <c:when test="${b.status == 'CONFIRMED'}">Đã Xác Nhận</c:when>
                                                <c:when test="${b.status == 'CANCELLED'}">Đã Hủy</c:when>
                                                <c:when test="${b.status == 'COMPLETED'}">Hoàn Thành</c:when>
                                                <c:when test="${b.status == 'CHECKED_IN'}">Đang Ở</c:when>
                                                <c:when test="${b.status == 'CHECKED_OUT'}">Đã Trả Phòng</c:when>
                                                <c:otherwise>${b.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="px-8 py-8">
                                        <div class="flex items-center gap-2 text-xs text-white/60 font-medium">
                                            <span class="w-6 h-6 rounded-full bg-white/5 flex items-center justify-center text-[10px] text-gold">${b.adults + b.children}</span>
                                            Khách
                                        </div>
                                    </td>
                                    <td class="px-8 py-8 text-right">
                                        <c:if test="${b.status == 'PENDING'}">
                                            <button onclick="confirmCancel('${b.bookingId}')" class="text-[10px] font-bold text-red-400/60 uppercase tracking-widest hover:text-red-400 transition-colors">
                                                Hủy đặt
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<footer class="bg-dark/50 border-t border-white/5 py-12 px-6">
    <div class="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-8">
        <div class="flex flex-col items-center md:items-start gap-2">
            <span class="text-xl font-serif font-bold text-white">Azure <span class="text-gold">Resort</span></span>
            <span class="text-[10px] text-white/20 uppercase tracking-[0.3em]">The Ultimate Luxury Experience</span>
        </div>
        <div class="flex gap-10 text-[10px] font-bold text-white/40 uppercase tracking-widest">
            <a href="#" class="hover:text-gold transition-colors">Chính sách</a>
            <a href="#" class="hover:text-gold transition-colors">Hỗ trợ</a>
            <a href="#" class="hover:text-gold transition-colors">Liên hệ</a>
        </div>
        <div class="text-[10px] text-white/20 uppercase tracking-widest">
            © 2026 Azure Resort & Spa.
        </div>
    </div>
</footer>

<c:if test="${not empty sessionScope.bookingFlash}">
    <div id="flashToast" class="fixed top-24 right-8 z-[2000] px-6 py-4 rounded-2xl glass-panel animate-reveal flex items-center gap-4 ${sessionScope.bookingFlash.startsWith('✅') ? 'border-emerald-500/20' : 'border-red-500/20'}">
        <div class="w-8 h-8 rounded-full flex items-center justify-center bg-white/5 text-lg">
            ${sessionScope.bookingFlash.startsWith('✅') ? '✨' : '⚠️'}
        </div>
        <div>
            <p class="text-[10px] text-white/40 uppercase tracking-widest font-bold">Thông báo hệ thống</p>
            <p class="text-sm font-medium text-white">${sessionScope.bookingFlash}</p>
        </div>
    </div>
    <c:remove var="bookingFlash" scope="session"/>
    <script>
        setTimeout(() => {
            const t = document.getElementById('flashToast');
            if (t) {
                t.style.opacity = '0';
                t.style.transform = 'translateY(-20px)';
                t.style.transition = 'all 0.5s cubic-bezier(0.2, 0.8, 0.2, 1)';
                setTimeout(() => t.remove(), 500);
            }
        }, 5000);
    </script>
</c:if>

<script>
    function confirmCancel(id) {
        if (confirm('Bạn có chắc chắn muốn hủy yêu cầu đặt phòng này?')) {
            // Implement cancellation redirect if needed
            // window.location.href = '${pageContext.request.contextPath}/booking?action=cancel&id=' + id;
        }
    }
</script>

</body>
</html>
