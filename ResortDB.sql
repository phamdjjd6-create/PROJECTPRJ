-- ================================================================
--  RESORT MANAGEMENT SYSTEM — SQL Server  (NÂNG CẤP TOÀN DIỆN)
--  Database  : ResortDB
--  Phiên bản : 2.0
--  Gồm       :
--    ✅ Giữ nguyên 9 bảng cũ (khớp model Java gốc)
--    🆕 tbl_departments      — phòng ban
--    🆕 tbl_services         — dịch vụ phụ trợ (spa, tour...)
--    🆕 tbl_booking_services — dịch vụ đặt kèm booking
--    🆕 tbl_payments         — lịch sử thanh toán
--    🆕 tbl_reviews          — đánh giá sau khi ở
--    🆕 tbl_maintenance      — lịch bảo trì cơ sở
--    🆕 tbl_promotions       — chương trình khuyến mãi
--    🆕 tbl_audit_log        — lịch sử thao tác hệ thống
--    🆕 TRIGGERS             — auto audit, auto status update
--    🆕 FUNCTIONS            — tính doanh thu, đếm booking
--    🆕 STORED PROCEDURES    — báo cáo, xử lý nghiệp vụ
--    🆕 VIEWS mở rộng        — dashboard, báo cáo
--    🆕 DATA MẪU đầy đủ      — 50+ rows thực tế
-- ================================================================

USE master;
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ResortDB')
    CREATE DATABASE ResortDB;
GO
USE ResortDB;
GO

-- ================================================================
--  ❶  DROP TẤT CẢ (thứ tự ngược FK)
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
IF OBJECT_ID('tbl_customers',        'U') IS NOT NULL DROP TABLE tbl_customers;
IF OBJECT_ID('tbl_employees',        'U') IS NOT NULL DROP TABLE tbl_employees;
IF OBJECT_ID('tbl_departments',      'U') IS NOT NULL DROP TABLE tbl_departments;
IF OBJECT_ID('tbl_persons',          'U') IS NOT NULL DROP TABLE tbl_persons;
GO

-- Drop views cũ
IF OBJECT_ID('vw_bookings',   'V') IS NOT NULL DROP VIEW vw_bookings;
IF OBJECT_ID('vw_employees',  'V') IS NOT NULL DROP VIEW vw_employees;
IF OBJECT_ID('vw_customers',  'V') IS NOT NULL DROP VIEW vw_customers;
IF OBJECT_ID('vw_contracts',  'V') IS NOT NULL DROP VIEW vw_contracts;
GO

-- ================================================================
--  ❷  BẢNG CỐT LÕI (giữ nguyên khớp model Java)
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
    person_type   VARCHAR(10)   NOT NULL,
    created_at    DATETIME      NOT NULL DEFAULT GETDATE(),
    updated_at    DATETIME      NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_persons       PRIMARY KEY (id),
    CONSTRAINT UQ_persons_email  UNIQUE (email),
    CONSTRAINT UQ_persons_idcard UNIQUE (id_card),
    CONSTRAINT CK_persons_type   CHECK  (person_type IN ('EMPLOYEE','CUSTOMER'))
);
GO

-- ── tbl_departments (MỚI) ────────────────────────────────────────
CREATE TABLE tbl_departments (
    dept_id   VARCHAR(10)   NOT NULL,
    dept_name NVARCHAR(100) NOT NULL,
    manager_id VARCHAR(20)  NULL,   -- FK → tbl_employees (set sau)

    CONSTRAINT PK_departments PRIMARY KEY (dept_id)
);
GO

-- ── tbl_employees ────────────────────────────────────────────────
CREATE TABLE tbl_employees (
    id        VARCHAR(20)   NOT NULL,
    dept_id   VARCHAR(10)   NULL,
    level     NVARCHAR(30)  NULL,
    position  NVARCHAR(60)  NULL,
    salary    DECIMAL(15,2) NOT NULL DEFAULT 0,
    hire_date DATE          NULL,
    password  VARCHAR(255)  NOT NULL DEFAULT '123456',
    is_active BIT           NOT NULL DEFAULT 1,

    CONSTRAINT PK_employees PRIMARY KEY (id),
    CONSTRAINT FK_employees_persons
        FOREIGN KEY (id) REFERENCES tbl_persons(id) ON DELETE CASCADE,
    CONSTRAINT FK_employees_dept
        FOREIGN KEY (dept_id) REFERENCES tbl_departments(dept_id)
);
GO

ALTER TABLE tbl_departments
    ADD CONSTRAINT FK_dept_manager
        FOREIGN KEY (manager_id) REFERENCES tbl_employees(id);
GO

-- ── tbl_customers ────────────────────────────────────────────────
CREATE TABLE tbl_customers (
    id              VARCHAR(20)   NOT NULL,
    type_customer   NVARCHAR(20)  NULL DEFAULT N'Normal',
    address         NVARCHAR(200) NULL,
    loyalty_points  INT           NOT NULL DEFAULT 0,
    total_spent     DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT PK_customers PRIMARY KEY (id),
    CONSTRAINT FK_customers_persons
        FOREIGN KEY (id) REFERENCES tbl_persons(id) ON DELETE CASCADE
);
GO

-- ── tbl_villas ───────────────────────────────────────────────────
CREATE TABLE tbl_villas (
    service_code  VARCHAR(20)   NOT NULL,
    service_name  NVARCHAR(150) NOT NULL,
    usable_area   DECIMAL(10,2) NOT NULL DEFAULT 0,
    cost          DECIMAL(15,2) NOT NULL DEFAULT 0,
    max_people    INT           NOT NULL DEFAULT 1,
    rental_type   NVARCHAR(20)  NULL,
    room_standard NVARCHAR(30)  NULL,
    pool_area     DECIMAL(10,2) NULL DEFAULT 0,
    num_of_floor  INT           NULL DEFAULT 1,
    status        NVARCHAR(20)  NOT NULL DEFAULT N'AVAILABLE',
    description   NVARCHAR(500) NULL,
    image_url     VARCHAR(300)  NULL,

    CONSTRAINT PK_villas       PRIMARY KEY (service_code),
    CONSTRAINT CK_villas_status CHECK (status IN ('AVAILABLE','OCCUPIED','MAINTENANCE'))
);
GO

-- ── tbl_houses ───────────────────────────────────────────────────
CREATE TABLE tbl_houses (
    service_code  VARCHAR(20)   NOT NULL,
    service_name  NVARCHAR(150) NOT NULL,
    usable_area   DECIMAL(10,2) NOT NULL DEFAULT 0,
    cost          DECIMAL(15,2) NOT NULL DEFAULT 0,
    max_people    INT           NOT NULL DEFAULT 1,
    rental_type   NVARCHAR(20)  NULL,
    room_standard NVARCHAR(30)  NULL,
    num_of_floor  INT           NULL DEFAULT 1,
    status        NVARCHAR(20)  NOT NULL DEFAULT N'AVAILABLE',
    description   NVARCHAR(500) NULL,
    image_url     VARCHAR(300)  NULL,

    CONSTRAINT PK_houses       PRIMARY KEY (service_code),
    CONSTRAINT CK_houses_status CHECK (status IN ('AVAILABLE','OCCUPIED','MAINTENANCE'))
);
GO

