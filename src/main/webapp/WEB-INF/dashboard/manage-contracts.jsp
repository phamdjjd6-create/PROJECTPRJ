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
:root{--gold:#c9a84c;--gold-light:#e8cc82;--dark:#0a0a0f;--card:rgba(255,255,255,0.03);--border:rgba(255,255,255,0.07);--text:#e8e8e8;--muted:rgba(255,255,255,0.45);--sidebar-w:256px}
body{font-family:'Inter',sans-serif;background:var(--dark);color:var(--text);min-height:100vh;display:flex}
.sidebar{width:var(--sidebar-w);flex-shrink:0;background:#080c14;border-right:1px solid rgba(201,168,76,0.12);display:flex;flex-direction:column;position:fixed;top:0;left:0;bottom:0;z-index:100}
.sidebar-brand{padding:28px 24px 22px;border-bottom:1px solid rgba(201,168,76,0.1)}
.brand-logo{font-family:'Playfair Display',serif;font-size:19px;font-weight:700;color:#fff}
.brand-logo span{color:var(--gold)}
.brand-tag{display:inline-block;margin-top:8px;font-size:9px;letter-spacing:2.5px;text-transform:uppercase;color:var(--dark);background:var(--gold);padding:3px 10px;border-radius:4px;font-weight:700}
.sidebar-user{padding:18px 24px;border-bottom:1px solid rgba(255,255,255,0.05);display:flex;align-items:center;gap:12px}
.user-avatar{width:38px;height:38px;border-radius:10px;background:linear-gradient(135deg,var(--gold),var(--gold-light));display:flex;align-items:center;justify-content:center;font-size:15px;font-weight:700;color:var(--dark);flex-shrink:0}
.user-name{font-size:13px;font-weight:600;color:#fff}
.user-role{font-size:11px;color:var(--gold);margin-top:2px}
.sidebar-nav{flex:1;padding:12px 0;overflow-y:auto}
.nav-section{padding:16px 24px 6px;font-size:9.5px;color:rgba(255,255,255,0.25);letter-spacing:2px;text-transform:uppercase;font-weight:600}
.nav-item{display:flex;align-items:center;gap:10px;padding:10px 24px;color:rgba(255,255,255,0.55);text-decoration:none;font-size:13px;font-weight:500;transition:all 0.18s;border-left:2px solid transparent}
.nav-item:hover{background:rgba(255,255,255,0.04);color:rgba(255,255,255,0.9)}
.nav-item.active{background:rgba(201,168,76,0.08);color:var(--gold);border-left-color:var(--gold)}
.nav-dot{width:5px;height:5px;border-radius:50%;background:rgba(255,255,255,0.2);flex-shrink:0}
.nav-item.active .nav-dot{background:var(--gold)}
.sidebar-footer{padding:16px 24px;border-top:1px solid rgba(255,255,255,0.05)}
.btn-logout{display:flex;align-items:center;gap:10px;color:rgba(248,113,113,0.6);font-size:13px;text-decoration:none;padding:8px 0;transition:color 0.2s}
.btn-logout:hover{color:#f87171}
.main{margin-left:var(--sidebar-w);flex:1;display:flex;flex-direction:column;min-height:100vh}
.topbar{height:60px;background:rgba(8,12,20,0.97);border-bottom:1px solid rgba(201,168,76,0.08);display:flex;align-items:center;justify-content:space-between;padding:0 36px;position:sticky;top:0;z-index:50;backdrop-filter:blur(20px)}
.topbar-title{font-family:'Playfair Display',serif;font-size:17px;color:#fff}
.content{padding:32px 36px 60px;flex:1}
.section-label{font-size:9.5px;color:var(--gold);letter-spacing:2.5px;text-transform:uppercase;font-weight:600;margin-bottom:4px}
.section-title{font-family:'Playfair Display',serif;font-size:22px;color:#fff;margin-bottom:24px}
</style>
<style>
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
.tab{padding:7px 16px;border-radius:50px;font-size:12.5px;font-weight:600;border:1.5px solid var(--border);color:var(--muted);background:transparent;cursor:pointer;transition:all 0.2s}
.tab:hover{border-color:rgba(201,168,76,0.4);color:var(--gold)}
.tab.active{background:var(--gold);color:var(--dark);border-color:var(--gold)}
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
.deposit-indicator{display:flex;align-items:center;gap:8px;padding:10px 16px;border-radius:10px;margin-bottom:16px;font-size:13px;font-weight:600}
.deposit-yes{background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.2);color:#4ade80}
.deposit-no{background:rgba(251,191,36,0.08);border:1px solid rgba(251,191,36,0.2);color:#fbbf24}
.card-actions{display:flex;gap:10px;padding-top:16px;border-top:1px solid var(--border);flex-wrap:wrap}
.btn-action{padding:8px 20px;border-radius:50px;font-size:12.5px;font-weight:600;border:none;cursor:pointer;transition:all 0.25s;font-family:'Inter',sans-serif}
.btn-deposit{background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--dark);font-weight:700}
.btn-deposit:hover{transform:scale(1.04);box-shadow:0 6px 20px rgba(201,168,76,0.35)}
.btn-reject{background:rgba(248,113,113,0.1);color:#f87171;border:1px solid rgba(248,113,113,0.3)}
.btn-reject:hover{background:#f87171;color:#fff}
.btn-complete{background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--dark)}
.btn-complete:hover{transform:scale(1.04)}
.empty{padding:60px;text-align:center;color:var(--muted)}
.empty .icon{font-size:48px;margin-bottom:12px;opacity:0.3}
.modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,0.75);z-index:2000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(4px)}
.modal-overlay.open{display:flex}
.modal{background:#0d1526;border:1px solid rgba(201,168,76,0.2);border-radius:24px;padding:36px;width:100%;max-width:440px}
.modal h3{font-family:'Playfair Display',serif;font-size:20px;color:#fff;margin-bottom:6px}
.modal-sub{color:var(--muted);font-size:13px;margin-bottom:20px}
.remaining-info{background:rgba(251,191,36,0.08);border:1px solid rgba(251,191,36,0.2);border-radius:12px;padding:12px 16px;margin-bottom:20px;font-size:13px;color:#fbbf24}
.modal-field{margin-bottom:16px}
.modal-field label{display:block;font-size:11px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;font-weight:600;margin-bottom:8px}
.modal-field input,.modal-field select{width:100%;background:rgba(0,0,0,0.3);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:12px 16px;color:#fff;font-size:14px;font-family:'Inter',sans-serif;outline:none;transition:border-color 0.2s}
.modal-field input:focus,.modal-field select:focus{border-color:var(--gold)}
.modal-field select option{background:#0d1526}
.modal-hint{font-size:11px;color:var(--muted);margin-top:5px}
.modal-actions{display:flex;gap:10px;margin-top:24px}
.btn-cancel{flex:1;padding:12px;border-radius:50px;background:transparent;border:1.5px solid rgba(255,255,255,0.15);color:var(--muted);font-size:13px;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.2s}
.btn-cancel:hover{color:#fff;border-color:rgba(255,255,255,0.3)}
.btn-pay{flex:2;padding:12px;border-radius:50px;background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--dark);font-size:13px;font-weight:700;border:none;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.25s}
.btn-pay:hover{transform:scale(1.03)}
@media(max-width:768px){
  .sidebar{transform:translateX(-100%);transition:transform 0.3s ease;z-index:200}
  .sidebar.open{transform:translateX(0)}
  .main{margin-left:0!important}
  .topbar{padding:0 16px}
  .content{padding:20px 16px 40px}
  .stats-row{flex-direction:column}
  .section-title{font-size:18px}
  .topbar-title{font-size:15px}
  #menuToggle{display:block!important}
  .filter-tabs{overflow-x:auto;flex-wrap:nowrap;padding-bottom:4px}
  .toolbar{flex-direction:column;align-items:stretch}
  .search-box{max-width:100%}
  .info-row{flex-direction:column;gap:12px}
  .card-body{padding:16px 18px}
}
</style>
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-brand">
    <div class="brand-logo">Azure <span>Resort</span></div>
    <div class="brand-tag">${isAdmin ? 'Admin Panel' : 'Staff Portal'}</div>
  </div>
  <div class="sidebar-user">
    <div class="user-avatar">${acc.fullName.substring(0,1)}</div>
    <div>
      <div class="user-name">${acc.fullName}</div>
      <div class="user-role">${isAdmin ? 'Quan Tri Vien' : 'Nhan Vien'}</div>
    </div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section">Tong Quan</div>
    <a href="${pageContext.request.contextPath}/dashboard/${isAdmin ? 'admin' : 'staff'}" class="nav-item"><span class="nav-dot"></span> Dashboard</a>
    <div class="nav-section">Van Hanh</div>
    <a href="${pageContext.request.contextPath}/dashboard/bookings" class="nav-item"><span class="nav-dot"></span> Booking</a>
    <a href="${pageContext.request.contextPath}/dashboard/contracts" class="nav-item active"><span class="nav-dot"></span> Hop Dong</a>
    <div class="nav-section">Quan Ly</div>
    <a href="${pageContext.request.contextPath}/dashboard/users" class="nav-item"><span class="nav-dot"></span> Nguoi Dung</a>
    <a href="${pageContext.request.contextPath}/dashboard/facilities" class="nav-item"><span class="nav-dot"></span> Phong &amp; Villa</a>
    <div class="nav-section">Ca Nhan</div>
    <a href="${pageContext.request.contextPath}/profile" class="nav-item"><span class="nav-dot"></span> Ho So</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/" class="btn-logout" style="color:rgba(201,168,76,0.7);margin-bottom:6px">Trang Chu</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Dang Xuat</a>
  </div>
</aside>

<div class="main">
  <div class="topbar">
    <button id="menuToggle" style="display:none;background:none;border:none;color:#fff;font-size:22px;cursor:pointer;padding:4px 8px">&#9776;</button>
    <div class="topbar-title">Duyet Hop Dong</div>
    <span style="font-size:12px;color:var(--muted)" id="topbarDate"></span>
  </div>
  <div class="content">
    <div class="section-label">Quan Ly</div>
    <div class="section-title">Hop Dong Phong</div>

    <c:if test="${not empty flashMsg}">
      <c:choose>
        <c:when test="${fn:startsWith(flashMsg, '&#x2705;')}"><div class="flash flash-success">${flashMsg}</div></c:when>
        <c:when test="${fn:startsWith(flashMsg, '&#x26A0;')}"><div class="flash flash-warn">${flashMsg}</div></c:when>
        <c:otherwise><div class="flash flash-error">${flashMsg}</div></c:otherwise>
      </c:choose>
    </c:if>

    <div class="stats-row">
      <a href="?status=DRAFT" class="stat-pill yellow"><div><div class="num">${cntDraft}</div><div class="lbl">Cho Duyet</div></div></a>
      <a href="?status=ACTIVE" class="stat-pill green"><div><div class="num">${cntActive}</div><div class="lbl">Dang Hieu Luc</div></div></a>
      <a href="?status=COMPLETED" class="stat-pill gold"><div><div class="num">${cntCompleted}</div><div class="lbl">Hoan Thanh</div></div></a>
    </div>

    <form method="get" action="${pageContext.request.contextPath}/dashboard/contracts" id="searchForm">
      <div class="toolbar">
        <div class="search-box">
          <span>&#128269;</span>
          <input type="text" id="searchInput" name="q" placeholder="Tim ma hop dong, ten khach..." value="${search}" autocomplete="off">
        </div>
        <div class="filter-tabs" id="filterTabs">
          <button type="button" class="tab ${statusFilter == 'ALL'       ? 'active' : ''}" data-status="ALL">Tat Ca</button>
          <button type="button" class="tab ${statusFilter == 'DRAFT'     ? 'active' : ''}" data-status="DRAFT">Cho Duyet</button>
          <button type="button" class="tab ${statusFilter == 'ACTIVE'    ? 'active' : ''}" data-status="ACTIVE">Hieu Luc</button>
          <button type="button" class="tab ${statusFilter == 'COMPLETED' ? 'active' : ''}" data-status="COMPLETED">Hoan Thanh</button>
          <button type="button" class="tab ${statusFilter == 'CANCELLED' ? 'active' : ''}" data-status="CANCELLED">Da Huy</button>
        </div>
      </div>
    </form>

    <div id="contractsContainer">
      <c:choose>
        <c:when test="${not empty contracts}">
          <div class="contracts-list" id="contractsList">
          <c:forEach var="ct" items="${contracts}">
            <c:choose>
              <c:when test="${ct.status == 'ACTIVE'}"><c:set var="aCls" value="accent-active"/><c:set var="bCls" value="badge-active"/><c:set var="sLbl" value="Dang Hieu Luc"/></c:when>
              <c:when test="${ct.status == 'COMPLETED'}"><c:set var="aCls" value="accent-completed"/><c:set var="bCls" value="badge-completed"/><c:set var="sLbl" value="Hoan Thanh"/></c:when>
              <c:when test="${ct.status == 'CANCELLED'}"><c:set var="aCls" value="accent-cancelled"/><c:set var="bCls" value="badge-cancelled"/><c:set var="sLbl" value="Da Huy"/></c:when>
              <c:otherwise><c:set var="aCls" value="accent-draft"/><c:set var="bCls" value="badge-draft"/><c:set var="sLbl" value="Cho Duyet"/></c:otherwise>
            </c:choose>
            <div class="contract-card" id="card-${ct.contractId}">
              <div class="card-accent ${aCls}"></div>
              <div class="card-body">
                <div class="card-top">
                  <div>
                    <div class="card-id">${ct.contractId}</div>
                    <div class="card-meta">Booking: ${ct.bookingId} &middot; Phong: <span style="color:var(--gold)">${ct.facilityId}</span> &middot; Khach: <strong style="color:#fff">${ct.customerName}</strong></div>
                  </div>
                  <span class="badge ${bCls}">${sLbl}</span>
                </div>
                <c:choose>
                  <c:when test="${ct.deposit != null && ct.deposit > 0}">
                    <div class="deposit-indicator deposit-yes">Da dat coc - co the duyet ngay</div>
                  </c:when>
                  <c:otherwise>
                    <div class="deposit-indicator deposit-no">Chua dat coc - can cho xac nhan thanh toan</div>
                  </c:otherwise>
                </c:choose>
                <div class="info-row">
                  <div class="info-item">
                    <div class="lbl">Dat Coc</div>
                    <c:choose>
                      <c:when test="${ct.deposit > 0}"><div class="val green"><fmt:formatNumber value="${ct.deposit}" type="number" groupingUsed="true"/> d</div></c:when>
                      <c:otherwise><div class="val yellow"><fmt:formatNumber value="${ct.deposit}" type="number" groupingUsed="true"/> d</div></c:otherwise>
                    </c:choose>
                  </div>
                  <div class="info-item">
                    <div class="lbl">Tong Gia Tri</div>
                    <div class="val gold"><fmt:formatNumber value="${ct.totalPayment}" type="number" groupingUsed="true"/> d</div>
                  </div>
                  <div class="info-item">
                    <div class="lbl">Da Thanh Toan</div>
                    <div class="val green"><fmt:formatNumber value="${ct.paidAmount}" type="number" groupingUsed="true"/> d</div>
                  </div>
                  <div class="info-item">
                    <div class="lbl">Con Lai</div>
                    <c:choose>
                      <c:when test="${ct.remainingAmount > 0}"><div class="val yellow"><fmt:formatNumber value="${ct.remainingAmount}" type="number" groupingUsed="true"/> d</div></c:when>
                      <c:otherwise><div class="val green">Du</div></c:otherwise>
                    </c:choose>
                  </div>
                  <div class="info-item"><div class="lbl">Nhan Phong</div><div class="val">${ct.startDate}</div></div>
                  <div class="info-item"><div class="lbl">Tra Phong</div><div class="val">${ct.endDate}</div></div>
                  <c:if test="${not empty ct.employeeName}">
                    <div class="info-item"><div class="lbl">Nhan Vien</div><div class="val">${ct.employeeName}</div></div>
                  </c:if>
                </div>
                <c:if test="${ct.status == 'DRAFT'}">
                  <c:choose>
                    <c:when test="${fn:startsWith(ct.facilityId, 'VL') || fn:startsWith(ct.facilityId, 'vl')}"><c:set var="dPct" value="50"/></c:when>
                    <c:when test="${fn:startsWith(ct.facilityId, 'HS') || fn:startsWith(ct.facilityId, 'hs')}"><c:set var="dPct" value="40"/></c:when>
                    <c:otherwise><c:set var="dPct" value="30"/></c:otherwise>
                  </c:choose>
                  <c:set var="dPreview" value="${ct.totalPayment * dPct / 100}"/>
                  <div class="card-actions">
                    <button type="button" class="btn-action btn-deposit"
                      data-contract="${ct.contractId}" data-pct="${dPct}" data-preview="${dPreview}"
                      onclick="ajaxConfirmDeposit(this)">
                      Xac Nhan Dat Coc ${dPct}% (<fmt:formatNumber value="${dPreview}" type="number" groupingUsed="true"/> d)
                    </button>
                    <button type="button" class="btn-action btn-reject"
                      data-contract="${ct.contractId}"
                      onclick="ajaxReject(this)">Tu Choi</button>
                  </div>
                </c:if>
                <c:if test="${ct.status == 'ACTIVE' && ct.remainingAmount <= 0}">
                  <div class="card-actions"><span style="font-size:12px;color:#4ade80">Da thanh toan du - san sang hoan tat</span></div>
                </c:if>
                <c:if test="${ct.status == 'ACTIVE' && ct.remainingAmount > 0}">
                  <div class="card-actions">
                    <button type="button" class="btn-action btn-complete"
                      data-contract="${ct.contractId}" data-remaining="${ct.remainingAmount}"
                      onclick="openPayModal(this.dataset.contract, this.dataset.remaining)">
                      Xac Nhan Thanh Toan Them
                    </button>
                  </div>
                </c:if>
              </div>
            </div>
          </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty"><div class="icon">&#128196;</div><p>Khong co hop dong nao</p></div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<div class="modal-overlay" id="payModal">
  <div class="modal">
    <h3>Xac Nhan Thanh Toan Them</h3>
    <p class="modal-sub">Ghi nhan khoan thanh toan tu khach hang</p>
    <div class="remaining-info">Con phai tra: <strong id="modalRemaining">-</strong></div>
    <form id="payForm" method="post" action="${pageContext.request.contextPath}/dashboard/action">
      <input type="hidden" name="action" value="add_payment">
      <input type="hidden" name="contractId" id="modalContractId">
      <div class="modal-field">
        <label>So Tien (d)</label>
        <input type="number" name="amount" id="modalAmount" min="1000" step="1000" required>
        <div class="modal-hint">VD: nhap 5000000 = 5.000.000 d</div>
      </div>
      <div class="modal-field">
        <label>Phuong Thuc</label>
        <select name="method">
          <option value="CASH">Tien mat</option>
          <option value="BANK_TRANSFER">Chuyen khoan</option>
          <option value="CARD">The tin dung</option>
          <option value="MOMO">MoMo</option>
        </select>
      </div>
      <div class="modal-actions">
        <button type="button" class="btn-cancel" onclick="closePayModal()">Huy</button>
        <button type="submit" class="btn-pay" id="paySubmitBtn">Xac Nhan</button>
      </div>
    </form>
  </div>
</div>

<div id="sidebarOverlay" onclick="document.querySelector('.sidebar').classList.remove('open');this.style.display='none'" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:199"></div>
<script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
<script>
(function() {
    // Date
    document.getElementById('topbarDate').textContent =
        new Date().toLocaleDateString('vi-VN',{weekday:'long',year:'numeric',month:'long',day:'numeric'});

    // Sidebar
    var menuBtn = document.getElementById('menuToggle');
    var sidebar = document.querySelector('.sidebar');
    var overlay = document.getElementById('sidebarOverlay');
    if (menuBtn) {
        menuBtn.addEventListener('click', function() {
            sidebar.classList.toggle('open');
            overlay.style.display = sidebar.classList.contains('open') ? 'block' : 'none';
        });
    }

    // Config
    var BASE_URL = '${pageContext.request.contextPath}/dashboard/contracts';
    var ACTION_URL = '${pageContext.request.contextPath}/dashboard/action';
    var currentStatus = '${statusFilter}';
    var currentSearch = '';
    var debounceTimer = null;
    var fmtNum = new Intl.NumberFormat('vi-VN');

    function fmtMoney(v) { return fmtNum.format(Number(v) || 0) + ' d'; }

    var STATUS_MAP = {
        DRAFT:     { cls: 'accent-draft',    badge: 'badge-draft',    lbl: 'Cho Duyet' },
        ACTIVE:    { cls: 'accent-active',   badge: 'badge-active',   lbl: 'Dang Hieu Luc' },
        COMPLETED: { cls: 'accent-completed',badge: 'badge-completed',lbl: 'Hoan Thanh' },
        CANCELLED: { cls: 'accent-cancelled',badge: 'badge-cancelled',lbl: 'Da Huy' }
    };
    function si(s) { return STATUS_MAP[s] || STATUS_MAP['DRAFT']; }

    function depositPct(fid) {
        if (!fid) return 30;
        var u = fid.toUpperCase();
        if (u.indexOf('VL') === 0) return 50;
        if (u.indexOf('HS') === 0) return 40;
        return 30;
    }

    function renderCard(ct) {
        var info = si(ct.status);
        var pct = depositPct(ct.facilityId);
        var preview = Math.round(Number(ct.totalPayment) * pct / 100);
        var hasDeposit = Number(ct.deposit) > 0;
        var remaining = Number(ct.remainingAmount);

        var depHtml = hasDeposit
            ? '<div class="deposit-indicator deposit-yes">Da dat coc - co the duyet ngay</div>'
            : '<div class="deposit-indicator deposit-no">Chua dat coc - can cho xac nhan</div>';

        var remHtml = remaining > 0
            ? '<div class="val yellow">' + fmtMoney(remaining) + '</div>'
            : '<div class="val green">Du</div>';

        var empHtml = ct.employeeName
            ? '<div class="info-item"><div class="lbl">Nhan Vien</div><div class="val">' + ct.employeeName + '</div></div>'
            : '';

        var actHtml = '';
        if (ct.status === 'DRAFT') {
            actHtml = '<div class="card-actions">'
                + '<button type="button" class="btn-action btn-deposit"'
                + ' data-contract="' + ct.contractId + '" data-pct="' + pct + '" data-preview="' + preview + '"'
                + ' onclick="ajaxConfirmDeposit(this)">'
                + 'Xac Nhan Dat Coc ' + pct + '% (' + fmtMoney(preview) + ')'
                + '</button>'
                + '<button type="button" class="btn-action btn-reject"'
                + ' data-contract="' + ct.contractId + '" onclick="ajaxReject(this)">Tu Choi</button>'
                + '</div>';
        } else if (ct.status === 'ACTIVE' && remaining > 0) {
            actHtml = '<div class="card-actions">'
                + '<button type="button" class="btn-action btn-complete"'
                + ' data-contract="' + ct.contractId + '" data-remaining="' + remaining + '"'
                + ' onclick="openPayModal(this.dataset.contract,this.dataset.remaining)">'
                + 'Xac Nhan Thanh Toan Them</button></div>';
        } else if (ct.status === 'ACTIVE' && remaining <= 0) {
            actHtml = '<div class="card-actions"><span style="font-size:12px;color:#4ade80">Da thanh toan du</span></div>';
        }

        return '<div class="contract-card" id="card-' + ct.contractId + '" style="opacity:0;transform:translateY(8px);transition:opacity 0.3s,transform 0.3s">'
            + '<div class="card-accent ' + info.cls + '"></div>'
            + '<div class="card-body">'
            + '<div class="card-top"><div>'
            + '<div class="card-id">' + ct.contractId + '</div>'
            + '<div class="card-meta">Booking: ' + (ct.bookingId||'') + ' &middot; Phong: <span style="color:var(--gold)">' + (ct.facilityId||'') + '</span> &middot; Khach: <strong style="color:#fff">' + (ct.customerName||'') + '</strong></div>'
            + '</div><span class="badge ' + info.badge + '">' + info.lbl + '</span></div>'
            + depHtml
            + '<div class="info-row">'
            + '<div class="info-item"><div class="lbl">Dat Coc</div><div class="val ' + (hasDeposit?'green':'yellow') + '">' + fmtMoney(ct.deposit) + '</div></div>'
            + '<div class="info-item"><div class="lbl">Tong Gia Tri</div><div class="val gold">' + fmtMoney(ct.totalPayment) + '</div></div>'
            + '<div class="info-item"><div class="lbl">Da Thanh Toan</div><div class="val green">' + fmtMoney(ct.paidAmount) + '</div></div>'
            + '<div class="info-item"><div class="lbl">Con Lai</div>' + remHtml + '</div>'
            + '<div class="info-item"><div class="lbl">Nhan Phong</div><div class="val">' + (ct.startDate||'') + '</div></div>'
            + '<div class="info-item"><div class="lbl">Tra Phong</div><div class="val">' + (ct.endDate||'') + '</div></div>'
            + empHtml
            + '</div>'
            + actHtml
            + '</div></div>';
    }

    function renderContracts(list) {
        var container = document.getElementById('contractsContainer');
        if (!list || list.length === 0) {
            container.innerHTML = '<div class="empty"><div class="icon">&#128196;</div><p>Khong co hop dong nao</p></div>';
            return;
        }
        var html = '<div class="contracts-list" id="contractsList">';
        for (var i = 0; i < list.length; i++) html += renderCard(list[i]);
        html += '</div>';
        container.innerHTML = html;
        requestAnimationFrame(function() {
            var cards = document.querySelectorAll('.contract-card');
            for (var i = 0; i < cards.length; i++) {
                (function(card, idx) {
                    setTimeout(function() { card.style.opacity='1'; card.style.transform='translateY(0)'; }, idx * 40);
                })(cards[i], i);
            }
        });
    }

    function updateCounts(counts) {
        if (!counts) return;
        var d = document.querySelector('.stat-pill.yellow .num');
        var a = document.querySelector('.stat-pill.green .num');
        var c = document.querySelector('.stat-pill.gold .num');
        if (d) d.textContent = counts.DRAFT || 0;
        if (a) a.textContent = counts.ACTIVE || 0;
        if (c) c.textContent = counts.COMPLETED || 0;
    }

    function loadContracts(status, search) {
        var container = document.getElementById('contractsContainer');
        var spinner = api.showSpinner(container);
        container.style.minHeight = '120px';
        api.get(BASE_URL, { status: status || 'ALL', q: search || '', format: 'json' })
            .then(function(data) {
                api.hideSpinner(spinner);
                container.style.minHeight = '';
                renderContracts(data.contracts);
                updateCounts(data.counts);
                var qs = 'status=' + encodeURIComponent(status || 'ALL');
                if (search) qs += '&q=' + encodeURIComponent(search);
                history.replaceState(null, '', BASE_URL + '?' + qs);
            })
            .catch(function(err) {
                api.hideSpinner(spinner);
                container.style.minHeight = '';
                api.toast('Loi tai danh sach: ' + err.message, 'error');
            });
    }

    // Filter tabs
    document.getElementById('filterTabs').addEventListener('click', function(e) {
        var btn = e.target.closest('[data-status]');
        if (!btn) return;
        var tabs = document.querySelectorAll('#filterTabs .tab');
        for (var i = 0; i < tabs.length; i++) tabs[i].classList.remove('active');
        btn.classList.add('active');
        currentStatus = btn.dataset.status;
        loadContracts(currentStatus, currentSearch);
    });

    // Stat pills
    var pills = document.querySelectorAll('.stat-pill');
    for (var i = 0; i < pills.length; i++) {
        pills[i].addEventListener('click', function(e) {
            e.preventDefault();
            var href = this.getAttribute('href') || '';
            var m = href.match(/status=(\w+)/);
            if (m) {
                currentStatus = m[1];
                var tabs = document.querySelectorAll('#filterTabs .tab');
                for (var j = 0; j < tabs.length; j++)
                    tabs[j].classList.toggle('active', tabs[j].dataset.status === currentStatus);
                loadContracts(currentStatus, currentSearch);
            }
        });
    }

    // Debounced search
    document.getElementById('searchInput').addEventListener('input', function() {
        clearTimeout(debounceTimer);
        var val = this.value.trim();
        debounceTimer = setTimeout(function() {
            currentSearch = val;
            loadContracts(currentStatus, currentSearch);
        }, 380);
    });
    document.getElementById('searchForm').addEventListener('submit', function(e) { e.preventDefault(); });

    // AJAX actions
    window.ajaxConfirmDeposit = function(btn) {
        var id = btn.dataset.contract;
        var pct = btn.dataset.pct;
        var preview = Number(btn.dataset.preview);
        if (!confirm('Xac nhan dat coc ' + pct + '% = ' + fmtMoney(preview) + ' cho hop dong ' + id + '?')) return;
        btn.disabled = true;
        btn.textContent = 'Dang xu ly...';
        api.post(ACTION_URL, { action: 'confirm_deposit', contractId: id })
            .then(function(data) {
                api.toast(data.message, 'success');
                updateCardStatus(id, data.status);
            })
            .catch(function(err) {
                api.toast(err.message, 'error');
                btn.disabled = false;
                btn.textContent = 'Xac Nhan Dat Coc ' + pct + '%';
            });
    };

    window.ajaxReject = function(btn) {
        var id = btn.dataset.contract;
        if (!confirm('Tu choi hop dong ' + id + '?')) return;
        btn.disabled = true;
        btn.textContent = 'Dang xu ly...';
        api.post(ACTION_URL, { action: 'reject_contract', contractId: id })
            .then(function() {
                api.toast('Hop dong da bi tu choi.', 'warn');
                updateCardStatus(id, 'CANCELLED');
            })
            .catch(function(err) {
                api.toast(err.message, 'error');
                btn.disabled = false;
                btn.textContent = 'Tu Choi';
            });
    };

    function updateCardStatus(contractId, newStatus) {
        var card = document.getElementById('card-' + contractId);
        if (!card) { loadContracts(currentStatus, currentSearch); return; }
        var info = si(newStatus);
        var accent = card.querySelector('.card-accent');
        if (accent) accent.className = 'card-accent ' + info.cls;
        var badge = card.querySelector('.badge');
        if (badge) { badge.className = 'badge ' + info.badge; badge.textContent = info.lbl; }
        var actions = card.querySelector('.card-actions');
        if (actions) {
            if (newStatus === 'CANCELLED') actions.remove();
            else if (newStatus === 'ACTIVE') actions.innerHTML = '<span style="font-size:12px;color:#4ade80">Hop dong da kich hoat</span>';
        }
        card.style.transition = 'box-shadow 0.4s,border-color 0.4s';
        card.style.borderColor = newStatus === 'CANCELLED' ? 'rgba(248,113,113,0.4)' : 'rgba(74,222,128,0.4)';
        setTimeout(function() { card.style.borderColor = ''; }, 1800);
    }

    // Payment modal
    window.openPayModal = function(contractId, remaining) {
        document.getElementById('modalContractId').value = contractId;
        document.getElementById('modalRemaining').textContent = fmtMoney(remaining);
        document.getElementById('modalAmount').value = Math.floor(Number(remaining) / 1000) * 1000;
        document.getElementById('modalAmount').max = remaining;
        document.getElementById('payModal').classList.add('open');
    };
    window.closePayModal = function() { document.getElementById('payModal').classList.remove('open'); };
    document.getElementById('payModal').addEventListener('click', function(e) { if (e.target === this) closePayModal(); });

    document.getElementById('payForm').addEventListener('submit', function(e) {
        e.preventDefault();
        var fd = new FormData(this);
        var contractId = fd.get('contractId');
        var submitBtn = document.getElementById('paySubmitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Dang xu ly...';
        api.post(ACTION_URL, fd)
            .then(function(data) {
                closePayModal();
                api.toast(data.message, 'success');
                updateCardStatus(contractId, data.status);
                setTimeout(function() { loadContracts(currentStatus, currentSearch); }, 800);
            })
            .catch(function(err) {
                api.toast(err.message, 'error');
                submitBtn.disabled = false;
                submitBtn.textContent = 'Xac Nhan';
            });
    });
})();
</script>
</body>
</html>
