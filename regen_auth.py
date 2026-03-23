import codecs

login_jsp = """<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { gold: '#c9a84c', dark: '#0a0a0f' } } }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; background: #0a0a0f; color: #e8e8e8; }
        .form-input { 
            width: 100%; background: rgba(255,255,255,0.04); border: 1.5px solid rgba(255,255,255,0.08); 
            border-radius: 12px; padding: 14px 18px 14px 44px; color: #fff; text-sm; outline: none; transition: all 0.25s; 
        }
        .form-input:focus { border-color: #c9a84c; background: rgba(255,255,255,0.08); box-shadow: 0 0 0 4px rgba(201,168,76,0.1); }
        .form-input::placeholder { color: rgba(255,255,255,0.2); }
        .input-icon { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: rgba(255,255,255,0.3); font-size: 16px; pointer-events: none; transition: 0.25s; }
        .relative:focus-within .input-icon { color: #c9a84c; }
        .btn-submit { background: linear-gradient(135deg, #c9a84c, #e8cc82); color: #0a0a0f; font-weight: 700; letter-spacing: 1px; transition: all 0.3s; box-shadow: 0 4px 15px rgba(201,168,76,0.2); }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(201,168,76,0.4); }
        .page-fade { animation: fade 0.8s cubic-bezier(0.4, 0, 0.2, 1); }
        @keyframes fade { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="page-fade min-h-screen grid grid-cols-1 lg:grid-cols-2">

    <!-- Left: Image Panel -->
    <div class="hidden lg:flex flex-col justify-end p-12 lg:p-16 relative bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1920&q=80');">
        <div class="absolute inset-0 bg-gradient-to-t from-dark via-dark/40 to-transparent"></div>
        <div class="relative z-10 w-full max-w-lg">
            <div class="text-gold tracking-[4px] text-lg mb-2">★★★★★</div>
            <a href="${pageContext.request.contextPath}/" class="block font-serif text-5xl lg:text-6xl font-bold text-white mb-2 leading-tight">Azure<br><span class="text-gold">Resort</span> & Spa</a>
            <div class="text-white/60 tracking-[3px] uppercase text-sm font-light mt-4">Luxury · Nature · Serenity</div>
            
            <div class="mt-12 space-y-4">
                <div class="flex items-center gap-4 text-white/70 text-sm bg-white/5 p-3 rounded-2xl backdrop-blur-sm border border-white/5 w-fit">
                    <span class="text-gold">✨</span> Phục vụ tận tâm, tiêu chuẩn 5 sao
                </div>
            </div>
        </div>
    </div>

    <!-- Right: Form Panel -->
    <div class="flex items-center justify-center p-8 lg:p-16">
        <div class="w-full max-w-[420px]">
            <a href="${pageContext.request.contextPath}/" class="lg:hidden block font-serif text-3xl font-bold text-white mb-8">Azure <span class="text-gold">Resort</span></a>
            
            <h2 class="font-serif text-3xl text-white font-bold mb-1">Chào mừng trở lại</h2>
            <div class="w-12 h-0.5 bg-gradient-to-r from-gold to-yellow-200 rounded-full mb-3"></div>
            <p class="text-sm text-white/40 mb-10 leading-relaxed">Đăng nhập để tiếp tục hành trình nghỉ dưỡng của bạn.</p>

            <c:if test="${not empty error}">
                <div class="bg-red-500/10 border border-red-500/20 text-red-400 p-3 rounded-xl text-sm mb-6 flex items-center gap-3">
                    <span>⚠️</span> ${error}
                </div>
            </c:if>
            <c:if test="${not empty param.registered}">
                <div class="bg-gold/10 border border-gold/20 text-gold p-3 rounded-xl text-sm mb-6 flex items-center gap-3">
                    <span>✅</span> Đăng ký thành công! Vui lòng đăng nhập.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST" class="space-y-5">
                <div>
                    <label class="block text-[11px] font-bold tracking-widest uppercase text-white/50 mb-2 ml-1">Tên tài khoản</label>
                    <div class="relative">
                        <span class="input-icon">👤</span>
                        <input type="text" name="username" class="form-input" placeholder="Nhập tên tài khoản" required>
                    </div>
                </div>

                <div>
                    <label class="block text-[11px] font-bold tracking-widest uppercase text-white/50 mb-2 ml-1">Mật khẩu</label>
                    <div class="relative">
                        <span class="input-icon">🔑</span>
                        <input type="password" name="password" class="form-input" placeholder="Nhập mật khẩu" required>
                    </div>
                </div>

                <div class="flex items-center justify-between pt-2">
                    <label class="flex items-center gap-2 cursor-pointer">
                        <input type="checkbox" name="remember" class="w-4 h-4 accent-gold bg-white/5 border-white/10 rounded">
                        <span class="text-[13px] text-white/50">Ghi nhớ đăng nhập</span>
                    </label>
                    <a href="#" class="text-[13px] text-gold hover:text-yellow-200 transition-colors">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn-submit w-full py-3.5 rounded-xl uppercase mt-4">Đăng Nhập</button>
            </form>

            <div class="flex items-center gap-4 my-8 opacity-50">
                <div class="flex-1 h-px bg-white/10"></div>
                <div class="text-[11px] text-white/50 uppercase tracking-widest">Hoặc</div>
                <div class="flex-1 h-px bg-white/10"></div>
            </div>

            <p class="text-center text-[13px] text-white/40">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="text-gold font-bold hover:text-yellow-200 ml-1">Đăng ký ngay</a>
            </p>
        </div>
    </div>
</body>
</html>
"""