-- ── tbl_rooms ────────────────────────────────────────────────────
CREATE TABLE tbl_rooms (
    service_code  VARCHAR(20)   NOT NULL,
    service_name  NVARCHAR(150) NOT NULL,
    usable_area   DECIMAL(10,2) NOT NULL DEFAULT 0,
    cost          DECIMAL(15,2) NOT NULL DEFAULT 0,
    max_people    INT           NOT NULL DEFAULT 1,
    rental_type   NVARCHAR(20)  NULL,
    free_services NVARCHAR(255) NULL,
    status        NVARCHAR(20)  NOT NULL DEFAULT N'AVAILABLE',
    floor_number  INT           NULL DEFAULT 1,
    image_url     VARCHAR(300)  NULL,

    CONSTRAINT PK_rooms       PRIMARY KEY (service_code),
    CONSTRAINT CK_rooms_status CHECK (status IN ('AVAILABLE','OCCUPIED','MAINTENANCE'))
);
GO

-- ── tbl_vouchers ─────────────────────────────────────────────────
CREATE TABLE tbl_vouchers (
    voucher_id       INT           NOT NULL IDENTITY(1,1),
    customer_id      VARCHAR(20)   NOT NULL,
    discount_percent INT           NOT NULL,
    expiry_date      VARCHAR(7)    NOT NULL,   -- MM/yyyy
    is_used          BIT           NOT NULL DEFAULT 0,
    created_at       DATETIME      NOT NULL DEFAULT GETDATE(),
    min_order_value  DECIMAL(15,2) NULL DEFAULT 0,

    CONSTRAINT PK_vouchers           PRIMARY KEY (voucher_id),
    CONSTRAINT FK_vouchers_customer  FOREIGN KEY (customer_id) REFERENCES tbl_customers(id),
    CONSTRAINT UQ_voucher_cust_exp   UNIQUE (customer_id, expiry_date),
    CONSTRAINT CK_voucher_pct        CHECK  (discount_percent BETWEEN 1 AND 100)
);
GO

-- ── tbl_bookings ─────────────────────────────────────────────────
CREATE TABLE tbl_bookings (
    booking_id    VARCHAR(20)   NOT NULL,
    date_booking  VARCHAR(10)   NULL,     -- dd/MM/yyyy
    start_date    VARCHAR(10)   NOT NULL, -- dd/MM/yyyy
    end_date      VARCHAR(10)   NOT NULL, -- dd/MM/yyyy
    customer_id   VARCHAR(20)   NOT NULL,
    facility_id   VARCHAR(20)   NOT NULL,
    status        NVARCHAR(20)  NOT NULL DEFAULT N'PENDING',
    voucher_id    INT           NULL,
    special_req   NVARCHAR(500) NULL,
    adults        INT           NOT NULL DEFAULT 1,
    children      INT           NOT NULL DEFAULT 0,
    created_by    VARCHAR(20)   NULL,     -- employee_id

    CONSTRAINT PK_bookings          PRIMARY KEY (booking_id),
    CONSTRAINT FK_bookings_customer FOREIGN KEY (customer_id) REFERENCES tbl_customers(id),
    CONSTRAINT FK_bookings_voucher  FOREIGN KEY (voucher_id)  REFERENCES tbl_vouchers(voucher_id),
    CONSTRAINT FK_bookings_creator  FOREIGN KEY (created_by)  REFERENCES tbl_employees(id),
    CONSTRAINT CK_bookings_status   CHECK (status IN (
        'PENDING','CONFIRMED','CANCELLED','CHECKED_IN','CHECKED_OUT'))
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

    CONSTRAINT PK_contracts          PRIMARY KEY (contract_id),
    CONSTRAINT FK_contracts_booking  FOREIGN KEY (booking_id)  REFERENCES tbl_bookings(booking_id),
    CONSTRAINT FK_contracts_employee FOREIGN KEY (employee_id) REFERENCES tbl_employees(id),
    CONSTRAINT UQ_contracts_booking  UNIQUE (booking_id),
    CONSTRAINT CK_contracts_status   CHECK (status IN ('DRAFT','ACTIVE','EXPIRED','CANCELLED'))
);
GO

-- ================================================================
--  ❸  BẢNG MỚI
-- ================================================================

-- ── tbl_services (dịch vụ phụ trợ: spa, tour, xe đưa đón...) ────
CREATE TABLE tbl_services (
    service_id    INT           NOT NULL IDENTITY(1,1),
    service_name  NVARCHAR(150) NOT NULL,
    category      NVARCHAR(50)  NULL,  -- SPA | TOUR | FOOD | TRANSPORT | OTHER
    unit_price    DECIMAL(15,2) NOT NULL DEFAULT 0,
    unit          NVARCHAR(30)  NULL,  -- lượt | giờ | ngày | người
    description   NVARCHAR(300) NULL,
    is_active     BIT           NOT NULL DEFAULT 1,

    CONSTRAINT PK_services PRIMARY KEY (service_id)
);
GO

-- ── tbl_booking_services (booking đặt thêm dịch vụ) ─────────────
CREATE TABLE tbl_booking_services (
    id          INT           NOT NULL IDENTITY(1,1),
    booking_id  VARCHAR(20)   NOT NULL,
    service_id  INT           NOT NULL,
    quantity    INT           NOT NULL DEFAULT 1,
    unit_price  DECIMAL(15,2) NOT NULL DEFAULT 0,  -- giá tại thời điểm đặt
    total_price AS (quantity * unit_price),         -- computed column
    service_date VARCHAR(10)  NULL,                 -- dd/MM/yyyy
    note        NVARCHAR(200) NULL,

    CONSTRAINT PK_booking_svc  PRIMARY KEY (id),
    CONSTRAINT FK_bsvc_booking FOREIGN KEY (booking_id) REFERENCES tbl_bookings(booking_id),
    CONSTRAINT FK_bsvc_service FOREIGN KEY (service_id) REFERENCES tbl_services(service_id)
);
GO

-- ── tbl_payments (lịch sử thanh toán) ───────────────────────────
CREATE TABLE tbl_payments (
    payment_id     INT           NOT NULL IDENTITY(1,1),
    contract_id    VARCHAR(20)   NOT NULL,
    amount         DECIMAL(15,2) NOT NULL,
    payment_date   DATETIME      NOT NULL DEFAULT GETDATE(),
    payment_method NVARCHAR(30)  NOT NULL DEFAULT N'CASH',
        -- CASH | BANK_TRANSFER | CREDIT_CARD | MOMO | VNPAY
    transaction_ref VARCHAR(100) NULL,
    note           NVARCHAR(200) NULL,
    received_by    VARCHAR(20)   NULL,    -- employee_id

    CONSTRAINT PK_payments          PRIMARY KEY (payment_id),
    CONSTRAINT FK_payments_contract FOREIGN KEY (contract_id) REFERENCES tbl_contracts(contract_id),
    CONSTRAINT FK_payments_emp      FOREIGN KEY (received_by) REFERENCES tbl_employees(id)
);
GO

