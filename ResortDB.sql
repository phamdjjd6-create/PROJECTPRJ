-- ================================================================
--  RESORT MANAGEMENT SYSTEM — SQL Server  (REFACTORED v2.1)
--  Database  : ResortDB
--  Features  :
--    ✅ Normalized Facility Hierarchy (Base table + Child tables)
--    ✅ Native DATE/DATETIME types for all date fields
--    ✅ Security: password_hash & is_deleted (Soft Delete)
--    ✅ Auditing: updated_at & audit log triggers
-- ================================================================

USE master;
GO

-- Drop database if exists to ensure a clean state for testing
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ResortDB')
BEGIN
    ALTER DATABASE ResortDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ResortDB;
END
GO

CREATE DATABASE ResortDB;
GO
USE ResortDB;
GO

-- ================================================================
--  ❶  DROP ALL (Reverse FK order)
-- ================================================================
IF OBJECT_ID('tbl_audit_log',        'U') IS NOT NULL DROP TABLE tbl_audit_log;
IF OBJECT_ID('tbl_reviews',          'U') IS NOT NULL DROP TABLE tbl_reviews;
IF OBJECT_ID('tbl_payments',         'U') IS NOT NULL DROP TABLE tbl_payments;
IF OBJECT_ID('tbl_booking_services', 'U') IS NOT NULL DROP TABLE tbl_booking_services;
IF OBJECT_ID('tbl_maintenance',      'U') IS NOT NULL DROP TABLE tbl_maintenance;
IF OBJECT_ID('tbl_promotions',       'U') IS NOT NULL DROP TABLE tbl_promotions;
IF OBJECT_ID('tbl_services',         'U') IS NOT NULL DROP TABLE tbl_services;
IF OBJECT_ID('tbl_contracts',        'U') IS NOT NULL DROP TABLE tbl_contracts;
IF OBJECT_ID('tbl_bookings',         'U') IS NOT NULL DROP TABLE tbl_bookings;
IF OBJECT_ID('tbl_vouchers',         'U') IS NOT NULL DROP TABLE tbl_vouchers;
IF OBJECT_ID('tbl_villas',           'U') IS NOT NULL DROP TABLE tbl_villas;
IF OBJECT_ID('tbl_houses',           'U') IS NOT NULL DROP TABLE tbl_houses;
IF OBJECT_ID('tbl_rooms',            'U') IS NOT NULL DROP TABLE tbl_rooms;
IF OBJECT_ID('tbl_facilities',       'U') IS NOT NULL DROP TABLE tbl_facilities;
IF OBJECT_ID('tbl_customers',        'U') IS NOT NULL DROP TABLE tbl_customers;
IF OBJECT_ID('tbl_employees',        'U') IS NOT NULL DROP TABLE tbl_employees;
IF OBJECT_ID('tbl_departments',      'U') IS NOT NULL DROP TABLE tbl_departments;
IF OBJECT_ID('tbl_persons',          'U') IS NOT NULL DROP TABLE tbl_persons;
GO

-- ================================================================
--  ❷  CORE TABLES
-- ================================================================

-- ── tbl_persons ─────────────────────────────────────────────────
CREATE TABLE tbl_persons (
    id            VARCHAR(20)   NOT NULL,
    full_name     NVARCHAR(100) NOT NULL,
    date_of_birth DATE          NULL,
    gender        NVARCHAR(10)  NULL,
    id_card       VARCHAR(20)   NULL,
    phone_number  VARCHAR(20)   NULL,
    email         VARCHAR(100)  NULL,
    account       VARCHAR(50)   NULL,          -- Tên đăng nhập
    password_hash VARCHAR(255)  NOT NULL DEFAULT '123456', -- Mật khẩu chuyển lên đây
    person_type   VARCHAR(10)   NOT NULL,
    created_at    DATETIME      NOT NULL DEFAULT GETDATE(),
    updated_at    DATETIME      NOT NULL DEFAULT GETDATE(),
    is_deleted    BIT           NOT NULL DEFAULT 0,

    CONSTRAINT PK_persons        PRIMARY KEY (id),
    CONSTRAINT UQ_persons_email  UNIQUE (email),
    CONSTRAINT CK_persons_type   CHECK  (person_type IN ('EMPLOYEE','CUSTOMER'))
);
GO


