USE ResortDB;
GO

CREATE OR ALTER VIEW vw_contracts AS
SELECT
    ct.contract_id,
    ct.deposit,
    ct.total_payment,
    ct.paid_amount,
    (ct.total_payment - ct.paid_amount) AS remaining_amount,
    ct.status,
    ct.signed_date,
    ct.notes,
    b.booking_id,
    CONVERT(VARCHAR(10), b.start_date, 120) AS start_date,
    CONVERT(VARCHAR(10), b.end_date,   120) AS end_date,
    b.facility_id,
    f.facility_type,
    pc.id          AS customer_id,
    pc.full_name   AS customer_name,
    pe.id          AS employee_id,
    pe.full_name   AS employee_name
FROM tbl_contracts ct
JOIN tbl_bookings  b   ON ct.booking_id  = b.booking_id
JOIN tbl_persons   pc  ON b.customer_id  = pc.id
JOIN tbl_facilities f  ON b.facility_id  = f.service_code
LEFT JOIN tbl_employees e   ON ct.employee_id = e.id
LEFT JOIN tbl_persons   pe  ON e.id = pe.id;
GO
