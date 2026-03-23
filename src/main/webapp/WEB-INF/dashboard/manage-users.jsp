<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TblPersons, model.TblEmployees" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
TblPersons acc = (TblPersons) session.getAttribute("account");
if (acc == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
boolean isAdmin = (acc instanceof TblEmployees) && "ADMIN".equals(((TblEmployees)acc).getRole());
pageContext.setAttribute("isAdmin", isAdmin);
String firstChar = (acc.getFullName() != null && !acc.getFullName().isEmpty()) ? String.valueOf(acc.getFullName().charAt(0)) : "?";
pageContext.setAttribute("firstChar", firstChar);
pageContext.setAttribute("roleLabel", isAdmin ? "Quản Trị Viên" : "Nhân Viên");
pageContext.setAttribute("panelLabel", isAdmin ? "Admin Panel" : "Staff Portal");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quản Lý Người Dùng — Azure Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
:root{--gold:#c9a84c;--gold-light:#e8cc82;--dark:#0a0a0f;--navy:#0d1526;--card:rgba(255,255,255,0.03);--border:rgba(255,255,255,0.07);--text:#e8e8e8;--muted:rgba(255,255,255,0.45);--sidebar-w:256px}
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
.stats-row{display:flex;gap:16px;margin-bottom:28px;flex-wrap:wrap}
.stat-pill{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:16px 24px;display:flex;align-items:center;gap:14px}
.stat-pill .num{font-family:'Inter',sans-serif;font-size:28px;font-weight:700;letter-spacing:-1px}
.stat-pill .lbl{font-size:12px;color:var(--muted)}
.stat-pill.gold .num{color:var(--gold)}
.stat-pill.blue .num{color:#60a5fa}
.taskbar{display:flex;background:rgba(255,255,255,0.02);border:1px solid var(--border);border-radius:12px;padding:4px;gap:4px;margin-bottom:28px;width:fit-content}
.taskbar-btn{display:flex;align-items:center;gap:8px;padding:10px 20px;border-radius:8px;border:none;background:transparent;color:var(--muted);font-size:13px;font-weight:600;cursor:pointer;transition:all 0.2s;font-family:'Inter',sans-serif;white-space:nowrap}
.taskbar-btn:hover{color:#fff;background:rgba(255,255,255,0.04)}
.taskbar-btn.active{background:var(--gold);color:var(--dark)}
.taskbar-btn .tab-count{background:rgba(0,0,0,0.2);padding:1px 7px;border-radius:50px;font-size:10px;font-weight:700}
.taskbar-btn.active .tab-count{background:rgba(0,0,0,0.25)}
.tab-panel{display:none}
.tab-panel.active{display:block}
.panel-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:18px;flex-wrap:wrap;gap:12px}
.panel-header-left{display:flex;align-items:center;gap:12px;flex-wrap:wrap;flex:1}
.panel-title{font-family:'Playfair Display',serif;font-size:19px;color:#fff;white-space:nowrap}
.panel-count{font-size:12px;color:var(--muted);background:rgba(255,255,255,0.06);padding:3px 10px;border-radius:50px;white-space:nowrap}
.panel-search{display:flex;align-items:center;gap:8px;background:rgba(255,255,255,0.05);border:1px solid var(--border);border-radius:10px;padding:8px 14px;min-width:200px;max-width:340px;transition:border-color 0.2s;flex:1}
.panel-search:focus-within{border-color:rgba(201,168,76,0.4)}
.panel-search input{background:none;border:none;outline:none;color:#fff;font-size:13px;width:100%;font-family:'Inter',sans-serif}
.panel-search input::placeholder{color:var(--muted)}
.btn-view-all{padding:7px 16px;background:rgba(201,168,76,0.08);color:var(--gold);border:1px solid rgba(201,168,76,0.25);border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.2s;white-space:nowrap}
.btn-view-all:hover{background:rgba(201,168,76,0.15)}
.btn-add{padding:8px 16px;background:rgba(74,222,128,0.1);color:#4ade80;border:1px solid rgba(74,222,128,0.3);border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.2s;white-space:nowrap}
.btn-add:hover{background:#4ade80;color:#000}
.table-wrap{background:var(--card);border:1px solid var(--border);border-radius:16px;overflow:hidden}
table{width:100%;border-collapse:collapse}
th{padding:12px 18px;text-align:left;font-size:9.5px;color:var(--muted);letter-spacing:1.5px;text-transform:uppercase;font-weight:600;border-bottom:1px solid var(--border);white-space:nowrap}
td{padding:13px 18px;font-size:13px;color:var(--text);border-bottom:1px solid rgba(255,255,255,0.04);vertical-align:middle}
tr:last-child td{border-bottom:none}
tr:hover td{background:rgba(255,255,255,0.02)}
.id-cell{color:var(--gold);font-weight:700;font-size:12px;letter-spacing:0.5px}
.muted-cell{color:rgba(255,255,255,0.5);font-size:12.5px}
.money-cell{color:var(--gold);font-weight:600}
.badge{display:inline-flex;align-items:center;gap:3px;padding:3px 10px;border-radius:4px;font-size:10.5px;font-weight:700}
.badge-diamond{background:rgba(201,168,76,0.15);color:var(--gold);border:1px solid rgba(201,168,76,0.3)}
.badge-gold{background:rgba(234,179,8,0.15);color:#eab308;border:1px solid rgba(234,179,8,0.3)}
.badge-silver{background:rgba(148,163,184,0.15);color:#94a3b8;border:1px solid rgba(148,163,184,0.3)}
.badge-normal{background:rgba(255,255,255,0.06);color:var(--muted);border:1px solid rgba(255,255,255,0.1)}
.badge-admin{background:rgba(201,168,76,0.12);color:var(--gold)}
.badge-staff{background:rgba(96,165,250,0.12);color:#60a5fa}
.badge-active{background:rgba(74,222,128,0.12);color:#4ade80}
.badge-locked{background:rgba(248,113,113,0.12);color:#f87171}
.btn-sm{padding:5px 12px;border-radius:4px;font-size:11.5px;font-weight:600;border:none;cursor:pointer;transition:all 0.2s;font-family:'Inter',sans-serif}
.btn-edit{background:rgba(201,168,76,0.1);color:var(--gold);border:1px solid rgba(201,168,76,0.3)}
.btn-edit:hover{background:var(--gold);color:var(--dark)}
.btn-voucher{background:rgba(74,222,128,0.1);color:#4ade80;border:1px solid rgba(74,222,128,0.3)}
.btn-voucher:hover{background:#4ade80;color:#000}
.btn-voucher-done{background:rgba(255,255,255,0.04);color:var(--muted);border:1px solid rgba(255,255,255,0.08);cursor:not-allowed}
.btn-delete{background:rgba(248,113,113,0.1);color:#f87171;border:1px solid rgba(248,113,113,0.3)}
.btn-delete:hover{background:#f87171;color:#fff}
.flash{padding:12px 18px;border-radius:8px;margin-bottom:20px;font-size:13px;display:flex;align-items:center;gap:10px}
.flash-success{background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.25);color:#4ade80}
.flash-error{background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.25);color:#f87171}
.empty{padding:60px;text-align:center;color:var(--muted);font-size:13.5px}
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,0.75);z-index:999;align-items:center;justify-content:center;backdrop-filter:blur(6px)}
.modal-overlay.open{display:flex}
.modal-box{background:#0d1526;border:1px solid rgba(201,168,76,0.25);border-radius:16px;width:460px;padding:32px;box-shadow:0 20px 60px rgba(0,0,0,0.6);max-height:90vh;overflow-y:auto}
.modal-hdr{display:flex;justify-content:space-between;align-items:center;margin-bottom:24px}
.modal-sub{font-size:10px;letter-spacing:2px;text-transform:uppercase;margin-bottom:4px}
.modal-title{font-family:'Playfair Display',serif;font-size:20px;color:#fff}
.modal-close{background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.1);color:#fff;width:32px;height:32px;border-radius:8px;cursor:pointer;font-size:14px}
.form-row{margin-bottom:16px}
.form-row-2{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:16px}
.form-lbl{display:block;font-size:11px;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:6px}
.form-inp{width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);color:#fff;padding:10px 14px;border-radius:8px;outline:none;font-size:14px;font-family:'Inter',sans-serif;transition:border-color 0.2s}
.form-inp:focus{border-color:rgba(201,168,76,0.5)}
.form-select{width:100%;background:#0d1526;border:1px solid rgba(255,255,255,0.1);color:#fff;padding:10px 14px;border-radius:8px;outline:none;font-size:14px;font-family:'Inter',sans-serif;cursor:pointer}
.modal-footer{display:flex;justify-content:flex-end;gap:10px;margin-top:24px}
.btn-cancel{padding:10px 20px;background:transparent;color:var(--muted);border:1px solid rgba(255,255,255,0.15);border-radius:8px;cursor:pointer;font-size:13px;font-family:'Inter',sans-serif}
.btn-save{padding:10px 24px;background:var(--gold);color:#000;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:13px;font-family:'Inter',sans-serif}
.btn-save:hover{background:var(--gold-light)}
.warn-text{font-size:11px;color:rgba(248,113,113,0.7);margin-top:6px}
.voucher-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;margin-bottom:16px}
.voucher-card{border:1.5px solid var(--border);border-radius:12px;padding:16px;cursor:pointer;transition:all 0.2s;position:relative;background:rgba(255,255,255,0.02)}
.voucher-card:hover{border-color:rgba(201,168,76,0.4);background:rgba(201,168,76,0.05)}
.voucher-card.selected{border-color:var(--gold);background:rgba(201,168,76,0.1)}
.voucher-card.disabled{opacity:0.4;cursor:not-allowed;pointer-events:none}
.voucher-pct{font-family:'Playfair Display',serif;font-size:28px;font-weight:700;color:var(--gold)}
.voucher-name{font-size:11px;color:#fff;font-weight:600;margin-top:4px}
.voucher-desc{font-size:10px;color:var(--muted);margin-top:4px;line-height:1.5}
.voucher-code{background:rgba(201,168,76,0.1);border:1px dashed rgba(201,168,76,0.4);border-radius:6px;padding:6px 10px;margin-top:8px;font-size:11px;font-weight:700;color:var(--gold);letter-spacing:1.5px;text-align:center}
.voucher-check{position:absolute;top:8px;right:8px;width:18px;height:18px;border-radius:50%;background:var(--gold);display:none;align-items:center;justify-content:center;font-size:10px;color:#000}
.voucher-card.selected .voucher-check{display:flex}
.voucher-gifted{background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.25);border-radius:10px;padding:14px;text-align:center;color:#4ade80;font-size:13px;font-weight:600;display:none}
@media(max-width:900px){.sidebar{display:none}.main{margin-left:0}}
</style>
</head>
<body>

<aside class="sidebar">
  <div class="sidebar-brand">
    <div class="brand-logo">Azure <span>Resort</span></div>
    <div class="brand-tag">${panelLabel}</div>
  </div>
  <div class="sidebar-user">
    <div class="user-avatar">${firstChar}</div>
    <div>
      <div class="user-name">${acc.fullName}</div>
      <div class="user-role">${roleLabel}</div>
    </div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section">Tổng Quan</div>
    <c:choose>
      <c:when test="${isAdmin}">
        <a href="${pageContext.request.contextPath}/dashboard/admin" class="nav-item"><span class="nav-dot"></span> Dashboard</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/dashboard/staff" class="nav-item"><span class="nav-dot"></span> Dashboard</a>
      </c:otherwise>
    </c:choose>
    <div class="nav-section">Vận Hành</div>
    <a href="${pageContext.request.contextPath}/dashboard/bookings" class="nav-item"><span class="nav-dot"></span> Booking</a>
    <a href="${pageContext.request.contextPath}/dashboard/contracts" class="nav-item"><span class="nav-dot"></span> Hợp Đồng</a>
    <div class="nav-section">Quản Lý</div>
    <a href="${pageContext.request.contextPath}/dashboard/users" class="nav-item active"><span class="nav-dot"></span> Người Dùng</a>
    <a href="${pageContext.request.contextPath}/dashboard/facilities" class="nav-item"><span class="nav-dot"></span> Phòng &amp; Villa</a>
    <div class="nav-section">Cá Nhân</div>
    <a href="${pageContext.request.contextPath}/profile" class="nav-item"><span class="nav-dot"></span> Hồ Sơ</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng Xuất</a>
  </div>
</aside>

<div class="main">
  <div class="topbar">
    <div class="topbar-title">Quản Lý Người Dùng</div>
    <span style="font-size:12px;color:var(--muted)" id="topbarDate"></span>
  </div>
  <div class="content">

    <%-- Flash message --%>
    <c:if test="${not empty flashMsg}">
      <c:choose>
        <c:when test="${not empty flashError}">
          <div class="flash flash-error">${flashMsg}</div>
        </c:when>
        <c:otherwise>
          <div class="flash flash-success">${flashMsg}</div>
        </c:otherwise>
      </c:choose>
    </c:if>

    <div class="stats-row">
      <div class="stat-pill gold">
        <div><div class="num">${totalCustomers}</div><div class="lbl">Khách Hàng</div></div>
      </div>
      <div class="stat-pill blue">
        <div><div class="num">${totalEmployees}</div><div class="lbl">Nhân Viên</div></div>
      </div>
    </div>

    <div class="taskbar">
      <button class="taskbar-btn" id="taskBtn-customers" onclick="switchTab('customers',this)">
        Khách Hàng <span class="tab-count">${totalCustomers}</span>
      </button>
      <c:if test="${isAdmin}">
        <button class="taskbar-btn" id="taskBtn-employees" onclick="switchTab('employees',this)">
          Nhân Viên <span class="tab-count">${totalEmployees}</span>
        </button>
      </c:if>
    </div>

    <%-- TAB KHÁCH HÀNG --%>
    <div class="tab-panel" id="panel-customers">
      <div class="panel-header">
        <div class="panel-header-left">
          <div class="panel-title">Danh Sách Khách Hàng</div>
          <span class="panel-count" id="cus-count">${totalCustomers} người</span>
          <div class="panel-search">
            <svg width="14" height="14" fill="none" stroke="rgba(255,255,255,0.3)" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
            <input type="text" id="cusSearch" placeholder="Tìm tên, email, SĐT..." autocomplete="off" oninput="filterTable('cus',this.value)">
          </div>
          <button class="btn-view-all" onclick="viewAll('cus')">Xem Tất Cả</button>
        </div>
        <c:if test="${isAdmin}">
          <button class="btn-add" onclick="openAddCustomer()">+ Thêm Khách Hàng</button>
        </c:if>
      </div>
      <div class="table-wrap">
        <c:choose>
          <c:when test="${not empty customers}">
            <table id="cusTable">
              <thead><tr>
                <th>ID</th><th>Họ Tên / Email</th><th>Điện Thoại</th>
                <th>Hạng Thành Viên</th><th>Tổng Chi Tiêu</th><th>Trạng Thái</th>
                <c:if test="${isAdmin}"><th>Thao Tác</th></c:if>
              </tr></thead>
              <tbody>
                <c:forEach var="c" items="${customers}">
                  <c:set var="cusTypeCls" value="badge-normal"/>
                  <c:if test="${c.typeCustomer == 'Diamond'}"><c:set var="cusTypeCls" value="badge-diamond"/></c:if>
                  <c:if test="${c.typeCustomer == 'Gold'}"><c:set var="cusTypeCls" value="badge-gold"/></c:if>
                  <c:if test="${c.typeCustomer == 'Silver'}"><c:set var="cusTypeCls" value="badge-silver"/></c:if>
                  <tr>
                    <td class="id-cell">${c.id}</td>
                    <td>
                      <div style="font-weight:600">${c.fullName}</div>
                      <div class="muted-cell" style="font-size:11.5px;margin-top:2px">${c.email}</div>
                    </td>
                    <td>${c.phoneNumber}</td>
                    <td><span class="badge ${cusTypeCls}">${not empty c.typeCustomer ? c.typeCustomer : 'Normal'}</span></td>
                    <td class="money-cell"><fmt:formatNumber value="${c.totalSpent}" type="number" maxFractionDigits="0"/>đ</td>
                    <td><span class="badge badge-active">Hoạt động</span></td>
                    <c:if test="${isAdmin}">
                      <td>
                        <div style="display:flex;gap:6px;flex-wrap:wrap">
                          <button class="btn-sm btn-edit"
                            onclick="openEditCustomer('${c.id}','${c.fullName}','${c.typeCustomer}','${c.address}','${c.email}','${c.phoneNumber}','${c.totalSpent}')">Sửa</button>
                          <c:choose>
                            <c:when test="${not empty sessionScope.giftedVouchers && sessionScope.giftedVouchers.contains(c.id)}">
                              <button class="btn-sm btn-voucher-done" disabled>Đã tặng</button>
                            </c:when>
                            <c:otherwise>
                              <button class="btn-sm btn-voucher" id="btnVoucher_${c.id}"
                                onclick="openVoucher('${c.id}','${c.fullName}','${c.typeCustomer}')">Voucher</button>
                            </c:otherwise>
                          </c:choose>
                          <form method="post" action="${pageContext.request.contextPath}/dashboard/action"
                            style="display:inline" onsubmit="return confirm('Xóa khách hàng ${c.fullName}?')">
                            <input type="hidden" name="action" value="delete_customer">
                            <input type="hidden" name="cusId" value="${c.id}">
                            <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users?tab=customers">
                            <button type="submit" class="btn-sm btn-delete">Xóa</button>
                          </form>
                        </div>
                      </td>
                    </c:if>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
            <div id="cusEmpty" style="display:none;padding:40px;text-align:center;color:var(--muted)">Không tìm thấy khách hàng nào</div>
          </c:when>
          <c:otherwise>
            <div class="empty"><p>Chưa có khách hàng</p></div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <%-- TAB NHÂN VIÊN --%>
    <c:if test="${isAdmin}">
    <div class="tab-panel" id="panel-employees">
      <div class="panel-header">
        <div class="panel-header-left">
          <div class="panel-title">Danh Sách Nhân Viên</div>
          <span class="panel-count" id="emp-count">${totalEmployees} người</span>
          <div class="panel-search">
            <svg width="14" height="14" fill="none" stroke="rgba(255,255,255,0.3)" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
            <input type="text" id="empSearch" placeholder="Tìm tên, email, chức vụ..." autocomplete="off" oninput="filterTable('emp',this.value)">
          </div>
          <button class="btn-view-all" onclick="viewAll('emp')">Xem Tất Cả</button>
        </div>
        <c:if test="${canManageEmployee}">
          <button class="btn-add" onclick="openAddEmployee()">+ Thêm Nhân Viên</button>
        </c:if>
      </div>
      <div class="table-wrap">
        <c:choose>
          <c:when test="${not empty employees}">
            <table id="empTable">
              <thead><tr>
                <th>ID</th><th>Họ Tên / Email</th><th>Chức Vụ</th><th>Phòng Ban</th>
                <th>Lương</th><th>Role</th><th>Trạng Thái</th>
                <c:if test="${canManageEmployee}"><th>Thao Tác</th></c:if>
              </tr></thead>
              <tbody>
                <c:forEach var="e" items="${employees}">
                  <c:set var="empRoleCls" value="${e.role == 'ADMIN' ? 'badge-admin' : 'badge-staff'}"/>
                  <c:set var="empActiveCls" value="${e.isActive ? 'badge-active' : 'badge-locked'}"/>
                  <c:set var="empActiveTxt" value="${e.isActive ? 'Đang làm' : 'Nghỉ'}"/>
                  <tr>
                    <td class="id-cell">${e.id}</td>
                    <td>
                      <div style="font-weight:600">${e.fullName}</div>
                      <div class="muted-cell" style="font-size:11.5px;margin-top:2px">${e.email}</div>
                    </td>
                    <td>${e.position}</td>
                    <td class="muted-cell">${e.deptName}</td>
                    <td class="money-cell"><fmt:formatNumber value="${e.salary}" type="number" maxFractionDigits="0"/>đ</td>
                    <td><span class="badge ${empRoleCls}">${e.role}</span></td>
                    <td><span class="badge ${empActiveCls}">${empActiveTxt}</span></td>
                    <c:if test="${canManageEmployee}">
                      <td>
                        <div style="display:flex;gap:6px">
                          <button class="btn-sm btn-edit"
                            onclick="openEditEmployee('${e.id}','${e.salary}','${e.position}','${e.role}','${e.fullName}','${e.email}','${e.deptId}','${e.isActive}')">Sửa</button>
                          <form method="post" action="${pageContext.request.contextPath}/dashboard/action"
                            style="display:inline" onsubmit="return confirm('Xóa hẳn nhân viên ${e.fullName}? Không thể hoàn tác!')">
                            <input type="hidden" name="action" value="delete_employee">
                            <input type="hidden" name="empId" value="${e.id}">
                            <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users?tab=employees">
                            <button type="submit" class="btn-sm btn-delete">Xóa</button>
                          </form>
                        </div>
                      </td>
                    </c:if>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
            <div id="empEmpty" style="display:none;padding:40px;text-align:center;color:var(--muted)">Không tìm thấy nhân viên nào</div>
          </c:when>
          <c:otherwise>
            <div class="empty"><p>Chưa có nhân viên</p></div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    </c:if>

  </div><%-- end .content --%>
</div><%-- end .main --%>

<%-- MODAL: Sửa Nhân Viên --%>
<div id="modalEmployee" class="modal-overlay">
  <div class="modal-box">
    <div class="modal-hdr">
      <div>
        <div class="modal-sub" style="color:var(--gold)">Nhân Viên</div>
        <div class="modal-title" id="editEmpName">Sửa Thông Tin</div>
      </div>
      <button class="modal-close" onclick="closeModal('modalEmployee')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/dashboard/action">
      <input type="hidden" name="action" value="edit_employee">
      <input type="hidden" name="empId" id="editEmpId">
      <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users?tab=employees">
      <div class="form-row-2">
        <div><label class="form-lbl">Họ Tên *</label><input type="text" name="fullName" id="editEmpFullName" class="form-inp" required></div>
        <div><label class="form-lbl">Email *</label><input type="email" name="email" id="editEmpEmail" class="form-inp" required></div>
      </div>
      <div class="form-row-2">
        <div><label class="form-lbl">Chức Vụ</label><input type="text" name="position" id="editEmpPosition" class="form-inp"></div>
        <div>
          <label class="form-lbl">Phòng Ban</label>
          <select name="deptId" id="editEmpDept" class="form-select">
            <option value="">-- Chọn phòng ban --</option>
            <c:forEach var="d" items="${departments}">
              <option value="${d.deptId}" style="background:#0d1526">${d.deptName}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-row"><label class="form-lbl">Lương (VNĐ)</label><input type="number" name="salary" id="editEmpSalary" class="form-inp" min="0" step="500000"></div>
      <div class="form-row-2">
        <div>
          <label class="form-lbl">Quyền (Role)</label>
          <select name="role" id="editEmpRole" class="form-select">
            <option value="STAFF" style="background:#0d1526">STAFF</option>
            <option value="ADMIN" style="background:#0d1526">ADMIN</option>
          </select>
          <div class="warn-text">⚠️ ADMIN có toàn quyền hệ thống</div>
        </div>
        <div>
          <label class="form-lbl">Trạng Thái</label>
          <select name="isActive" id="editEmpActive" class="form-select">
            <option value="true"  style="background:#0d1526">Đang làm</option>
            <option value="false" style="background:#0d1526">Nghỉ</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-cancel" onclick="closeModal('modalEmployee')">Hủy</button>
        <button type="submit" class="btn-save">Lưu Thay Đổi</button>
      </div>
    </form>
  </div>
</div>

<%-- MODAL: Sửa Khách Hàng --%>
<div id="modalCustomer" class="modal-overlay">
  <div class="modal-box">
    <div class="modal-hdr">
      <div>
        <div class="modal-sub" style="color:#60a5fa">Khách Hàng</div>
        <div class="modal-title" id="editCusName">Sửa Thông Tin</div>
      </div>
      <button class="modal-close" onclick="closeModal('modalCustomer')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/dashboard/action">
      <input type="hidden" name="action" value="edit_customer">
      <input type="hidden" name="cusId" id="editCusId">
      <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users?tab=customers">
      <div class="form-row-2">
        <div><label class="form-lbl">Họ Tên</label><input type="text" name="fullName" id="editCusFullName" class="form-inp" required></div>
        <div><label class="form-lbl">Email</label><input type="email" name="email" id="editCusEmail" class="form-inp" required></div>
      </div>
      <div class="form-row-2">
        <div><label class="form-lbl">Số Điện Thoại</label><input type="text" name="phoneNumber" id="editCusPhone" class="form-inp"></div>
        <div>
          <label class="form-lbl">Hạng Thành Viên</label>
          <select name="typeCustomer" id="editCusType" class="form-select">
            <option value="Normal"  style="background:#0d1526">Normal</option>
            <option value="Silver"  style="background:#0d1526">Silver</option>
            <option value="Gold"    style="background:#0d1526">Gold</option>
            <option value="Diamond" style="background:#0d1526">Diamond</option>
          </select>
        </div>
      </div>
      <div class="form-row"><label class="form-lbl">Tổng Chi Tiêu (VNĐ)</label><input type="number" name="totalSpent" id="editCusTotalSpent" class="form-inp" min="0" step="1000"></div>
      <div class="modal-footer">
        <button type="button" class="btn-cancel" onclick="closeModal('modalCustomer')">Hủy</button>
        <button type="submit" class="btn-save">Lưu Thay Đổi</button>
      </div>
    </form>
  </div>
</div>

<%-- MODAL: Thêm Khách Hàng --%>
<div id="modalAddCustomer" class="modal-overlay">
  <div class="modal-box">
    <div class="modal-hdr">
      <div>
        <div class="modal-sub" style="color:#4ade80">Khách Hàng Mới</div>
        <div class="modal-title">Thêm Khách Hàng</div>
      </div>
      <button class="modal-close" onclick="closeModal('modalAddCustomer')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/dashboard/action">
      <input type="hidden" name="action" value="add_customer">
      <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users?tab=customers">
      <div class="form-row-2">
        <div><label class="form-lbl">Họ Tên *</label><input type="text" name="fullName" class="form-inp" placeholder="Nguyễn Văn A" required></div>
        <div><label class="form-lbl">Email *</label><input type="email" name="email" class="form-inp" placeholder="email@example.com" required></div>
      </div>
      <div class="form-row-2">
        <div><label class="form-lbl">Số Điện Thoại</label><input type="text" name="phoneNumber" class="form-inp" placeholder="09xxxxxxxx"></div>
        <div>
          <label class="form-lbl">Hạng Thành Viên</label>
          <select name="typeCustomer" class="form-select">
            <option value="Normal"  style="background:#0d1526">Normal</option>
            <option value="Silver"  style="background:#0d1526">Silver</option>
            <option value="Gold"    style="background:#0d1526">Gold</option>
            <option value="Diamond" style="background:#0d1526">Diamond</option>
          </select>
        </div>
      </div>
      <div class="form-row-2">
        <div><label class="form-lbl">Tên Tài Khoản *</label><input type="text" name="username" class="form-inp" placeholder="username123" required></div>
        <div><label class="form-lbl">Mật Khẩu *</label><input type="password" name="password" class="form-inp" placeholder="••••••••" required></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-cancel" onclick="closeModal('modalAddCustomer')">Hủy</button>
        <button type="submit" class="btn-save">+ Thêm Khách Hàng</button>
      </div>
    </form>
  </div>
</div>

<%-- MODAL: Thêm Nhân Viên --%>
<div id="modalAddEmployee" class="modal-overlay">
  <div class="modal-box">
    <div class="modal-hdr">
      <div>
        <div class="modal-sub" style="color:#60a5fa">Nhân Viên Mới</div>
        <div class="modal-title">Thêm Nhân Viên</div>
      </div>
      <button class="modal-close" onclick="closeModal('modalAddEmployee')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/dashboard/action">
      <input type="hidden" name="action" value="add_employee">
      <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/dashboard/users?tab=employees">
      <div class="form-row-2">
        <div><label class="form-lbl">Họ Tên *</label><input type="text" name="fullName" class="form-inp" placeholder="Nguyễn Văn B" required></div>
        <div><label class="form-lbl">Email *</label><input type="email" name="email" class="form-inp" placeholder="email@resort.com" required></div>
      </div>
      <div class="form-row-2">
        <div><label class="form-lbl">Số Điện Thoại</label><input type="text" name="phoneNumber" class="form-inp" placeholder="09xxxxxxxx"></div>
        <div><label class="form-lbl">Tên Tài Khoản *</label><input type="text" name="username" class="form-inp" placeholder="nhanvien01" required></div>
      </div>
      <div class="form-row"><label class="form-lbl">Mật Khẩu *</label><input type="password" name="password" class="form-inp" placeholder="••••••••" required></div>
      <div class="form-row-2">
        <div><label class="form-lbl">Chức Vụ *</label><input type="text" name="position" class="form-inp" placeholder="Lễ tân, Quản lý..." required></div>
        <div>
          <label class="form-lbl">Phòng Ban</label>
          <select name="deptId" class="form-select">
            <option value="">-- Chọn phòng ban --</option>
            <c:forEach var="d" items="${departments}">
              <option value="${d.deptId}" style="background:#0d1526">${d.deptName}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-row"><label class="form-lbl">Lương (VNĐ)</label><input type="number" name="salary" class="form-inp" placeholder="10000000" min="0" step="500000"></div>
      <div class="form-row">
        <label class="form-lbl">Quyền</label>
        <select name="role" class="form-select">
          <option value="STAFF" style="background:#0d1526">STAFF</option>
          <option value="ADMIN" style="background:#0d1526">ADMIN</option>
        </select>
        <div class="warn-text">⚠️ ADMIN có toàn quyền hệ thống</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-cancel" onclick="closeModal('modalAddEmployee')">Hủy</button>
        <button type="submit" class="btn-save">+ Thêm Nhân Viên</button>
      </div>
    </form>
  </div>
</div>

<%-- MODAL: Tặng Voucher --%>
<div id="modalVoucher" class="modal-overlay">
  <div class="modal-box">
    <div class="modal-hdr">
      <div>
        <div class="modal-sub" style="color:#4ade80">Tặng Ưu Đãi</div>
        <div class="modal-title" id="voucherName">Khách Hàng</div>
      </div>
      <button class="modal-close" onclick="closeModal('modalVoucher')">✕</button>
    </div>
    <div id="voucherGifted" class="voucher-gifted">Đã tặng voucher thành công!</div>
    <div id="voucherPicker">
      <p style="font-size:12px;color:var(--muted);margin-bottom:14px">Chọn voucher phù hợp:</p>
      <div class="voucher-grid">
        <div class="voucher-card" id="vc1" onclick="selectVoucher(1,'EARLYBIRD20')">
          <div class="voucher-check">✓</div>
          <div class="voucher-pct">20%</div>
          <div class="voucher-name">Đặt Sớm 30 Ngày</div>
          <div class="voucher-desc">Giảm 20% mọi phòng &amp; villa</div>
          <div class="voucher-code">EARLYBIRD20</div>
        </div>
        <div class="voucher-card" id="vc2" onclick="selectVoucher(2,'WEEKEND15')">
          <div class="voucher-check">✓</div>
          <div class="voucher-pct">15%</div>
          <div class="voucher-name">Gói Cuối Tuần</div>
          <div class="voucher-desc">Giảm 15% + bữa sáng miễn phí</div>
          <div class="voucher-code">WEEKEND15</div>
        </div>
        <div class="voucher-card" id="vc3" onclick="selectVoucher(3,'VIP2026')">
          <div class="voucher-check">✓</div>
          <div class="voucher-pct">30%</div>
          <div class="voucher-name">Khách VIP</div>
          <div class="voucher-desc">Giảm 30% Diamond/Gold</div>
          <div class="voucher-code">VIP2026</div>
        </div>
      </div>
      <div id="voucherRec" style="background:rgba(201,168,76,0.06);border:1px solid rgba(201,168,76,0.2);border-radius:10px;padding:12px 14px;font-size:12.5px;color:rgba(255,255,255,0.7);line-height:1.6;margin-bottom:16px"></div>
      <div style="display:flex;justify-content:flex-end;gap:10px">
        <button class="btn-cancel" onclick="closeModal('modalVoucher')">Hủy</button>
        <button id="btnGiveVoucher" class="btn-save" onclick="giveVoucher()"
          style="background:linear-gradient(135deg,#4ade80,#22c55e);color:#000" disabled>Tặng Voucher</button>
      </div>
    </div>
  </div>
</div>

<script>
document.getElementById('topbarDate').textContent =
  new Date().toLocaleDateString('vi-VN',{weekday:'long',year:'numeric',month:'long',day:'numeric'});

(function(){
  var params = new URLSearchParams(window.location.search);
  var tab = params.get('tab') || 'customers';
  var btn = document.getElementById('taskBtn-' + tab);
  if (btn) switchTab(tab, btn);
  else {
    var defBtn = document.getElementById('taskBtn-customers');
    if (defBtn) switchTab('customers', defBtn);
  }
})();

function switchTab(tab, btn) {
  document.querySelectorAll('.tab-panel').forEach(function(p){ p.classList.remove('active'); });
  document.querySelectorAll('.taskbar-btn').forEach(function(b){ b.classList.remove('active'); });
  var panel = document.getElementById('panel-' + tab);
  if (panel) panel.classList.add('active');
  if (btn) btn.classList.add('active');
}

function filterTable(prefix, q) {
  q = q.toLowerCase();
  var tableId = prefix==='cus' ? 'cusTable' : 'empTable';
  var emptyId = prefix==='cus' ? 'cusEmpty' : 'empEmpty';
  var countId = prefix==='cus' ? 'cus-count' : 'emp-count';
  var table = document.getElementById(tableId);
  if (!table) return;
  var rows = table.querySelectorAll('tbody tr');
  var visible = 0;
  rows.forEach(function(row){
    var match = row.textContent.toLowerCase().includes(q);
    row.style.display = match ? '' : 'none';
    if (match) visible++;
  });
  var emptyDiv = document.getElementById(emptyId);
  if (emptyDiv) emptyDiv.style.display = visible===0 ? 'block' : 'none';
  var countEl = document.getElementById(countId);
  if (countEl) countEl.textContent = visible + ' người';
}

function viewAll(prefix) {
  var searchEl = document.getElementById(prefix==='cus' ? 'cusSearch' : 'empSearch');
  if (searchEl) { searchEl.value = ''; filterTable(prefix, ''); }
}

function openModal(id){ document.getElementById(id).classList.add('open'); }
function closeModal(id){ document.getElementById(id).classList.remove('open'); }

document.querySelectorAll('.modal-overlay').forEach(function(m){
  m.addEventListener('click', function(e){ if(e.target===this) closeModal(this.id); });
});

function openEditEmployee(id, salary, position, role, name, email, deptId, isActive) {
  document.getElementById('editEmpId').value       = id;
  document.getElementById('editEmpFullName').value = name     || '';
  document.getElementById('editEmpEmail').value    = email    || '';
  document.getElementById('editEmpPosition').value = position || '';
  document.getElementById('editEmpSalary').value   = salary   ? parseFloat(salary) : 0;
  document.getElementById('editEmpRole').value     = role     || 'STAFF';
  document.getElementById('editEmpDept').value     = deptId   || '';
  document.getElementById('editEmpActive').value   = isActive ? 'true' : 'false';
  document.getElementById('editEmpName').textContent = name || 'Sửa Thông Tin';
  openModal('modalEmployee');
}

function openEditCustomer(id, name, type, address, email, phone, totalSpent) {
  document.getElementById('editCusId').value         = id;
  document.getElementById('editCusName').textContent = name || 'Sửa Thông Tin';
  document.getElementById('editCusFullName').value   = name       || '';
  document.getElementById('editCusEmail').value      = email      || '';
  document.getElementById('editCusPhone').value      = phone      || '';
  document.getElementById('editCusType').value       = type       || 'Normal';
  document.getElementById('editCusTotalSpent').value = totalSpent || 0;
  openModal('modalCustomer');
}

function openAddCustomer() { openModal('modalAddCustomer'); }
function openAddEmployee() { openModal('modalAddEmployee'); }

var currentVoucherId   = null;
var currentVoucherCode = null;
var currentCustomerId  = null;

function openVoucher(id, name, type) {
  currentCustomerId = id;
  document.getElementById('voucherName').textContent = name;
  document.querySelectorAll('.voucher-card').forEach(function(c){ c.classList.remove('selected'); });
  document.getElementById('btnGiveVoucher').disabled = true;
  currentVoucherId = null; currentVoucherCode = null;
  var rec = '';
  if (type==='Diamond')      { rec='Khách Diamond — Gợi ý <b>VIP2026 (30%)</b>.'; document.getElementById('vc3').classList.remove('disabled'); }
  else if (type==='Gold')    { rec='Khách Gold — Gợi ý <b>EARLYBIRD20 (20%)</b> hoặc <b>VIP2026 (30%)</b>.'; document.getElementById('vc3').classList.remove('disabled'); }
  else if (type==='Silver')  { rec='Khách Silver — Gợi ý <b>WEEKEND15 (15%)</b>.'; document.getElementById('vc3').classList.add('disabled'); }
  else                       { rec='Khách Normal — Gợi ý <b>WEEKEND15 (15%)</b>.'; document.getElementById('vc3').classList.add('disabled'); }
  document.getElementById('voucherRec').innerHTML = rec;
  document.getElementById('voucherGifted').style.display = 'none';
  document.getElementById('voucherPicker').style.display = 'block';
  openModal('modalVoucher');
}

function selectVoucher(num, code) {
  document.querySelectorAll('.voucher-card').forEach(function(c){ c.classList.remove('selected'); });
  document.getElementById('vc'+num).classList.add('selected');
  currentVoucherId   = num;
  currentVoucherCode = code;
  document.getElementById('btnGiveVoucher').disabled = false;
}

function giveVoucher() {
  if (!currentVoucherId || !currentCustomerId) return;
  var form = document.createElement('form');
  form.method = 'POST';
  form.action = '${pageContext.request.contextPath}/dashboard/action';
  var fields = {
    action: 'give_voucher',
    cusId: currentCustomerId,
    voucherCode: currentVoucherCode,
    redirect: '${pageContext.request.contextPath}/dashboard/users?tab=customers'
  };
  Object.keys(fields).forEach(function(k){
    var inp = document.createElement('input');
    inp.type='hidden'; inp.name=k; inp.value=fields[k];
    form.appendChild(inp);
  });
  document.body.appendChild(form);
  form.submit();
}
</script>
</body>
</html>