-- Filtered Index to allow multiple NULLs in id_card (SQL Server specific)
CREATE UNIQUE INDEX UIX_persons_idcard   ON tbl_persons(id_card)  WHERE id_card  IS NOT NULL;
-- Filtered Index to allow multiple NULLs in account
CREATE UNIQUE INDEX UIX_persons_account  ON tbl_persons(account)  WHERE account  IS NOT NULL;
GO

-- ── tbl_departments ──────────────────────────────────────────────
CREATE TABLE tbl_departments (
    dept_id   VARCHAR(10)   NOT NULL,
    dept_name NVARCHAR(100) NOT NULL,
    manager_id VARCHAR(20)  NULL,

    CONSTRAINT PK_departments PRIMARY KEY (dept_id)
);
GO

-- ── tbl_employees ────────────────────────────────────────────────
CREATE TABLE tbl_employees (
    id            VARCHAR(20)   NOT NULL,
    dept_id       VARCHAR(10)   NULL,
    level         NVARCHAR(30)  NULL,
    position      NVARCHAR(60)  NULL,
    salary        DECIMAL(15,2) NOT NULL DEFAULT 0,
    hire_date     DATE          NULL,
    is_active     BIT           NOT NULL DEFAULT 1,
    role          VARCHAR(10)   NOT NULL DEFAULT 'STAFF',

    CONSTRAINT PK_employees PRIMARY KEY (id),
    CONSTRAINT FK_employees_persons FOREIGN KEY (id) REFERENCES tbl_persons(id) ON DELETE CASCADE,
    CONSTRAINT FK_employees_dept    FOREIGN KEY (dept_id) REFERENCES tbl_departments(dept_id),
    CONSTRAINT CK_employees_role    CHECK (role IN ('ADMIN', 'STAFF'))
);
GO

ALTER TABLE tbl_departments
    ADD CONSTRAINT FK_dept_manager FOREIGN KEY (manager_id) REFERENCES tbl_employees(id);
GO

-- ── tbl_customers ────────────────────────────────────────────────
CREATE TABLE tbl_customers (
    id              VARCHAR(20)   NOT NULL,
    type_customer   NVARCHAR(20)  NULL DEFAULT N'Normal',
    address         NVARCHAR(200) NULL,
    loyalty_points  INT           NOT NULL DEFAULT 0,
    total_spent     DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT PK_customers PRIMARY KEY (id),
    CONSTRAINT FK_customers_persons FOREIGN KEY (id) REFERENCES tbl_persons(id) ON DELETE CASCADE
);
GO

-- ================================================================
--  ❸  FACILITY NORMALIZATION
-- ================================================================

-- ── tbl_facilities (BASE TABLE) ──────────────────────────────────
CREATE TABLE tbl_facilities (
    service_code  VARCHAR(20)   NOT NULL,
    service_name  NVARCHAR(150) NOT NULL,
    usable_area   DECIMAL(10,2) NOT NULL DEFAULT 0,
    cost          DECIMAL(15,2) NOT NULL DEFAULT 0,
    max_people    INT           NOT NULL DEFAULT 1,
    rental_type   NVARCHAR(20)  NULL,
    status        NVARCHAR(20)  NOT NULL DEFAULT N'AVAILABLE',
    facility_type VARCHAR(10)   NOT NULL, -- VILLA | HOUSE | ROOM
    description   NVARCHAR(500) NULL,
    image_url     VARCHAR(300)  NULL,
    created_at    DATETIME      NOT NULL DEFAULT GETDATE(),
    updated_at    DATETIME      NOT NULL DEFAULT GETDATE(),
    is_deleted    BIT           NOT NULL DEFAULT 0,
    usage_count   INT           NOT NULL DEFAULT 0,

    CONSTRAINT PK_facilities PRIMARY KEY (service_code),
    CONSTRAINT CK_facilities_type   CHECK (facility_type IN ('VILLA','HOUSE','ROOM')),
    CONSTRAINT CK_facilities_status CHECK (status IN ('AVAILABLE','OCCUPIED','MAINTENANCE'))
);
GO