-- ── tbl_reviews (đánh giá sau khi trả phòng) ────────────────────
CREATE TABLE tbl_reviews (
    review_id     INT           NOT NULL IDENTITY(1,1),
    booking_id    VARCHAR(20)   NOT NULL,
    customer_id   VARCHAR(20)   NOT NULL,
    rating        TINYINT       NOT NULL,   -- 1–5 sao
    title         NVARCHAR(150) NULL,
    content       NVARCHAR(1000) NULL,
    review_date   DATETIME      NOT NULL DEFAULT GETDATE(),
    is_published  BIT           NOT NULL DEFAULT 1,
    reply         NVARCHAR(500) NULL,       -- phản hồi của resort

    CONSTRAINT PK_reviews           PRIMARY KEY (review_id),
    CONSTRAINT FK_reviews_booking   FOREIGN KEY (booking_id)  REFERENCES tbl_bookings(booking_id),
    CONSTRAINT FK_reviews_customer  FOREIGN KEY (customer_id) REFERENCES tbl_customers(id),
    CONSTRAINT UQ_reviews_booking   UNIQUE (booking_id),
    CONSTRAINT CK_reviews_rating    CHECK  (rating BETWEEN 1 AND 5)
);
GO

-- ── tbl_maintenance (lịch bảo trì cơ sở) ───────────────────────
CREATE TABLE tbl_maintenance (
    maintenance_id INT           NOT NULL IDENTITY(1,1),
    facility_id    VARCHAR(20)   NOT NULL,
    facility_type  NVARCHAR(10)  NOT NULL,  -- VILLA | HOUSE | ROOM
    start_date     DATE          NOT NULL,
    end_date       DATE          NULL,
    reason         NVARCHAR(300) NULL,
    status         NVARCHAR(20)  NOT NULL DEFAULT N'SCHEDULED',
        -- SCHEDULED | IN_PROGRESS | COMPLETED | CANCELLED
    assigned_to    VARCHAR(20)   NULL,     -- employee_id
    cost           DECIMAL(15,2) NULL DEFAULT 0,

    CONSTRAINT PK_maintenance        PRIMARY KEY (maintenance_id),
    CONSTRAINT FK_maintenance_emp    FOREIGN KEY (assigned_to) REFERENCES tbl_employees(id),
    CONSTRAINT CK_maintenance_type   CHECK (facility_type IN ('VILLA','HOUSE','ROOM')),
    CONSTRAINT CK_maintenance_status CHECK (status IN ('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED'))
);
GO

-- ── tbl_promotions (khuyến mãi theo mùa, ngày lễ...) ───────────
CREATE TABLE tbl_promotions (
    promo_id      INT           NOT NULL IDENTITY(1,1),
    promo_name    NVARCHAR(150) NOT NULL,
    promo_code    VARCHAR(30)   NOT NULL,
    discount_type NVARCHAR(10)  NOT NULL DEFAULT 'PERCENT',  -- PERCENT | FIXED
    discount_value DECIMAL(15,2) NOT NULL DEFAULT 0,
    start_date    DATE          NOT NULL,
    end_date      DATE          NOT NULL,
    min_nights    INT           NOT NULL DEFAULT 1,
    max_uses      INT           NULL,      -- NULL = không giới hạn
    used_count    INT           NOT NULL DEFAULT 0,
    applies_to    NVARCHAR(20)  NOT NULL DEFAULT 'ALL',  -- ALL | VILLA | HOUSE | ROOM
    is_active     BIT           NOT NULL DEFAULT 1,

    CONSTRAINT PK_promotions          PRIMARY KEY (promo_id),
    CONSTRAINT UQ_promotions_code     UNIQUE (promo_code),
    CONSTRAINT CK_promotions_dtype    CHECK (discount_type IN ('PERCENT','FIXED')),
    CONSTRAINT CK_promotions_applies  CHECK (applies_to IN ('ALL','VILLA','HOUSE','ROOM'))
);
GO

