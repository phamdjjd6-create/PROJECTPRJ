<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Phòng — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        gold: '#c9a84c',
                        dark: '#0a0a0f',
                        navy: '#0d1526',
                    }
                }
            }
        }
    </script>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --gold: #c9a84c; --gold-light: #e8cc82;
            --dark: #0a0a0f; --navy: #0d1526;
            --text: #e8e8e8; --text-muted: rgba(255,255,255,0.45);
            --card-bg: rgba(255,255,255,0.03);
            --border: rgba(255,255,255,0.08);
        }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); min-height: 100vh; }
        .glass { background: rgba(255,255,255,0.03); backdrop-filter: blur(20px); border: 1px solid var(--border); }
        
        /* Navbar */
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 48px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.92); border-bottom: 1px solid rgba(201,168,76,0.1); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-link { color: rgba(255,255,255,0.5); text-decoration: none; font-size: 13px; font-weight: 500; transition: color 0.2s; }
        .nav-link:hover { color: var(--gold); }

        /* Stepper */
        .stepper { display: flex; align-items: center; gap: 8px; margin-bottom: 32px; }
        .step { width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; border: 1.5px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.3); }
        .step.active { background: var(--gold); border-color: var(--gold); color: var(--dark); }
        .step.done { border-color: var(--gold); color: var(--gold); }
        .step-line { flex: 1; height: 1.5px; background: rgba(255,255,255,0.1); }
        .step-line.done { background: var(--gold); }

        /* Form Controls */
        label { display: block; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--gold); margin-bottom: 8px; }
        .input-group { position: relative; }
        .form-input { width: 100%; background: rgba(255,255,255,0.03); border: 1.5px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 12px 16px; color: #fff; font-size: 14px; outline: none; transition: all 0.25s; }
        .form-input:focus { border-color: var(--gold); background: rgba(255,255,255,0.06); box-shadow: 0 0 0 4px rgba(201,168,76,0.1); }
        .form-input:disabled { opacity: 0.5; cursor: not-allowed; }

        /* Summary Card */
        .summary-card { position: sticky; top: 100px; }
        .summary-row { display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 12px; }
        .summary-total { border-top: 1px solid rgba(255,255,255,0.1); padding-top: 16px; margin-top: 16px; font-family: 'Playfair Display', serif; font-size: 24px; font-weight: 700; color: var(--gold); }

        /* Action Buttons */
        .btn-action { width: 100%; padding: 14px; border-radius: 14px; font-weight: 700; font-size: 14px; letter-spacing: 1px; text-transform: uppercase; transition: all 0.3s; cursor: pointer; text-align: center; }
        .btn-confirm { background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; }
        .btn-confirm:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(201,168,76,0.3); }
        .btn-back { background: transparent; border: 1.5px solid rgba(255,255,255,0.15); color: #fff; margin-top: 12px; display: inline-block; text-decoration: none; }
        .btn-back:hover { border-color: #fff; }
        
        .author-title { color: var(--gold); font-size: 11px; margin-top: 4px; text-transform: uppercase; letter-spacing: 2px; font-weight: 700; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .fade-in { animation: fadeIn 0.4s ease-out; }
    </style>
</head>
<body class="pt-24 pb-20 px-6">

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <a href="${pageContext.request.contextPath}/rooms" class="nav-link">← Quay lại danh sách</a>
    <div class="hidden sm:block text-[11px] text-white/30 uppercase tracking-widest">
        Tiến trình đặt phòng
    </div>
</nav>

<main class="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-10">
    <!-- Left Column: Booking Form -->
    <div class="lg:col-span-2 space-y-8 fade-in">
        <div class="glass rounded-3xl p-8 md:p-10">
            <h1 class="font-serif text-3xl md:text-4xl text-white font-bold mb-8">
                Hoàn tất <em class="text-gold italic">đặt phòng của bạn</em>
            </h1>

            <form id="bookingForm" action="${pageContext.request.contextPath}/booking" method="POST" class="space-y-8">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="facilityId" value="${facility.serviceCode}">
                
                <!-- Room Info (Visual only) -->
                <div class="flex items-center gap-6 p-4 rounded-2xl bg-white/5 border border-white/10 mb-8">
                    <img src="${facility.imageUrl}" alt="${facility.serviceName}" class="w-24 h-24 rounded-xl object-cover">
                    <div>
                        <span class="text-[10px] text-gold font-bold uppercase tracking-widest">${facility.facilityType}</span>
                        <h2 class="text-xl font-bold text-white">${facility.serviceName}</h2>
                        <p class="text-sm text-white/50">${facility.usableArea} m² · Tối đa ${facility.maxPeople} khách</p>
                    </div>
                </div>

                <!-- Stay Details -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-4">
                        <label>Ngày Nhận Phòng</label>
                        <div class="input-group">
                            <input type="date" name="startDate" id="startDate" required class="form-input" 
                                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>
                    </div>
                    <div class="space-y-4">
                        <label>Ngày Trả Phòng</label>
                        <div class="input-group">
                            <input type="date" name="endDate" id="endDate" required class="form-input">
                        </div>
                    </div>
                </div>

                <!-- Guests -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-4">
                        <label>Người lớn</label>
                        <select name="adults" id="adults" class="form-input">
                            <c:forEach var="i" begin="1" end="${facility.maxPeople}">
                                <option value="${i}">${i} người lớn</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="space-y-4">
                        <label>Trẻ em</label>
                        <select name="children" id="children" class="form-input">
                            <c:forEach var="i" begin="0" end="${facility.maxPeople}">
                                <option value="${i}">${i} trẻ em</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Special Requests -->
                <div class="space-y-4">
                    <label>Yêu cầu đặc biệt</label>
                    <textarea name="specialReq" rows="3" class="form-input" placeholder="Bạn có yêu cầu gì thêm không? (VD: giường phụ, trang trí sinh nhật...)"></textarea>
                </div>

                <!-- Voucher Section -->
                <div class="space-y-4">
                    <label>Mã Ưu Đãi (Voucher)</label>
                    <div class="flex gap-3">
                        <input type="text" id="voucherCode" placeholder="Nhập mã ưu đãi..." class="form-input flex-grow">
                        <button type="button" id="applyVoucher" class="px-6 rounded-12 font-bold text-xs uppercase tracking-widest bg-white/10 hover:bg-gold hover:text-dark transition-all border border-white/10">Áp dụng</button>
                    </div>
                    <p id="voucherMsg" class="text-[11px]"></p>
                    <input type="hidden" name="voucherId" id="appliedVoucherId">
                </div>

                <!-- Confirmation Policy -->
                <div class="flex items-start gap-3 pt-4 border-t border-white/5">
                    <input type="checkbox" id="policy" required class="mt-1">
                    <label for="policy" class="normal-case text-[12px] text-white/60 font-medium">
                        Tôi đồng ý với <a href="#" class="text-gold hover:underline">Điều khoản & Chính sách</a> của Azure Resort & Spa.
                    </label>
                </div>

                <div class="pt-2">
                    <button type="submit" class="btn-action btn-confirm">Xác nhận đặt phòng</button>
                    <a href="${pageContext.request.contextPath}/rooms" class="btn-action btn-back">Thay đổi lựa chọn</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Right Column: Summary -->
    <div class="fade-in" style="animation-delay: 0.1s">
        <div class="glass rounded-3xl p-8 summary-card">
            <h3 class="font-serif text-2xl text-white font-bold mb-6">Tóm tắt</h3>
            
            <div class="space-y-4 pb-6 border-b border-white/10">
                <div class="summary-row">
                    <span class="text-white/50">Đơn giá</span>
                    <span class="font-bold text-white"><fmt:formatNumber value="${facility.cost}" pattern="#,###"/> đ / đêm</span>
                </div>
                <div class="summary-row">
                    <span class="text-white/50">Thời gian</span>
                    <span class="font-bold text-white" id="summaryNights">0 đêm</span>
                </div>
                <div class="summary-row hidden" id="voucherRow">
                    <span class="text-white/50">Giám giá</span>
                    <span class="font-bold text-emerald-400" id="voucherDiscount">- 0 đ</span>
                </div>
            </div>

            <div class="summary-total">
                <div class="text-[10px] text-white/30 uppercase tracking-[2px] mb-2 font-sans font-bold">Tổng cộng tạm tính</div>
                <div id="totalAmount"><fmt:formatNumber value="0" pattern="#,###"/> đ</div>
            </div>

            <div class="mt-8 space-y-4">
                <div class="flex items-center gap-3 text-xs text-white/40">
                    <svg class="w-4 h-4 text-emerald-500" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                    Xác nhận tức thì
                </div>
                <div class="flex items-center gap-3 text-xs text-white/40">
                    <svg class="w-4 h-4 text-emerald-500" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                    Giá đã bao gồm thuế & phí
                </div>
                <div class="flex items-center gap-3 text-xs text-white/40">
                    <svg class="w-4 h-4 text-gold" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"></path></svg>
                    Hỗ trợ 24/7
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Payment Modal (Simulation) -->
<div id="paymentModal" class="fixed inset-0 z-[2000] hidden flex items-center justify-center p-6">
    <div class="absolute inset-0 bg-black/80 backdrop-blur-md"></div>
    <div class="relative glass max-w-md w-full rounded-3xl p-10 text-center scale-95 opacity-0 transition-all duration-300" id="modalContent">
        <div class="w-20 h-20 bg-gold/20 rounded-full flex items-center justify-center mx-auto mb-6">
            <svg class="w-10 h-10 text-gold animate-pulse" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04l-7.081 3.04a11.955 11.955 0 01-8.618-3.04 11.955 11.955 0 01-8.618-3.04z"></path></svg>
        </div>
        <h2 class="font-serif text-3xl text-white font-bold mb-4">Đang xử lý đặt phòng</h2>
        <p class="text-white/60 text-sm mb-8">Vui lòng đợi trong giây lát khi hệ thống thực hiện kết nối dịch vụ...</p>
        <div class="w-full bg-white/5 h-1.5 rounded-full overflow-hidden">
            <div class="bg-gold h-full w-0 transition-all duration-[3000ms] ease-out" id="modalBar"></div>
        </div>
    </div>
</div>

<script>
    const COST = ${not empty facility.cost ? facility.cost : 0};
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const totalDisplay = document.getElementById('totalAmount');
    const nightsDisplay = document.getElementById('summaryNights');
    const voucherInput = document.getElementById('voucherCode');
    const voucherBtn = document.getElementById('applyVoucher');
    const voucherMsg = document.getElementById('voucherMsg');
    const voucherRow = document.getElementById('voucherRow');
    const voucherDiscountDisplay = document.getElementById('voucherDiscount');
    const appliedVoucherHidden = document.getElementById('appliedVoucherId');

    let appliedVoucher = null;

    function calculateTotal() {
        const start = new Date(startDateInput.value);
        const end = new Date(endDateInput.value);

        if (startDateInput.value && endDateInput.value && end > start) {
            const diffTime = Math.abs(end - start);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            
            nightsDisplay.textContent = diffDays + ' đêm';
            
            let total = diffDays * COST;
            if (appliedVoucher) {
                const discount = (total * appliedVoucher.discountValue) / 100;
                total -= discount;
                voucherRow.classList.remove('hidden');
                voucherDiscountDisplay.textContent = '- ' + discount.toLocaleString('vi-VN') + ' đ';
            } else {
                voucherRow.classList.add('hidden');
            }

            totalDisplay.textContent = total.toLocaleString('vi-VN') + ' đ';
        } else {
            nightsDisplay.textContent = '0 đêm';
            totalDisplay.textContent = '0 đ';
        }
    }

    startDateInput.addEventListener('change', () => {
        endDateInput.min = startDateInput.value;
        if (endDateInput.value && endDateInput.value <= startDateInput.value) {
            endDateInput.value = '';
        }
        calculateTotal();
    });

    endDateInput.addEventListener('change', calculateTotal);

    voucherBtn.addEventListener('click', async () => {
        const code = voucherInput.value.trim();
        if (!code) {
            alert('Vui lòng nhập mã voucher');
            return;
        }

        voucherBtn.disabled = true;
        voucherBtn.textContent = '...';
        
        try {
            const resp = await fetch('${pageContext.request.contextPath}/booking?action=checkVoucher&code=' + encodeURIComponent(code));
            const data = await resp.json();
            
            if (data.success) {
                appliedVoucher = data.voucher;
                appliedVoucherHidden.value = appliedVoucher.voucherId;
                voucherMsg.textContent = 'Áp dụng thành công: ' + appliedVoucher.voucherName + ' (-' + appliedVoucher.discountValue + '%)';
                voucherMsg.className = 'text-[11px] text-emerald-400 font-medium';
                calculateTotal();
            } else {
                appliedVoucher = null;
                appliedVoucherHidden.value = '';
                voucherMsg.textContent = data.message || 'Mã không hợp lệ hoặc đã hết hạn';
                voucherMsg.className = 'text-[11px] text-rose-400 font-medium';
                calculateTotal();
            }
        } catch (e) {
            console.error(e);
            alert('Lỗi kết nối máy chủ');
        } finally {
            voucherBtn.disabled = false;
            voucherBtn.textContent = 'Áp dụng';
        }
    });

    document.getElementById('bookingForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const modal = document.getElementById('paymentModal');
        const content = document.getElementById('modalContent');
        const bar = document.getElementById('modalBar');
        
        modal.classList.remove('hidden');
        setTimeout(() => {
            content.classList.remove('scale-95', 'opacity-0');
            bar.style.width = '100%';
        }, 10);
        
        setTimeout(() => {
            this.submit();
        }, 3200);
    });
</script>

</body>
</html>