-- ── tbl_villas (CHILD TABLE) ────────────────────────────────────
CREATE TABLE tbl_villas (
    service_code  VARCHAR(20)   NOT NULL,
    room_standard NVARCHAR(30)  NULL,
    pool_area     DECIMAL(10,2) NULL DEFAULT 0,
    num_of_floor  INT           NULL DEFAULT 1,

    CONSTRAINT PK_villas PRIMARY KEY (service_code),
    CONSTRAINT FK_villas_facility FOREIGN KEY (service_code) REFERENCES tbl_facilities(service_code) ON DELETE CASCADE
);
GO

-- ── tbl_houses (CHILD TABLE) ─────────────────────────────────────
CREATE TABLE tbl_houses (
    service_code  VARCHAR(20)   NOT NULL,
    room_standard NVARCHAR(30)  NULL,
    num_of_floor  INT           NULL DEFAULT 1,

    CONSTRAINT PK_houses PRIMARY KEY (service_code),
    CONSTRAINT FK_houses_facility FOREIGN KEY (service_code) REFERENCES tbl_facilities(service_code) ON DELETE CASCADE
);
GO

-- ── tbl_rooms (CHILD TABLE) ──────────────────────────────────────
CREATE TABLE tbl_rooms (
    service_code  VARCHAR(20)   NOT NULL,
    free_services NVARCHAR(255) NULL,
    floor_number  INT           NULL DEFAULT 1,

    CONSTRAINT PK_rooms PRIMARY KEY (service_code),
    CONSTRAINT FK_rooms_facility FOREIGN KEY (service_code) REFERENCES tbl_facilities(service_code) ON DELETE CASCADE
);
GO

-- ================================================================
--  ❹  TRANSACTIONAL TABLES
-- ================================================================

-- ── tbl_vouchers ─────────────────────────────────────────────────
CREATE TABLE tbl_vouchers (
    voucher_id       INT           NOT NULL IDENTITY(1,1),
    customer_id      VARCHAR(20)   NOT NULL,
    discount_percent INT           NOT NULL,
    expiry_date      DATE          NOT NULL, -- Native DATE
    is_used          BIT           NOT NULL DEFAULT 0,
    created_at       DATETIME      NOT NULL DEFAULT GETDATE(),
    min_order_value  DECIMAL(15,2) NULL DEFAULT 0,

    CONSTRAINT PK_vouchers           PRIMARY KEY (voucher_id),
    CONSTRAINT FK_vouchers_customer  FOREIGN KEY (customer_id) REFERENCES tbl_customers(id),
    CONSTRAINT CK_voucher_pct        CHECK  (discount_percent BETWEEN 1 AND 100)
);
GO

-- ── tbl_bookings ─────────────────────────────────────────────────
CREATE TABLE tbl_bookings (
    booking_id    VARCHAR(20)   NOT NULL,
    date_booking  DATETIME      NOT NULL DEFAULT GETDATE(),
    start_date    DATE          NOT NULL,
    end_date      DATE          NOT NULL,
    customer_id   VARCHAR(20)   NOT NULL,
    facility_id   VARCHAR(20)   NOT NULL,
    status        NVARCHAR(20)  NOT NULL DEFAULT N'PENDING',
    voucher_id    INT           NULL,
    special_req   NVARCHAR(500) NULL,
    adults        INT           NOT NULL DEFAULT 1,
    children      INT           NOT NULL DEFAULT 0,
    created_by    VARCHAR(20)   NULL,

    CONSTRAINT PK_bookings          PRIMARY KEY (booking_id),
    CONSTRAINT FK_bookings_customer FOREIGN KEY (customer_id) REFERENCES tbl_customers(id),
    CONSTRAINT FK_bookings_facility FOREIGN KEY (facility_id) REFERENCES tbl_facilities(service_code),
    CONSTRAINT FK_bookings_voucher  FOREIGN KEY (voucher_id)  REFERENCES tbl_vouchers(voucher_id),
    CONSTRAINT FK_bookings_creator  FOREIGN KEY (created_by)  REFERENCES tbl_employees(id),
    CONSTRAINT CK_bookings_status   CHECK (status IN ('PENDING','CONFIRMED','CANCELLED','CHECKED_IN','CHECKED_OUT'))
);
GO