-- ── tbl_audit_log (mọi INSERT/UPDATE/DELETE quan trọng) ──────────
CREATE TABLE tbl_audit_log (
    log_id       BIGINT        NOT NULL IDENTITY(1,1),
    table_name   VARCHAR(50)   NOT NULL,
    action       VARCHAR(10)   NOT NULL,   -- INSERT | UPDATE | DELETE
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
--  ❹  INDEXES (performance)
-- ================================================================
CREATE INDEX IX_bookings_customer    ON tbl_bookings(customer_id);
CREATE INDEX IX_bookings_facility    ON tbl_bookings(facility_id);
CREATE INDEX IX_bookings_status      ON tbl_bookings(status);
CREATE INDEX IX_bookings_dates       ON tbl_bookings(start_date, end_date);
CREATE INDEX IX_contracts_booking    ON tbl_contracts(booking_id);
CREATE INDEX IX_contracts_employee   ON tbl_contracts(employee_id);
CREATE INDEX IX_contracts_status     ON tbl_contracts(status);
CREATE INDEX IX_vouchers_customer    ON tbl_vouchers(customer_id);
CREATE INDEX IX_payments_contract    ON tbl_payments(contract_id);
CREATE INDEX IX_payments_date        ON tbl_payments(payment_date);
CREATE INDEX IX_reviews_customer     ON tbl_reviews(customer_id);
CREATE INDEX IX_bsvc_booking         ON tbl_booking_services(booking_id);
CREATE INDEX IX_maintenance_facility ON tbl_maintenance(facility_id, facility_type);
CREATE INDEX IX_audit_table          ON tbl_audit_log(table_name, changed_at);
GO

-- ================================================================
--  ❺  VIEWS
-- ================================================================

CREATE OR ALTER VIEW vw_employees AS
SELECT p.id, p.full_name, p.date_of_birth, p.gender, p.id_card,
       p.phone_number, p.email, p.created_at,
       e.dept_id, d.dept_name, e.level, e.position, e.salary,
       e.hire_date, e.is_active
FROM   tbl_persons   p
JOIN   tbl_employees e ON p.id    = e.id
LEFT JOIN tbl_departments d ON e.dept_id = d.dept_id;
GO

CREATE OR ALTER VIEW vw_customers AS
SELECT p.id, p.full_name, p.date_of_birth, p.gender, p.id_card,
       p.phone_number, p.email, p.created_at,
       c.type_customer, c.address, c.loyalty_points, c.total_spent
FROM   tbl_persons  p
JOIN   tbl_customers c ON p.id = c.id;
GO

-- View tổng hợp cơ sở (Villa + House + Room với type)
CREATE OR ALTER VIEW vw_facilities AS
SELECT service_code, service_name, usable_area, cost, max_people,
       rental_type, status, 'VILLA' AS facility_type,
       CAST(room_standard AS NVARCHAR(30)) AS room_standard,
       CAST(pool_area     AS VARCHAR(20))  AS extra_info,
       num_of_floor, description, image_url
FROM tbl_villas
UNION ALL
SELECT service_code, service_name, usable_area, cost, max_people,
       rental_type, status, 'HOUSE',
       room_standard, CAST(num_of_floor AS VARCHAR(20)), num_of_floor,
       description, image_url
FROM tbl_houses
UNION ALL
SELECT service_code, service_name, usable_area, cost, max_people,
       rental_type, status, 'ROOM',
       NULL, free_services, floor_number, NULL, image_url
FROM tbl_rooms;
GO

CREATE OR ALTER VIEW vw_bookings AS
SELECT
    b.booking_id, b.date_booking, b.start_date, b.end_date,
    b.status, b.adults, b.children, b.special_req,
    b.customer_id,
    p.full_name      AS customer_name,
    p.phone_number   AS customer_phone,
    cus.type_customer,
    b.facility_id,
    f.service_name   AS facility_name,
    f.facility_type,
    f.cost           AS cost_per_night,
    b.voucher_id,
    v.discount_percent,
    b.created_by,
    pe.full_name     AS created_by_name
FROM      tbl_bookings   b
JOIN      tbl_persons    p   ON b.customer_id = p.id
JOIN      tbl_customers  cus ON b.customer_id = cus.id
LEFT JOIN vw_facilities  f   ON b.facility_id  = f.service_code
LEFT JOIN tbl_vouchers   v   ON b.voucher_id   = v.voucher_id
LEFT JOIN tbl_employees  emp ON b.created_by   = emp.id
LEFT JOIN tbl_persons    pe  ON emp.id          = pe.id;
GO

CREATE OR ALTER VIEW vw_contracts AS
SELECT
    c.contract_id, c.booking_id, c.deposit, c.total_payment,
    c.paid_amount,
    c.total_payment - c.paid_amount AS remaining_amount,
    c.status, c.signed_date, c.notes,
    c.employee_id,
    pe.full_name   AS employee_name,
    b.customer_id, b.start_date, b.end_date, b.facility_id,
    p.full_name    AS customer_name
FROM      tbl_contracts c
JOIN      tbl_bookings  b  ON c.booking_id  = b.booking_id
JOIN      tbl_persons   p  ON b.customer_id = p.id
LEFT JOIN tbl_employees e  ON c.employee_id = e.id
LEFT JOIN tbl_persons   pe ON e.id          = pe.id;
GO

-- View doanh thu theo tháng
CREATE OR ALTER VIEW vw_monthly_revenue AS
SELECT
    YEAR(payment_date)  AS yr,
    MONTH(payment_date) AS mo,
    COUNT(*)            AS payment_count,
    SUM(amount)         AS total_revenue,
    AVG(amount)         AS avg_payment
FROM tbl_payments
GROUP BY YEAR(payment_date), MONTH(payment_date);
GO

-- View đánh giá trung bình theo cơ sở
CREATE OR ALTER VIEW vw_facility_ratings AS
SELECT
    b.facility_id,
    f.service_name,
    f.facility_type,
    COUNT(r.review_id)  AS review_count,
    AVG(CAST(r.rating AS DECIMAL(3,1))) AS avg_rating,
    SUM(CASE WHEN r.rating = 5 THEN 1 ELSE 0 END) AS five_star
FROM      tbl_reviews   r
JOIN      tbl_bookings  b ON r.booking_id  = b.booking_id
LEFT JOIN vw_facilities f ON b.facility_id = f.service_code
GROUP BY b.facility_id, f.service_name, f.facility_type;
GO

-- ================================================================
--  ❻  FUNCTIONS
-- ================================================================

-- Hàm: tính số đêm từ 2 string dd/MM/yyyy (dùng Booking gốc)
CREATE OR ALTER FUNCTION fn_nights(@start VARCHAR(10), @end VARCHAR(10))
RETURNS INT
AS BEGIN
    RETURN DATEDIFF(DAY,
        CONVERT(DATE, @start, 105),
        CONVERT(DATE, @end,   105))
END;
GO

-- Hàm: tính tiền phòng của 1 booking (chưa gồm dịch vụ phụ)
CREATE OR ALTER FUNCTION fn_room_cost(@booking_id VARCHAR(20))
RETURNS DECIMAL(18,2)
AS BEGIN
    DECLARE @cost   DECIMAL(15,2) = 0;
    DECLARE @nights INT           = 0;
    DECLARE @disc   INT           = 0;

    SELECT
        @cost   = f.cost,
        @nights = dbo.fn_nights(b.start_date, b.end_date),
        @disc   = ISNULL(v.discount_percent, 0)
    FROM      tbl_bookings b
    LEFT JOIN vw_facilities f ON b.facility_id = f.service_code
    LEFT JOIN tbl_vouchers  v ON b.voucher_id  = v.voucher_id
    WHERE b.booking_id = @booking_id;

    RETURN @cost * @nights * (1.0 - @disc / 100.0);
END;
GO

-- Hàm: tổng doanh thu theo khách hàng
CREATE OR ALTER FUNCTION fn_customer_revenue(@customer_id VARCHAR(20))
RETURNS DECIMAL(18,2)
AS BEGIN
    DECLARE @total DECIMAL(18,2) = 0;
    SELECT @total = ISNULL(SUM(pay.amount), 0)
    FROM tbl_payments  pay
    JOIN tbl_contracts con ON pay.contract_id = con.contract_id
    JOIN tbl_bookings  b   ON con.booking_id  = b.booking_id
    WHERE b.customer_id = @customer_id;
    RETURN @total;
END;
GO

-- Hàm: kiểm tra facility có trống không (trả 1=trống, 0=bận)
CREATE OR ALTER FUNCTION fn_is_available(
    @facility_id VARCHAR(20),
    @start       VARCHAR(10),
    @end         VARCHAR(10)
) RETURNS BIT
AS BEGIN
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*)
    FROM tbl_bookings
    WHERE facility_id = @facility_id
      AND status NOT IN ('CANCELLED','CHECKED_OUT')
      AND CONVERT(DATE, start_date, 105) < CONVERT(DATE, @end,   105)
      AND CONVERT(DATE, end_date,   105) > CONVERT(DATE, @start, 105);
    RETURN CASE WHEN @cnt = 0 THEN 1 ELSE 0 END;
END;
GO

-- ================================================================
--  ❼  STORED PROCEDURES
-- ================================================================

-- SP: Tạo employee (person + employee cùng 1 transaction)
CREATE OR ALTER PROCEDURE sp_insert_employee
    @id VARCHAR(20), @full_name NVARCHAR(100), @date_of_birth DATE,
    @gender NVARCHAR(10), @id_card VARCHAR(20), @phone_number VARCHAR(20),
    @email VARCHAR(100), @dept_id VARCHAR(10), @level NVARCHAR(30),
    @position NVARCHAR(60), @salary DECIMAL(15,2), @password VARCHAR(255),
    @hire_date DATE = NULL
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO tbl_persons(id,full_name,date_of_birth,gender,id_card,phone_number,email,person_type)
        VALUES (@id,@full_name,@date_of_birth,@gender,@id_card,@phone_number,@email,'EMPLOYEE');

        INSERT INTO tbl_employees(id,dept_id,level,position,salary,hire_date,password)
        VALUES (@id,@dept_id,@level,@position,@salary,ISNULL(@hire_date,GETDATE()),@password);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- SP: Tạo customer
CREATE OR ALTER PROCEDURE sp_insert_customer
    @id VARCHAR(20), @full_name NVARCHAR(100), @date_of_birth DATE,
    @gender NVARCHAR(10), @id_card VARCHAR(20), @phone_number VARCHAR(20),
    @email VARCHAR(100), @type_customer NVARCHAR(20), @address NVARCHAR(200)
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO tbl_persons(id,full_name,date_of_birth,gender,id_card,phone_number,email,person_type)
        VALUES (@id,@full_name,@date_of_birth,@gender,@id_card,@phone_number,@email,'CUSTOMER');

        INSERT INTO tbl_customers(id,type_customer,address)
        VALUES (@id,@type_customer,@address);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- SP: Tạo booking + tự sinh contract
