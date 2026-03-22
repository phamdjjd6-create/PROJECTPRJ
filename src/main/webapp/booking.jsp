<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Azure Resort & Spa — Đặt Phòng</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
        .glass-panel { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); }
        .form-input { width: 100%; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 12px 16px; color: white; outline: none; transition: border-color 0.2s; }
        .form-input:focus { border-color: var(--gold); }
        @media (max-width: 1024px) {
            .lg\\:col-span-7 { grid-column: span 12 / span 12 !important; }
            .lg\\:col-span-5 { grid-column: span 12 / span 12 !important; }
        }
        @media (max-width: 768px) {
            nav.fixed { padding: 0 16px !important; }
            nav.fixed ul { display: none !important; }
            .form-input { border-radius: 10px; padding: 10px 14px; }
            .sticky { position: static !important; }
            .lg\\:col-span-7, .lg\\:col-span-5 { grid-column: span 12 / span 12 !important; }
            .lg\\:grid-cols-12 { grid-template-columns: 1fr !important; }
            .fixed.inset-0 .w-full { max-width: 100% !important; margin: 0 !important; border-radius: 16px !important; }
        }
    </style>
    <style type="text/tailwindcss">
        @layer base {
            body { @apply bg-dark text-white font-sans antialiased selection:bg-gold/30; }
        }
        @layer components {
            .nav-link { @apply text-white/60 hover:text-gold transition-colors text-sm font-medium relative py-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-0 after:h-0.5 after:bg-gold after:transition-all hover:after:w-full; }
            .nav-link.active { @apply text-gold after:w-full; }
            .glass-panel { @apply bg-white/5 backdrop-blur-2xl border border-white/10; }
            .form-input { @apply w-full bg-white/5 border border-white/10 rounded-2xl px-6 py-4 text-sm text-white focus:outline-none focus:border-gold/50 transition-all [color-scheme:dark]; }
            .form-label { @apply block text-[10px] text-white/40 uppercase tracking-[0.2em] font-bold mb-2 ml-1; }
            .summary-item { @apply flex justify-between items-center py-3 border-b border-white/5 last:border-0; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav id="navbar" class="fixed top-0 left-0 right-0 z-[1000] px-6 md:px-12 h-20 flex items-center justify-between transition-all duration-500 bg-dark/80 backdrop-blur-md border-b border-gold/10">
    <a href="${pageContext.request.contextPath}/" class="text-2xl font-serif font-bold tracking-tight text-white group">
        Azure <span class="text-gold group-hover:text-gold-light transition-colors">Resort</span>
    </a>
    
    <ul class="hidden md:flex items-center gap-10">
        <li>
            <button onclick="history.back()" class="nav-link flex items-center gap-2 text-white/50 hover:text-gold transition-colors text-sm font-medium">
                ← Quay lại
            </button>
        </li>
        <li><a href="${pageContext.request.contextPath}/" class="nav-link">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="nav-link">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my" class="nav-link">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="nav-link">Tài Khoản</a></li>
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

<main class="max-w-7xl mx-auto px-6 pt-32 pb-24">
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
        
        <!-- Left Column: Form -->
        <div class="lg:col-span-7 space-y-12 animate-reveal">
            <div>
                <span class="block text-gold text-[10px] uppercase tracking-[0.4em] font-bold mb-4">Reservation Inquiry</span>
                <h1 class="text-5xl md:text-6xl font-serif font-bold text-white mb-6">Lên kế hoạch <br><span class="italic text-gold">Kỳ nghỉ mơ ước</span></h1>
                <p class="text-white/40 text-lg leading-relaxed max-w-xl font-light">Mỗi chi tiết nhỏ đều được chúng tôi chăm chút để mang lại sự thoải mái tuyệt đối cho quý khách.</p>
            </div>

            <form action="${pageContext.request.contextPath}/booking" method="POST" class="space-y-8" id="bookingForm">
                <div class="space-y-2">
                    <label for="facilityId" class="form-label">Loại Không Gian Nghỉ Dưỡng</label>
                    <select name="facilityId" id="facilityId" class="form-input appearance-none cursor-pointer" required>
                        <option value="" disabled ${empty param.facility ? 'selected' : ''}>-- Vui lòng chọn loại phòng --</option>
                        <c:forEach var="f" items="${facilities}">
                            <option value="${f.serviceCode}" ${param.facility == f.serviceCode ? 'selected' : ''} data-price="${f.cost}" class="bg-navy py-2">
                                ${f.serviceName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div class="space-y-2">
                        <label for="startDate" class="form-label">Ngày Nhận Phòng</label>
                        <input type="date" name="startDate" id="startDate" class="form-input" required value="${param.checkin}">
                        <p class="text-[10px] text-red-400 mt-2 hidden" id="startDateError">Ngày không hợp lệ</p>
                    </div>
                    <div class="space-y-2">
                        <label for="endDate" class="form-label">Ngày Trả Phòng</label>
                        <input type="date" name="endDate" id="endDate" class="form-input" required value="${param.checkout}">
                        <p class="text-[10px] text-red-400 mt-2 hidden" id="endDateError">Ngày trả phòng phải sau ngày nhận</p>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div class="space-y-2">
                        <label for="adults" class="form-label">Người Lớn (Từ 12T)</label>
                        <input type="number" name="adults" id="adults" class="form-input" required min="1" max="15" value="${not empty param.adults ? param.adults : '1'}">
                    </div>
                    <div class="space-y-2">
                        <label for="children" class="form-label">Trẻ Em (Dưới 12T)</label>
                        <input type="number" name="children" id="children" class="form-input" required min="0" max="15" value="0">
                        <p class="text-[10px] text-red-400 mt-2 hidden" id="guestError"></p>
                    </div>
                </div>

                <div class="space-y-2">
                    <label for="voucherId" class="form-label">Mã Giảm Giá (Nếu có)</label>
                    <div class="relative">
                        <input type="text" name="voucherId" id="voucherId" class="form-input pr-24" placeholder="Ví dụ: WELCOME2026">
                        <button type="button" id="btnApplyVoucher" onclick="applyVoucher()"
                                class="absolute right-2 top-2 bottom-2 px-4 bg-white/10 rounded-xl text-[10px] font-bold text-gold uppercase tracking-widest hover:bg-gold hover:text-dark transition-all">Áp dụng</button>
                    </div>
                    <p id="voucherMsg" class="text-[11px] mt-1 hidden"></p>
                </div>

                <div class="space-y-2">
                    <label for="specialReq" class="form-label">Yêu Cầu Đặc Biệt</label>
                    <textarea name="specialReq" id="specialReq" class="form-input min-h-[120px]" placeholder="VD: Trang trí phòng trăng mật, đón sân bay, dị ứng thực phẩm..."></textarea>
                </div>

                <div class="pt-6">
                    <!-- Deposit Option -->
                    <div id="depositBox" class="mb-6 p-5 rounded-2xl border border-gold/20 bg-gold/5 hidden">
                        <div class="flex items-start gap-4">
                            <input type="checkbox" name="depositNow" id="depositNow" value="1"
                                   class="mt-1 w-4 h-4 accent-[#c9a84c] cursor-pointer flex-shrink-0">
                            <div>
                                <label for="depositNow" class="text-sm font-semibold text-gold cursor-pointer">Đặt cọc 10% ngay</label>
                                <p class="text-[11px] text-white/40 mt-1 leading-relaxed">
                                    Thanh toán trước 10% để xác nhận booking ngay lập tức — không cần chờ admin duyệt.<br>
                                    Số tiền cọc: <strong id="depositAmt" class="text-gold">0 đ</strong>
                                </p>
                            </div>
                        </div>
                    </div>

                    <button type="button" id="btnSubmitBooking" onclick="handleBookingSubmit()"
                            class="w-full py-6 bg-gradient-to-r from-gold to-gold-light text-dark font-bold rounded-2xl uppercase tracking-[0.2em] transition-all hover:scale-[1.02] active:scale-95 shadow-xl shadow-gold/30 flex items-center justify-center gap-3">
                        Gửi yêu cầu đặt phòng ✦
                    </button>
                    <p class="text-center mt-4 text-[10px] text-white/30 uppercase tracking-widest leading-relaxed">
                        Bằng việc xác nhận, quý khách đồng ý với <a href="#" class="underline hover:text-gold transition-colors">Điều khoản & Quy định</a> của chúng tôi.
                    </p>
                </div>
            </form>

            <!-- Payment Modal -->
            <div id="payModal" class="fixed inset-0 z-[9999] flex items-center justify-center p-4" style="display:none!important">
                <div class="absolute inset-0 bg-black/70 backdrop-blur-sm" onclick="closePayModal()"></div>
                <div class="relative bg-[#0d1526] border border-gold/25 rounded-[32px] p-8 w-full max-w-md shadow-2xl">
                    <div class="text-center mb-6">
                        <div class="text-4xl mb-3">💳</div>
                        <h3 class="text-xl font-serif font-bold text-white">Thanh Toán Đặt Cọc</h3>
                        <p class="text-xs text-white/40 mt-1">Chuyển khoản để xác nhận booking ngay</p>
                    </div>

                    <!-- QR placeholder + bank info -->
                    <div class="bg-white rounded-2xl p-4 mb-5 flex items-center justify-center">
                        <div style="width:160px;height:160px;background:#f0f0f0;border-radius:12px;display:flex;align-items:center;justify-content:center;flex-direction:column;gap:6px">
                            <div style="font-size:48px">📱</div>
                            <div style="font-size:10px;color:#666;text-align:center;font-family:monospace" id="qrCode">QR CODE</div>
                        </div>
                    </div>

                    <div class="space-y-3 mb-6">
                        <div class="flex justify-between items-center p-3 bg-white/5 rounded-xl">
                            <span class="text-xs text-white/40">Ngân hàng</span>
                            <span class="text-xs font-bold text-white">VietcomBank</span>
                        </div>
                        <div class="flex justify-between items-center p-3 bg-white/5 rounded-xl">
                            <span class="text-xs text-white/40">Số tài khoản</span>
                            <span class="text-xs font-bold text-white font-mono">1234 5678 9012</span>
                        </div>
                        <div class="flex justify-between items-center p-3 bg-white/5 rounded-xl">
                            <span class="text-xs text-white/40">Chủ tài khoản</span>
                            <span class="text-xs font-bold text-white">AZURE RESORT SPA</span>
                        </div>
                        <div class="flex justify-between items-center p-3 bg-gold/10 border border-gold/20 rounded-xl">
                            <span class="text-xs text-white/40">Số tiền</span>
                            <span class="text-sm font-bold text-gold" id="modalAmt">0 đ</span>
                        </div>
                        <div class="flex justify-between items-center p-3 bg-white/5 rounded-xl">
                            <span class="text-xs text-white/40">Nội dung CK</span>
                            <span class="text-xs font-bold text-white font-mono" id="modalCode">AZ...</span>
                        </div>
                    </div>

                    <div class="flex gap-3">
                        <button onclick="closePayModal()" class="flex-1 py-3 border border-white/10 rounded-xl text-xs text-white/50 hover:text-white transition-colors">Hủy</button>
                        <button onclick="confirmPayment()" class="flex-1 py-3 bg-gradient-to-r from-gold to-gold-light text-dark font-bold rounded-xl text-xs uppercase tracking-widest">
                            Đã chuyển khoản ✓
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Summary Card -->
        <div class="lg:col-span-1"></div> <!-- Spacer -->
        <div class="lg:col-span-4 sticky top-32 animate-reveal" style="animation-delay: 200ms">
            <div class="glass-panel rounded-[40px] p-10 overflow-hidden relative group">
                <!-- Decorative Elements -->
                <div class="absolute -top-24 -right-24 w-48 h-48 bg-gold/10 rounded-full blur-[80px] group-hover:bg-gold/20 transition-all duration-700"></div>
                
                <h3 class="text-2xl font-serif font-bold text-white mb-8">Tóm tắt <span class="text-gold italic">Đặt phòng</span></h3>
                
                <div class="space-y-4" id="pricePreview" style="display:none">
                    <div class="summary-item">
                        <span class="text-white/40 text-xs uppercase tracking-widest">Loại phòng</span>
                        <span class="text-xs font-semibold text-right max-w-[150px] truncate" id="summaryFacilityName">Chưa chọn</span>
                    </div>
                    <div class="summary-item">
                        <span class="text-white/40 text-xs uppercase tracking-widest">Thời gian</span>
                        <span class="text-xs font-semibold" id="summaryNights">0 đêm</span>
                    </div>
                    <div class="summary-item">
                        <span class="text-white/40 text-xs uppercase tracking-widest">Đơn giá</span>
                        <span class="text-xs font-semibold" id="summaryRate">0 đ</span>
                    </div>
                    <div class="summary-item" id="summaryDiscountRow" style="display:none">
                        <span class="text-green-400 text-xs uppercase tracking-widest">Giảm giá</span>
                        <span class="text-xs font-semibold text-green-400" id="summaryDiscount">-0 đ</span>
                    </div>
                    
                    <!-- Total -->
                    <div class="pt-8 mt-4 border-t border-white/10 flex justify-between items-end">
                        <div>
                            <span class="block text-[10px] text-white/30 uppercase tracking-[0.3em] font-bold mb-1">Tổng phí tạm tính</span>
                            <span class="text-3xl font-serif font-bold text-gold" id="summaryTotal">0 đ</span>
                        </div>
                        <div class="text-[10px] text-white/20 italic">VND</div>
                    </div>

                    <div class="mt-10 p-4 bg-white/2 border border-white/5 rounded-2xl">
                        <ul class="space-y-2">
                            <li class="flex items-center gap-2 text-[10px] text-white/40">
                                <span class="text-gold">✓</span> Wifi miễn phí tốc độ cao
                            </li>
                            <li class="flex items-center gap-2 text-[10px] text-white/40">
                                <span class="text-gold">✓</span> Ăn sáng buffet tại nhà hàng Pearl
                            </li>
                            <li class="flex items-center gap-2 text-[10px] text-white/40">
                                <span class="text-gold">✓</span> Sử dụng hồ bơi & gym miễn phí
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Empty State -->
                <div id="summaryEmpty" class="py-20 text-center space-y-4">
                    <div class="text-4xl opacity-20 text-gold">🏖️</div>
                    <p class="text-xs text-white/30 leading-relaxed uppercase tracking-widest">Vui lòng hoàn thiện form để xem báo cáo chi phí chi tiết.</p>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="bg-[#060608] border-t border-white/5 py-12 px-6 md:px-12">
    <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
        <div class="col-span-1 md:col-span-1">
            <h4 class="text-xl font-serif font-bold text-white mb-6">Azure <span class="text-gold">Resort</span></h4>
            <p class="text-white/40 text-sm leading-relaxed">Trải nghiệm sự sang trọng và tinh tế giữa lòng thiên nhiên kỳ thú.</p>
        </div>
        <div>
            <h5 class="text-xs font-bold text-white/60 uppercase tracking-widest mb-6">Thông tin</h5>
            <div class="flex flex-col gap-4 text-xs text-white/30">
                <a href="#" class="hover:text-gold transition-colors">Về chúng tôi</a>
                <a href="#" class="hover:text-gold transition-colors">Điều khoản & Chính sách</a>
                <a href="#" class="hover:text-gold transition-colors">Câu hỏi thường gặp</a>
            </div>
        </div>
        <div>
            <h5 class="text-xs font-bold text-white/60 uppercase tracking-widest mb-6">Hỗ trợ</h5>
            <div class="flex flex-col gap-4 text-xs text-white/30">
                <a href="#" class="hover:text-gold transition-colors">Trung tâm trợ giúp</a>
                <a href="#" class="hover:text-gold transition-colors">Liên hệ 24/7</a>
                <a href="#" class="hover:text-gold transition-colors">Hướng dẫn đặt phòng</a>
            </div>
        </div>
        <div>
            <h5 class="text-xs font-bold text-white/60 uppercase tracking-widest mb-6">Liên hệ</h5>
            <div class="flex flex-col gap-4 text-xs text-white/30">
                <span>📍 Đà Nẵng, Việt Nam</span>
                <span>📞 1800 7777</span>
                <span>✉️ info@azure-resort.vn</span>
            </div>
        </div>
    </div>
    <div class="max-w-7xl mx-auto pt-8 border-t border-white/5 flex flex-col md:flex-row justify-between items-center gap-4 text-[10px] text-white/20 uppercase tracking-widest">
        <span>© 2026 Azure Resort & Spa. All rights reserved.</span>
        <span>Crafted by Azure Experience Team</span>
    </div>
</footer>

<script>
(function() {
    const today = new Date().toISOString().split('T')[0];
    const startEl  = document.getElementById('startDate');
    const endEl    = document.getElementById('endDate');
    const endErr   = document.getElementById('endDateError');
    const selEl    = document.getElementById('facilityId');
    const fmtVND   = n => new Intl.NumberFormat('vi-VN').format(n) + ' đ';

    startEl.min = today;
    endEl.min   = today;

    // ── Price + deposit summary ───────────────────────────────────────────────
    function updateSummary() {
        const opt    = selEl.options[selEl.selectedIndex];
        const start  = startEl.value;
        const end    = endEl.value;
        const preview = document.getElementById('pricePreview');
        const empty   = document.getElementById('summaryEmpty');

        if (!opt || !opt.value || !start || !end) {
            preview.style.display = 'none';
            empty.style.display   = 'block';
            document.getElementById('depositBox').classList.add('hidden');
            return;
        }

        const price  = parseFloat(opt.getAttribute('data-price'));
        const nights = Math.round((new Date(end) - new Date(start)) / 86400000);

        if (!price || nights <= 0) {
            preview.style.display = 'none';
            empty.style.display   = 'block';
            document.getElementById('depositBox').classList.add('hidden');
            return;
        }

        const total = price * nights;
        document.getElementById('summaryFacilityName').textContent = opt.text.trim();
        document.getElementById('summaryRate').textContent         = fmtVND(price);
        document.getElementById('summaryNights').textContent       = nights + ' đêm';
        document.getElementById('summaryTotal').textContent        = fmtVND(total);
        preview.style.display = 'block';
        empty.style.display   = 'none';

        // Deposit box
        document.getElementById('depositAmt').textContent = fmtVND(Math.round(total * 0.1));
        document.getElementById('depositBox').classList.remove('hidden');
    }

    // ── Guest validation ──────────────────────────────────────────────────────
    function validateGuests() {
        const id    = selEl.value;
        if (!id) return true;
        const limit = id.startsWith('VL') ? 15 : id.startsWith('HS') ? 5 : 3;
        const total = (parseInt(document.getElementById('adults').value) || 0)
                    + (parseInt(document.getElementById('children').value) || 0);
        const err   = document.getElementById('guestError');
        if (total > limit) {
            err.textContent     = `Giới hạn số người cho loại này là ${limit}.`;
            err.style.display   = 'block';
            return false;
        }
        err.style.display = 'none';
        return true;
    }

    // ── Events ────────────────────────────────────────────────────────────────
    startEl.addEventListener('change', function() {
        if (this.value) {
            const d = new Date(this.value);
            d.setDate(d.getDate() + 1);
            const min = d.toISOString().split('T')[0];
            endEl.min = min;
            if (endEl.value && endEl.value < min) endEl.value = min;
        }
        updateSummary();
    });
    endEl.addEventListener('change', updateSummary);
    selEl.addEventListener('change', () => { updateSummary(); validateGuests(); });
    document.getElementById('adults').addEventListener('input', validateGuests);
    document.getElementById('children').addEventListener('input', validateGuests);

    updateSummary();

    // ── Voucher AJAX ──────────────────────────────────────────────────────────
    let _appliedVoucher = null; // { type, value }

    window.applyVoucher = function() {
        const code = document.getElementById('voucherId').value.trim();
        const msgEl = document.getElementById('voucherMsg');
        const nights = parseInt(document.getElementById('summaryNights').textContent) || 0;
        if (!code) {
            msgEl.textContent = 'Vui lòng nhập mã giảm giá.';
            msgEl.className = 'text-[11px] mt-1 text-red-400';
            msgEl.classList.remove('hidden');
            return;
        }
        const btn = document.getElementById('btnApplyVoucher');
        btn.textContent = '...';
        btn.disabled = true;
        fetch('${pageContext.request.contextPath}/booking?action=validateVoucher&code=' + encodeURIComponent(code) + '&nights=' + nights)
            .then(r => r.json())
            .then(data => {
                btn.textContent = 'Áp dụng';
                btn.disabled = false;
                msgEl.textContent = data.msg;
                msgEl.classList.remove('hidden');
                if (data.valid) {
                    _appliedVoucher = { type: data.type, value: data.value };
                    msgEl.className = 'text-[11px] mt-1 text-green-400';
                } else {
                    _appliedVoucher = null;
                    msgEl.className = 'text-[11px] mt-1 text-red-400';
                }
                updateSummary();
            })
            .catch(() => {
                btn.textContent = 'Áp dụng';
                btn.disabled = false;
                msgEl.textContent = 'Lỗi kết nối. Thử lại sau.';
                msgEl.className = 'text-[11px] mt-1 text-red-400';
                msgEl.classList.remove('hidden');
            });
    };

    // Reset voucher when facility/dates change
    const _origUpdateSummary = updateSummary;
    document.getElementById('voucherId').addEventListener('input', function() {
        _appliedVoucher = null;
        document.getElementById('summaryDiscountRow').style.display = 'none';
        document.getElementById('voucherMsg').classList.add('hidden');
    });

    // ── Override updateSummary to include discount ────────────────────────────
    function updateSummaryWithDiscount() {
        const opt    = selEl.options[selEl.selectedIndex];
        const start  = startEl.value;
        const end    = endEl.value;
        const preview = document.getElementById('pricePreview');
        const empty   = document.getElementById('summaryEmpty');

        if (!opt || !opt.value || !start || !end) {
            preview.style.display = 'none';
            empty.style.display   = 'block';
            document.getElementById('depositBox').classList.add('hidden');
            return;
        }

        const price  = parseFloat(opt.getAttribute('data-price'));
        const nights = Math.round((new Date(end) - new Date(start)) / 86400000);

        if (!price || nights <= 0) {
            preview.style.display = 'none';
            empty.style.display   = 'block';
            document.getElementById('depositBox').classList.add('hidden');
            return;
        }

        const base = price * nights;
        let total = base;
        const discRow = document.getElementById('summaryDiscountRow');

        if (_appliedVoucher) {
            let discAmt = 0;
            if (_appliedVoucher.type === 'PERCENT') {
                discAmt = Math.round(base * _appliedVoucher.value / 100);
            } else {
                discAmt = Math.min(parseFloat(_appliedVoucher.value), base);
            }
            total = Math.max(0, base - discAmt);
            document.getElementById('summaryDiscount').textContent = '-' + fmtVND(discAmt);
            discRow.style.display = '';
        } else {
            discRow.style.display = 'none';
        }

        document.getElementById('summaryFacilityName').textContent = opt.text.trim();
        document.getElementById('summaryRate').textContent         = fmtVND(price);
        document.getElementById('summaryNights').textContent       = nights + ' đêm';
        document.getElementById('summaryTotal').textContent        = fmtVND(total);
        preview.style.display = 'block';
        empty.style.display   = 'none';

        document.getElementById('depositAmt').textContent = fmtVND(Math.round(total * 0.1));
        document.getElementById('depositBox').classList.remove('hidden');
    }

    // Replace updateSummary with the discount-aware version
    updateSummary = updateSummaryWithDiscount;
    updateSummary();

    // ── Submit handler ────────────────────────────────────────────────────────
    let _payCode = '';

    window.handleBookingSubmit = function() {
        // Basic HTML5 validation
        if (!document.getElementById('bookingForm').reportValidity()) return;

        const start = new Date(startEl.value);
        const end   = new Date(endEl.value);
        if (end <= start) { endErr.classList.remove('hidden'); return; }
        endErr.classList.add('hidden');
        if (!validateGuests()) return;

        if (document.getElementById('depositNow').checked) {
            const total   = parseFloat(document.getElementById('summaryTotal').textContent.replace(/[^0-9]/g, '')) || 0;
            const deposit = Math.round(total * 0.1);
            _payCode = 'AZ' + Date.now().toString().slice(-8);
            document.getElementById('modalAmt').textContent  = fmtVND(deposit);
            document.getElementById('modalCode').textContent = _payCode;
            document.getElementById('qrCode').textContent    = _payCode;
            document.getElementById('payModal').style.removeProperty('display');
        } else {
            document.getElementById('bookingForm').submit();
        }
    };

    window.closePayModal = function() {
        document.getElementById('payModal').style.setProperty('display', 'none', 'important');
    };

    window.confirmPayment = function() {
        closePayModal();
        document.getElementById('bookingForm').submit();
    };
})();
</script>

<script src="assets/js/drum-datepicker.js"></script>
<script>
    // Drum Date Picker Integration
    (function() {
        const today = new Date();
        const startPick = document.getElementById('startDate');
        const endPick = document.getElementById('endDate');

        if (typeof DrumDatePicker !== 'undefined') {
            const startPicker = new DrumDatePicker(startPick, {
                minDate: today,
                onChange: (val) => {
                    const next = new Date(val);
                    next.setDate(next.getDate() + 1);
                    if(typeof endPicker !== 'undefined') {
                        endPicker.selected = { d: next.getDate(), m: next.getMonth()+1, y: next.getFullYear() };
                        endPicker._renderDrums();
                        endPicker._confirm();
                    }
                }
            });

            const endPicker = new DrumDatePicker(endPick, {
                minDate: today
            });
        }
    })();
</script>

</body>
</html>
