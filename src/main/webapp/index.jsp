<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Azure Resort &amp; Spa — Trang Chủ</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&family=Dancing+Script:wght@400..700&subset=vietnamese&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        gold: '#c9a84c',
                        dark: '#0a0a0f',
                    },
                    fontFamily: {
                        script: ['"Dancing Script"', 'cursive'],
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
            scroll-behavior: smooth;
        }
        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: var(--dark); }
        ::-webkit-scrollbar-thumb { background: linear-gradient(var(--dark), var(--gold), var(--dark)); border-radius: 10px; border: 2px solid var(--dark); }
        
        body { font-family: 'Inter', sans-serif; color: var(--text); overflow-x: hidden; background: linear-gradient(135deg, rgba(13,21,38,0.8), rgba(10,10,15,0.85)), url('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1920&q=40') center/cover fixed; }
        .glass { background: rgba(255,255,255,0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.08); }

        /* Scroll Progress Bar */
        #scroll-progress { position: fixed; top: 0; left: 0; width: 0%; height: 3px; background: linear-gradient(to right, var(--gold), var(--gold-light)); z-index: 10001; transition: width 0.1s ease-out; box-shadow: 0 0 10px rgba(201,168,76,0.5); }
        
        /* Hero Video */
        .hero { position: relative; height: 100vh; display: flex; align-items: center; justify-content: center; overflow: hidden; }
        .hero-video { position: absolute; top: 50%; left: 50%; min-width: 100%; min-height: 100%; width: auto; height: auto; z-index: -100; transform: translate(-50%, -50%); object-fit: cover; }
        .hero-overlay { position: absolute; inset: 0; background: linear-gradient(135deg, rgba(10,10,15,0.8), rgba(10,10,15,0.4)); z-index: -50; }
        
        /* Parallax Elements */
        .parallax-leaf { position: absolute; pointer-events: none; opacity: 0.15; z-index: 1; filter: drop-shadow(0 0 20px rgba(201,168,76,0.3)); }
        
        /* Skeleton Shimmer */
        .skeleton { position: relative; overflow: hidden; background: rgba(255,255,255,0.05); }
        .skeleton::after { content: ""; position: absolute; top: 0; right: 0; bottom: 0; left: 0; transform: translateX(-100%); background: linear-gradient(90deg, transparent, rgba(255,255,255,0.08), transparent); animation: shimmer 2s infinite; }
        @keyframes shimmer { 100% { transform: translateX(100%); } }

        /* Testimonials Carousel */
        .testimonials { background: rgba(13,21,38,0.3); position: relative; padding: 100px 0; overflow: hidden; backdrop-filter: blur(10px); }
        .testimonial-container { max-width: 1000px; margin: 0 auto; position: relative; overflow: hidden; padding: 0 20px; }
        .testimonial-track { display: flex; transition: transform 0.8s cubic-bezier(0.645, 0.045, 0.355, 1.000); }
        .testimonial-item { min-width: 100%; width: 100%; flex-shrink: 0; padding: 0 40px; text-align: center; box-sizing: border-box; }
        .quote-icon { font-size: 64px; color: var(--gold); opacity: 0.15; margin-bottom: 20px; font-family: 'Playfair Display', serif; }
        .testimonial-text { font-family: 'Playfair Display', serif; font-size: 24px; color: #fff; line-height: 1.6; font-style: italic; margin-bottom: 40px; }
        .testimonial-author { display: flex; align-items: center; justify-content: center; gap: 20px; }
        .author-img { width: 70px; height: 70px; border-radius: 50%; object-fit: cover; border: 2px solid var(--gold); box-shadow: 0 10px 20px rgba(0,0,0,0.5); }
        .author-name { font-weight: 700; color: #fff; font-size: 18px; }
        .author-title { color: var(--gold); font-size: 12px; margin-top: 4px; text-transform: uppercase; letter-spacing: 2px; }
        .stars { color: var(--gold); font-size: 16px; margin-bottom: 15px; letter-spacing: 4px; }
        .carousel-dots { display: flex; justify-content: center; gap: 10px; margin-top: 40px; }
        .dot { width: 8px; height: 8px; border-radius: 50%; border: 1px solid var(--gold); background: transparent; transition: all 0.3s ease; cursor: pointer; }
        .dot.active { background: var(--gold); transform: scale(1.3); }

        /* Instagram Grid */
        .instagram-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 12px; padding: 0 60px; margin-bottom: 80px; }
        .insta-item { position: relative; aspect-ratio: 1; overflow: hidden; border-radius: 12px; cursor: pointer; }
        .insta-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .insta-overlay { position: absolute; inset: 0; background: rgba(201,168,76,0.4); opacity: 0; transition: opacity 0.3s ease; display: flex; align-items: center; justify-content: center; }
        .insta-item:hover .insta-overlay { opacity: 1; }
        .insta-item:hover .insta-img { transform: scale(1.1); }
        

        @keyframes float { 0% { transform: translateY(0px); } 50% { transform: translateY(-15px); } 100% { transform: translateY(0px); } }
        .animate-float { animation: float 6s ease-in-out infinite; }
        .reveal { opacity: 0; transform: translateY(30px); transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1); }
        .reveal.active { opacity: 1; transform: translateY(0); }
        .delay-100 { transition-delay: 100ms; }
        .delay-200 { transition-delay: 200ms; }
        .delay-300 { transition-delay: 300ms; }

        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 60px; height: 80px; display: flex; align-items: center; justify-content: space-between; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); }
        .navbar.scrolled { height: 64px; background: rgba(10,10,15,0.8); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.2); box-shadow: 0 4px 30px rgba(0,0,0,0.5), 0 0 20px rgba(201,168,76,0.05); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 24px; font-weight: 700; color: #fff; text-decoration: none; transition: transform 0.3s; }
        .navbar.scrolled .nav-brand { transform: scale(0.9); }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 36px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.75); text-decoration: none; font-size: 13.5px; font-weight: 500; letter-spacing: 0.5px; transition: color 0.2s; position: relative; }
        .nav-links a::after { content: ''; position: absolute; bottom: -4px; left: 0; right: 100%; height: 1px; background: var(--gold); transition: right 0.25s; }
        .nav-links a:hover { color: #fff; }
        .nav-links a:hover::after { right: 0; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-greeting { color: rgba(255,255,255,0.5); font-size: 13px; }
        .nav-greeting strong { color: var(--gold); }
        .btn-nav-logout { padding: 8px 20px; border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; background: transparent; color: var(--gold); font-size: 13px; cursor: pointer; transition: all 0.25s; text-decoration: none; }
        .btn-nav-logout:hover { background: var(--gold); color: var(--dark); }
        .btn-nav-login { padding: 8px 24px; background: var(--gold); color: var(--dark); border: 1px solid var(--gold); border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.25s; }
        .btn-nav-login:hover { background: var(--gold-light); }
        .btn-nav-register { padding: 8px 24px; background: transparent; color: var(--gold); border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.25s; }
        .btn-nav-register:hover { background: var(--gold); color: var(--dark); }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: translateY(0); } }

        .btn-primary { padding: 15px 40px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; border-radius: 50px; font-size: 14px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; cursor: pointer; transition: all 0.3s; box-shadow: 0 8px 28px rgba(201,168,76,0.3); }
        .btn-primary:hover { transform: translateY(-3px); box-shadow: 0 16px 40px rgba(201,168,76,0.4); }
        .btn-outline { padding: 14px 36px; background: transparent; border: 1.5px solid rgba(255,255,255,0.4); color: #fff; border-radius: 50px; font-size: 14px; font-weight: 500; text-decoration: none; transition: all 0.3s; }
        .btn-outline:hover { border-color: var(--gold); color: var(--gold); }

        @keyframes bounce { 0%,100% { transform: translateX(-50%) translateY(0); } 50% { transform: translateX(-50%) translateY(8px); } }

        section { padding: 96px 60px; }
        .section-inner { max-width: 1200px; margin: 0 auto; }
        .section-label { display: inline-block; color: var(--gold); font-size: 11px; letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 12px; }
        .section-title { font-family: 'Playfair Display', serif; font-size: clamp(28px,4vw,44px); color: #fff; line-height: 1.2; margin-bottom: 16px; }
        .section-title em { color: var(--gold); font-style: italic; }
        .section-desc { color: var(--text-muted); font-size: 15px; line-height: 1.8; max-width: 560px; }
        .stats-bar {
            background: linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(201,168,76,0.04) 50%, rgba(0,0,0,0) 100%);
            border-top: 1px solid rgba(201,168,76,0.12);
            border-bottom: 1px solid rgba(201,168,76,0.12);
            padding: 52px 60px;
            position: relative;
            overflow: hidden;
        }
        .stats-bar::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse at 50% 50%, rgba(201,168,76,0.06) 0%, transparent 70%);
            pointer-events: none;
        }
        .stats-inner { max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-around; flex-wrap: wrap; gap: 32px; position: relative; z-index: 1; }
        .stat-item { text-align: center; position: relative; padding: 0 40px; }
        .stat-item:not(:last-child)::after {
            content: '';
            position: absolute;
            right: 0; top: 50%;
            transform: translateY(-50%);
            width: 1px; height: 40px;
            background: linear-gradient(180deg, transparent, rgba(201,168,76,0.25), transparent);
        }
        .stat-num {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            color: var(--gold);
            font-weight: 700;
            line-height: 1;
            letter-spacing: -1px;
            text-shadow: 0 0 40px rgba(201,168,76,0.3);
        }
        .stat-label {
            color: rgba(255,255,255,0.35);
            font-size: 10px;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            margin-top: 10px;
            font-weight: 600;
        }
        .features { background: transparent; position: relative; overflow: hidden; }
        .features::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse at 50% 100%, rgba(201,168,76,0.05) 0%, transparent 65%); pointer-events: none; }
        .features .section-inner { position: relative; z-index: 1; }
        .features-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-top: 52px; }
        .feature-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 20px; padding: 36px 28px; text-align: center; cursor: pointer; transition: all 0.3s; text-decoration: none; display: block; }
        .feature-card:hover { background: rgba(201,168,76,0.06); border-color: rgba(201,168,76,0.25); transform: translateY(-6px); box-shadow: 0 20px 48px rgba(0,0,0,0.3); }
        .feature-card h3 { color: #fff; font-size: 16px; font-weight: 600; margin-bottom: 10px; }
        .feature-card p { color: var(--text-muted); font-size: 13px; line-height: 1.6; }
        .feature-arrow { display: inline-flex; align-items: center; gap: 6px; color: var(--gold); font-size: 12px; font-weight: 600; margin-top: 16px; letter-spacing: 0.5px; }
        .rooms { background: transparent; border-top: 1px solid rgba(255,255,255,0.05); }
        .rooms-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 28px; margin-top: 52px; }
        /* Room Cards Enhancement */
        .room-card { background: var(--glass); border: 1px solid var(--border); border-radius: 28px; overflow: hidden; transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1); position: relative; z-index: 2; }
        .room-card:hover { transform: translateY(-12px); border-color: var(--gold); box-shadow: 0 30px 60px -12px rgba(0,0,0,0.5); }
        .room-img { width: 100%; height: 260px; object-fit: cover; transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1); }
        .room-card:hover .room-img { transform: scale(1.1); }
        .room-img-wrap { overflow: hidden; position: relative; }
        .room-badge { position: absolute; top: 20px; right: 20px; background: rgba(10,10,15,0.6); backdrop-filter: blur(10px); color: var(--gold); padding: 6px 14px; border-radius: 50px; font-size: 11px; font-weight: 700; border: 1px solid var(--gold); }
        .room-body { padding: 24px; }
        .room-type { color: var(--gold); font-size: 11px; letter-spacing: 2px; text-transform: uppercase; font-weight: 600; margin-bottom: 8px; }
        .room-name { font-family: 'Playfair Display', serif; font-size: 22px; color: #fff; margin-bottom: 10px; }
        .room-desc { color: var(--text-muted); font-size: 13.5px; line-height: 1.6; margin-bottom: 18px; }
        .room-amenities { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 20px; }
        .amenity { background: rgba(255,255,255,0.05); border-radius: 50px; padding: 4px 14px; font-size: 12px; color: rgba(255,255,255,0.6); }
        .room-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 18px; border-top: 1px solid rgba(255,255,255,0.06); }
        .room-price .price { font-family: 'Playfair Display', serif; font-size: 26px; color: var(--gold); font-weight: 700; }
        .room-price .per { color: var(--text-muted); font-size: 12px; margin-left: 4px; }
        .btn-book { padding: 10px 24px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border: none; border-radius: 50px; font-size: 13px; font-weight: 700; cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.25s; text-decoration: none; }
        .btn-book:hover { transform: scale(1.05); }
        .btn-detail { padding: 10px 20px; background: transparent; border: 1.5px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7); border-radius: 50px; font-size: 12.5px; font-weight: 500; cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.25s; text-decoration: none; }
        .btn-detail:hover { border-color: var(--gold); color: var(--gold); }
        .room-footer-btns { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        .status-tag { position: absolute; top: 16px; right: 16px; font-size: 10px; font-weight: 700; padding: 4px 12px; border-radius: 50px; letter-spacing: 0.5px; }
        .status-tag.available   { background: rgba(74,222,128,0.15); color: #4ade80; border: 1px solid rgba(74,222,128,0.3); }
        .status-tag.occupied    { background: rgba(248,113,113,0.15); color: #f87171; border: 1px solid rgba(248,113,113,0.3); }
        .status-tag.maintenance { background: rgba(251,191,36,0.15);  color: #fbbf24; border: 1px solid rgba(251,191,36,0.3); }
        .no-rooms { grid-column: 1 / -1; text-align: center; padding: 64px 24px; color: var(--text-muted); }
        .no-rooms p { font-size: 15px; margin-top: 12px; }
        .promotions { background: rgba(13,21,38,0.4); position: relative; overflow: hidden; backdrop-filter: blur(5px); }
        .promotions::before { content: ''; position: absolute; inset: 0; background-image: url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=1920&q=60'); background-size: cover; background-position: center; opacity: 0.07; z-index: 0; }
        .promotions::after { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse at 50% 0%, rgba(201,168,76,0.08) 0%, transparent 70%); z-index: 0; pointer-events: none; }
        .promotions .section-inner { position: relative; z-index: 1; }
        .promo-grid { grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; margin-top: 52px; }
        .promo-card { background: linear-gradient(135deg, rgba(201,168,76,0.08), rgba(201,168,76,0.02)); border: 1px solid rgba(201,168,76,0.2); border-radius: 20px; padding: 32px; position: relative; overflow: hidden; transition: all 0.3s; }
        .promo-card::before { content: ''; position: absolute; right: -30px; top: -30px; width: 120px; height: 120px; border-radius: 50%; background: rgba(201,168,76,0.08); }
        .promo-card:hover { border-color: rgba(201,168,76,0.4); transform: translateY(-4px); }
        .promo-discount { font-family: 'Playfair Display', serif; font-size: 58px; font-weight: 700; color: var(--gold); line-height: 1; margin-bottom: 8px; }
        .promo-title { font-size: 17px; font-weight: 600; color: #fff; margin-bottom: 10px; }
        .promo-desc { font-size: 13px; color: var(--text-muted); line-height: 1.6; margin-bottom: 20px; }
        .promo-code { background: rgba(201,168,76,0.1); border: 1px dashed rgba(201,168,76,0.4); border-radius: 8px; padding: 10px 16px; display: flex; justify-content: space-between; align-items: center; }
        .promo-code span { font-weight: 700; color: var(--gold); letter-spacing: 2px; font-size: 15px; }
        .promo-code button { background: none; border: none; color: var(--text-muted); font-size: 12px; cursor: pointer; transition: color 0.2s; }
        .promo-code button:hover { color: var(--gold); }
        .promo-expiry { font-size: 12px; color: var(--text-muted); margin-top: 12px; }
        .my-account { background: linear-gradient(135deg, rgba(201,168,76,0.05), rgba(13,21,38,0.8)); border-top: 1px solid rgba(201,168,76,0.1); }
        .account-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 48px; }
        .account-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 28px 24px; text-align: center; text-decoration: none; transition: all 0.3s; display: block; }
        .account-card:hover { background: rgba(201,168,76,0.06); border-color: rgba(201,168,76,0.25); transform: translateY(-4px); }
        .account-card h4 { color: #fff; font-size: 15px; font-weight: 600; margin-bottom: 6px; }
        .account-card p { color: var(--text-muted); font-size: 12.5px; }
        footer { background: rgba(13,21,38,0.6); backdrop-filter: blur(20px); border-top: 1px solid rgba(201,168,76,0.1); padding: 60px; }
        .footer-inner { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 48px; }
        .footer-brand .logo { font-family: 'Playfair Display', serif; font-size: 26px; color: #fff; margin-bottom: 14px; }
        .footer-brand .logo span { color: var(--gold); }
        .footer-brand p { color: var(--text-muted); font-size: 13.5px; line-height: 1.7; }
        .footer-col h4 { color: #fff; font-size: 13px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 18px; }
        .footer-col a { display: block; color: var(--text-muted); text-decoration: none; font-size: 13.5px; margin-bottom: 10px; transition: color 0.2s; }
        .footer-col a:hover { color: var(--gold); }
        .footer-bottom { max-width: 1200px; margin: 40px auto 0; padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.06); display: flex; justify-content: space-between; align-items: center; color: rgba(255,255,255,0.25); font-size: 12.5px; }
        .footer-bottom span { color: var(--gold); }
        /* ── Hamburger ── */
        .hamburger { display: none; background: none; border: none; color: #fff; font-size: 24px; cursor: pointer; padding: 4px 8px; line-height: 1; }
        .mobile-nav { display: none; position: fixed; top: 80px; left: 0; right: 0; background: rgba(10,10,15,0.97); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.15); z-index: 999; padding: 16px 24px 20px; flex-direction: column; gap: 4px; }
        .mobile-nav.open { display: flex; }
        .mobile-nav a { color: rgba(255,255,255,0.75); text-decoration: none; font-size: 14px; font-weight: 500; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .mobile-nav a:last-child { border-bottom: none; }
        .mobile-nav a:hover { color: var(--gold); }

        /* Typography Reveal Anim */
        .char { display: inline-block; opacity: 0; transform: translateY(20px) rotateX(-90deg); transition: all 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94); }
        .reveal.active .char { opacity: 1; transform: translateY(0) rotateX(0); }

        @media (max-width: 1024px) {
            .stats-inner { gap: 20px; }
            .rooms-grid { grid-template-columns: repeat(2, 1fr); }
            .promo-grid { grid-template-columns: repeat(2, 1fr); }
            .features-grid { grid-template-columns: repeat(2, 1fr); }
            .footer-inner { grid-template-columns: 1fr 1fr; gap: 32px; }
        }
        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .nav-links { display: none; }
            .hamburger { display: block; }
            section { padding: 48px 20px; }
            .stats-bar { padding: 36px 20px; }
            .stats-inner { display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; justify-items: center; }
            .stat-item { padding: 0 16px; }
            .stat-item:not(:last-child)::after { display: none; }
            .stat-num { font-size: 36px; }
            .rooms-grid { grid-template-columns: 1fr; }
            .promo-grid { grid-template-columns: 1fr; }
            .features-grid { grid-template-columns: 1fr; }
            .footer-inner { grid-template-columns: 1fr; gap: 28px; }
            footer { padding: 40px 20px; }
            .footer-bottom { flex-direction: column; gap: 8px; text-align: center; }
            .nav-right { gap: 8px; }
            .nav-greeting { display: none; }
            .btn-nav-login, .btn-nav-register { padding: 7px 14px; font-size: 12px; }
        }

        .page-fade { animation: pageFadeIn 0.8s cubic-bezier(0.4, 0, 0.2, 1); }
        @keyframes pageFadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="page-fade">
    <!-- ULTRA LUXURY ELEMENTS -->
    <div id="scroll-progress"></div>

<!-- MOBILE NAV -->
<div class="mobile-nav" id="mobileNav">
    <a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a>
    <a href="#promotions">Ưu đãi</a>
    <a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a>
    <a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a>
    <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
        <a href="${pageContext.request.contextPath}/dashboard/admin">Quản Trị</a>
    </c:if>
    <c:choose>
        <c:when test="${not empty sessionScope.account}">
            <a href="${pageContext.request.contextPath}/logout">Đăng Xuất</a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/login.jsp">Đăng Nhập</a>
            <a href="${pageContext.request.contextPath}/register.jsp">Đăng Ký</a>
        </c:otherwise>
    </c:choose>
</div>

<!-- NAVBAR -->
<nav class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <button class="hamburger" id="hamburgerBtn" onclick="document.getElementById('mobileNav').classList.toggle('open')" aria-label="Menu">☰</button>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a></li>
        <li><a href="#promotions">Kỳ nghỉ</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a></li>
        <c:if test="${sessionScope.account.personType == 'EMPLOYEE'}">
            <li><a href="${pageContext.request.contextPath}/dashboard/admin" class="text-gold font-bold hover:text-white transition-colors">Quản Trị</a></li>
        </c:if>
    </ul>
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <span class="nav-greeting hidden lg:inline">Xin chào, <strong>${sessionScope.account.fullName}</strong></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Đăng Xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-nav-login">Đăng Nhập</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn-nav-register">Đăng Ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- HERO SECTION -->
<section class="hero" id="home">
    <div class="hero-slider absolute inset-0 w-full h-full z-0 overflow-hidden">
        <img src="https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1920&q=80" class="hero-slide absolute inset-0 w-full h-full object-cover transition-opacity duration-[2000ms] ease-in-out opacity-100">
        <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1920&q=80" class="hero-slide absolute inset-0 w-full h-full object-cover transition-opacity duration-[2000ms] ease-in-out opacity-0">
        <img src="https://images.unsplash.com/photo-1498503182468-3b51cbb6cb24?auto=format&fit=crop&w=1920&q=80" class="hero-slide absolute inset-0 w-full h-full object-cover transition-opacity duration-[2000ms] ease-in-out opacity-0">
    </div>
    <div class="hero-overlay"></div>
    
    <!-- Decorative Parallax Elements -->
    <div class="parallax-leaf left-[5%] top-[20%] w-24 h-24" data-speed="0.05">
        <svg viewBox="0 0 24 24" fill="var(--gold)"><path d="M17,8C8,10 5.9,16.17 3.82,21.34L5.71,22L6.66,19.7C7.14,19.87 7.64,20 8,20C19,20 22,3 22,3C21,5 14,5.25 9,6.25C4,7.25 2,11.5 2,13.5C2,15.5 3.75,17.25 3.75,17.25C7,11 8,9 17,8Z"/></svg>
    </div>
    <div class="parallax-leaf right-[8%] top-[40%] w-16 h-16 rotate-45" data-speed="0.1">
        <svg viewBox="0 0 24 24" fill="var(--gold)"><path d="M17,8C8,10 5.9,16.17 3.82,21.34L5.71,22L6.66,19.7C7.14,19.87 7.64,20 8,20C19,20 22,3 22,3C21,5 14,5.25 9,6.25C4,7.25 2,11.5 2,13.5C2,15.5 3.75,17.25 3.75,17.25C7,11 8,9 17,8Z"/></svg>
    </div>

    <div class="hero-content relative z-20 text-center max-w-4xl px-6 animate-float reveal">
        <div class="hero-badge inline-flex items-center gap-2 bg-gold/10 border border-gold/30 px-5 py-2 rounded-full text-gold text-xs tracking-[0.2em] uppercase mb-8 backdrop-blur-sm animate-pulse">
            TUYỆT TÁC NGHỈ DƯỠNG
        </div>
        <h1 class="font-serif text-5xl md:text-7xl lg:text-8xl text-white font-bold leading-tight mb-6 animate-[fadeUp_1s_ease-out]">
            Thiên Đường<br>Nghỉ Dưỡng<br>
            <span class="text-gold font-script block mt-2 text-4xl md:text-6xl lg:text-7xl">Giữa Biển Xanh</span>
        </h1>
        <p class="text-white/70 text-lg md:text-xl font-light leading-relaxed mb-10 max-w-2xl mx-auto animate-[fadeUp_1.2s_ease-out]">
            Trải nghiệm kỳ nghỉ đẳng cấp tại một trong những khu nghỉ dưỡng sang trọng bậc nhất Việt Nam, nơi thiên nhiên giao hòa cùng kiến trúc hiện đại.
        </p>
        <div class="hero-actions flex flex-wrap justify-center gap-4 animate-[fadeUp_1.4s_ease-out]">
            <a href="${pageContext.request.contextPath}/rooms" class="btn-primary hover:scale-105 transition-transform">Khám phá phòng</a>
            <a href="${pageContext.request.contextPath}/booking" class="btn-outline border-white/40 hover:border-gold hover:text-gold hover:bg-gold/5 transition-all">Đặt lịch ngay</a>
        </div>
    </div>
</section>

<!-- STATS -->
<div class="stats-bar reveal">
    <div class="stats-inner">
        <div class="stat-item reveal delay-100">
            <div class="stat-num">50+</div>
            <div class="stat-label">PHÒNG NGHỈ</div>
        </div>
        <div class="stat-item reveal delay-200">
            <div class="stat-num">5★</div>
            <div class="stat-label">ĐÁNH GIÁ</div>
        </div>
        <div class="stat-item reveal delay-300">
            <div class="stat-num">15K+</div>
            <div class="stat-label">KHÁCH HÀNG</div>
        </div>
        <div class="stat-item reveal delay-400">
            <div class="stat-num">10+</div>
            <div class="stat-label">NĂM KINH NGHIỆM</div>
        </div>
    </div>
</div>

<!-- PROMOTIONS SECTION -->
<section class="py-24 px-12" id="promotions">
    <div class="max-w-7xl mx-auto">
        <div class="section-header text-center mb-16 reveal">
            <span class="text-gold tracking-[0.3em] uppercase text-xs font-bold mb-4 block">Đặc Quyền Riêng Tư</span>
            <h2 class="font-serif text-5xl text-white font-bold italic">Ưu đãi độc quyền</h2>
        </div>

        <div class="promo-grid">
            <!-- Promo 1 -->
            <div class="promo-card reveal delay-100 skeleton p-8 border border-white/10 rounded-3xl hover:border-gold transition-all duration-500">
                <div class="promo-discount text-gold font-bold text-3xl mb-4">20%</div>
                <h3 class="text-white font-bold text-xl mb-2">Đặt Sớm Rước Ưu Đãi</h3>
                <p class="text-white/50 text-sm mb-6">Giảm ngay 20% cho các đặt phòng trước ít nhất 30 ngày.</p>
                <div class="promo-code-wrap flex items-center justify-between bg-white/5 p-3 rounded-xl border border-white/10">
                    <span class="promo-code font-mono text-gold font-bold">EARLYBIRD20</span>
                    <button class="text-[10px] text-white/50 hover:text-white" onclick="copyCode('EARLYBIRD20', this)">SAO CHÉP</button>
                </div>
            </div>

            <!-- Promo 2 -->
            <div class="promo-card reveal delay-200 skeleton p-8 border border-white/10 rounded-3xl hover:border-gold transition-all duration-500">
                <div class="promo-discount text-gold font-bold text-3xl mb-4">15%</div>
                <h3 class="text-white font-bold text-xl mb-2">Cuối Tuần Rực Rỡ</h3>
                <p class="text-white/50 text-sm mb-6">Tận hưởng kỳ nghỉ cuối tuần với ưu đãi 15% và miễn phí bữa sáng.</p>
                <div class="promo-code-wrap flex items-center justify-between bg-white/5 p-3 rounded-xl border border-white/10">
                    <span class="promo-code font-mono text-gold font-bold">WEEKEND15</span>
                    <button class="text-[10px] text-white/50 hover:text-white" onclick="copyCode('WEEKEND15', this)">SAO CHÉP</button>
                </div>
            </div>

            <!-- Promo 3 -->
            <div class="promo-card reveal delay-300 skeleton p-8 border border-white/10 rounded-3xl hover:border-gold transition-all duration-500">
                <div class="promo-discount text-gold font-bold text-3xl mb-4">30%</div>
                <h3 class="text-white font-bold text-xl mb-2">Đặc Quyền Thành Viên</h3>
                <p class="text-white/50 text-sm mb-6">Ưu đãi lên đến 30% dành riêng cho khách hàng thân thiết Azure.</p>
                <div class="promo-code-wrap flex items-center justify-between bg-white/5 p-3 rounded-xl border border-white/10">
                    <span class="promo-code font-mono text-gold font-bold">VIP2026</span>
                    <button class="text-[10px] text-white/50 hover:text-white" onclick="copyCode('VIP2026', this)">SAO CHÉP</button>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- TESTIMONIALS SECTION -->
<section class="testimonials overflow-hidden">
    <div class="section-header text-center mb-16 reveal">
        <span class="text-gold tracking-[0.3em] uppercase text-xs font-bold mb-4 block">Tiếng nói từ trái tim</span>
        <h2 class="font-serif text-5xl text-white font-bold">Cảm nghĩ của khách hàng</h2>
    </div>
    
    <div class="testimonial-container">
        <div class="testimonial-track" id="testimonialTrack">
            <!-- Testimonial 1 -->
            <div class="testimonial-item">
                <div class="stars">★★★★★</div>
                <div class="quote-icon">“</div>
                <p class="testimonial-text">"Kỳ nghỉ tuyệt vời nhất mà tôi từng có. Không gian sang trọng, dịch vụ tận tâm và món ăn thực sự đẳng cấp. Tôi nhất định sẽ quay lại!"</p>
                <div class="testimonial-author">
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80" class="author-img" alt="Guest" loading="lazy">
                    <div class="text-left">
                        <div class="author-name">Nguyễn Hồng Nhung</div>
                        <div class="author-title">Doanh nhân · Hà Nội</div>
                    </div>
                </div>
            </div>
            <!-- Testimonial 2 -->
            <div class="testimonial-item">
                <div class="stars">★★★★★</div>
                <div class="quote-icon">“</div>
                <p class="testimonial-text">"Trợ lý ảo Azure AI rất thông minh, giúp tôi đặt bàn tối và gợi ý tour du lịch cực kỳ nhanh chóng. Một resort công nghệ thực thụ."</p>
                <div class="testimonial-author">
                    <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80" class="author-img" alt="Guest" loading="lazy">
                    <div class="text-left">
                        <div class="author-name">David Tran</div>
                        <div class="author-title">Giám đốc Sáng tạo · TP.HCM</div>
                    </div>
                </div>
            </div>
            <!-- Testimonial 3 -->
            <div class="testimonial-item">
                <div class="stars">★★★★★</div>
                <div class="quote-icon">“</div>
                <p class="testimonial-text">"Bình minh trên biển nhìn từ ban công phòng Suite thực sự là trải nghiệm vô tiền khoáng hậu. Cảm ơn Azure đã gắn kết gia đình chúng tôi."</p>
                <div class="testimonial-author">
                    <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80" class="author-img" alt="Guest" loading="lazy">
                    <div class="text-left">
                        <div class="author-name">Lê Phương Thảo</div>
                        <div class="author-title">Nhiếp ảnh gia · Đà Nẵng</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="carousel-dots" id="carouselDots"></div>
    </div>
</section>

<!-- FEATURES -->
<section class="features reveal">
    <div class="section-inner">
        <span class="section-label">DỊCH VỤ CỦA CHÚNG TÔI</span>
        <h2 class="section-title">Trải nghiệm <em>Hoàn hảo</em></h2>
        <p class="section-desc">Chúng tôi cam kết mang lại những giá trị vượt trội và trải nghiệm cá nhân hóa sâu sắc cho mọi khách hàng.</p>
        <div class="features-grid">
            <a href="${pageContext.request.contextPath}/rooms" class="feature-card reveal delay-100 group">
                <div class="flex flex-col items-center">
                    <h3 class="group-hover:text-gold transition-colors">Đặt phòng trực tuyến</h3>
                    <p>Hệ thống đặt phòng nhanh chóng, minh bạch và an toàn.</p>
                    <span class="feature-arrow group-hover:translate-x-2 transition-transform">Đặt phòng →</span>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/booking?view=my" class="feature-card reveal delay-200 group">
                <div class="flex flex-col items-center">
                    <h3 class="group-hover:text-gold transition-colors">Quản lý đặt chỗ</h3>
                    <p>Theo dõi và thay đổi lịch trình nghỉ dưỡng dễ dàng.</p>
                    <span class="feature-arrow group-hover:translate-x-2 transition-transform">Xem thêm →</span>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/contracts" class="feature-card reveal delay-300 group">
                <div class="flex flex-col items-center">
                    <h3 class="group-hover:text-gold transition-colors">Hợp đồng & Pháp lý</h3>
                    <p>Mọi giao dịch đều được đảm bảo bằng hợp đồng điện tử.</p>
                    <span class="feature-arrow group-hover:translate-x-2 transition-transform">Xem thêm →</span>
                </div>
            </a>
            <a href="#promotions" class="feature-card reveal delay-400 group">
                <div class="flex flex-col items-center">
                    <h3 class="group-hover:text-gold transition-colors">Ưu đãi hấp dẫn</h3>
                    <p>Luôn có những voucher giá trị dành cho kỳ nghỉ của bạn.</p>
                    <span class="feature-arrow group-hover:translate-x-2 transition-transform">Săn deal →</span>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- FOOTER -->
<!-- INSTAGRAM FEED SECTION -->
<section class="py-24">
    <div class="section-header text-center mb-16 reveal">
        <span class="text-gold tracking-[0.3em] uppercase text-xs font-bold mb-4 block">Khoảnh khắc thực tế</span>
        <h2 class="font-serif text-5xl text-white font-bold italic">#AzureResortMoments</h2>
    </div>
    <div class="instagram-grid reveal">
        <div class="insta-item"><img src="https://images.unsplash.com/photo-1544124499-58d096185973?auto=format&fit=crop&w=400&q=80" class="insta-img" loading="lazy"><div class="insta-overlay">❤</div></div>
        <div class="insta-item"><img src="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=400&q=80" class="insta-img" loading="lazy"><div class="insta-overlay">❤</div></div>
        <div class="insta-item"><img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=400&q=80" class="insta-img" loading="lazy"><div class="insta-overlay">❤</div></div>
        <div class="insta-item"><img src="https://images.unsplash.com/photo-1510076857177-74700760be4d?auto=format&fit=crop&w=400&q=80" class="insta-img" loading="lazy"><div class="insta-overlay">❤</div></div>
        <div class="insta-item"><img src="https://images.unsplash.com/photo-1584132915807-fd1f5fbc078f?auto=format&fit=crop&w=400&q=80" class="insta-img" loading="lazy"><div class="insta-overlay">❤</div></div>
        <div class="insta-item"><img src="https://images.unsplash.com/photo-1596436889106-be35e843f974?auto=format&fit=crop&w=400&q=80" class="insta-img" loading="lazy"><div class="insta-overlay">❤</div></div>
    </div>
</section>

<footer>
    <div class="footer-inner">
        <div class="footer-brand">
            <div class="logo">Azure <span>Resort</span> &amp; Spa</div>
            <p>Khu nghỉ dưỡng sang trọng bậc nhất với những dịch vụ đẳng cấp thế giới và không gian gần gũi thiên nhiên.</p>
        </div>
        <div class="footer-col">
            <h4>KHÁM PHÁ</h4>
            <a href="${pageContext.request.contextPath}/rooms">Phòng &amp; Villa</a>
            <a href="#promotions">Ưu đãi</a>
            <a href="${pageContext.request.contextPath}/booking">Đặt phòng</a>
        </div>
        <div class="footer-col">
            <h4>TÀI KHOẢN</h4>
            <a href="${pageContext.request.contextPath}/booking?view=my">Booking Của Tôi</a>
            <a href="${pageContext.request.contextPath}/profile">Tài Khoản</a>
        </div>
        <div class="footer-col">
            <h4>LIÊN HỆ</h4>
            <a href="#">📍 Đà Nẵng, Việt Nam</a>
            <a href="#">📞 1800 7777</a>
            <a href="#">✉️ info@azure-resort.vn</a>
        </div>
    </div>
    <div class="footer-bottom">
        <span>© 2026 <span>Azure Resort &amp; Spa</span>. Mọi quyền được bảo lưu.</span>
        <span>Được phát triển bởi Azure Team</span>
    </div>
</footer>

<!-- CHATBOT WIDGET -->
<div id="chatbot-widget" class="fixed bottom-8 right-8 z-[2000] font-sans">
    <!-- Toggle Button -->
    <button id="chatbot-toggle" class="w-16 h-16 bg-gold rounded-full shadow-2xl flex items-center justify-center text-dark hover:scale-110 transition-transform duration-300 group relative">
        <svg class="w-8 h-8 group-hover:rotate-12 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path>
        </svg>
        <div class="absolute -top-1 -right-1 w-4 h-4 bg-emerald-500 border-2 border-dark rounded-full"></div>
    </button>

    <!-- Chat Window -->
    <div id="chatbot-window" class="absolute bottom-20 right-0 w-[400px] h-[600px] bg-[#0a0a0f]/90 backdrop-blur-2xl border border-white/10 rounded-[32px] shadow-2xl flex flex-col overflow-hidden opacity-0 translate-y-10 scale-95 pointer-events-none transition-all duration-500 ease-[cubic-bezier(0.34,1.56,0.64,1)]">
        <!-- Header -->
        <div class="p-5 bg-gold/10 border-b border-gold/10 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-full bg-gold/20 flex items-center justify-center text-gold">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                </div>
                <div>
                    <div class="flex items-center gap-2">
                        <h3 class="text-white font-bold text-sm">Azure AI Concierge</h3>
                        <c:if test="${not empty sessionScope.account}">
                            <span id="vip-badge" class="px-2 py-0.5 rounded-full bg-gold/20 border border-gold/30 text-[9px] text-gold font-black uppercase tracking-tighter shadow-[0_0_10px_rgba(201,138,76,0.2)]">VIP</span>
                        </c:if>
                    </div>
                    <div class="flex items-center gap-1.5">
                        <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                        <span class="text-[10px] text-white/40 uppercase tracking-widest font-bold">Trực tuyến</span>
                    </div>
                </div>
            </div>
            <div class="flex items-center gap-2">
                <c:if test="${sessionScope.account != null && sessionScope.account.personType == 'EMPLOYEE'}">
                <button id="chatbot-settings-btn" class="text-white/30 hover:text-white transition-colors" title="Cài đặt API Key">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                </button>
                </c:if>
                <button id="close-chat" class="text-white/30 hover:text-white transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
        </div>

        <c:if test="${sessionScope.account != null && sessionScope.account.personType == 'EMPLOYEE'}">
        <!-- Settings Panel -->
        <div id="chatbot-settings-panel" class="hidden p-4 bg-dark/95 border-b border-gold/10 relative z-10 shadow-lg top-0 w-full transition-all">
            <label class="block text-xs text-gold mb-2 font-bold uppercase tracking-wider">Custom Grok / Groq API Key</label>
            <input type="password" id="grok-api-key-input" placeholder="xai-... hoặc gsk_..." class="w-full bg-white/5 border border-white/10 rounded-xl px-3 py-2.5 text-sm text-white focus:outline-none focus:border-gold mb-2 transition-colors">
            <p class="text-[10px] text-white/40 leading-relaxed">Nhập mã CỦA BẠN để nâng cấp AI. Bỏ trống sẽ dùng Key hệ thống mặc định.</p>
        </div>
        </c:if>

        <!-- Messages -->
        <div id="chat-messages" class="flex-grow overflow-y-auto p-5 space-y-4 scroll-smooth">
            <div class="flex gap-3">
                <div class="w-8 h-8 rounded-full bg-gold/10 flex items-center justify-center text-gold flex-shrink-0">A</div>
                <div class="bg-white/5 border border-white/10 rounded-2xl rounded-tl-none p-3.5 text-sm text-white/80 leading-relaxed max-w-[85%]">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            Xin chào <strong>${sessionScope.account.fullName}</strong>! 👋 Tôi là <strong>Azure</strong>, trợ lý của Azure Resort & Spa. Tôi có thể giúp gì cho kỳ nghỉ của bạn hôm nay?
                        </c:when>
                        <c:otherwise>
                            Xin chào! 👋 Tôi là <strong>Azure</strong>, trợ lý ảo của <strong>Azure Resort & Spa</strong>. Tôi có thể tư vấn về phòng/villa, thời tiết Đà Nẵng và hỗ trợ đặt phòng. Quý khách cần hỗ trợ gì ạ?
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Inputs -->
        <div class="p-4 bg-white/5 border-t border-white/5">
            <div class="flex gap-2 overflow-x-auto pb-3 no-scrollbar mb-2 mt-1">
                <button onclick="sendQuick('Thời tiết Đà Nẵng')" class="whitespace-nowrap px-4 py-1.5 rounded-full bg-white/5 border border-white/10 text-[11px] text-white/50 hover:bg-gold/10 hover:text-gold hover:border-gold/30 transition-all">🌤️ Thời tiết</button>
                <button onclick="sendQuick('Phòng còn trống')" class="whitespace-nowrap px-4 py-1.5 rounded-full bg-white/5 border border-white/10 text-[11px] text-white/50 hover:bg-gold/10 hover:text-gold hover:border-gold/30 transition-all">🏡 Phòng trống</button>
                <button onclick="sendQuick('Ưu đãi hiện có')" class="whitespace-nowrap px-4 py-1.5 rounded-full bg-white/5 border border-white/10 text-[11px] text-white/50 hover:bg-gold/10 hover:text-gold hover:border-gold/30 transition-all">🎁 Ưu đãi</button>
            </div>
            <div class="relative">
                <input type="text" id="chat-input" placeholder="Nhập tin nhắn..." class="w-full bg-white/5 border border-white/10 rounded-2xl py-3.5 pl-5 pr-12 text-sm text-white outline-none focus:border-gold/50 focus:bg-white/10 transition-all">
                <button id="send-chat" class="absolute right-3 top-1/2 -translate-y-1/2 text-gold hover:scale-110 transition-transform">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z"></path></svg>
                </button>
            </div>
            <p class="text-[10px] text-white/20 text-center mt-3 tracking-widest uppercase font-bold">Azure Luxury Concierge AI</p>
        </div>
    </div>
</div>

<script>
    // Chatbot Logic
    const chatToggle = document.getElementById('chatbot-toggle');
    const chatWindow = document.getElementById('chatbot-window');
    const closeChat = document.getElementById('close-chat');
    const chatInput = document.getElementById('chat-input');
    const sendBtn = document.getElementById('send-chat');
    const chatMessages = document.getElementById('chat-messages');

    // API Key Settings
    const settingsBtn = document.getElementById('chatbot-settings-btn');
    const settingsPanel = document.getElementById('chatbot-settings-panel');
    const apiKeyInput = document.getElementById('grok-api-key-input');
    
    if (apiKeyInput) {
        const savedKey = localStorage.getItem('customGrokKey');
        if (savedKey) apiKeyInput.value = savedKey;
        
        settingsBtn.addEventListener('click', () => {
            settingsPanel.classList.toggle('hidden');
        });
        
        apiKeyInput.addEventListener('input', (e) => {
            localStorage.setItem('customGrokKey', e.target.value.trim());
        });
    }

    chatToggle.addEventListener('click', () => {
        const isOpen = !chatWindow.classList.contains('opacity-0');
        if (isOpen) {
            chatWindow.classList.add('opacity-0', 'translate-y-10', 'scale-95', 'pointer-events-none');
        } else {
            chatWindow.classList.remove('opacity-0', 'translate-y-10', 'scale-95', 'pointer-events-none');
            setTimeout(() => chatInput.focus(), 100);
        }
    });

    closeChat.addEventListener('click', () => {
        chatWindow.classList.add('opacity-0', 'translate-y-10', 'scale-95', 'pointer-events-none');
    });

    async function sendMessage() {
        const text = chatInput.value.trim();
        if (!text) return;

        // Append User Message
        appendMsg(text, 'user');
        chatInput.value = '';

        // Typing Indicator
        const typingId = appendMsg('...', 'bot', true);

        try {
            const formData = new FormData();
            formData.append('message', text);
            formData.append('apiKey', localStorage.getItem('customGrokKey') || '');
            
            const resp = await fetch('${pageContext.request.contextPath}/chatbot', {
                method: 'POST',
                body: formData
            });
            const data = await resp.json();
            
            chatMessages.removeChild(document.getElementById(typingId));
            appendMsg(data.reply, 'bot');
            
            // Handle Actions if any
            if (data.actions && data.actions.length > 0) {
                appendActions(data.actions);
            }
        } catch (e) {
            console.error(e);
            chatMessages.removeChild(document.getElementById(typingId));
            appendMsg('Xin lỗi, tôi gặp chút sự cố kỹ thuật. Quý khách vui lòng thử lại sau hoặc liên hệ hotline.', 'bot');
        }
    }

    function appendMsg(text, role, isTyping = false) {
        const id = 'msg-' + Date.now();
        const div = document.createElement('div');
        div.id = id;
        div.className = 'flex gap-3 ' + (role === 'user' ? 'flex-row-reverse' : '');
        
        const avatar = document.createElement('div');
        avatar.className = 'w-8 h-8 rounded-full flex-shrink-0 flex items-center justify-center text-xs font-bold ' + 
                          (role === 'user' ? 'bg-gold text-dark' : 'bg-gold/10 text-gold');
        avatar.textContent = role === 'user' ? 'U' : 'A';
        
        const msg = document.createElement('div');
        msg.className = 'p-3.5 text-sm leading-relaxed max-w-[85%] ' + 
                     (role === 'user' ? 'bg-gold/20 text-white rounded-2xl rounded-tr-none' : 'bg-white/5 border border-white/10 text-white/80 rounded-2xl rounded-tl-none');
        
        // Advanced Markdown Parser (Images, Bold, Italic, Lists)
        let parsedText = text.replace(/\n/g, '<br>')
                             .replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<div class="my-3 overflow-hidden rounded-xl border border-white/10 shadow-lg"><img src="$2" alt="$1" class="w-full h-auto object-cover hover:scale-105 transition-transform duration-500"></div>')
                             .replace(/\*\*([^*]+)\*\*/g, '<b class="text-gold">$1</b>')
                             .replace(/\*([^*]+)\*/g, '<i class="text-white/60">$1</i>')
                             .replace(/^- (.+)$/gm, '<li class="ml-4 list-disc marker:text-gold">$1</li>');
        msg.innerHTML = parsedText;
        
        div.appendChild(avatar);
        div.appendChild(msg);
        chatMessages.appendChild(div);
        chatMessages.scrollTop = chatMessages.scrollHeight;

        if (role === 'bot' && !isTyping) {
            new Audio('https://actions.google.com/sounds/v1/ui/beep_short.ogg').play().catch(e => {});
        }
        
        return id;
    }

    function appendActions(actions) {
        const div = document.createElement('div');
        div.className = 'flex flex-wrap gap-2 pt-2 ml-11';
        actions.forEach(act => {
            const btn = document.createElement('a');
            btn.href = act.url.startsWith('/') ? '${pageContext.request.contextPath}' + act.url : act.url;
            if (act.url.startsWith('booking:')) {
                btn.href = '${pageContext.request.contextPath}/booking?id=' + act.url.split(':')[1];
            } else if (act.url.startsWith('service:')) {
                // Assuming service booking is handled by a similar route or modal
                btn.href = '${pageContext.request.contextPath}/services?id=' + act.url.split(':')[1];
                btn.classList.replace('bg-gold', 'bg-emerald-500');
                btn.classList.add('text-white');
            }
            btn.className += ' px-4 py-2 rounded-xl font-bold text-xs hover:scale-105 transition-transform flex items-center gap-1.5';
            if (act.url.startsWith('booking:')) btn.innerHTML = '🏠 ' + act.label;
            else if (act.url.startsWith('service:')) btn.innerHTML = '✨ ' + act.label;
            else btn.textContent = act.label;
            div.appendChild(btn);
        });
        chatMessages.appendChild(div);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function sendQuick(text) {
        chatInput.value = text;
        sendMessage();
    }

    sendBtn.addEventListener('click', sendMessage);
    chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') sendMessage();
    });
</script>


<script>
    // Proactive Greeting System
    (function() {
        const nudge = document.createElement('div');
        nudge.id = 'chat-nudge';
        nudge.className = 'fixed bottom-24 right-8 px-5 py-3.5 bg-gold text-dark font-bold text-sm rounded-2xl rounded-br-none shadow-2xl opacity-0 translate-y-4 pointer-events-none transition-all duration-700 z-[999] flex items-center gap-3 cursor-pointer hover:-translate-y-1';
        nudge.innerHTML = `
            <div class="w-6 h-6 rounded-full bg-dark/10 flex items-center justify-center">✨</div>
            <span>Xin chào! Tôi có thể giúp gì cho kỳ nghỉ của bạn?</span>
        `;
        document.body.appendChild(nudge);

        nudge.addEventListener('click', () => {
            nudge.classList.add('opacity-0', 'translate-y-4', 'pointer-events-none');
            chatToggle.click();
        });

        // Show nudge after 12 seconds if chat wasn't opened
        setTimeout(() => {
            if (chatWindow.classList.contains('opacity-0')) {
                nudge.classList.remove('opacity-0', 'translate-y-4', 'pointer-events-none');
            }
        }, 12000);
    })();

    // Navbar Smart Show/Hide (Headroom style)
    let lastScroll = 0;
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
        const currentScroll = window.scrollY;
        
        // Background Opacity/Blur
        navbar.classList.toggle('scrolled', currentScroll > 60);
        
        // Hide/Show logic
        if (currentScroll > lastScroll && currentScroll > 200) {
            navbar.style.transform = 'translateY(-100%)'; // Hide on scroll down
        } else {
            navbar.style.transform = 'translateY(0)'; // Show on scroll up
        }
        lastScroll = currentScroll;
        
        // Scroll Progress Bar
        const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
        const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
        const scrolled = (winScroll / height) * 100;
        document.getElementById('scroll-progress').style.width = scrolled + "%";
    });

    // Typography Reveal (Split Text)
    function splitTextToChars(selector) {
        document.querySelectorAll(selector).forEach(el => {
            const text = el.textContent.trim();
            el.innerHTML = text.split('').map(char => {
                const content = (char === ' ') ? '&nbsp;' : char;
                return '<span class="char">' + content + '</span>';
            }).join('');
            
            // Re-apply delay to chars
            el.querySelectorAll('.char').forEach((char, i) => {
                char.style.transitionDelay = (i * 30) + 'ms';
            });
        });
    }
    splitTextToChars('.hero h1, .section-header h2');

    // Predictive Prefetching
    document.querySelectorAll('a[href]').forEach(link => {
        link.addEventListener('mouseenter', () => {
            const url = link.getAttribute('href');
            if (url && url.startsWith('/') && !url.includes('#')) {
                const prefetch = document.createElement('link');
                prefetch.rel = 'prefetch';
                prefetch.href = url;
                document.head.appendChild(prefetch);
            }
        }, { once: true });
    });

    // Parallax Effect
    window.addEventListener('scroll', () => {
        const scrolled = window.scrollY;
        document.querySelectorAll('.parallax-leaf').forEach(el => {
            const speed = parseFloat(el.getAttribute('data-speed') || 0.05);
            el.style.transform = 'translateY(' + (scrolled * speed) + 'px) rotate(' + (scrolled * 0.1) + 'deg)';
        });
    });

    // Hero Image Slider
    (function() {
        const slides = document.querySelectorAll('.hero-slide');
        let currentSlide = 0;
        if(slides.length > 1) {
            setInterval(() => {
                slides[currentSlide].classList.remove('opacity-100');
                slides[currentSlide].classList.add('opacity-0');
                currentSlide = (currentSlide + 1) % slides.length;
                slides[currentSlide].classList.remove('opacity-0');
                slides[currentSlide].classList.add('opacity-100');
            }, 5000);
        }
    })();

    // Testimonial Carousel logic - Robust version
    (function() {
        const track = document.getElementById('testimonialTrack');
        const items = document.querySelectorAll('.testimonial-item');
        const dotsContainer = document.getElementById('carouselDots');
        let currentIdx = 0;
        let slideInterval;

        if (!track || items.length === 0) return;

        // Create dots
        items.forEach((_, i) => {
            const dot = document.createElement('div');
            dot.className = 'dot' + (i === 0 ? ' active' : '');
            dot.addEventListener('click', () => {
                goToSlide(i);
                resetInterval();
            });
            dotsContainer.appendChild(dot);
        });

        function goToSlide(i) {
            currentIdx = i;
            track.style.transform = 'translateX(-' + (i * 100) + '%)';
            const dots = dotsContainer.querySelectorAll('.dot');
            dots.forEach((d, idx) => {
                d.classList.toggle('active', idx === i);
            });
        }

        function startInterval() {
            slideInterval = setInterval(() => {
                currentIdx = (currentIdx + 1) % items.length;
                goToSlide(currentIdx);
            }, 6000);
        }

        function resetInterval() {
            if (slideInterval) clearInterval(slideInterval);
            startInterval();
        }

        startInterval();
    })();



    // Scroll Reveal Observer
    const observerOptions = { threshold: 0.15 };
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
            }
        });
    }, observerOptions);

    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    function copyCode(code, btn) {
        navigator.clipboard.writeText(code).then(() => {
            const orig = btn.textContent;
            btn.textContent = '✅';
            setTimeout(() => btn.textContent = orig, 2000);
        });
    }

    // Back to top button
    const backToTop = document.createElement('button');
    backToTop.id = 'back-to-top';
    backToTop.className = 'fixed bottom-24 right-8 w-12 h-12 bg-dark/80 backdrop-blur border border-gold/30 rounded-full flex items-center justify-center text-gold shadow-lg opacity-0 translate-y-10 pointer-events-none transition-all duration-500 z-[1000]';
    backToTop.innerHTML = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"></path></svg>';
    document.body.appendChild(backToTop);
    
    window.addEventListener('scroll', () => {
        if (window.scrollY > 400) {
            backToTop.classList.remove('opacity-0', 'translate-y-10', 'pointer-events-none');
        } else {
            backToTop.classList.add('opacity-0', 'translate-y-10', 'pointer-events-none');
        }
    });
    backToTop.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
</script>

</body>
</html>