CREATE OR ALTER PROCEDURE sp_create_booking
    @booking_id  VARCHAR(20),
    @customer_id VARCHAR(20),
    @facility_id VARCHAR(20),
    @start_date  VARCHAR(10),
    @end_date    VARCHAR(10),
    @adults      INT = 1,
    @children    INT = 0,
    @voucher_id  INT = NULL,
    @special_req NVARCHAR(500) = NULL,
    @created_by  VARCHAR(20)   = NULL
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra tính khả dụng
        IF dbo.fn_is_available(@facility_id, @start_date, @end_date) = 0
            RAISERROR(N'Cơ sở đã được đặt trong khoảng thời gian này.', 16, 1);

        -- Insert booking
        INSERT INTO tbl_bookings(booking_id,date_booking,start_date,end_date,
                                 customer_id,facility_id,status,voucher_id,
                                 special_req,adults,children,created_by)
        VALUES (@booking_id,
                FORMAT(GETDATE(),'dd/MM/yyyy'),
                @start_date, @end_date,
                @customer_id, @facility_id, 'CONFIRMED',
                @voucher_id, @special_req, @adults, @children, @created_by);

        -- Auto tạo contract DRAFT
        DECLARE @contract_id VARCHAR(20) = 'CT-' + @booking_id;
        DECLARE @total DECIMAL(15,2) = dbo.fn_room_cost(@booking_id);

        INSERT INTO tbl_contracts(contract_id,booking_id,deposit,total_payment,employee_id,status)
        VALUES (@contract_id, @booking_id, @total * 0.3, @total, @created_by, 'DRAFT');

        COMMIT TRANSACTION;
        SELECT @booking_id AS booking_id, @contract_id AS contract_id, @total AS total_amount;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- SP: Thanh toán (cập nhật paid_amount + phát sinh payment record)
CREATE OR ALTER PROCEDURE sp_make_payment
    @contract_id    VARCHAR(20),
    @amount         DECIMAL(15,2),
    @payment_method NVARCHAR(30) = N'CASH',
    @received_by    VARCHAR(20)  = NULL,
    @transaction_ref VARCHAR(100) = NULL
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Ghi nhận thanh toán
        INSERT INTO tbl_payments(contract_id,amount,payment_method,received_by,transaction_ref)
        VALUES (@contract_id,@amount,@payment_method,@received_by,@transaction_ref);

        -- Cập nhật tổng đã thanh toán
        UPDATE tbl_contracts
        SET    paid_amount += @amount,
               status = CASE
                   WHEN paid_amount + @amount >= total_payment THEN 'ACTIVE'
                   ELSE status
               END
        WHERE  contract_id = @contract_id;

        -- Cộng loyalty points cho customer (1đ = 1 điểm / 10,000 VNĐ)
        UPDATE c
        SET    c.loyalty_points += CAST(@amount / 10000 AS INT),
               c.total_spent    += @amount
        FROM   tbl_customers c
        JOIN   tbl_contracts ct ON ct.contract_id = @contract_id
        JOIN   tbl_bookings  b  ON b.booking_id   = ct.booking_id
        WHERE  c.id = b.customer_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- SP: Báo cáo doanh thu theo khoảng thời gian
CREATE OR ALTER PROCEDURE sp_revenue_report
    @from_date DATE,
    @to_date   DATE
AS BEGIN
    SET NOCOUNT ON;
    SELECT
        YEAR(pay.payment_date)  AS nam,
        MONTH(pay.payment_date) AS thang,
        COUNT(DISTINCT b.booking_id)  AS so_booking,
        COUNT(DISTINCT b.customer_id) AS so_khach,
        SUM(pay.amount)               AS doanh_thu,
        AVG(pay.amount)               AS tb_moi_lan
    FROM tbl_payments  pay
    JOIN tbl_contracts con ON pay.contract_id = con.contract_id
    JOIN tbl_bookings  b   ON con.booking_id  = b.booking_id
    WHERE CAST(pay.payment_date AS DATE) BETWEEN @from_date AND @to_date
    GROUP BY YEAR(pay.payment_date), MONTH(pay.payment_date)
    ORDER BY nam, thang;
END;
GO

-- SP: Top khách hàng VIP (theo tổng chi tiêu)
CREATE OR ALTER PROCEDURE sp_top_customers @top INT = 10
AS BEGIN
    SELECT TOP (@top)
        c.id, p.full_name, p.phone_number, p.email,
        c.type_customer, c.loyalty_points, c.total_spent,
        COUNT(DISTINCT b.booking_id) AS total_bookings,
        AVG(CAST(r.rating AS DECIMAL(3,1))) AS avg_rating_given
    FROM      tbl_customers c
    JOIN      tbl_persons   p ON c.id = p.id
    LEFT JOIN tbl_bookings  b ON c.id = b.customer_id AND b.status = 'CHECKED_OUT'
    LEFT JOIN tbl_reviews   r ON r.customer_id = c.id
    GROUP BY c.id, p.full_name, p.phone_number, p.email,
             c.type_customer, c.loyalty_points, c.total_spent
    ORDER BY c.total_spent DESC;
END;
GO

-- ================================================================
--  ❽  TRIGGERS
-- ================================================================

-- Trigger: Khi booking CHECKED_IN → đổi status cơ sở → OCCUPIED
CREATE OR ALTER TRIGGER trg_booking_status_change
ON tbl_bookings AFTER UPDATE
AS BEGIN
    SET NOCOUNT ON;

    -- Nếu status chuyển sang CHECKED_IN
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.booking_id = d.booking_id
               WHERE i.status = 'CHECKED_IN' AND d.status <> 'CHECKED_IN')
    BEGIN
        DECLARE @fid VARCHAR(20), @ftype NVARCHAR(10);
        SELECT @fid = i.facility_id
        FROM inserted i JOIN deleted d ON i.booking_id = d.booking_id
        WHERE i.status = 'CHECKED_IN';

        -- Xác định loại facility rồi update status
        IF EXISTS (SELECT 1 FROM tbl_villas WHERE service_code = @fid)
            UPDATE tbl_villas SET status = 'OCCUPIED' WHERE service_code = @fid;
        ELSE IF EXISTS (SELECT 1 FROM tbl_houses WHERE service_code = @fid)
            UPDATE tbl_houses SET status = 'OCCUPIED' WHERE service_code = @fid;
        ELSE
            UPDATE tbl_rooms  SET status = 'OCCUPIED' WHERE service_code = @fid;
    END

    -- Nếu status chuyển sang CHECKED_OUT hoặc CANCELLED → AVAILABLE
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.booking_id = d.booking_id
               WHERE i.status IN ('CHECKED_OUT','CANCELLED')
                 AND d.status NOT IN ('CHECKED_OUT','CANCELLED'))
    BEGIN
        SELECT @fid = i.facility_id
        FROM inserted i JOIN deleted d ON i.booking_id = d.booking_id
        WHERE i.status IN ('CHECKED_OUT','CANCELLED');

        IF EXISTS (SELECT 1 FROM tbl_villas WHERE service_code = @fid)
            UPDATE tbl_villas SET status = 'AVAILABLE' WHERE service_code = @fid;
        ELSE IF EXISTS (SELECT 1 FROM tbl_houses WHERE service_code = @fid)
            UPDATE tbl_houses SET status = 'AVAILABLE' WHERE service_code = @fid;
        ELSE
            UPDATE tbl_rooms  SET status = 'AVAILABLE' WHERE service_code = @fid;
    END