-- ── tbl_contracts ────────────────────────────────────────────────
CREATE TABLE tbl_contracts (
    contract_id   VARCHAR(20)   NOT NULL,
    booking_id    VARCHAR(20)   NOT NULL,
    deposit       DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_payment DECIMAL(15,2) NOT NULL DEFAULT 0,
    paid_amount   DECIMAL(15,2) NOT NULL DEFAULT 0,
    employee_id   VARCHAR(20)   NULL,
    status        NVARCHAR(20)  NOT NULL DEFAULT N'DRAFT',
    signed_date   DATE          NULL,
    notes         NVARCHAR(500) NULL,

    CONSTRAINT PK_contracts PRIMARY KEY (contract_id),
    CONSTRAINT FK_contracts_booking  FOREIGN KEY (booking_id)  REFERENCES tbl_bookings(booking_id),
    CONSTRAINT FK_contracts_employee FOREIGN KEY (employee_id) REFERENCES tbl_employees(id),
    CONSTRAINT UQ_contracts_booking  UNIQUE (booking_id),
    CONSTRAINT CK_contracts_status   CHECK (status IN ('DRAFT','ACTIVE','EXPIRED','CANCELLED'))
);
GO

-- ── tbl_services ─────────────────────────────────────────────────
CREATE TABLE tbl_services (
    service_id    INT           NOT NULL IDENTITY(1,1),
    service_name  NVARCHAR(150) NOT NULL,
    category      NVARCHAR(50)  NULL,
    unit_price    DECIMAL(15,2) NOT NULL DEFAULT 0,
    unit          NVARCHAR(30)  NULL,
    description   NVARCHAR(300) NULL,
    is_active     BIT           NOT NULL DEFAULT 1,

    CONSTRAINT PK_services PRIMARY KEY (service_id)
);
GO

-- ── tbl_booking_services ────────────────────────────────────────
CREATE TABLE tbl_booking_services (
    id           INT           NOT NULL IDENTITY(1,1),
    booking_id   VARCHAR(20)   NOT NULL,
    service_id   INT           NOT NULL,
    quantity     INT           NOT NULL DEFAULT 1,
    unit_price   DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_price  AS (quantity * unit_price),
    service_date DATE          NULL,
    note         NVARCHAR(200) NULL,

    CONSTRAINT PK_booking_svc  PRIMARY KEY (id),
    CONSTRAINT FK_bsvc_booking FOREIGN KEY (booking_id) REFERENCES tbl_bookings(booking_id),
    CONSTRAINT FK_bsvc_service FOREIGN KEY (service_id) REFERENCES tbl_services(service_id)
);
GO

-- ── tbl_payments ─────────────────────────────────────────────────
CREATE TABLE tbl_payments (
    payment_id     INT           NOT NULL IDENTITY(1,1),
    contract_id    VARCHAR(20)   NOT NULL,
    amount         DECIMAL(15,2) NOT NULL,
    payment_date   DATETIME      NOT NULL DEFAULT GETDATE(),
    payment_method NVARCHAR(30)  NOT NULL DEFAULT N'CASH',
    transaction_ref VARCHAR(100) NULL,
    note           NVARCHAR(200) NULL,
    received_by    VARCHAR(20)   NULL,

    CONSTRAINT PK_payments          PRIMARY KEY (payment_id),
    CONSTRAINT FK_payments_contract FOREIGN KEY (contract_id) REFERENCES tbl_contracts(contract_id),
    CONSTRAINT FK_payments_emp      FOREIGN KEY (received_by) REFERENCES tbl_employees(id)
);
GO

