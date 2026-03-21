<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TblPersons" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    TblPersons currentUser = (TblPersons) session.getAttribute("account");
    if (currentUser == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    pageContext.setAttribute("currentUser", currentUser);
    pageContext.setAttribute("account", currentUser.getFullName());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hợp Đồng Của Tôi — Azure Resort</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --gold: #c9a84c; --gold-light: #e8cc82; --dark: #0a0a0f; --navy: #0d1526; --card: rgba(255,255,255,0.03); --border: rgba(255,255,255,0.07); --text: #e8e8e8; --muted: rgba(255,255,255,0.45); }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background: var(--dark); color: var(--text); min-height: 100vh; }

        /* ── NAVBAR ── */
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; padding: 0 60px; height: 72px; display: flex; align-items: center; justify-content: space-between; background: rgba(10,10,15,0.96); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(201,168,76,0.15); }
        .nav-brand { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 36px; list-style: none; }
        .nav-links a { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 13.5px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover, .nav-links a.active { color: var(--gold); }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-greeting { color: var(--muted); font-size: 13px; }
        .nav-greeting strong { color: var(--gold); }
        .btn-logout { padding: 8px 20px; border: 1px solid rgba(201,168,76,0.4); border-radius: 50px; background: transparent; color: var(--gold); font-size: 13px; text-decoration: none; transition: all 0.25s; }
        .btn-logout:hover { background: var(--gold); color: var(--dark); }

        /* ── PAGE HERO ── */
        .page-hero { margin-top: 72px; background: linear-gradient(135deg, var(--navy) 0%, #0a0a0f 100%); border-bottom: 1px solid rgba(201,168,76,0.1); padding: 48px 60px 40px; }
        .page-hero-inner { max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 24px; }
        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--muted); margin-bottom: 16px; }
        .breadcrumb a { color: var(--muted); text-decoration: none; transition: color 0.2s; }
        .breadcrumb a:hover { color: var(--gold); }
        .breadcrumb .sep { color: rgba(255,255,255,0.15); }
        .section-label { display: inline-block; color: var(--gold); font-size: 10px; letter-spacing: 3px; text-transform: uppercase; font-weight: 600; margin-bottom: 8px; }
        .page-title { font-family: 'Playfair Display', serif; font-size: clamp(28px,4vw,40px); color: #fff; line-height: 1.15; }
        .page-title em { color: var(--gold); font-style: italic; }
        .page-desc { color: var(--muted); font-size: 14px; margin-top: 6px; }

        /* ── STATS ── */
        .stats-row { display: flex; gap: 16px; flex-wrap: wrap; }
        .stat-pill { background: rgba(201,168,76,0.08); border: 1px solid rgba(201,168,76,0.18); border-radius: 14px; padding: 14px 22px; text-align: center; min-width: 110px; }
        .stat-pill .num { font-family: 'Playfair Display', serif; font-size: 26px; font-weight: 700; color: var(--gold); line-height: 1; }
        .stat-pill .lbl { font-size: 11px; color: var(--muted); margin-top: 4px; letter-spacing: 0.5px; }
        .stat-pill.green .num { color: #4ade80; }
        .stat-pill.blue  .num { color: #60a5fa; }

        /* ── WRAP ── */
        .page-wrap { max-width: 1100px; margin: 0 auto; padding: 36px 60px 80px; }

        /* ── FILTER BAR ── */
        .filter-bar { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; margin-bottom: 28px; }
        .filter-tabs { display: flex; gap: 8px; flex-wrap: wrap; }
        .tab { padding: 7px 18px; border-radius: 50px; font-size: 12.5px; font-weight: 600; border: 1.5px solid var(--border); color: var(--muted); background: transparent; cursor: pointer; transition: all 0.2s; }
        .tab:hover { border-color: rgba(201,168,76,0.4); color: var(--gold); }
        .tab.active { background: var(--gold); color: var(--dark); border-color: var(--gold); }
        .result-count { font-size: 13px; color: var(--muted); }
        .result-count strong { color: var(--gold); }

        /* ── CONTRACT CARD ── */
        .contracts-list { display: flex; flex-direction: column; gap: 20px; }
        .contract-card { background: var(--card); border: 1px solid var(--border); border-radius: 24px; overflow: hidden; transition: all 0.3s; animation: fadeUp 0.4s ease both; }
        .contract-card:hover { border-color: rgba(201,168,76,0.25); box-shadow: 0 16px 48px rgba(0,0,0,0.35); transform: translateY(-2px); }
        @keyframes fadeUp { from { opacity:0; transform:translateY(16px); } to { opacity:1; transform:translateY(0); } }

        /* Card accent bar */
        .card-accent { height: 4px; }
        .accent-active    { background: linear-gradient(90deg, #4ade80, #22c55e); }
        .accent-completed { background: linear-gradient(90deg, var(--gold), var(--gold-light)); }
        .accent-cancelled { background: linear-gradient(90deg, #f87171, #ef4444); }
        .accent-draft     { background: linear-gradient(90deg, #60a5fa, #3b82f6); }
        .accent-expired   { background: linear-gradient(90deg, #94a3b8, #64748b); }

        .card-inner { padding: 28px 32px; }

        /* Card header */
        .card-header { display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; margin-bottom: 24px; flex-wrap: wrap; }
        .card-title-block { display: flex; align-items: center; gap: 14px; }
        .card-icon { width: 48px; height: 48px; border-radius: 14px; background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.2); display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .card-title { font-family: 'Playfair Display', serif; font-size: 19px; color: #fff; font-weight: 600; }
        .card-subtitle { color: var(--muted); font-size: 12px; margin-top: 3px; }
        .status-badge { padding: 5px 14px; border-radius: 50px; font-size: 11px; font-weight: 700; letter-spacing: 0.5px; white-space: nowrap; }
        .badge-active    { background: rgba(74,222,128,0.12); color: #4ade80; border: 1px solid rgba(74,222,128,0.3); }
        .badge-completed { background: rgba(201,168,76,0.12); color: var(--gold); border: 1px solid rgba(201,168,76,0.3); }
        .badge-cancelled { background: rgba(248,113,113,0.12); color: #f87171; border: 1px solid rgba(248,113,113,0.3); }
        .badge-draft     { background: rgba(96,165,250,0.12); color: #60a5fa; border: 1px solid rgba(96,165,250,0.3); }
        .badge-expired   { background: rgba(148,163,184,0.12); color: #94a3b8; border: 1px solid rgba(148,163,184,0.3); }

        /* Info grid */
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 0; border: 1px solid var(--border); border-radius: 16px; overflow: hidden; margin-bottom: 24px; }
        .info-cell { padding: 16px 20px; border-right: 1px solid var(--border); border-bottom: 1px solid var(--border); }
        .info-cell:last-child { border-right: none; }
        .info-cell:nth-last-child(-n+3) { border-bottom: none; }
        .info-lbl { font-size: 10px; color: var(--muted); letter-spacing: 1.5px; text-transform: uppercase; font-weight: 600; margin-bottom: 6px; }
        .info-val { font-size: 14px; color: #fff; font-weight: 500; }
        .info-val.gold { color: var(--gold); font-family: 'Playfair Display', serif; font-size: 16px; }
        .info-val.green { color: #4ade80; }
        .info-val.yellow { color: #fbbf24; }

        /* Payment progress */
        .payment-block { margin-bottom: 20px; }
        .payment-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .payment-label { font-size: 12px; color: var(--muted); }
        .payment-amounts { display: flex; gap: 16px; align-items: center; }
        .paid-amt { font-size: 13px; color: #4ade80; font-weight: 600; }
        .remain-amt { font-size: 13px; color: #fbbf24; font-weight: 600; }
        .remain-amt.zero { color: #4ade80; }
        .pct-label { font-size: 13px; color: var(--gold); font-weight: 700; }
        .progress-track { height: 8px; background: rgba(255,255,255,0.07); border-radius: 50px; overflow: hidden; position: relative; }
        .progress-fill { height: 100%; border-radius: 50px; transition: width 1s cubic-bezier(.4,0,.2,1); position: relative; }
        .progress-fill::after { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent); animation: shimmer 2s infinite; }
        @keyframes shimmer { 0% { transform: translateX(-100%); } 100% { transform: translateX(100%); } }
        .fill-full    { background: linear-gradient(90deg, #4ade80, #22c55e); }
        .fill-partial { background: linear-gradient(90deg, var(--gold), var(--gold-light)); }
        .fill-low     { background: linear-gradient(90deg, #f87171, #fbbf24); }

        /* Notes */
        .notes-row { display: flex; align-items: flex-start; gap: 10px; padding: 14px 18px; background: rgba(201,168,76,0.04); border: 1px solid rgba(201,168,76,0.1); border-radius: 12px; margin-bottom: 20px; }
        .notes-row .note-icon { font-size: 16px; flex-shrink: 0; margin-top: 1px; }
        .notes-row p { font-size: 13px; color: var(--muted); font-style: italic; line-height: 1.6; }

        /* Card footer */
        .card-footer { display: flex; justify-content: flex-end; gap: 10px; padding-top: 16px; border-top: 1px solid var(--border); }
        .btn-action { padding: 9px 22px; border-radius: 50px; font-size: 12.5px; font-weight: 600; text-decoration: none; transition: all 0.25s; cursor: pointer; border: none; font-family: 'Inter', sans-serif; }
        .btn-outline { background: transparent; border: 1.5px solid rgba(201,168,76,0.35); color: var(--gold); }
        .btn-outline:hover { background: var(--gold); color: var(--dark); }
        .btn-primary { background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); }
        .btn-primary:hover { transform: scale(1.04); }

        /* ── EMPTY ── */
        .empty-state { text-align: center; padding: 100px 24px; }
        .empty-icon { font-size: 64px; opacity: 0.25; margin-bottom: 20px; }
        .empty-state h3 { font-family: 'Playfair Display', serif; font-size: 22px; color: #fff; margin-bottom: 10px; }
        .empty-state p { color: var(--muted); font-size: 14px; margin-bottom: 24px; }
        .btn-explore { display: inline-block; padding: 12px 32px; background: linear-gradient(135deg, var(--gold), var(--gold-light)); color: var(--dark); border-radius: 50px; font-size: 13px; font-weight: 700; text-decoration: none; transition: all 0.25s; }
        .btn-explore:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(201,168,76,0.3); }

        /* ── ERROR ── */
        .error-box { background: rgba(248,113,113,0.07); border: 1px solid rgba(248,113,113,0.2); border-radius: 16px; padding: 24px 28px; color: #f87171; }
        .error-box strong { display: block; margin-bottom: 6px; font-size: 15px; }
        .error-box code { font-size: 12px; opacity: 0.8; }

        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .page-hero { padding: 36px 20px 28px; }
            .page-wrap { padding: 24px 20px 60px; }
            .card-inner { padding: 20px; }
            .info-grid { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Azure <span>Resort</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/rooms.jsp">Phòng &amp; Villa</a></li>
        <li><a href="${pageContext.request.contextPath}/booking">Đặt Phòng</a></li>
        <li><a href="${pageContext.request.contextPath}/contracts" class="active">Hợp Đồng</a></li>
        <li><a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a></li>
    </ul>
    <div class="nav-right">
        <span class="nav-greeting">Xin chào, <strong>${account}</strong></span>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
    </div>
</nav>

<%-- ── Tính thống kê ── --%>
<c:set var="total" value="0"/>
<c:set var="cntActive" value="0"/>
<c:set var="cntCompleted" value="0"/>
<c:set var="cntOther" value="0"/>
<c:forEach var="c" items="${contracts}">
    <c:set var="total" value="${total + 1}"/>
    <c:choose>
        <c:when test="${c.status == 'ACTIVE'}">   <c:set var="cntActive"    value="${cntActive + 1}"/></c:when>
        <c:when test="${c.status == 'COMPLETED'}"><c:set var="cntCompleted" value="${cntCompleted + 1}"/></c:when>
        <c:otherwise>                             <c:set var="cntOther"     value="${cntOther + 1}"/></c:otherwise>
    </c:choose>
</c:forEach>

<!-- PAGE HERO -->
<div class="page-hero">
    <div class="page-hero-inner">
        <div>
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
                <span class="sep">›</span>
                <a href="${pageContext.request.contextPath}/account.jsp">Tài Khoản</a>
                <span class="sep">›</span>
                <span style="color:var(--gold)">Hợp Đồng</span>
            </div>
            <span class="section-label">Quản Lý Tài Chính</span>
            <h1 class="page-title">Hợp Đồng <em>Của Tôi</em></h1>
            <p class="page-desc">Theo dõi tình trạng hợp đồng và tiến độ thanh toán tại Azure Resort &amp; Spa</p>
        </div>
        <div class="stats-row">
            <div class="stat-pill">
                <div class="num">${total}</div>
                <div class="lbl">Tổng</div>
            </div>
            <div class="stat-pill green">
                <div class="num">${cntActive}</div>
                <div class="lbl">Hiệu Lực</div>
            </div>
            <div class="stat-pill">
                <div class="num">${cntCompleted}</div>
                <div class="lbl">Hoàn Thành</div>
            </div>
        </div>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="page-wrap">
    <c:choose>
        <c:when test="${not empty contractError}">
            <div class="error-box">
                <strong>⚠ Không thể tải dữ liệu hợp đồng</strong>
                <code>${contractError}</code>
            </div>
        </c:when>
        <c:when test="${empty contracts}">
            <div class="empty-state">
                <div class="empty-icon">📋</div>
                <h3>Chưa có hợp đồng nào</h3>
                <p>Đặt phòng và hoàn tất thủ tục để hợp đồng xuất hiện tại đây.</p>
                <a href="${pageContext.request.contextPath}/rooms.jsp" class="btn-explore">Khám Phá Phòng →</a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Filter bar -->
            <div class="filter-bar">
                <div class="filter-tabs">
                    <button class="tab active" onclick="filterBy('ALL',this)">Tất Cả (${total})</button>
                    <button class="tab" onclick="filterBy('ACTIVE',this)">Đang Hiệu Lực</button>
                    <button class="tab" onclick="filterBy('COMPLETED',this)">Hoàn Thành</button>
                    <button class="tab" onclick="filterBy('DRAFT',this)">Chờ Duyệt</button>
                    <button class="tab" onclick="filterBy('CANCELLED',this)">Đã Hủy</button>
                </div>
                <span class="result-count" id="resultCount">Hiển thị <strong>${total}</strong> hợp đồng</span>
            </div>

            <!-- Contract list -->
            <div class="contracts-list" id="contractsList">
                <c:forEach var="ct" items="${contracts}" varStatus="loop">
                    <%-- Resolve status labels & classes --%>
                    <c:choose>
                        <c:when test="${ct.status == 'ACTIVE'}">
                            <c:set var="accentClass" value="accent-active"/>
                            <c:set var="badgeClass"  value="badge-active"/>
                            <c:set var="statusLabel" value="Đang Hiệu Lực"/>
                        </c:when>
                        <c:when test="${ct.status == 'COMPLETED'}">
                            <c:set var="accentClass" value="accent-completed"/>
                            <c:set var="badgeClass"  value="badge-completed"/>
                            <c:set var="statusLabel" value="Hoàn Thành"/>
                        </c:when>
                        <c:when test="${ct.status == 'CANCELLED'}">
                            <c:set var="accentClass" value="accent-cancelled"/>
                            <c:set var="badgeClass"  value="badge-cancelled"/>
                            <c:set var="statusLabel" value="Đã Hủy"/>
                        </c:when>
                        <c:when test="${ct.status == 'EXPIRED'}">
                            <c:set var="accentClass" value="accent-expired"/>
                            <c:set var="badgeClass"  value="badge-expired"/>
                            <c:set var="statusLabel" value="Hết Hạn"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="accentClass" value="accent-draft"/>
                            <c:set var="badgeClass"  value="badge-draft"/>
                            <c:set var="statusLabel" value="Chờ Duyệt"/>
                        </c:otherwise>
                    </c:choose>

                    <%-- Payment % --%>
                    <c:set var="pct" value="0"/>
                    <c:if test="${ct.totalPayment != null && ct.totalPayment > 0}">
                        <c:set var="pct" value="${ct.paidAmount * 100 / ct.totalPayment}"/>
                    </c:if>
                    <c:choose>
                        <c:when test="${pct >= 100}"><c:set var="fillClass" value="fill-full"/></c:when>
                        <c:when test="${pct >= 50}"> <c:set var="fillClass" value="fill-partial"/></c:when>
                        <c:otherwise>               <c:set var="fillClass" value="fill-low"/></c:otherwise>
                    </c:choose>

                    <div class="contract-card" data-status="${ct.status}" style="animation-delay:${loop.index * 0.07}s">
                        <div class="card-accent ${accentClass}"></div>
                        <div class="card-inner">
                            <!-- Header -->
                            <div class="card-header">
                                <div class="card-title-block">
                                    <div class="card-icon">📄</div>
                                    <div>
                                        <div class="card-title">${ct.contractId}</div>
                                        <div class="card-subtitle">
                                            Booking: <strong style="color:rgba(255,255,255,0.7)">${ct.bookingId}</strong>
                                            &nbsp;·&nbsp; Phòng: <strong style="color:var(--gold)">${ct.facilityId}</strong>
                                        </div>
                                    </div>
                                </div>
                                <span class="status-badge ${badgeClass}">${statusLabel}</span>
                            </div>

                            <!-- Info grid -->
                            <div class="info-grid">
                                <div class="info-cell">
                                    <div class="info-lbl">Ngày Ký</div>
                                    <div class="info-val">
                                        <c:choose>
                                            <c:when test="${ct.signedDate != null}"><fmt:formatDate value="${ct.signedDate}" pattern="dd/MM/yyyy"/></c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-cell">
                                    <div class="info-lbl">Nhận Phòng</div>
                                    <div class="info-val">${ct.startDate}</div>
                                </div>
                                <div class="info-cell">
                                    <div class="info-lbl">Trả Phòng</div>
                                    <div class="info-val">${ct.endDate}</div>
                                </div>
                                <div class="info-cell">
                                    <div class="info-lbl">Đặt Cọc</div>
                                    <div class="info-val"><fmt:formatNumber value="${ct.deposit}" type="number" groupingUsed="true"/> đ</div>
                                </div>
                                <div class="info-cell">
                                    <div class="info-lbl">Tổng Giá Trị</div>
                                    <div class="info-val gold"><fmt:formatNumber value="${ct.totalPayment}" type="number" groupingUsed="true"/> đ</div>
                                </div>
                                <div class="info-cell">
                                    <div class="info-lbl">Còn Phải Trả</div>
                                    <c:choose>
                                        <c:when test="${ct.remainingAmount != null && ct.remainingAmount > 0}">
                                            <div class="info-val yellow"><fmt:formatNumber value="${ct.remainingAmount}" type="number" groupingUsed="true"/> đ</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="info-val green">✓ Đã thanh toán đủ</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <c:if test="${not empty ct.employeeName}">
                                <div class="info-cell">
                                    <div class="info-lbl">Nhân Viên Phụ Trách</div>
                                    <div class="info-val">${ct.employeeName}</div>
                                </div>
                                </c:if>
                            </div>

                            <!-- Payment progress -->
                            <div class="payment-block">
                                <div class="payment-row">
                                    <span class="payment-label">Tiến độ thanh toán</span>
                                    <div class="payment-amounts">
                                        <span class="paid-amt">Đã trả: <fmt:formatNumber value="${ct.paidAmount}" type="number" groupingUsed="true"/> đ</span>
                                        <span class="pct-label"><fmt:formatNumber value="${pct}" maxFractionDigits="0"/>%</span>
                                    </div>
                                </div>
                                <div class="progress-track">
                                    <div class="progress-fill ${fillClass}" style="width:0%" data-width="<fmt:formatNumber value='${pct}' maxFractionDigits='0'/>%"></div>
                                </div>
                            </div>

                            <!-- Notes -->
                            <c:if test="${not empty ct.notes}">
                            <div class="notes-row">
                                <span class="note-icon">💬</span>
                                <p>${ct.notes}</p>
                            </div>
                            </c:if>

                            <!-- Footer actions -->
                            <div class="card-footer">
                                <c:if test="${ct.status == 'ACTIVE' && ct.remainingAmount > 0}">
                                    <span style="font-size:12px;color:#fbbf24;align-self:center">⏳ Vui lòng liên hệ nhân viên để thanh toán thêm</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer style="background:#060608;border-top:1px solid rgba(201,168,76,0.1);padding:28px 60px;margin-top:40px;">
    <div style="max-width:1100px;margin:0 auto;display:flex;justify-content:space-between;align-items:center;color:rgba(255,255,255,0.2);font-size:12.5px;">
        <span>© 2026 <span style="color:var(--gold)">Azure Resort &amp; Spa</span>. All rights reserved.</span>
        <span>Made with ❤️ in Vietnam</span>
    </div>
</footer>

<!-- FLASH TOAST -->
<c:if test="${not empty sessionScope.paymentFlash}">
    <div class="flash-toast ${sessionScope.paymentFlash.startsWith('✅') ? 'flash-success' : 'flash-error'}" id="flashToast">
        ${sessionScope.paymentFlash}
    </div>
    <c:remove var="paymentFlash" scope="session"/>
</c:if>

<script>
    // Animate progress bars on load
    window.addEventListener('load', () => {
        document.querySelectorAll('.progress-fill').forEach(el => {
            el.style.width = el.dataset.width;
        });
        const toast = document.getElementById('flashToast');
        if (toast) setTimeout(() => { toast.style.opacity = '0'; toast.style.transition = 'opacity 0.5s'; setTimeout(() => toast.remove(), 500); }, 4000);
    });

    // Filter contracts
    function filterBy(status, btn) {
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');
        let visible = 0;
        document.querySelectorAll('.contract-card').forEach(card => {
            const show = status === 'ALL' || card.dataset.status === status;
            card.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        document.getElementById('resultCount').innerHTML =
            'Hiển thị <strong>' + visible + '</strong> hợp đồng';
    }

    function openPayModal(contractId, remaining) {
        document.getElementById('modalContractId').value = contractId;
        document.getElementById('modalRemaining').textContent = new Intl.NumberFormat('vi-VN').format(remaining) + ' đ';
        document.getElementById('modalAmount').max = remaining;
        document.getElementById('modalAmount').value = '';
        document.getElementById('payModal').classList.add('open');
    }

    function closePayModal() {
        document.getElementById('payModal').classList.remove('open');
    }

    // Close modal on overlay click
    document.getElementById('payModal').addEventListener('click', function(e) {
        if (e.target === this) closePayModal();
    });
</script>
</body>
</html>