END;
GO

-- Trigger: Ghi audit log mỗi khi booking thay đổi
CREATE OR ALTER TRIGGER trg_audit_bookings
ON tbl_bookings AFTER INSERT, UPDATE, DELETE
AS BEGIN
    SET NOCOUNT ON;
    DECLARE @action VARCHAR(10);

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @action = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @action = 'INSERT';
    ELSE
        SET @action = 'DELETE';

    INSERT INTO tbl_audit_log(table_name, action, record_id, old_value, new_value, changed_at)
    SELECT
        'tbl_bookings', @action,
        ISNULL(i.booking_id, d.booking_id),
        CASE WHEN d.booking_id IS NOT NULL
             THEN 'status:' + d.status + '|facility:' + d.facility_id
             ELSE NULL END,
        CASE WHEN i.booking_id IS NOT NULL
             THEN 'status:' + i.status + '|facility:' + i.facility_id
             ELSE NULL END,
        GETDATE()
    FROM      inserted i
    FULL JOIN deleted  d ON i.booking_id = d.booking_id;
END;
GO

-- Trigger: Voucher tự đánh dấu is_used khi booking CONFIRMED
CREATE OR ALTER TRIGGER trg_mark_voucher_used
ON tbl_bookings AFTER INSERT, UPDATE
AS BEGIN
    SET NOCOUNT ON;
    UPDATE v SET v.is_used = 1
    FROM tbl_vouchers v
    JOIN inserted i ON i.voucher_id = v.voucher_id
    WHERE i.status IN ('CONFIRMED','CHECKED_IN','CHECKED_OUT')
      AND v.is_used = 0;
END;
GO

-- ================================================================
--  ❾  DATA MẪU
-- ================================================================

-- Phòng ban
INSERT INTO tbl_departments(dept_id, dept_name) VALUES
('DP01', N'Ban Quản lý'),
('DP02', N'Lễ tân & Đặt phòng'),
('DP03', N'Dịch vụ & Chăm sóc khách hàng'),
('DP04', N'Kỹ thuật & Bảo trì'),
('DP05', N'Kế toán & Tài chính');
GO

-- Nhân viên
EXEC sp_insert_employee 'NV001',N'Nguyễn Văn An',    '1985-03-10',N'Nam','001085111111','0901111111','an.nv@resort.vn',    'DP01',N'Senior',N'Manager',      30000000,'123456','2015-01-01';
EXEC sp_insert_employee 'NV002',N'Trần Thị Bình',    '1995-08-20',N'Nữ', '001095222222','0912222222','binh.tt@resort.vn',  'DP02',N'Junior',N'Receptionist', 12000000,'123456','2020-06-01';
EXEC sp_insert_employee 'NV003',N'Lê Văn Cường',     '1988-11-15',N'Nam','001088333333','0923333333','cuong.lv@resort.vn', 'DP01',N'Senior',N'Admin',        28000000,'123456','2016-03-15';
EXEC sp_insert_employee 'NV004',N'Phạm Thị Dịu',     '1997-05-25',N'Nữ', '001097444444','0934444444','diu.pt@resort.vn',   'DP02',N'Junior',N'Receptionist', 11500000,'123456','2022-01-10';
EXEC sp_insert_employee 'NV005',N'Hoàng Minh Em',    '1990-09-08',N'Nam','001090555555','0945555555','em.hm@resort.vn',    'DP03',N'Middle',N'Concierge',    15000000,'123456','2018-07-20';
EXEC sp_insert_employee 'NV006',N'Vũ Thị Phương',    '1993-12-30',N'Nữ', '001093666666','0956666666','phuong.vt@resort.vn','DP05',N'Middle',N'Accountant',   18000000,'123456','2019-04-05';
EXEC sp_insert_employee 'NV007',N'Đặng Văn Quân',    '1986-07-22',N'Nam','001086777777','0967777777','quan.dv@resort.vn',  'DP04',N'Senior',N'Technician',   17000000,'123456','2017-09-01';
GO

-- Gán manager cho phòng ban
UPDATE tbl_departments SET manager_id = 'NV001' WHERE dept_id = 'DP01';
UPDATE tbl_departments SET manager_id = 'NV002' WHERE dept_id = 'DP02';
UPDATE tbl_departments SET manager_id = 'NV005' WHERE dept_id = 'DP03';
UPDATE tbl_departments SET manager_id = 'NV007' WHERE dept_id = 'DP04';
UPDATE tbl_departments SET manager_id = 'NV006' WHERE dept_id = 'DP05';
GO

-- Khách hàng
EXEC sp_insert_customer 'KH001',N'Phạm Thị Hương',  '1985-03-22',N'Nữ', '002085101010','0901010101','huong.pt@gmail.com',  N'VIP',       N'12 Lê Lợi, Q1, TP.HCM';
EXEC sp_insert_customer 'KH002',N'Hoàng Minh Khoa', '1992-07-14',N'Nam','002092202020','0912020202','khoa.hm@gmail.com',   N'Normal',    N'45 Nguyễn Huệ, Đà Nẵng';
EXEC sp_insert_customer 'KH003',N'Vũ Thị Linh',     '1988-12-05',N'Nữ', '002088303030','0923030303','linh.vt@gmail.com',   N'Corporate', N'89 Hùng Vương, Hà Nội';
EXEC sp_insert_customer 'KH004',N'Ngô Văn Mạnh',    '1990-06-18',N'Nam','002090404040','0934040404','manh.nv@gmail.com',   N'VIP',       N'5 Điện Biên Phủ, Q3, TP.HCM';
EXEC sp_insert_customer 'KH005',N'Bùi Thị Nga',     '1995-01-29',N'Nữ', '002095505050','0945050505','nga.bt@gmail.com',    N'Normal',    N'23 Pasteur, Nha Trang';
EXEC sp_insert_customer 'KH006',N'Trịnh Văn Oanh',  '1983-09-11',N'Nam','002083606060','0956060606','oanh.tv@gmail.com',   N'Corporate', N'67 Lý Thường Kiệt, Huế';
EXEC sp_insert_customer 'KH007',N'Lý Thị Phúc',     '1998-04-03',N'Nữ', '002098707070','0967070707','phuc.lt@gmail.com',   N'Normal',    N'30 Trần Phú, Đà Lạt';
EXEC sp_insert_customer 'KH008',N'Đinh Văn Quý',    '1987-11-20',N'Nam','002087808080','0978080808','quy.dv@gmail.com',    N'VIP',       N'100 Nguyễn Văn Linh, Cần Thơ';
GO