-- ── tbl_reviews ──────────────────────────────────────────────────
CREATE TABLE tbl_reviews (
    review_id     INT           NOT NULL IDENTITY(1,1),
    booking_id    VARCHAR(20)   NOT NULL,
    customer_id   VARCHAR(20)   NOT NULL,
    rating        TINYINT       NOT NULL,
    title         NVARCHAR(150) NULL,
    content       NVARCHAR(1000) NULL,
    review_date   DATETIME      NOT NULL DEFAULT GETDATE(),
    is_published  BIT           NOT NULL DEFAULT 1,
    reply         NVARCHAR(500) NULL,

    CONSTRAINT PK_reviews PRIMARY KEY (review_id),
    CONSTRAINT FK_reviews_booking   FOREIGN KEY (booking_id)  REFERENCES tbl_bookings(booking_id),
    CONSTRAINT FK_reviews_customer  FOREIGN KEY (customer_id) REFERENCES tbl_customers(id),
    CONSTRAINT UQ_reviews_booking   UNIQUE (booking_id),
    CONSTRAINT CK_reviews_rating    CHECK  (rating BETWEEN 1 AND 5)
);
GO

-- ── tbl_maintenance ──────────────────────────────────────────────
CREATE TABLE tbl_maintenance (
    maintenance_id INT           NOT NULL IDENTITY(1,1),
    facility_id    VARCHAR(20)   NOT NULL,
    start_date     DATE          NOT NULL,
    end_date       DATE          NULL,
    reason         NVARCHAR(300) NULL,
    status         NVARCHAR(20)  NOT NULL DEFAULT N'SCHEDULED',
    assigned_to    VARCHAR(20)   NULL,
    cost           DECIMAL(15,2) NULL DEFAULT 0,

    CONSTRAINT PK_maintenance PRIMARY KEY (maintenance_id),
    CONSTRAINT FK_maintenance_facility FOREIGN KEY (facility_id) REFERENCES tbl_facilities(service_code),
    CONSTRAINT FK_maintenance_emp      FOREIGN KEY (assigned_to) REFERENCES tbl_employees(id),
    CONSTRAINT CK_maintenance_status   CHECK (status IN ('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED'))
);
GO

-- ── tbl_promotions ───────────────────────────────────────────────
CREATE TABLE tbl_promotions (
    promo_id      INT           NOT NULL IDENTITY(1,1),
    promo_name    NVARCHAR(150) NOT NULL,
    promo_code    VARCHAR(30)   NOT NULL,
    discount_type NVARCHAR(10)  NOT NULL DEFAULT 'PERCENT',
    discount_value DECIMAL(15,2) NOT NULL DEFAULT 0,
    start_date    DATE          NOT NULL,
    end_date      DATE          NOT NULL,
    min_nights    INT           NOT NULL DEFAULT 1,
    max_uses      INT           NULL,
    used_count    INT           NOT NULL DEFAULT 0,
    applies_to    NVARCHAR(20)  NOT NULL DEFAULT 'ALL',
    is_active     BIT           NOT NULL DEFAULT 1,

    CONSTRAINT PK_promotions PRIMARY KEY (promo_id),
    CONSTRAINT UQ_promotions_code UNIQUE (promo_code),
    CONSTRAINT CK_promotions_dtype CHECK (discount_type IN ('PERCENT','FIXED'))
);
GO

