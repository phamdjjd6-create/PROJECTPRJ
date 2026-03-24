<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${facility.serviceName} — Azure Resort</title>
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
        }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); overflow-x: hidden; }
        .glass { background: rgba(255,255,255,0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.08); }
        
        /* Navbar */
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 48px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.8); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.1); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-link { color: rgba(255,255,255,0.5); text-decoration: none; font-size: 13px; font-weight: 500; transition: color 0.2s; }
        .nav-link:hover { color: var(--gold); }

        /* Detail Header */
        .detail-header { position: relative; height: 60vh; overflow: hidden; }
        .detail-img { width: 100%; height: 100%; object-fit: cover; }
        .detail-overlay { position: absolute; inset: 0; background: linear-gradient(to bottom, transparent, var(--dark)); }
        .detail-title-wrap { position: absolute; bottom: 40px; left: 48px; max-width: 800px; }
        .detail-badge { display: inline-block; background: var(--gold); color: var(--dark); font-size: 10px; font-weight: 700; padding: 4px 12px; border-radius: 50px; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; }
        .detail-name { font-family: 'Playfair Display', serif; font-size: 56px; font-weight: 700; color: #fff; line-height: 1.1; }

        /* Content */
        .content-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 48px; padding: 60px 48px; max-width: 1400px; margin: 0 auto; }
        .section-title { font-family: 'Playfair Display', serif; font-size: 28px; color: #fff; margin-bottom: 24px; position: relative; padding-bottom: 12px; }
        .section-title::after { content: ''; position: absolute; bottom: 0; left: 0; width: 40px; height: 2px; background: var(--gold); }
        
        .amenity-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 16px; margin-bottom: 40px; }
        .amenity-item { display: flex; align-items: center; gap: 12px; background: rgba(255,255,255,0.03); padding: 16px; border-radius: 16px; border: 1px solid rgba(255,255,255,0.05); }
        .amenity-icon { width: 32px; height: 32px; color: var(--gold); flex-shrink: 0; }
        .amenity-text { font-size: 13.5px; color: rgba(255,255,255,0.7); font-weight: 500; }

        .booking-card { position: sticky; top: 100px; padding: 32px; border-radius: 24px; }
        .price-box { margin-bottom: 24px; }
        .price-val { font-family: 'Playfair Display', serif; font-size: 32px; font-weight: 700; color: var(--gold); }
        .price-per { font-size: 14px; color: var(--text-muted); }
        
        .btn-booking { display: block; width: 100%; padding: 16px; background: var(--gold); color: var(--dark); border-radius: 50px; font-weight: 700; text-align: center; text-decoration: none; font-size: 14px; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s; box-shadow: 0 10px 20px rgba(201,168,76,0.25); }
        .btn-booking:hover { transform: translateY(-3px); background: var(--gold-light); box-shadow: 0 15px 30px rgba(201,168,76,0.35); }

        .desc-text { line-height: 1.8; color: rgba(255,255,255,0.6); font-size: 15px; margin-bottom: 40px; white-space: pre-line; }

        @media (max-width: 1024px) {
            .content-grid { grid-template-columns: 1fr; }
            .detail-name { font-size: 40px; }
        }
        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .detail-header { height: 40vh; }
            .detail-title-wrap { left: 20px; bottom: 20px; }
            .detail-name { font-size: 32px; }
            .content-grid { padding: 40px 20px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <a href="${pageContext.request.contextPath}/rooms" class="nav-link">← Quay lại danh sách</a>
</nav>

<header class="detail-header">
    <img src="${facility.imageUrl}" alt="${facility.serviceName}" class="detail-img">
    <div class="detail-overlay"></div>
    <div class="detail-title-wrap">
        <span class="detail-badge">${facility.facilityType}</span>
        <h1 class="detail-name">${facility.serviceName}</h1>
    </div>
</header>

<main class="content-grid">
    <div class="content-main">
        <h2 class="section-title">Tổng quan</h2>
        <div class="flex gap-10 mb-8 pb-8 border-b border-white/5">
            <div>
                <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-1">Diện tích</span>
                <span class="text-xl font-bold text-white">${facility.area} m²</span>
            </div>
            <div>
                <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-1">Sức chứa</span>
                <span class="text-xl font-bold text-white">Tối đa ${facility.maxPeople} khách</span>
            </div>
            <div>
                <span class="block text-[10px] text-white/30 uppercase tracking-widest mb-1">Trạng thái</span>
                <span class="text-xl font-bold ${facility.status == 'Available' ? 'text-emerald-400' : 'text-rose-400'}">
                    ${facility.status == 'Available' ? 'Sẵn sàng' : (facility.status == 'Occupied' ? 'Đã được đặt' : 'Bảo trì')}
                </span>
            </div>
        </div>

        <h2 class="section-title">Tiện nghi đẳng cấp</h2>
        <div class="amenity-grid">
            <div class="amenity-item">
                <div class="amenity-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"></path></svg>
                </div>
                <span class="amenity-text">Miễn phí buffet sáng</span>
            </div>
            <div class="amenity-item">
                <div class="amenity-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"></path></svg>
                </div>
                <span class="amenity-text">Wifi tốc độ cao</span>
            </div>
            <div class="amenity-item">
                <div class="amenity-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <span class="amenity-text">TV 4K + Netflix</span>
            </div>
            <div class="amenity-item">
                <div class="amenity-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                </div>
                <span class="amenity-text">Điều hòa 2 chiều</span>
            </div>
            <div class="amenity-item">
                <div class="amenity-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-7.714 2.143L11 21l-2.286-6.857L1 12l7.714-2.143L11 3z"></path></svg>
                </div>
                <span class="amenity-text">Mini bar miễn phí</span>
            </div>
            <div class="amenity-item">
                <div class="amenity-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                </div>
                <span class="amenity-text">Hỗ trợ 24/7</span>
            </div>
        </div>

        <h2 class="section-title">Mô tả chi tiết</h2>
        <div class="desc-text">
            ${facility.description}
        </div>
    </div>

    <div class="content-sidebar">
        <div class="glass booking-card">
            <div class="price-box">
                <div class="price-val"><fmt:formatNumber value="${facility.cost}" pattern="#,###"/> đ</div>
                <div class="price-per">mỗi đêm, đã bao gồm thuế & phí</div>
            </div>
            
            <div class="space-y-4 mb-24">
                <div class="flex items-center gap-3 text-xs text-white/40">
                    <svg class="w-4 h-4 text-emerald-500" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                    Xác nhận đặt phòng tức thì
                </div>
                <div class="flex items-center gap-3 text-xs text-white/40">
                    <svg class="w-4 h-4 text-emerald-500" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                    Dịch vụ đưa đón sân bay miễn phí
                </div>
            </div>

            <c:choose>
                <c:when test="${facility.status == 'Available'}">
                    <a href="${pageContext.request.contextPath}/booking?id=${facility.facilityId}" class="btn-booking">Đặt phòng ngay</a>
                </c:when>
                <c:otherwise>
                    <div class="bg-white/5 border border-white/10 rounded-2xl p-4 text-center">
                        <span class="text-sm text-white/40">Phòng hiện không khả dụng để đặt trực tuyến</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<footer>
    <div class="footer-logo">Azure <span>Resort</span> &amp; Spa</div>
    <div class="footer-text">© 2026 Azure Resort &amp; Spa. Bản quyền được bảo lưu.</div>
    <div class="footer-text">Địa chỉ: Đà Nẵng, Việt Nam | Hotline: 1800 7777</div>
</footer>

</body>
</html>