-- Villas
INSERT INTO tbl_villas(service_code,service_name,usable_area,cost,max_people,rental_type,room_standard,pool_area,num_of_floor,status,description)
VALUES
('VL001',N'Villa Hướng Biển Sunrise', 350.0, 8500000,10,'day',N'5 sao', 80.0,2,'AVAILABLE',N'Villa sang trọng view biển, hồ bơi vô cực'),
('VL002',N'Villa Garden Paradise',    280.0, 6500000, 8,'day',N'4 sao', 60.0,2,'AVAILABLE',N'Villa vườn nhiệt đới yên tĩnh'),
('VL003',N'Villa Royal Ocean View',   450.0,12000000,14,'day',N'5 sao',120.0,3,'AVAILABLE',N'Villa hoàng gia 3 tầng, view 360 độ'),
('VL004',N'Villa Sunset Cliff',       320.0, 9000000,10,'day',N'5 sao', 70.0,2,'AVAILABLE',N'Villa trên vách đá, cảnh hoàng hôn tuyệt đẹp');
GO

-- Houses
INSERT INTO tbl_houses(service_code,service_name,usable_area,cost,max_people,rental_type,room_standard,num_of_floor,status,description)
VALUES
('HS001',N'Beach House Cozy',       120.0,2500000,6,'day',N'3 sao',2,'AVAILABLE',N'Ngôi nhà ấm cúng cạnh bãi biển'),
('HS002',N'Mountain View House',    180.0,3200000,8,'day',N'4 sao',2,'AVAILABLE',N'Nhà gỗ view núi, không khí trong lành'),
('HS003',N'Garden Family House',    150.0,2800000,6,'day',N'3 sao',2,'AVAILABLE',N'Nhà vườn phù hợp gia đình'),
('HS004',N'Riverside Bamboo House', 200.0,3800000,8,'day',N'4 sao',2,'AVAILABLE',N'Nhà tre bên sông, phong cách sinh thái');
GO

-- Rooms
INSERT INTO tbl_rooms(service_code,service_name,usable_area,cost,max_people,rental_type,free_services,status,floor_number)
VALUES
('RM001',N'Deluxe Ocean Room',      45.0, 850000,2,'day',N'Wifi, Breakfast, Pool','AVAILABLE',3),
('RM002',N'Superior Garden Room',   35.0, 650000,2,'day',N'Wifi, Breakfast','AVAILABLE',2),
('RM003',N'Suite Presidential',     85.0,2200000,4,'day',N'Wifi, Breakfast, Spa, Transfer','AVAILABLE',5),
('RM004',N'Standard Room',          28.0, 450000,2,'day',N'Wifi','AVAILABLE',1),
('RM005',N'Family Bungalow',        65.0,1200000,4,'day',N'Wifi, Breakfast, Bike','AVAILABLE',1),
('RM006',N'Honeymoon Suite',        70.0,1800000,2,'day',N'Wifi, Breakfast, Flowers, Jacuzzi','AVAILABLE',4);
GO

-- Dịch vụ phụ trợ
INSERT INTO tbl_services(service_name,category,unit_price,unit,description)
VALUES
(N'Massage toàn thân 60 phút',  'SPA',       350000,N'lượt',  N'Massage thư giãn với tinh dầu'),
(N'Facial treatment 90 phút',   'SPA',       500000,N'lượt',  N'Chăm sóc da mặt cao cấp'),
(N'Tour tham quan thành phố',   'TOUR',      250000,N'người', N'Khám phá văn hóa địa phương'),
(N'Tour lặn biển',              'TOUR',      800000,N'người', N'Lặn ngắm san hô với HDV'),
(N'Xe đưa đón sân bay',        'TRANSPORT',  300000,N'lượt',  N'Xe 7 chỗ điều hòa'),
(N'Tiệc BBQ tại villa',        'FOOD',      1500000,N'buổi',  N'BBQ ngoài trời cho 10 người'),
(N'Bữa sáng nâng cấp Buffet',  'FOOD',       250000,N'người', N'Buffet sáng 50+ món'),
(N'Thuê xe đạp',                'TRANSPORT',   80000,N'ngày',  N'Xe đạp địa hình khám phá'),
(N'Dịch vụ giặt ủi',           'OTHER',       50000,N'kg',    N'Giặt sấy ủi trong ngày'),
(N'Sinh nhật trọn gói',        'OTHER',      2000000,N'lần',  N'Trang trí, bánh, nến, chụp ảnh');
GO

-- Vouchers
INSERT INTO tbl_vouchers(customer_id,discount_percent,expiry_date,is_used,min_order_value)
VALUES
('KH001',20,'12/2025',0,5000000),
('KH001',10,'06/2026',0,2000000),
('KH002',15,'03/2026',0,3000000),
('KH003', 5,'09/2025',1,1000000),
('KH004',25,'12/2025',0,8000000),
('KH005',10,'06/2026',0,2000000),
('KH006',15,'03/2026',0,3000000),
('KH007', 5,'12/2026',0,1000000),
('KH008',30,'01/2026',0,10000000);
GO

-- Promotions
INSERT INTO tbl_promotions(promo_name,promo_code,discount_type,discount_value,start_date,end_date,min_nights,max_uses,applies_to)
VALUES
(N'Hè Rực Rỡ 2025',     'SUMMER25',  'PERCENT',20,'2025-06-01','2025-08-31',2,100,'ALL'),
(N'Tết Bính Ngọ',       'TET2026',   'PERCENT',30,'2026-01-25','2026-02-05',3, 50,'VILLA'),
(N'Cuối tuần vui',      'WEEKEND10', 'PERCENT',10,'2025-01-01','2025-12-31',1,NULL,'ROOM'),
(N'Đặt sớm 30 ngày',    'EARLY30',   'FIXED',  500000,'2025-01-01','2025-12-31',3, 200,'ALL'),
(N'Khách doanh nghiệp', 'CORP2025',  'PERCENT',15,'2025-01-01','2025-12-31',2,NULL,'HOUSE');
GO

-- Bookings (nhiều trạng thái)
EXEC sp_create_booking 'BK001','KH001','VL001','10/01/2025','15/01/2025',2,1,1,N'Cần view biển, tầng cao',        'NV002';
EXEC sp_create_booking 'BK002','KH002','HS001','20/02/2025','25/02/2025',3,0,NULL,NULL,                            'NV002';
EXEC sp_create_booking 'BK003','KH003','RM003','01/04/2025','05/04/2025',2,0,3,N'Trăng mật - xin trang trí phòng','NV004';
EXEC sp_create_booking 'BK004','KH004','VL002','10/04/2025','14/04/2025',4,2,5,NULL,                               'NV002';
EXEC sp_create_booking 'BK005','KH005','RM001','05/05/2025','10/05/2025',1,0,NULL,NULL,                            'NV004';
EXEC sp_create_booking 'BK006','KH001','HS002','15/06/2025','20/06/2025',2,1,1,N'Phòng yên tĩnh',                 'NV002';
EXEC sp_create_booking 'BK007','KH006','VL003','01/07/2025','07/07/2025',6,3,6,N'Họp công ty 10 người',           'NV004';
EXEC sp_create_booking 'BK008','KH007','RM006','14/02/2026','17/02/2026',2,0,8,N'Valentine, xin hoa hồng',        'NV002';
EXEC sp_create_booking 'BK009','KH008','VL004','20/08/2025','27/08/2025',4,2,9,NULL,                               'NV004';
EXEC sp_create_booking 'BK010','KH002','RM005','10/09/2025','15/09/2025',2,1,NULL,N'Cần giường phụ cho trẻ em',    'NV002';
GO