-- ── tbl_audit_log ────────────────────────────────────────────────
CREATE TABLE tbl_audit_log (
    log_id       BIGINT        NOT NULL IDENTITY(1,1),
    table_name   VARCHAR(50)   NOT NULL,
    action       VARCHAR(10)   NOT NULL,
    record_id    VARCHAR(50)   NOT NULL,
    old_value    NVARCHAR(MAX) NULL,
    new_value    NVARCHAR(MAX) NULL,
    changed_by   VARCHAR(20)   NULL,
    changed_at   DATETIME      NOT NULL DEFAULT GETDATE(),
    ip_address   VARCHAR(50)   NULL,

    CONSTRAINT PK_audit_log PRIMARY KEY (log_id)
);
GO

-- ================================================================
--  ❺  VIEWS & LOGIC
-- ================================================================

CREATE OR ALTER VIEW vw_facilities AS
SELECT f.service_code, f.service_name, f.usable_area, f.cost, f.max_people,
       f.rental_type, f.status, f.facility_type, f.description, f.image_url,
       v.room_standard, v.pool_area, v.num_of_floor,
       h.room_standard AS house_standard, h.num_of_floor AS house_floors,
       r.free_services, r.floor_number
FROM tbl_facilities f
LEFT JOIN tbl_villas v ON f.service_code = v.service_code
LEFT JOIN tbl_houses h ON f.service_code = h.service_code
LEFT JOIN tbl_rooms  r ON f.service_code = r.service_code
WHERE f.is_deleted = 0;
GO

CREATE OR ALTER VIEW vw_bookings AS
SELECT
    b.booking_id, b.date_booking, b.start_date, b.end_date,
    b.status, b.adults, b.children, b.special_req,
    b.customer_id, p.full_name AS customer_name,
    b.facility_id, f.service_name AS facility_name, f.facility_type,
    f.cost AS cost_per_night,
    v.discount_percent
FROM tbl_bookings b
JOIN tbl_persons p ON b.customer_id = p.id
JOIN tbl_facilities f ON b.facility_id = f.service_code
LEFT JOIN tbl_vouchers v ON b.voucher_id = v.voucher_id;
GO

-- View: danh sách nhân viên kèm phòng ban
CREATE OR ALTER VIEW vw_employees AS
SELECT
    p.id, p.full_name, p.date_of_birth, p.gender, p.id_card,
    p.phone_number, p.email, p.account, p.created_at,
    e.dept_id, d.dept_name, e.level, e.position,
    e.salary, e.hire_date, e.is_active, e.role
FROM tbl_employees e
JOIN tbl_persons p    ON e.id = p.id
LEFT JOIN tbl_departments d ON e.dept_id = d.dept_id
WHERE p.is_deleted = 0;
GO

-- View: danh sách khách hàng
CREATE OR ALTER VIEW vw_customers AS
SELECT
    p.id, p.full_name, p.date_of_birth, p.gender, p.id_card,
    p.phone_number, p.email, p.account, p.created_at,
    c.type_customer, c.address, c.loyalty_points, c.total_spent
FROM tbl_customers c
JOIN tbl_persons p ON c.id = p.id
WHERE p.is_deleted = 0;
GO

-- View: hợp đồng kèm thông tin booking, khách hàng, nhân viên
CREATE OR ALTER VIEW vw_contracts AS
SELECT
    ct.contract_id, ct.deposit, ct.total_payment, ct.paid_amount,
    ct.status AS contract_status, ct.signed_date, ct.notes,
    b.booking_id, b.start_date, b.end_date, b.status AS booking_status,
    pc.id AS customer_id, pc.full_name AS customer_name,
    pe.id AS employee_id, pe.full_name AS employee_name,
    f.service_name AS facility_name, f.facility_type,
    f.cost AS cost_per_night
FROM tbl_contracts ct
JOIN tbl_bookings b    ON ct.booking_id = b.booking_id
JOIN tbl_persons  pc   ON b.customer_id = pc.id
JOIN tbl_facilities f  ON b.facility_id = f.service_code
LEFT JOIN tbl_employees e  ON ct.employee_id = e.id
LEFT JOIN tbl_persons   pe ON e.id = pe.id;
GO

