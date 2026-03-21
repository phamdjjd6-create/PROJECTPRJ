<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Azure Resort & Spa — Đặt Phòng</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/drum-datepicker.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --gold: #c9a84c;
            --gold-light: #e8cc82;
            --dark: #0a0a0f;
            --navy: #0d1526;
            --text: #e8e8e8;
            --text-muted: rgba(255,255,255,0.5);
            --bg-glass: rgba(255, 255, 255, 0.05);
            --border-glass: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark);
            color: var(--text);
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* ════════════════════════════════
           NAVBAR (Copy from index.jsp)
        ════════════════════════════════ */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
            padding: 0 60px; height: 72px;
            display: flex; align-items: center; justify-content: space-between;
            background: rgba(10,10,15,0.9);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(201,168,76,0.15);
        }
        .nav-brand {
            font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700;
            color: #fff; text-decoration: none;
        }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 36px; list-style: none; }
        .nav-links a {
            color: rgba(255,255,255,0.75); text-decoration: none;
            font-size: 13.5px; font-weight: 500; letter-spacing: 0.5px; transition: color 0.2s; position: relative;
        }
        .nav-links a::after {
            content: ''; position: absolute; bottom: -4px; left: 0; right: 100%;
            height: 1px; background: var(--gold); transition: right 0.25s;
        }
        .nav-links a:hover { color: #fff; }
        .nav-links a:hover::after { right: 0; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-greeting { color: rgba(255,255,255,0.5); font-size: 13px; }
        .nav-greeting strong { color: var(--gold); }
        .btn-nav-logout, .btn-nav-login {
            padding: 8px 20px; border-radius: 50px; font-size: 13px;
            font-family: 'Inter', sans-serif; cursor: pointer; transition: all 0.25s; text-decoration: none;
        }
        .btn-nav-logout { border: 1px solid rgba(201,168,76,0.4); background: transparent; color: var(--gold); }
        .btn-nav-logout:hover { background: var(--gold); color: var(--dark); }
        .btn-nav-login { background: var(--gold); color: var(--dark); font-weight: 600; border: 1px solid var(--gold); }
        .btn-nav-login:hover { background: var(--gold-light); box-shadow: 0 4px 12px rgba(201,168,76,0.3); }

        /* ════════════════════════════════
           BOOKING SECTION
        ════════════════════════════════ */
        .booking-page-wrap {
            flex: 1;
            padding: 120px 20px 60px;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(to bottom, var(--dark), var(--navy));
        }

        .booking-container {
            max-width: 800px;
            width: 100%;
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            backdrop-filter: blur(10px);
            animation: fadeUp 0.8s ease-out forwards;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .booking-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .booking-label {
            display: inline-block; color: var(--gold); font-size: 12px;
            letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 12px;
        }

        .booking-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 36px;
            color: #fff;
            margin-bottom: 15px;
        }

        .booking-header h1 em {
            color: var(--gold);
            font-style: italic;
        }

        .booking-header p {
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.6;
        }

        .booking-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            font-size: 11px;
            color: var(--text-muted);
            letter-spacing: 1.5px;
            text-transform: uppercase;
            font-weight: 600;
        }

        .form-control {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid var(--border-glass);
            border-radius: 12px;
            padding: 14px 18px;
            color: #fff;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            outline: none;
            transition: all 0.3s ease;
            width: 100%;
        }

        .form-control:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 2px rgba(201, 168, 76, 0.2);
            background: rgba(0, 0, 0, 0.4);
        }

        input[type="date"] {
            color-scheme: dark;
        }        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.3);
        }

        select.form-control option {
            background: var(--navy);
            color: #fff;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        .price-preview {
            grid-column: 1 / -1;
            background: rgba(201,168,76,0.06);
            border: 1px solid rgba(201,168,76,0.2);
            border-radius: 14px;
            padding: 20px 24px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
            color: rgba(255,255,255,0.7);
        }
        .price-row.price-total {
            border-top: 1px solid rgba(201,168,76,0.2);
            padding-top: 10px;
            margin-top: 2px;
            font-size: 16px;
            font-weight: 700;
            color: #fff;
        }
        .price-row.price-total span:last-child {
            color: var(--gold);
            font-family: 'Playfair Display', serif;
            font-size: 20px;
        }
        .price-label { color: rgba(255,255,255,0.5); font-size: 13px; }

        .submit-btn {
            grid-column: 1 / -1;
            padding: 18px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: var(--dark);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            box-shadow: 0 8px 20px rgba(201,168,76,0.25);
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(201,168,76,0.35);
        }

        .error-message {
            color: #ff6b6b;
            font-size: 12px;
            margin-top: 4px;
            display: none;
        }

        /* ════════════════════════════════
           FOOTER (Copy from index.jsp)
        ════════════════════════════════ */
        footer { background: #060608; border-top: 1px solid rgba(201,168,76,0.1); padding: 60px; }
        .footer-inner { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 48px; }
        .footer-brand .logo { font-family: 'Playfair Display', serif; font-size: 26px; color: #fff; margin-bottom: 14px; }
        .footer-brand .logo span { color: var(--gold); }
        .footer-brand p { color: var(--text-muted); font-size: 13.5px; line-height: 1.7; }
        .footer-col h4 { color: #fff; font-size: 13px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 18px; }
        .footer-col a { display: block; color: var(--text-muted); text-decoration: none; font-size: 13.5px; margin-bottom: 10px; transition: color 0.2s; }
        .footer-col a:hover { color: var(--gold); }
        .footer-bottom { max-width: 1200px; margin: 40px auto 0; padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.06); display: flex; justify-content: space-between; align-items: center; color: rgba(255,255,255,0.25); font-size: 12.5px; }
        .footer-bottom span { color: var(--gold); }

        @media (max-width: 768px) {
            .navbar { padding: 0 24px; }
            .booking-container { padding: 30px 20px; }
            .booking-form { grid-template-columns: 1fr; }
            .footer-inner { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar" id="navbar">
    <a href="index.jsp" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="index.jsp#rooms">Phòng &amp; Villa</a></li>
        <li><a href="index.jsp#promotions">Khuyến Mãi</a></li>
        <li><a href="booking.jsp">Đặt Phòng</a></li>
        <li><a href="contracts">Hợp Đồng</a></li>
    </ul>
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <span class="nav-greeting">Xin chào, <strong>${sessionScope.account.fullName}</strong></span>
                <a href="logout" class="btn-nav-logout">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="login.jsp" class="btn-nav-login">Đăng nhập</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- BOOKING SECTION -->
<div class="booking-page-wrap">
    <div class="booking-container">
        <div class="booking-header">
            <span class="booking-label">Bắt Đầu Kỳ Nghỉ</span>
            <h1>Đặt <em>Trải Nghiệm</em> Của Bạn</h1>
            <p>Vui lòng điền thông tin chi tiết dưới đây để đặt không gian nghỉ dưỡng lý tưởng tại Azure Resort & Spa.</p>
        </div>

        <form action="booking" method="POST" class="booking-form" id="bookingForm">
            <!-- Hidden Fields (Can be passed from previous page via URL/JS, or filled by user) -->
            
            <div class="form-group full-width">
                <label for="facilityId">Loại Phòng / Villa</label>
                <select name="facilityId" id="facilityId" class="form-control" required>
                    <option value="" disabled ${empty param.facility ? 'selected' : ''}>-- Chọn Phòng / Villa --</option>
                    <option value="VL001" ${param.facility == 'VL001' ? 'selected' : ''}>Presidential Ocean Villa (5★ Diamond) - 15,000,000 đ/đêm</option>
                    <option value="VL002" ${param.facility == 'VL002' ? 'selected' : ''}>Family Garden Villa (4★ Premium) - 6,500,000 đ/đêm</option>
                    <option value="HS001" ${param.facility == 'HS001' ? 'selected' : ''}>Tropical Beach House (5★ Luxury) - 9,500,000 đ/đêm</option>
                    <option value="HS002" ${param.facility == 'HS002' ? 'selected' : ''}>Garden Bungalow House (4★ Comfort) - 4,800,000 đ/đêm</option>
                    <option value="RM001" ${param.facility == 'RM001' ? 'selected' : ''}>Ocean View Suite - 2,500,000 đ/đêm</option>
                    <option value="RM002" ${param.facility == 'RM002' ? 'selected' : ''}>Deluxe Garden Room - 1,200,000 đ/đêm</option>
                    <option value="RM003" ${param.facility == 'RM003' ? 'selected' : ''}>Premium Pool Access Room - 1,800,000 đ/đêm</option>
                </select>
            </div>

            <div class="form-group">
                <label for="startDate">Ngày Nhận Phòng (Check-in)</label>
                <input type="date" name="startDate" id="startDate" class="form-control" required value="${param.checkin}">
                <div class="error-message" id="startDateError">Ngày nhận phòng không hợp lệ.</div>
            </div>

            <div class="form-group">
                <label for="endDate">Ngày Trả Phòng (Check-out)</label>
                <input type="date" name="endDate" id="endDate" class="form-control" required value="${param.checkout}">
                <div class="error-message" id="endDateError">Ngày trả phòng phải sau ngày nhận phòng.</div>
            </div>

            <div class="form-group">
                <label for="adults">Người Lớn</label>
                <input type="number" name="adults" id="adults" class="form-control" required min="1" max="15" placeholder="VD: 2" value="${not empty param.adults ? param.adults : '1'}">
            </div>

            <div class="form-group">
                <label for="children">Trẻ Em (0 - 12T)</label>
                <input type="number" name="children" id="children" class="form-control" required min="0" max="15" placeholder="VD: 1" value="0">
                <div class="error-message" id="guestError" style="display:none"></div>
                <div style="font-size:11px;color:rgba(255,255,255,0.4);margin-top:4px">
                    Villa: tối đa 15 người &nbsp;·&nbsp; House: tối đa 5 người &nbsp;·&nbsp; Phòng: tối đa 3 người
                </div>
            </div>

            <div class="form-group full-width">
                <label for="voucherId">Mã Khuyến Mãi (Nếu có)</label>
                <input type="text" name="voucherId" id="voucherId" class="form-control" placeholder="Nhập mã voucher...">
            </div>

            <div class="form-group full-width">
                <label for="specialReq">Yêu Cầu Đặc Biệt</label>
                <textarea name="specialReq" id="specialReq" class="form-control" placeholder="Ví dụ: Đón sân bay, ăn chay, chuẩn bị giường cho em bé..."></textarea>
            </div>

            <!-- Price Preview -->
            <div class="price-preview full-width" id="pricePreview" style="display:none">
                <div class="price-row">
                    <span class="price-label">Đơn giá</span>
                    <span id="pricePerNight">—</span>
                </div>
                <div class="price-row">
                    <span class="price-label">Số đêm</span>
                    <span id="priceNights">—</span>
                </div>
                <div class="price-row price-total">
                    <span class="price-label">Tổng tiền</span>
                    <span id="priceTotal">—</span>
                </div>
            </div>

            <button type="submit" class="submit-btn" id="submitBtn">Xác Nhận Đặt Phòng</button>
        </form>
    </div>
</div>

<!-- FOOTER -->
<footer>
    <div class="footer-inner">
        <div class="footer-brand">
            <div class="logo">Azure <span>Resort</span> &amp; Spa</div>
            <p>Thiên đường nghỉ dưỡng 5 sao với vẻ đẹp thiên nhiên kỳ thú và dịch vụ đẳng cấp thế giới.</p>
        </div>
        <div class="footer-col">
            <h4>Khám Phá</h4>
            <a href="index.jsp#rooms">Phòng &amp; Villa</a>
            <a href="index.jsp#promotions">Khuyến Mãi</a>
            <a href="booking.jsp">Đặt Phòng</a>
        </div>
        <div class="footer-col">
            <h4>Tài Khoản</h4>
            <a href="booking?view=my">Booking Của Tôi</a>
            <a href="contracts">Hợp Đồng</a>
            <a href="profile">Hồ Sơ</a>
        </div>
        <div class="footer-col">
            <h4>Liên Hệ</h4>
            <a href="#">📍 Đà Nẵng, Việt Nam</a>
            <a href="#">📞 1800 7777</a>
            <a href="#">✉️ info@azure-resort.vn</a>
        </div>
    </div>
    <div class="footer-bottom">
        <span>© 2026 <span>Azure Resort &amp; Spa</span>. All rights reserved.</span>
        <span>Made with ❤️ in Vietnam</span>
    </div>
</footer>

<script>
    // Set min date to today
    const todayStr = new Date().toISOString().split('T')[0];
    document.getElementById('startDate').min = todayStr;
    document.getElementById('endDate').min = todayStr;

    // Validation Logic
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');    const endDateError = document.getElementById('endDateError');
    const bookingForm = document.getElementById('bookingForm');

    // Make sure End Date is always greater than or equal to Start Date + 1 day
    startDateInput.addEventListener('change', function() {
        if(this.value) {
            const startDate = new Date(this.value);
            startDate.setDate(startDate.getDate() + 1);
            
            // Format to YYYY-MM-DD
            const minEndDate = startDate.toISOString().split('T')[0];
            endDateInput.min = minEndDate;
            
            if(endDateInput.value && endDateInput.value < minEndDate) {
                endDateInput.value = minEndDate;
            }
        }
    });

    bookingForm.addEventListener('submit', function(e) {
        let valid = true;
        
        const start = new Date(startDateInput.value);
        const end = new Date(endDateInput.value);
        
        if (end <= start) {
            endDateError.style.display = 'block';
            valid = false;
        } else {
            endDateError.style.display = 'none';
        }

        if (!validateGuests()) valid = false;

        if (!valid) {
            e.preventDefault();
        }
    });

    // ── Guest limit by facility type ──
    const facilityLimits = {
        'VL001': 15, 'VL002': 15,
        'HS001': 5,  'HS002': 5,
        'RM001': 3,  'RM002': 3, 'RM003': 3
    };

    function updateGuestLimit() {
        const facilityId = document.getElementById('facilityId').value;
        const limit = facilityId.startsWith('VL') ? 15 : facilityId.startsWith('HS') ? 5 : facilityId.startsWith('RM') ? 3 : 15;
        document.getElementById('adults').max = limit;
        document.getElementById('children').max = limit;
        validateGuests();
    }

    function validateGuests() {
        const facilityId = document.getElementById('facilityId').value;
        const limit = facilityId.startsWith('VL') ? 15 : facilityId.startsWith('HS') ? 5 : facilityId.startsWith('RM') ? 3 : null;
        const adults = parseInt(document.getElementById('adults').value) || 0;
        const children = parseInt(document.getElementById('children').value) || 0;
        const total = adults + children;
        const guestError = document.getElementById('guestError');
        if (limit && total > limit) {
            guestError.textContent = `Giới hạn số người thuê.`;
            guestError.style.display = 'block';
            return false;
        }
        guestError.style.display = 'none';
        return true;
    }

    document.getElementById('facilityId').addEventListener('change', updateGuestLimit);
    document.getElementById('adults').addEventListener('input', validateGuests);
    document.getElementById('children').addEventListener('input', validateGuests);
    const facilityPrices = {
        'VL001': 15000000, 'VL002': 6500000,
        'HS001': 9500000,  'HS002': 4800000,
        'RM001': 2500000,  'RM002': 1200000, 'RM003': 1800000
    };

    function updatePrice() {
        const facilityId = document.getElementById('facilityId').value;
        const startVal   = document.getElementById('startDate').value;
        const endVal     = document.getElementById('endDate').value;
        const preview    = document.getElementById('pricePreview');

        if (!facilityId || !startVal || !endVal) { preview.style.display = 'none'; return; }

        const price  = facilityPrices[facilityId];
        const nights = Math.round((new Date(endVal) - new Date(startVal)) / 86400000);
        if (!price || nights <= 0) { preview.style.display = 'none'; return; }

        const fmt = n => new Intl.NumberFormat('vi-VN').format(n) + ' đ';
        document.getElementById('pricePerNight').textContent = fmt(price) + '/đêm';
        document.getElementById('priceNights').textContent   = nights + ' đêm';
        document.getElementById('priceTotal').textContent    = fmt(price * nights);
        preview.style.display = 'flex';
    }

    document.getElementById('facilityId').addEventListener('change', updatePrice);
    document.getElementById('startDate').addEventListener('change', updatePrice);
    document.getElementById('endDate').addEventListener('change', updatePrice);

</script>
<script src="assets/js/drum-datepicker.js"></script>
<script>
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];

    const startPicker = new DrumDatePicker(document.getElementById('startDate'), {
        minDate: today,
        onChange: (val) => {
            const next = new Date(val);
            next.setDate(next.getDate() + 1);
            endPicker.selected = { d: next.getDate(), m: next.getMonth()+1, y: next.getFullYear() };
            endPicker._renderDrums();
            endPicker._confirm();
            updatePrice();
        }
    });

    const endPicker = new DrumDatePicker(document.getElementById('endDate'), {
        minDate: today,
        onChange: () => updatePrice()
    });
</script>

</body>
</html>
