<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TblPersons" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    TblPersons currentUser = (TblPersons) session.getAttribute("account");
    if (currentUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    pageContext.setAttribute("currentUser", currentUser);
    pageContext.setAttribute("account", currentUser.getFullName());
%>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hợp Đồng Của Tôi — Azure Resort</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        gold: '#c9a84c',
                        'gold-light': '#e8cc82',
                        dark: '#0a0a0f',
                        navy: '#0d1526',
                        azure: '#3b82f6',
                    },
                    fontFamily: {
                        serif: ['Playfair Display', 'serif'],
                        sans: ['Inter', 'sans-serif'],
                    },
                    animation: {
                        'reveal': 'reveal 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards',
                        'shimmer': 'shimmer 2s infinite linear',
                    },
                    keyframes: {
                        reveal: {
                            '0%': { opacity: '0', transform: 'translateY(20px)' },
                            '100%': { opacity: '1', transform: 'translateY(0)' },
                        },
                        shimmer: {
                            '0%': { transform: 'translateX(-100%)' },
                            '100%': { transform: 'translateX(100%)' },
                        }
                    }
                }
            }
        }
    </script>
    <style>
        :root {
            --gold: #c9a84c; --gold-light: #e8cc82;
            --dark: #0a0a0f; --navy: #0d1526; --azure: #3b82f6;
        }
        body { background-color: var(--dark); color: white; font-family: 'Inter', sans-serif; margin: 0; }
        .contract-card { background: rgba(255, 255, 255, 0.02); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 40px; overflow: hidden; }
        .stat-pill { background: rgba(201, 168, 76, 0.05); border: 1px solid rgba(201, 168, 76, 0.2); border-radius: 16px; padding: 16px 24px; display: flex; flex-direction: column; align-items: center; }
    </style>
    <style type="text/tailwindcss">
        @layer base {
            body { @apply bg-dark text-white font-sans antialiased selection:bg-gold/30; }
        }
        @layer components {
            .nav-link { @apply text-white/70 hover:text-gold text-sm font-medium transition-colors relative py-2; }
            .nav-link.active { @apply text-gold after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-full after:h-0.5 after:bg-gold after:rounded-full; }
            .stat-pill { @apply bg-gold/5 border border-gold/20 rounded-2xl px-6 py-4 flex flex-col items-center justify-center min-w-[120px]; }
            .contract-card { @apply bg-white/[0.02] border border-white/5 rounded-[40px] overflow-hidden hover:border-gold/25 transition-all hover:shadow-2xl hover:shadow-black/50; }
            .badge-status { @apply px-4 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-widest border; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="fixed top-0 left-0 right-0 z-50 h-24 bg-dark/80 backdrop-blur-xl border-b border-white/5 px-8 md:px-16 flex items-center justify-between">
    <a href="${pageContext.request.contextPath}/" class="text-2xl font-serif font-bold text-white tracking-tight">
        Azure <span class="text-gold">Resort</span>
    </a>
    
    <div class="hidden lg:flex items-center gap-12">
        <a href="${pageContext.request.contextPath}/rooms" class="nav-link">Phòng & Room</a>
        <a href="${pageContext.request.contextPath}/booking" class="nav-link">Đặt Phòng</a>
        <a href="${pageContext.request.contextPath}/contracts" class="nav-link active">Hợp Đồng</a>
        <a href="${pageContext.request.contextPath}/account.jsp" class="nav-link">Tài Khoản</a>
        <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
            <a href="${pageContext.request.contextPath}/dashboard/admin" class="nav-link text-gold font-bold border border-gold/20 px-4 py-1.5 rounded-full hover:bg-gold hover:text-dark transition-all">Bảng điều khiền</a>
        </c:if>
    </div>

    <div class="flex items-center gap-6">
        <div class="text-right hidden sm:block">
            <p class="text-[10px] text-white/30 uppercase tracking-widest font-bold">Thành viên</p>
            <p class="text-sm font-medium text-gold">${account}</p>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="px-6 py-2.5 rounded-full border border-gold/30 text-gold text-xs font-bold hover:bg-gold hover:text-dark transition-all">Đăng xuất</a>
    </div>
</nav>

<%-- ── Thống kê ── --%>
<c:set var="total" value="0"/>
<c:set var="cntActive" value="0"/>
<c:set var="cntCompleted" value="0"/>
<c:forEach var="c" items="${contracts}">
    <c:set var="total" value="${total + 1}"/>
    <c:choose>
        <c:when test="${c.status == 'ACTIVE'}"><c:set var="cntActive" value="${cntActive + 1}"/></c:when>
        <c:when test="${c.status == 'COMPLETED'}"><c:set var="cntCompleted" value="${cntCompleted + 1}"/></c:when>
    </c:choose>
</c:forEach>

<!-- HERO SECTION -->
<section class="pt-48 pb-20 px-8 md:px-16 bg-gradient-to-b from-navy/30 to-transparent border-b border-white/5">
    <div class="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-end gap-12">
        <div class="space-y-4 animate-reveal">
            <div class="flex items-center gap-3 text-[10px] text-white/30 uppercase tracking-[0.3em] font-bold">
                <a href="${pageContext.request.contextPath}/" class="hover:text-gold transition-colors">Azure</a>
                <span>/</span>
                <span class="text-gold">Hợp đồng pháp lý</span>
            </div>
            <h1 class="text-5xl md:text-7xl font-serif font-bold text-white leading-tight">Hợp Đồng <br><span class="text-gold italic font-light">Của Tôi</span></h1>
            <p class="text-white/40 max-w-md font-light leading-relaxed">Theo dõi, quản lý và thanh toán các hợp đồng lưu trú của bạn một cách minh bạch và an toàn.</p>
        </div>

        <div class="flex gap-4 animate-reveal" style="animation-delay: 200ms">
            <div class="stat-pill">
                <span class="text-3xl font-serif font-bold text-gold">${total}</span>
                <span class="text-[9px] text-white/30 uppercase tracking-widest font-bold mt-1">Tổng số</span>
            </div>
            <div class="stat-pill border-emerald-500/20 bg-emerald-500/5">
                <span class="text-3xl font-serif font-bold text-emerald-500">${cntActive}</span>
                <span class="text-[9px] text-white/30 uppercase tracking-widest font-bold mt-1">Hiệu lực</span>
            </div>
            <div class="stat-pill border-white/10 bg-white/5">
                <span class="text-3xl font-serif font-bold text-white/60">${cntCompleted}</span>
                <span class="text-[9px] text-white/30 uppercase tracking-widest font-bold mt-1">Đã trả</span>
            </div>
        </div>
    </div>
</section>

<!-- CONTENT -->
<main class="py-20 px-8 md:px-16 max-w-7xl mx-auto space-y-12">
    <c:choose>
        <c:when test="${not empty contractError}">
            <div class="p-8 bg-red-500/10 border border-red-500/20 rounded-[40px] text-center space-y-4 animate-reveal">
                <div class="text-4xl">⚠️</div>
                <h3 class="text-xl font-bold text-white">Không thể kết nối dữ liệu</h3>
                <p class="text-red-400/60 font-mono text-xs">${contractError}</p>
            </div>
        </c:when>
        <c:when test="${empty contracts}">
            <div class="py-32 text-center space-y-8 animate-reveal">
                <div class="text-8xl opacity-10">🏜️</div>
                <div class="space-y-2">
                    <h3 class="text-2xl font-serif font-bold text-white">Chưa có hợp đồng nào</h3>
                    <p class="text-white/30 font-light">Bạn cần hoàn tất đặt phòng để hệ thống khởi tạo hợp đồng.</p>
                </div>
                <a href="${pageContext.request.contextPath}/rooms.jsp" class="inline-block px-10 py-5 bg-gold text-dark text-[10px] font-bold uppercase tracking-[0.3em] rounded-full hover:bg-gold-light transition-all shadow-2xl shadow-gold/20">Khám phá ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Filters -->
            <div class="flex flex-wrap items-center justify-between gap-6 animate-reveal" style="animation-delay: 300ms">
                <div class="flex gap-2">
                    <button class="px-6 py-2.5 rounded-full text-[10px] font-bold uppercase tracking-widest border border-gold bg-gold text-dark transition-all" onclick="filterBy('ALL', this)">Tất cả</button>
                    <button class="px-6 py-2.5 rounded-full text-[10px] font-bold uppercase tracking-widest border border-white/10 text-white/40 hover:text-white transition-all" onclick="filterBy('ACTIVE', this)">Đang Hiệu Lực</button>
                    <button class="px-6 py-2.5 rounded-full text-[10px] font-bold uppercase tracking-widest border border-white/10 text-white/40 hover:text-white transition-all" onclick="filterBy('COMPLETED', this)">Hoàn Thành</button>
                </div>
                <p class="text-[10px] text-white/20 uppercase tracking-widest font-bold" id="resultCount">Hiển thị <strong>${total}</strong> hợp đồng</p>
            </div>

            <!-- List -->
            <div class="grid grid-cols-1 gap-10 animate-reveal" id="contractsList" style="animation-delay: 400ms">
                <c:forEach var="ct" items="${contracts}" varStatus="loop">
                    <c:set var="statusCls" value="${ct.status == 'ACTIVE' ? 'emerald' : ct.status == 'COMPLETED' ? 'gold' : ct.status == 'CANCELLED' ? 'red' : 'blue'}"/>
                    <c:set var="statusText" value="${ct.status == 'ACTIVE' ? 'Đang Hiệu Lực' : ct.status == 'COMPLETED' ? 'Đã Hoàn Thành' : ct.status == 'CANCELLED' ? 'Đã Hủy' : 'Chờ Duyệt'}"/>
                    
                    <c:set var="pct" value="0"/>
                    <c:if test="${ct.totalPayment > 0}"><c:set var="pct" value="${ct.paidAmount * 100 / ct.totalPayment}"/></c:if>

                    <div class="contract-card group" data-status="${ct.status}">
                        <div class="h-1.5 w-full bg-gradient-to-r ${ct.status == 'ACTIVE' ? 'from-emerald-500 to-teal-500' : ct.status == 'COMPLETED' ? 'from-gold to-gold-light' : 'from-azure to-blue-500'}"></div>
                        
                        <div class="p-8 md:p-12 space-y-12">
                            <div class="flex flex-col md:flex-row justify-between items-start gap-8">
                                <div class="flex gap-6 items-center">
                                    <div class="w-16 h-16 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center text-3xl group-hover:scale-110 transition-transform">📄</div>
                                    <div class="space-y-1">
                                        <h3 class="text-2xl font-serif font-bold text-white tracking-wide">${ct.contractId}</h3>
                                        <p class="text-[10px] text-white/30 uppercase tracking-widest font-bold">Booking #${ct.bookingId.bookingId} · Phòng: <span class="text-gold font-mono tracking-normal">${ct.bookingId.facilityId.serviceName}</span></p>
                                    </div>
                                </div>
                                <span class="badge-status ${ct.status == 'ACTIVE' ? 'border-emerald-500/20 text-emerald-500 bg-emerald-500/5' : ct.status == 'COMPLETED' ? 'border-gold/20 text-gold bg-gold/5' : 'border-white/10 text-white/30'}">
                                    ${statusText}
                                </span>
                            </div>

                            <div class="grid grid-cols-2 lg:grid-cols-4 gap-8">
                                <div class="space-y-1.5">
                                    <p class="text-[9px] text-white/20 uppercase tracking-[0.2em] font-bold">Ngày ký kết</p>
                                    <p class="text-sm font-medium text-white/80"><fmt:formatDate value="${ct.signedDate}" pattern="dd / MM / yyyy"/></p>
                                </div>
                                <div class="space-y-1.5">
                                    <p class="text-[9px] text-white/20 uppercase tracking-[0.2em] font-bold">Thời gian ở</p>
                                    <p class="text-sm font-medium text-white/80"><fmt:formatDate value="${ct.bookingId.startDate}" pattern="dd/MM"/> <span class="mx-2 text-white/10">→</span> <fmt:formatDate value="${ct.bookingId.endDate}" pattern="dd/MM"/></p>
                                </div>
                                <div class="space-y-1.5">
                                    <p class="text-[9px] text-white/20 uppercase tracking-[0.2em] font-bold">Đặt cọc</p>
                                    <p class="text-sm font-bold text-emerald-500"><fmt:formatNumber value="${ct.deposit}" type="number" groupingUsed="true"/> đ</p>
                                </div>
                                <div class="space-y-1.5">
                                    <p class="text-[9px] text-white/20 uppercase tracking-[0.2em] font-bold">Tổng hợp đồng</p>
                                    <p class="text-xl font-serif font-bold text-gold"><fmt:formatNumber value="${ct.totalPayment}" type="number" groupingUsed="true"/> đ</p>
                                </div>
                            </div>

                            <div class="space-y-4">
                                <div class="flex justify-between items-end">
                                    <div class="space-y-1">
                                        <p class="text-[10px] text-white/20 uppercase tracking-widest font-bold">Tiến độ thanh toán</p>
                                        <p class="text-sm font-bold text-white">Đã trả: <span class="text-emerald-500"><fmt:formatNumber value="${ct.paidAmount}" type="number" groupingUsed="true"/> đ</span></p>
                                    </div>
                                    <span class="text-lg font-serif font-bold text-gold"><fmt:formatNumber value="${pct}" maxFractionDigits="1"/>%</span>
                                </div>
                                <div class="h-2 bg-white/5 rounded-full overflow-hidden relative">
                                    <div class="h-full bg-gradient-to-r from-gold to-gold-light rounded-full transition-all duration-1000 relative" style="width: 0%" data-pct="${pct}">
                                        <div class="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent animate-shimmer"></div>
                                    </div>
                                </div>
                                <c:if test="${ct.totalPayment - ct.paidAmount > 0}">
                                    <p class="text-right text-[10px] text-amber-500/60 uppercase tracking-widest font-bold italic">Còn lại: <fmt:formatNumber value="${ct.totalPayment - ct.paidAmount}" type="number" groupingUsed="true"/> đ</p>
                                </c:if>
                            </div>

                            <c:if test="${not empty ct.notes}">
                                <div class="p-5 bg-white/[0.03] border border-white/5 rounded-2xl flex gap-4">
                                    <span class="text-gold">💬</span>
                                    <p class="text-xs text-white/40 leading-relaxed italic">${ct.notes}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<footer class="py-20 border-t border-white/5 bg-navy/20">
    <div class="max-w-7xl mx-auto px-8 md:px-16 flex flex-col md:flex-row justify-between items-center gap-8">
        <p class="text-xs text-white/20 uppercase tracking-widest font-medium">© 2026 Azure Resort & Spa · Một không gian tuyệt đối</p>
        <div class="flex gap-8">
            <a href="#" class="text-[10px] text-white/20 uppercase tracking-widest font-bold hover:text-gold transition-colors">Chính sách bảo mật</a>
            <a href="#" class="text-[10px] text-white/20 uppercase tracking-widest font-bold hover:text-gold transition-colors">Điều khoản hợp đồng</a>
        </div>
    </div>
</footer>

<script>
    // Animate progress bars
    window.addEventListener('load', () => {
        document.querySelectorAll('[data-pct]').forEach(el => {
            el.style.width = el.getAttribute('data-pct') + '%';
        });
    });

    // Simple Filter
    function filterBy(status, btn) {
        document.querySelectorAll('button').forEach(b => {
             if(b.classList.contains('bg-gold')) {
                 b.classList.remove('bg-gold', 'text-dark', 'border-gold');
                 b.classList.add('border-white/10', 'text-white/40');
             }
        });
        btn.classList.remove('border-white/10', 'text-white/40');
        btn.classList.add('bg-gold', 'text-dark', 'border-gold');

        let visible = 0;
        document.querySelectorAll('.contract-card').forEach(card => {
            if (status === 'ALL' || card.getAttribute('data-status') === status) {
                card.classList.remove('hidden');
                visible++;
            } else {
                card.classList.add('hidden');
            }
        });
        document.getElementById('resultCount').innerHTML = 'Hiển thị <strong>' + visible + '</strong> hợp đồng';
    }
</script>

</body>
</html>
