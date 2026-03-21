<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    TblPersons acc = (TblPersons) session.getAttribute("account");
    if (acc == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    boolean isAdmin = (acc instanceof TblEmployees) && "ADMIN".equals(((TblEmployees)acc).getRole());
    pageContext.setAttribute("isAdmin", isAdmin);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt Hợp Đồng — Azure Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        :root{--gold:#c9a84c;--gold-light:#e8cc82;--dark:#0a0a0f;--navy:#0d1526;--card:rgba(255,255,255,0.03);--border:rgba(255,255,255,0.07);--text:#e8e8e8;--muted:rgba(255,255,255,0.45)}
        body{font-family:'Inter',sans-serif;background:var(--dark);color:var(--text);min-height:100vh;display:flex}
        .sidebar{width:260px;flex-shrink:0;background:rgba(13,21,38,0.98);border-right:1px solid rgba(201,168,76,0.12);display:flex;flex-direction:column;position:fixed;top:0;left:0;bottom:0;z-index:100}
        .sidebar-brand{padding:28px 24px 20px;border-bottom:1px solid rgba(201,168,76,0.1)}
        .brand-logo{font-family:'Playfair Display',serif;font-size:20px;font-weight:700;color:#fff}
        .brand-logo span{color:var(--gold)}
        .brand-sub{font-size:10px;color:var(--muted);letter-spacing:2px;text-transform:uppercase;margin-top:4px}
        .sidebar-user{padding:20px 24px;border-bottom:1px solid rgba(255,255,255,0.05);display:flex;align-items:center;gap:12px}
        .user-avatar{width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,var(--gold),var(--gold-light));display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:700;color:var(--dark);flex-shrink:0}
        .user-name{font-size:13.5px;font-weight:600;color:#fff}
        .user-role{font-size:11px;color:var(--gold);margin-top:2px}
        .sidebar-nav{flex:1;padding:16px 0;overflow-y:auto}
        .nav-section{padding:8px 24px 4px;font-size:10px;color:var(--muted);letter-spacing:2px;text-transform:uppercase;font-weight:600}
        .nav-item{display:flex;align-items:center;gap:12px;padding:11px 24px;color:rgba(255,255,255,0.6);text-decoration:none;font-size:13.5px;font-weight:500;transition:all 0.2s}
        .nav-item:hover{background:rgba(255,255,255,0.04);color:#fff}
        .nav-item.active{background:rgba(201,168,76,0.1);color:var(--gold);border-right:2px solid var(--gold)}
        .nav-item .icon{font-size:17px;width:22px;text-align:center;flex-shrink:0}
        .sidebar-footer{padding:16px 24px;border-top:1px solid rgba(255,255,255,0.05)}
        .btn-logout{display:flex;align-items:center;gap:10px;color:rgba(248,113,113,0.7);font-size:13px;text-decoration:none;padding:10px 0;transition:color 0.2s}
        .btn-logout:hover{color:#f87171}
        .main{margin-left:260px;flex:1;display:flex;flex-direction:column;min-height:100vh}
        .topbar{height:64px;background:rgba(10,10,15,0.95);border-bottom:1px solid rgba(201,168,76,0.08);display:flex;align-items:center;justify-content:space-between;padding:0 36px;position:sticky;top:0;z-index:50;backdrop-filter:blur(20px)}
        .topbar-title{font-family:'Playfair Display',serif;font-size:18px;color:#fff}
        .content{padding:32px 36px 60px;flex:1}
        .section-label{font-size:10px;color:var(--gold);letter-spacing:2px;text-transform:uppercase;font-weight:600;margin-bottom:4px}
        .section-title{font-family:'Playfair Display',serif;font-size:24px;color:#fff;margin-bottom:24px}

        /* Flash message */
        .flash{padding:14px 20px;border-radius:12px;margin-bottom:20px;font-size:13.5px;font-weight:500}
        .flash-success{background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.25);color:#4ade80}
        .flash-warn{background:rgba(251,191,36,0.08);border:1px solid rgba(251,191,36,0.25);color:#fbbf24}
        .flash-error{background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.25);color:#f87171}

        .stats-row{display:flex;gap:16px;margin-bottom:24px;flex-wrap:wrap}
        .stat-pill{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:14px 22px;display:flex;align-items:center;gap:14px;cursor:pointer;text-decoration:none;transition:all 0.2s}
        .stat-pill:hover{border-color:rgba(201,168,76,0.3)}
        .stat-pill .num{font-family:'Playfair Display',serif;font-size:26px;font-weight:700}
        .stat-pill .lbl{font-size:12px;color:var(--muted)}
        .stat-pill.yellow .num{color:#fbbf24}
        .stat-pill.green .num{color:#4ade80}
        .stat-pill.gold .num{color:var(--gold)}

        .toolbar{display:flex;align-items:center;gap:12px;margin-bottom:20px;flex-wrap:wrap}
        .search-box{display:flex;align-items:center;gap:8px;background:rgba(255,255,255,0.05);border:1px solid var(--border);border-radius:10px;padding:8px 14px;flex:1;min-width:200px;max-width:360px}
        .search-box input{background:none;border:none;outline:none;color:#fff;font-size:13.5px;width:100%}
        .search-box input::placeholder{color:var(--muted)}
        .filter-tabs{display:flex;gap:8px;flex-wrap:wrap}
        .tab{padding:7px 16px;border-radius:50px;font-size:12.5px;font-weight:600;border:1.5px solid var(--border);color:var(--muted);background:transparent;cursor:pointer;transition:all 0.2s;text-decoration:none}
        .tab:hover{border-color:rgba(201,168,76,0.4);color:var(--gold)}
        .tab.active{background:var(--gold);color:var(--dark);border-color:var(--gold)}

        /* Contract cards */
        .contracts-list{display:flex;flex-direction:column;gap:16px}
        .contract-card{background:var(--card);border:1px solid var(--border);border-radius:20px;overflow:hidden;transition:all 0.3s}
        .contract-card:hover{border-color:rgba(201,168,76,0.2);transform:translateY(-1px)}
        .card-accent{height:3px}
        .accent-draft{background:linear-gradient(90deg,#60a5fa,#3b82f6)}
        .accent-active{background:linear-gradient(90deg,#4ade80,#22c55e)}
        .accent-completed{background:linear-gradient(90deg,var(--gold),var(--gold-light))}
        .accent-cancelled{background:linear-gradient(90deg,#f87171,#ef4444)}
        .card-body{padding:24px 28px}
        .card-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:16px;flex-wrap:wrap;gap:12px}
        .card-id{font-family:'Playfair Display',serif;font-size:18px;color:#fff;font-weight:600}
        .card-meta{font-size:12px;color:var(--muted);margin-top:3px}
        .badge{display:inline-block;padding:4px 12px;border-radius:50px;font-size:11px;font-weight:700}
        .badge-draft{background:rgba(96,165,250,0.12);color:#60a5fa}
        .badge-active{background:rgba(74,222,128,0.12);color:#4ade80}
        .badge-completed{background:rgba(201,168,76,0.12);color:var(--gold)}
        .badge-cancelled{background:rgba(248,113,113,0.12);color:#f87171}
        .info-row{display:flex;gap:24px;flex-wrap:wrap;margin-bottom:16px}
        .info-item .lbl{font-size:10px;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:4px}
        .info-item .val{font-size:14px;color:#fff;font-weight:500}
        .info-item .val.gold{color:var(--gold);font-family:'Playfair Display',serif;font-size:16px}
        .info-item .val.green{color:#4ade80}
        .info-item .val.yellow{color:#fbbf24}

        /* Deposit indicator */
        .deposit-indicator{display:flex;align-items:center;gap:8px;padding:10px 16px;border-radius:10px;margin-bottom:16px;font-size:13px;font-weight:600}
        .deposit-yes{background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.2);color:#4ade80}
        .deposit-no{background:rgba(251,191,36,0.08);border:1px solid rgba(251,191,36,0.2);color:#fbbf24}

        .card-actions{display:flex;gap:10px;padding-top:16px;border-top:1px solid var(--border);flex-wrap:wrap}
        .btn-action{padding:8px 20px;border-radius:50px;font-size:12.5px;font-weight:600;border:none;cursor:pointer;transition:all 0.25s;font-family:'Inter',sans-serif}
        .btn-approve{background:linear-gradient(135deg,#4ade80,#22c55e);color:#000}
        .btn-approve:hover{transform:scale(1.04)}
        .btn-deposit{background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--dark);font-weight:700}
        .btn-deposit:hover{transform:scale(1.04);box-shadow:0 6px 20px rgba(201,168,76,0.35)}
        .btn-reject{background:rgba(248,113,113,0.1);color:#f87171;border:1px solid rgba(248,113,113,0.3)}
        .btn-reject:hover{background:#f87171;color:#fff}
        .btn-complete{background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--dark)}
        .btn-complete:hover{transform:scale(1.04)}

        .empty{padding:60px;text-align:center;color:var(--muted)}
        .empty .icon{font-size:48px;margin-bottom:12px;opacity:0.3}

        /* Modal */
        .modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,0.75);z-index:2000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(4px)}
        .modal-overlay.open{display:flex}
        .modal{background:#0d1526;border:1px solid rgba(201,168,76,0.2);border-radius:24px;padding:36px;width:100%;max-width:440px}
        .modal h3{font-family:'Playfair Display',serif;font-size:20px;color:#fff;margin-bottom:6px}
        .modal .modal-sub{color:var(--muted);font-size:13px;margin-bottom:20px}
        .modal .remaining-info{background:rgba(251,191,36,0.08);border:1px solid rgba(251,191,36,0.2);border-radius:12px;padding:12px 16px;margin-bottom:20px;font-size:13px;color:#fbbf24}
        .modal .remaining-info strong{font-size:16px}
        .modal-field{margin-bottom:16px}
        .modal-field label{display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;font-weight:600;margin-bottom:8px}
        .modal-field input,.modal-field select{width:100%;background:rgba(0,0,0,0.3);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:12px 16px;color:#fff;font-size:14px;font-family:'Inter',sans-serif;outline:none;transition:border-color 0.2s}
        .modal-field input:focus,.modal-field select:focus{border-color:var(--gold)}
        .modal-field select option{background:#0d1526}
        .modal-hint{font-size:11px;color:var(--muted);margin-top:5px}
        .modal-actions{display:flex;gap:10px;margin-top:24px}
        .modal-actions .btn-cancel{flex:1;padding:12px;border-radius:50px;background:transparent;border:1.5px solid rgba(255,255,255,0.15);color:var(--muted);font-size:13px;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.2s}
        .modal-actions .btn-cancel:hover{color:#fff;border-color:rgba(255,255,255,0.3)}
        .modal-actions .btn-pay{flex:2;padding:12px;border-radius:50px;background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--dark);font-size:13px;font-weight:700;border:none;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.25s}
        .modal-actions .btn-pay:hover{transform:scale(1.03)}
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-logo">Azure <span>Resort</span></div>
        <div class="brand-sub">${isAdmin ? 'Admin Panel' : 'Staff Portal'}</div>
    </div>
    <div class="sidebar-user">
        <div class="user-avatar">${acc.fullName.substring(0,1)}</div>
        <div><div class="user-name">${acc.fullName}</div><div class="user-role">${isAdmin ? '⚡ Admin' : '👔 Staff'}</div></div>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">Tổng Quan</div>
        <a href="${pageContext.request.contextPath}/dashboard/${isAdmin ? 'admin' : 'staff'}" class="nav-item"><span class="icon">🏠</span> Dashboard</a>
        <div class="nav-section">Quản Lý</div>
        <a href="${pageContext.request.contextPath}/dashboard/users" class="nav-item"><span class="icon">👥</span> Người Dùng</a>
        <a href="${pageContext.request.contextPath}/dashboard/bookings" class="nav-item"><span class="icon">📋</span> Booking</a>
        <a href="${pageContext.request.contextPath}/dashboard/contracts" class="nav-item active"><span class="icon">📄</span> Hợp Đồng</a>
        <a href="${pageContext.request.contextPath}/dashboard/facilities" class="nav-item"><span class="icon">🏨</span> Phòng & Villa</a>
    </nav>
    <div class="sidebar-footer"><a href="${pageContext.request.contextPath}/logout" class="btn-logout"><span>🚪</span> Đăng Xuất</a></div>
</aside>

<div class="main">
    <div class="topbar">
        <div class="topbar-title">Duyệt Hợp Đồng</div>
        <span style="font-size:12px;color:var(--muted)" id="topbarDate"></span>
    </div>
    <div class="content">
        <div class="section-label">Quản Lý</div>
        <div class="section-title">Hợp Đồng Phòng</div>

        <!-- Flash message -->
        <c:if test="${not empty flashMsg}">
            <div class="flash ${flashMsg.startsWith('✅') ? 'flash-success' : flashMsg.startsWith('⚠️') ? 'flash-warn' : 'flash-error'}">
                ${flashMsg}
            </div>
        </c:if>

        <!-- Stats -->
        <div class="stats-row">
            <a href="?status=DRAFT" class="stat-pill yellow">
                <div><div class="num">${cntDraft}</div><div class="lbl">Chờ Duyệt</div></div>
            </a>
            <a href="?status=ACTIVE" class="stat-pill green">
                <div><div class="num">${cntActive}</div><div class="lbl">Đang Hiệu Lực</div></div>
            </a>
            <a href="?status=COMPLETED" class="stat-pill gold">
                <div><div class="num">${cntCompleted}</div><div class="lbl">Hoàn Thành</div></div>
            </a>
        </div>

        <!-- Toolbar -->
        <form method="get" action="${pageContext.request.contextPath}/dashboard/contracts">
            <div class="toolbar">
                <div class="search-box">
                    <span>🔍</span>
                    <input type="text" name="q" placeholder="Tìm mã hợp đồng, tên khách..." value="${search}">
                </div>
                <div class="filter-tabs">
                    <a href="?status=ALL" class="tab ${statusFilter == 'ALL' ? 'active' : ''}">Tất Cả</a>
                    <a href="?status=DRAFT" class="tab ${statusFilter == 'DRAFT' ? 'active' : ''}">Chờ Duyệt</a>
                    <a href="?status=ACTIVE" class="tab ${statusFilter == 'ACTIVE' ? 'active' : ''}">Hiệu Lực</a>
                    <a href="?status=COMPLETED" class="tab ${statusFilter == 'COMPLETED' ? 'active' : ''}">Hoàn Thành</a>
                    <a href="?status=CANCELLED" class="tab ${statusFilter == 'CANCELLED' ? 'active' : ''}">Đã Hủy</a>
                </div>
            </div>
        </form>

        <!-- Contract cards -->
        <c:choose>
            <c:when test="${not empty contracts}">
                <div class="contracts-list">
                <c:forEach var="ct" items="${contracts}">
                    <c:choose>
                        <c:when test="${ct.status == 'ACTIVE'}"><c:set var="accentCls" value="accent-active"/><c:set var="badgeCls" value="badge-active"/><c:set var="statusLbl" value="Đang Hiệu Lực"/></c:when>
                        <c:when test="${ct.status == 'COMPLETED'}"><c:set var="accentCls" value="accent-completed"/><c:set var="badgeCls" value="badge-completed"/><c:set var="statusLbl" value="Hoàn Thành"/></c:when>
                        <c:when test="${ct.status == 'CANCELLED'}"><c:set var="accentCls" value="accent-cancelled"/><c:set var="badgeCls" value="badge-cancelled"/><c:set var="statusLbl" value="Đã Hủy"/></c:when>
                        <c:otherwise><c:set var="accentCls" value="accent-draft"/><c:set var="badgeCls" value="badge-draft"/><c:set var="statusLbl" value="Chờ Duyệt"/></c:otherwise>
                    </c:choose>

                    <div class="contract-card">
                        <div class="card-accent ${accentCls}"></div>
                        <div class="card-body">
                            <div class="card-top">
                                <div>
                                    <div class="card-id">📄 ${ct.contractId}</div>
                                    <div class="card-meta">Booking: ${ct.bookingId} · Phòng: <span style="color:var(--gold)">${ct.facilityId}</span> · Khách: <strong style="color:#fff">${ct.customerName}</strong></div>
                                </div>
                                <span class="badge ${badgeCls}">${statusLbl}</span>
                            </div>

                            <!-- Deposit indicator -->
                            <c:choose>
                                <c:when test="${ct.deposit != null && ct.deposit > 0}">
                                    <div class="deposit-indicator deposit-yes">✅ Đã đặt cọc — có thể duyệt ngay</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="deposit-indicator deposit-no">⚠️ Chưa đặt cọc — cần chờ xác nhận thanh toán</div>
                                </c:otherwise>
                            </c:choose>

                            <div class="info-row">
                                <div class="info-item">
                                    <div class="lbl">Đặt Cọc</div>
                                    <div class="val ${ct.deposit > 0 ? 'green' : 'yellow'}">
                                        <fmt:formatNumber value="${ct.deposit}" type="number" groupingUsed="true"/> đ
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Tổng Giá Trị</div>
                                    <div class="val gold"><fmt:formatNumber value="${ct.totalPayment}" type="number" groupingUsed="true"/> đ</div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Đã Thanh Toán</div>
                                    <div class="val green"><fmt:formatNumber value="${ct.paidAmount}" type="number" groupingUsed="true"/> đ</div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Còn Lại</div>
                                    <div class="val ${ct.remainingAmount > 0 ? 'yellow' : 'green'}">
                                        <c:choose>
                                            <c:when test="${ct.remainingAmount > 0}"><fmt:formatNumber value="${ct.remainingAmount}" type="number" groupingUsed="true"/> đ</c:when>
                                            <c:otherwise>✓ Đủ</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Nhận Phòng</div>
                                    <div class="val">${ct.startDate}</div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Trả Phòng</div>
                                    <div class="val">${ct.endDate}</div>
                                </div>
                                <c:if test="${not empty ct.employeeName}">
                                <div class="info-item">
                                    <div class="lbl">Nhân Viên</div>
                                    <div class="val">${ct.employeeName}</div>
                                </div>
                                </c:if>
                            </div>

                            <!-- Actions -->
                            <c:if test="${ct.status == 'DRAFT'}">
                            <%-- Tính % cọc theo loại facility từ facilityId prefix --%>
                            <c:choose>
                                <c:when test="${fn:startsWith(ct.facilityId, 'VL') || fn:startsWith(ct.facilityId, 'vl')}"><c:set var="depositPct" value="50"/><c:set var="facilityLabel" value="Villa"/></c:when>
                                <c:when test="${fn:startsWith(ct.facilityId, 'HS') || fn:startsWith(ct.facilityId, 'hs')}"><c:set var="depositPct" value="40"/><c:set var="facilityLabel" value="House"/></c:when>
                                <c:otherwise><c:set var="depositPct" value="30"/><c:set var="facilityLabel" value="Phòng"/></c:otherwise>
                            </c:choose>
                            <c:set var="depositPreview" value="${ct.totalPayment * depositPct / 100}"/>
                            <div class="card-actions">
                                <%-- Nút xác nhận đặt cọc --%>
                                <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                    <input type="hidden" name="action" value="confirm_deposit">
                                    <input type="hidden" name="contractId" value="${ct.contractId}">
                                    <button type="submit" class="btn-action btn-deposit"
                                        onclick="return confirm('Xác nhận đặt cọc ${depositPct}% = ${depositPreview} đ cho hợp đồng ${ct.contractId}?')">
                                        💰 Xác Nhận Đặt Cọc ${depositPct}% (<fmt:formatNumber value="${depositPreview}" type="number" groupingUsed="true"/> đ)
                                    </button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/dashboard/action" style="display:inline">
                                    <input type="hidden" name="action" value="reject_contract">
                                    <input type="hidden" name="contractId" value="${ct.contractId}">
                                    <button type="submit" class="btn-action btn-reject" onclick="return confirm('Từ chối hợp đồng này?')">❌ Từ Chối</button>
                                </form>
                            </div>
                            </c:if>
                            <c:if test="${ct.status == 'ACTIVE' && ct.remainingAmount <= 0}">
                            <div class="card-actions">
                                <span style="font-size:12px;color:#4ade80">✅ Đã thanh toán đủ — sẵn sàng hoàn tất</span>
                            </div>
                            </c:if>
                            <c:if test="${ct.status == 'ACTIVE' && ct.remainingAmount > 0}">
                            <div class="card-actions">
                                <button type="button" class="btn-action btn-complete"
                                    onclick="openPayModal('${ct.contractId}', ${ct.remainingAmount})">
                                    💳 Xác Nhận Thanh Toán Thêm
                                </button>
                            </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty"><div class="icon">📄</div><p>Không có hợp đồng nào</p></div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<script>
    const d = new Date();
    document.getElementById('topbarDate').textContent = d.toLocaleDateString('vi-VN',{weekday:'long',year:'numeric',month:'long',day:'numeric'});
</script>

<!-- PAYMENT MODAL -->
<div class="modal-overlay" id="payModal">
    <div class="modal">
        <h3>💳 Xác Nhận Thanh Toán Thêm</h3>
        <p class="modal-sub">Ghi nhận khoản thanh toán từ khách hàng</p>
        <div class="remaining-info">
            Còn phải trả: <strong id="modalRemaining">—</strong>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/dashboard/action">
            <input type="hidden" name="action" value="add_payment">
            <input type="hidden" name="contractId" id="modalContractId">
            <div class="modal-field">
                <label>Số Tiền (đ)</label>
                <input type="number" name="amount" id="modalAmount" min="1000" step="1000" required>
                <div class="modal-hint">Nhập số ngàn — VD: nhập <strong>5000</strong> = 5.000.000 đ</div>
            </div>
            <div class="modal-field">
                <label>Phương Thức</label>
                <select name="method">
                    <option value="CASH">Tiền mặt</option>
                    <option value="BANK_TRANSFER">Chuyển khoản</option>
                    <option value="CARD">Thẻ tín dụng</option>
                    <option value="MOMO">MoMo</option>
                </select>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closePayModal()">Huỷ</button>
                <button type="submit" class="btn-pay">Xác Nhận</button>
            </div>
        </form>
    </div>
</div>

<c:if test="${not empty sessionScope.flashMsg}">
<script>
    // Flash already shown in .flash div above, clear after 4s
    setTimeout(() => {
        const f = document.querySelector('.flash');
        if (f) { f.style.opacity='0'; f.style.transition='opacity 0.5s'; setTimeout(()=>f.remove(),500); }
    }, 4000);
</script>
</c:if>

<script>
    function openPayModal(contractId, remaining) {
        document.getElementById('modalContractId').value = contractId;
        document.getElementById('modalRemaining').textContent = new Intl.NumberFormat('vi-VN').format(remaining) + ' đ';
        // Mặc định = số tiền còn lại, làm tròn xuống ngàn, hiển thị dạng "ngàn đồng"
        const defaultVal = Math.floor(remaining / 1000) * 1000;
        document.getElementById('modalAmount').value = defaultVal;
        document.getElementById('modalAmount').max = remaining;
        document.getElementById('payModal').classList.add('open');
    }
    function closePayModal() {
        document.getElementById('payModal').classList.remove('open');
    }
    document.getElementById('payModal').addEventListener('click', function(e) {
        if (e.target === this) closePayModal();
    });
</script>
</body>
</html>