register_jsp = """<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Tài Khoản — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { gold: '#c9a84c', dark: '#0a0a0f' } } }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; background: #0a0a0f; color: #e8e8e8; }
        .form-input { 
            width: 100%; background: rgba(255,255,255,0.04); border: 1.5px solid rgba(255,255,255,0.08); 
            border-radius: 12px; padding: 13px 14px 13px 40px; color: #fff; font-size: 13.5px; outline: none; transition: all 0.25s; 
            appearance: none;
        }
        .form-input:focus { border-color: #c9a84c; background: rgba(255,255,255,0.08); box-shadow: 0 0 0 4px rgba(201,168,76,0.1); }
        .form-input::placeholder { color: rgba(255,255,255,0.2); }
        select.form-input option { background: #0a0a0f; color: #fff; }
        .input-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: rgba(255,255,255,0.3); font-size: 15px; pointer-events: none; transition: 0.25s; }
        .relative:focus-within .input-icon { color: #c9a84c; }
        .btn-submit { background: linear-gradient(135deg, #c9a84c, #e8cc82); color: #0a0a0f; font-weight: 700; letter-spacing: 1px; transition: all 0.3s; box-shadow: 0 4px 15px rgba(201,168,76,0.2); }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(201,168,76,0.4); }
        .page-fade { animation: fade 0.8s cubic-bezier(0.4, 0, 0.2, 1); }
        @keyframes fade { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        
        /* Custom scrollbar for form panel */
        .scroll-panel::-webkit-scrollbar { width: 6px; }
        .scroll-panel::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }
    </style>
</head>
<body class="page-fade min-h-screen grid grid-cols-1 lg:grid-cols-2 overflow-hidden">

    <!-- Left: Image Panel -->
    <div class="hidden lg:flex flex-col justify-center p-12 lg:p-16 relative bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1920&q=80');">
        <div class="absolute inset-0 bg-gradient-to-t from-dark/90 via-dark/50 to-dark/20"></div>
        <div class="relative z-10 w-full max-w-lg mt-20">
            <div class="text-gold tracking-[4px] text-lg mb-4">★★★★★</div>
            <a href="${pageContext.request.contextPath}/" class="block font-serif text-5xl lg:text-6xl font-bold text-white mb-3 leading-tight drop-shadow-lg">Azure<br><span class="text-gold">Resort</span> & Spa</a>
            <div class="text-white/60 tracking-[3px] uppercase text-sm font-light mt-5">Luxury · Nature · Serenity</div>
            
            <div class="mt-14 space-y-5">
                <div class="flex items-center gap-4 text-white/70 text-sm">
                    <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold flex-shrink-0">✓</div>
                    Đặt phòng nhanh chóng, quy trình thanh toán bảo mật.
                </div>
                <div class="flex items-center gap-4 text-white/70 text-sm">
                    <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold flex-shrink-0">✓</div>
                    Nhận ưu đãi độc quyền 15-30% cho khách hàng mới.
                </div>
                <div class="flex items-center gap-4 text-white/70 text-sm">
                    <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold flex-shrink-0">✓</div>
                    Tích lũy điểm thưởng đổi lấy đêm nghỉ miễn phí.
                </div>
                <div class="flex items-center gap-4 text-white/70 text-sm">
                    <div class="w-10 h-10 rounded-xl bg-gold/10 border border-gold/20 flex items-center justify-center text-gold flex-shrink-0">✓</div>
                    Hỗ trợ khách hàng chuyên nghiệp 24/7.
                </div>
            </div>
        </div>
    </div>

    <!-- Right: Form Panel -->
    <div class="flex justify-center p-6 lg:p-12 h-screen overflow-y-auto scroll-panel bg-dark">
        <div class="w-full max-w-[500px] my-auto py-8">
            <h2 class="font-serif text-3xl text-white font-bold mb-1">Tạo Tài Khoản</h2>
            <div class="w-12 h-0.5 bg-gradient-to-r from-gold to-yellow-200 rounded-full mb-3"></div>
            <p class="text-[13px] text-white/40 mb-8 leading-relaxed">Đăng ký miễn phí & bắt đầu hành trình nghỉ dưỡng đẳng cấp</p>

            <c:if test="${not empty error}">
                <div class="bg-red-500/10 border border-red-500/20 text-red-400 p-3 rounded-xl text-sm mb-6 flex items-start gap-3">
                    <span class="mt-0.5">⚠️</span> <div>${error}</div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST" class="space-y-4">
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-[10px] font-bold tracking-widest uppercase text-white/50 mb-1.5 ml-1">Họ và tên <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <span class="input-icon">👤</span>
                            <input type="text" name="fullName" class="form-input" placeholder="Nguyễn Văn A" value="${param.fullName}" required>
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold tracking-widest uppercase text-white/50 mb-1.5 ml-1">Tên tài khoản <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <span class="input-icon">@</span>
                            <input type="text" name="username" class="form-input" placeholder="nguyenvana" value="${param.username}" required>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-[10px] font-bold tracking-widest uppercase text-white/50 mb-1.5 ml-1">Ngày sinh <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <span class="input-icon">📅</span>
                            <input type="date" name="dateOfBirth" class="form-input" value="${param.dateOfBirth}" required>
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold tracking-widest uppercase text-white/50 mb-1.5 ml-1">Giới tính <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <span class="input-icon">⚧</span>
                            <select name="gender" class="form-input" required>
                                <option value="" disabled selected>Chọn giới tính</option>
                                <option value="Male" ${param.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${param.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                <option value="Other" ${param.gender == 'Other' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-[10px] font-bold tracking-widest uppercase text-white/50 mb-1.5 ml-1">Email <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <span class="input-icon">✉️</span>
                            <input type="email" name="email" class="form-input" placeholder="example@gmail.com" value="${param.email}" required>
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold tracking-widest uppercase text-white/50 mb-1.5 ml-1">Số điện thoại</label>
                        <div class="relative">
                            <span class="input-icon">📞</span>
                            <input type="tel" name="phone" class="form-input" placeholder="09xx xxx xxx" value="${param.phone}">
                        </div>
                    </div>
                </div>

                <div>
                    <label class="block text-[10px] font-bold tracking-widest uppercase text-white/50 mb-1.5 ml-1">Mật khẩu <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <span class="input-icon">🔒</span>
                        <input type="password" name="password" class="form-input" placeholder="Tối thiểu 6 ký tự" required minlength="6">
                    </div>
                </div>

                <div>
                    <label class="block text-[10px] font-bold tracking-widest uppercase text-white/50 mb-1.5 ml-1">Xác nhận mật khẩu <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <span class="input-icon">🔒</span>
                        <input type="password" name="confPass" class="form-input" placeholder="Nhập lại mật khẩu" required minlength="6">
                    </div>
                </div>

                <div class="pt-2">
                    <button type="submit" class="btn-submit w-full py-4 rounded-xl uppercase">Tạo Tài Khoản</button>
                </div>
            </form>

            <div class="flex items-center gap-4 my-6 opacity-30">
                <div class="flex-1 h-px bg-white"></div>
            </div>

            <p class="text-center text-[13px] text-white/40">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-gold font-bold hover:text-yellow-200 ml-1 pb-2">Đăng nhập ngay</a>
            </p>
        </div>
    </div>
</body>
</html>
"""

with codecs.open("src/main/webapp/login.jsp", "w", "utf-8") as f:
    f.write(login_jsp)
    
with codecs.open("src/main/webapp/register.jsp", "w", "utf-8") as f:
    f.write(register_jsp)

print("Restored login and register pages beautifully.")
