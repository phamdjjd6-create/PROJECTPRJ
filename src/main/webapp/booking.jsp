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
        <li><a href="${pageContext.request.contextPath}/" class="nav-link">Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms" class="nav-link">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking" class="nav-link active">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp" class="nav-link">Tài Khoản</a></li>
        <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
            <li><a href="${pageContext.request.contextPath}/dashboard/admin" class="nav-link text-gold font-bold border border-gold/20 px-4 py-1.5 rounded-full hover:bg-gold hover:text-dark transition-all">Bảng điều khiển</a></li>
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
                        <button type="button" class="absolute right-2 top-2 bottom-2 px-4 bg-white/10 rounded-xl text-[10px] font-bold text-gold uppercase tracking-widest hover:bg-gold hover:text-dark transition-all">Áp dụng</button>
                    </div>
                </div>

                <div class="space-y-2">
                    <label for="specialReq" class="form-label">Yêu Cầu Đặc Biệt</label>
                    <textarea name="specialReq" id="specialReq" class="form-input min-h-[120px]" placeholder="VD: Trang trí phòng trăng mật, đón sân bay, dị ứng thực phẩm..."></textarea>
                </div>

                <div class="pt-6">
                    <button type="submit" class="w-full py-6 bg-gradient-to-r from-gold to-gold-light text-dark font-bold rounded-2xl uppercase tracking-[0.2em] transition-all hover:scale-[1.02] active:scale-95 shadow-xl shadow-gold/30 flex items-center justify-center gap-3">
                        Gửi yêu cầu đặt phòng ✦
                    </button>
                    <p class="text-center mt-4 text-[10px] text-white/30 uppercase tracking-widest leading-relaxed">
                        Bằng việc xác nhận, quý khách đồng ý với <a href="#" class="underline hover:text-gold transition-colors">Điều khoản & Quy định</a> của chúng tôi.
                    </p>
                </div>
            </form>
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
    // Logic initialization
    (function() {
        const todayStrVal = new Date().toISOString().split('T')[0];
        document.getElementById('startDate').min = todayStrVal;
        document.getElementById('endDate').min = todayStrVal;

        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        const endDateError = document.getElementById('endDateError');
        const bookingForm = document.getElementById('bookingForm');
        const facilitySelect = document.getElementById('facilityId');

        function updatePrice() {
            const selectedOption = facilitySelect.options[facilitySelect.selectedIndex];
            const startVal = startDateInput.value;
            const endVal = endDateInput.value;
            const preview = document.getElementById('pricePreview');
            const empty = document.getElementById('summaryEmpty');

            if (!selectedOption || !selectedOption.value || !startVal || !endVal) {
                preview.style.display = 'none';
                empty.style.display = 'block';
                return;
            }

            const price = parseFloat(selectedOption.getAttribute('data-price'));
            const nights = Math.round((new Date(endVal) - new Date(startVal)) / 86400000);

            if (!price || nights <= 0) {
                preview.style.display = 'none';
                empty.style.display = 'block';
                return;
            }

            const fmt = n => new Intl.NumberFormat('vi-VN').format(n) + ' đ';
            document.getElementById('summaryFacilityName').textContent = selectedOption.text.trim();
            document.getElementById('summaryRate').textContent = fmt(price);
            document.getElementById('summaryNights').textContent = nights + ' đêm';
            document.getElementById('summaryTotal').textContent = fmt(price * nights);
            
            preview.style.display = 'block';
            empty.style.display = 'none';
        }

        function validateGuests() {
            const facilityId = facilitySelect.value;
            if(!facilityId) return true;
            const limit = facilityId.startsWith('VL') ? 15 : facilityId.startsWith('HS') ? 5 : 3;
            const adults = parseInt(document.getElementById('adults').value) || 0;
            const children = parseInt(document.getElementById('children').value) || 0;
            const total = adults + children;
            const guestError = document.getElementById('guestError');

            if (limit && total > limit) {
                guestError.textContent = `Giới hạn số người cho loại này là ${limit}.`;
                guestError.style.display = 'block';
                return false;
            }
            guestError.style.display = 'none';
            return true;
        }

        startDateInput.addEventListener('change', function() {
            if(this.value) {
                const startDate = new Date(this.value);
                startDate.setDate(startDate.getDate() + 1);
                const minEndDateStr = startDate.toISOString().split('T')[0];
                endDateInput.min = minEndDateStr;
                if(endDateInput.value && endDateInput.value < minEndDateStr) {
                    endDateInput.value = minEndDateStr;
                }
            }
            updatePrice();
        });

        endDateInput.addEventListener('change', updatePrice);
        facilitySelect.addEventListener('change', () => {
            updatePrice();
            validateGuests();
        });
        document.getElementById('adults').addEventListener('input', validateGuests);
        document.getElementById('children').addEventListener('input', validateGuests);

        bookingForm.addEventListener('submit', function(e) {
            let valid = true;
            const start = new Date(startDateInput.value);
            const end = new Date(endDateInput.value);
            
            if (end <= start) {
                endDateError.classList.remove('hidden');
                valid = false;
            } else {
                endDateError.classList.add('hidden');
            }

            if (!validateGuests()) valid = false;
            if (!valid) e.preventDefault();
        });

        // Initial run
        updatePrice();
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