-- View: đánh giá kèm tên khách hàng và cơ sở vật chất
CREATE OR ALTER VIEW vw_facility_ratings AS
SELECT
    r.review_id, r.rating, r.title, r.content, r.review_date,
    r.is_published, r.reply,
    p.full_name AS customer_name,
    f.service_name AS facility_name, f.facility_type
FROM tbl_reviews r
JOIN tbl_bookings b   ON r.booking_id = b.booking_id
JOIN tbl_persons  p   ON r.customer_id = p.id
JOIN tbl_facilities f ON b.facility_id = f.service_code
WHERE r.is_published = 1;
GO

-- View: doanh thu theo tháng
CREATE OR ALTER VIEW vw_monthly_revenue AS
SELECT
    YEAR(b.start_date)  AS revenue_year,
    MONTH(b.start_date) AS revenue_month,
    f.facility_type,
    COUNT(DISTINCT b.booking_id)                        AS total_bookings,
    SUM(DATEDIFF(DAY, b.start_date, b.end_date) * f.cost
        * (1.0 - ISNULL(v.discount_percent, 0) / 100.0)) AS total_revenue
FROM tbl_bookings b
JOIN tbl_facilities f  ON b.facility_id = f.service_code
LEFT JOIN tbl_vouchers v ON b.voucher_id = v.voucher_id
WHERE b.status IN ('CONFIRMED','CHECKED_IN','CHECKED_OUT')
GROUP BY YEAR(b.start_date), MONTH(b.start_date), f.facility_type;
GO

-- Hàm: tính số đêm (Native DATE)
CREATE OR ALTER FUNCTION fn_nights(@start DATE, @end DATE)
RETURNS INT
AS BEGIN
    RETURN DATEDIFF(DAY, @start, @end)
END;
GO

-- TRIGGER: Cập nhật facility status
CREATE OR ALTER TRIGGER trg_facility_status_update
ON tbl_bookings AFTER UPDATE
AS BEGIN
    SET NOCOUNT ON;
    IF UPDATE(status)
    BEGIN
        UPDATE f
        SET status = CASE 
            WHEN i.status = 'CHECKED_IN' THEN 'OCCUPIED'
            WHEN i.status IN ('CHECKED_OUT', 'CANCELLED') THEN 'AVAILABLE'
            ELSE f.status
        END
        FROM tbl_facilities f
        JOIN inserted i ON f.service_code = i.facility_id
        WHERE i.status IN ('CHECKED_IN', 'CHECKED_OUT', 'CANCELLED');
    END
END;
GO

-- ================================================================
--  ❻  SAMPLE DATA (v2.2 — Role-Based)
-- ================================================================

-- ================================================================
--  ❻  SAMPLE DATA (v2.3 — Realistic Data & Refactored Auth)
-- ================================================================

-- ── Departments ──────────────────────────────────────────────────
INSERT INTO tbl_departments(dept_id, dept_name)
VALUES 
    ('DP01', N'Ban Giám Đốc'), 
    ('DP02', N'Tiếp Tân & Chăm Sóc Khách Hàng'), 
    ('DP03', N'IT & Vận Hành Hệ Thống');
GO

-- ── Persons & Employees (Tài khoản nhân viên) ────────────────────
-- Admin
INSERT INTO tbl_persons(id, full_name, person_type, id_card, email, phone_number, account, password_hash)
VALUES ('NV001', N'Phạm Tuấn Việt', 'EMPLOYEE', '044203001111', 'tuanviet1520@gmail.com', '0814577495', 'admin_viet', '$2a$10$wYQ.2P8z.yW.M.R7.Q.1234567890dummyhash1');
INSERT INTO tbl_employees(id, dept_id, salary, role, position, hire_date)
VALUES ('NV001', 'DP03', 25000000, 'ADMIN', N'Quản trị viên hệ thống', '2023-09-01');