-- Cập nhật status một số booking
UPDATE tbl_bookings SET status = 'CHECKED_OUT' WHERE booking_id IN ('BK001','BK002','BK003');
UPDATE tbl_bookings SET status = 'CHECKED_IN'  WHERE booking_id = 'BK004';
UPDATE tbl_bookings SET status = 'CANCELLED'   WHERE booking_id = 'BK010';
GO

-- Dịch vụ đặt kèm booking
INSERT INTO tbl_booking_services(booking_id,service_id,quantity,unit_price,service_date,note)
VALUES
('BK001',1,2, 350000,'11/01/2025',N'2 người massage'),
('BK001',6,1,1500000,'13/01/2025',N'BBQ tối thứ 4'),
('BK001',5,1, 300000,'10/01/2025',N'Đón sân bay'),
('BK002',3,3, 250000,'21/02/2025',N'Tour thành phố 3 người'),
('BK003',2,1, 500000,'02/04/2025',N'Facial cho cô dâu'),
('BK003',10,1,2000000,'04/04/2025',N'Gói sinh nhật bất ngờ'),
('BK004',4,4, 800000,'11/04/2025',N'Lặn biển 4 người'),
('BK005',8,2,  80000,'06/05/2025',N'Thuê xe đạp 2 ngày'),
('BK006',1,2, 350000,'16/06/2025',N'Couples massage'),
('BK007',6,2,1500000,'03/07/2025',N'BBQ 2 buổi'),
('BK007',5,2, 300000,'01/07/2025',N'Đón 2 xe sân bay'),
('BK009',4,6, 800000,'22/08/2025',N'Lặn biển cả nhóm');
GO

-- Thanh toán
EXEC sp_make_payment 'CT-BK001', 42500000,'BANK_TRANSFER','NV006','TXN20250115001';
EXEC sp_make_payment 'CT-BK002', 12500000,'CASH',          'NV006', NULL;
EXEC sp_make_payment 'CT-BK003',  2550000,'MOMO',          'NV006','MOMO20250401';
EXEC sp_make_payment 'CT-BK003',  5950000,'CREDIT_CARD',   'NV006','CC20250405001';
EXEC sp_make_payment 'CT-BK004', 18200000,'BANK_TRANSFER', 'NV006','TXN20250410002';
EXEC sp_make_payment 'CT-BK005',  4250000,'CASH',          'NV006', NULL;
EXEC sp_make_payment 'CT-BK006', 16000000,'VNPAY',         'NV006','VP20250620001';
EXEC sp_make_payment 'CT-BK007', 48000000,'BANK_TRANSFER', 'NV006','TXN20250707003';
GO

-- Đánh giá
INSERT INTO tbl_reviews(booking_id,customer_id,rating,title,content,reply)
VALUES
('BK001','KH001',5,N'Tuyệt vời!',
 N'Villa cực kỳ sang trọng, nhân viên chu đáo, hồ bơi đẹp. Sẽ quay lại!',
 N'Cảm ơn quý khách đã tin tưởng. Hẹn gặp lại!'),
('BK002','KH002',4,N'Rất tốt',
 N'Beach house thoải mái, sạch sẽ. Bữa sáng ngon. Trừ 1 sao vì wifi yếu.',
 N'Chúng tôi đã nâng cấp hệ thống Wifi, mong quý khách trải nghiệm lần sau.'),
('BK003','KH003',5,N'Kỳ nghỉ trăng mật hoàn hảo',
 N'Phòng được trang trí rất lãng mạn, dịch vụ spa xuất sắc. Không thể hài lòng hơn!',
 N'Chúc mừng hạnh phúc đến hai bạn!'),
('BK005','KH005',3,N'Bình thường',
 N'Phòng sạch nhưng hơi nhỏ. Nhân viên lễ tân chưa nhiệt tình lắm.',
 N'Xin lỗi vì trải nghiệm chưa tốt. Chúng tôi sẽ cải thiện dịch vụ.');
GO

-- Lịch bảo trì
INSERT INTO tbl_maintenance(facility_id,facility_type,start_date,end_date,reason,status,assigned_to,cost)
VALUES
('VL002','VILLA', '2025-03-01','2025-03-07',N'Sơn lại tường, bảo dưỡng hồ bơi',    'COMPLETED','NV007',15000000),
('HS003','HOUSE', '2025-04-15','2025-04-18',N'Thay hệ thống điện',                  'COMPLETED','NV007', 8000000),
('RM004','ROOM',  '2025-05-10','2025-05-11',N'Thay toilet, sửa vòi hoa sen',        'COMPLETED','NV007', 3000000),
('VL001','VILLA', '2026-02-15',NULL,         N'Bảo dưỡng định kỳ hệ thống điều hòa','SCHEDULED','NV007', 5000000);
GO

-- ================================================================
--  ❿  KIỂM TRA KẾT QUẢ
-- ================================================================
PRINT '===== RESORT DB v2.0 — VERIFICATION =====';

SELECT table_name = 'tbl_persons',        cnt = COUNT(*) FROM tbl_persons        UNION ALL
SELECT 'tbl_departments',                              COUNT(*) FROM tbl_departments    UNION ALL
SELECT 'tbl_employees',                                COUNT(*) FROM tbl_employees      UNION ALL
SELECT 'tbl_customers',                                COUNT(*) FROM tbl_customers      UNION ALL
SELECT 'tbl_villas',                                   COUNT(*) FROM tbl_villas         UNION ALL
SELECT 'tbl_houses',                                   COUNT(*) FROM tbl_houses         UNION ALL
SELECT 'tbl_rooms',                                    COUNT(*) FROM tbl_rooms          UNION ALL
SELECT 'tbl_services',                                 COUNT(*) FROM tbl_services       UNION ALL
SELECT 'tbl_vouchers',                                 COUNT(*) FROM tbl_vouchers       UNION ALL
SELECT 'tbl_promotions',                               COUNT(*) FROM tbl_promotions     UNION ALL
SELECT 'tbl_bookings',                                 COUNT(*) FROM tbl_bookings       UNION ALL
SELECT 'tbl_booking_services',                         COUNT(*) FROM tbl_booking_services UNION ALL
SELECT 'tbl_contracts',                                COUNT(*) FROM tbl_contracts      UNION ALL
SELECT 'tbl_payments',                                 COUNT(*) FROM tbl_payments       UNION ALL
SELECT 'tbl_reviews',                                  COUNT(*) FROM tbl_reviews        UNION ALL
SELECT 'tbl_maintenance',                              COUNT(*) FROM tbl_maintenance    UNION ALL
SELECT 'tbl_audit_log',                                COUNT(*) FROM tbl_audit_log;

PRINT '-- Top khach hang --';
EXEC sp_top_customers 5;

PRINT '-- Doanh thu Q1 2025 --';
EXEC sp_revenue_report '2025-01-01','2025-03-31';

PRINT '-- Danh sach booking --';
SELECT booking_id, customer_name, facility_name, start_date, end_date,
       dbo.fn_nights(start_date,end_date) AS nights,
       dbo.fn_room_cost(booking_id)       AS room_cost,
       status
FROM vw_bookings ORDER BY booking_id;

PRINT '-- Danh gia co so --';
SELECT * FROM vw_facility_ratings ORDER BY avg_rating DESC;

PRINT '===== ResortDB v2.0 READY! =====';
GO