-- Lễ tân
INSERT INTO tbl_persons(id, full_name, person_type, id_card, email, phone_number, account, password_hash)
VALUES ('NV002', N'Quân', 'EMPLOYEE', '044203002222', 'quan.reception@resort.com', '0901000002', 'staff_quan', '$2a$10$xyz.2P8z.yW.M.R7.Q.0987654321dummyhash2');
INSERT INTO tbl_employees(id, dept_id, salary, role, position, hire_date)
VALUES ('NV002', 'DP02', 12000000, 'STAFF', N'Trưởng ca Lễ tân', '2024-02-15');

-- ── Persons & Customers (Tài khoản khách hàng) ───────────────────
-- Khách hàng VIP
INSERT INTO tbl_persons(id, full_name, person_type, id_card, email, phone_number, account, password_hash)
VALUES ('KH001', N'Quốc', 'CUSTOMER', '044203003333', 'quoc.vip@gmail.com', '0912000001', 'quoc_vip', '$2a$10$abc.2P8z.yW.M.R7.Q.1122334455dummyhash3');
INSERT INTO tbl_customers(id, type_customer, address, loyalty_points, total_spent)
VALUES ('KH001', N'Diamond', N'Ba Đồn, Quảng Trị, Việt Nam', 1500, 45000000);

-- Khách hàng vãng lai
INSERT INTO tbl_persons(id, full_name, person_type, id_card, email, phone_number, account, password_hash)
VALUES ('KH002', N'Trần Thị Mai', 'CUSTOMER', '044203004444', 'maitran.88@gmail.com', '0933445566', 'mai_tran', '$2a$10$def.2P8z.yW.M.R7.Q.6677889900dummyhash4');
INSERT INTO tbl_customers(id, type_customer, address, loyalty_points, total_spent)
VALUES ('KH002', N'Normal', N'Hải Châu, Đà Nẵng', 100, 2500000);
GO

-- ── Facilities (Cơ sở vật chất) ──────────────────────────────────
INSERT INTO tbl_facilities(service_code, service_name, cost, facility_type, max_people, status, description)
VALUES
    ('VL001', N'Presidential Ocean Villa', 15000000, 'VILLA', 8, 'AVAILABLE', N'Villa mặt biển VIP nhất, hồ bơi vô cực riêng, quản gia 24/7'),
    ('VL002', N'Family Garden Villa', 6500000, 'VILLA', 6, 'AVAILABLE', N'Villa vườn nhiệt đới, không gian nướng BBQ ngoài trời'),
    ('RM001', N'Ocean View Suite', 2500000, 'ROOM',  2, 'AVAILABLE', N'Phòng Suite tầng 5, view toàn cảnh biển bình minh');
GO

INSERT INTO tbl_villas(service_code, room_standard, pool_area, num_of_floor)
VALUES ('VL001', '5 Star Diamond', 80.0, 2), ('VL002', '4 Star Premium', 45.0, 1);
GO

INSERT INTO tbl_rooms(service_code, free_services, floor_number)
VALUES ('RM001', N'Buffet sáng, Massage 60p, Minibar', 5);
GO

-- ── Bookings (Đặt phòng) ─────────────────────────────────────────
-- Booking đã xác nhận
INSERT INTO tbl_bookings(booking_id, start_date, end_date, customer_id, facility_id, status, adults, children)
VALUES
    ('BK_20260315_01', '2026-04-30', '2026-05-03', 'KH001', 'VL001', 'CONFIRMED', 4, 2),
    ('BK_20260315_02', '2026-05-10', '2026-05-12', 'KH002', 'RM001', 'PENDING',   2, 0);
GO

-- ── Contracts (Hợp đồng thanh toán) ──────────────────────────────
-- Hợp đồng cọc cho booking VL001 của khách hàng VIP
INSERT INTO tbl_contracts(contract_id, booking_id, deposit, total_payment, paid_amount, employee_id, status, signed_date)
VALUES ('CT_2026_001', 'BK_20260315_01', 15000000, 45000000, 15000000, 'NV002', 'ACTIVE', '2026-03-10');
GO

PRINT 'ResortDB Sample Data Inserted Successfully!';
GO

