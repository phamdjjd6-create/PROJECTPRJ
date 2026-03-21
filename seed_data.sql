-- USE ResortDB; -- Replace with actual DB name if needed

-- Insert 3 new Facilities
INSERT INTO tbl_facilities (service_code, service_name, usable_area, cost, max_people, rental_type, status, facility_type, description, image_url, created_at, updated_at, is_deleted)
VALUES 
('RM-0004', N'Super Deluxe Room', 45.0, 1500000, 2, 'DAY', 'AVAILABLE', 'ROOM', N'Phòng Deluxe rộng rãi, view ngắm biển trực tiếp, có bồn tắm', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', GETDATE(), GETDATE(), 0),
('RM-0005', N'Suite Ocean Room', 65.0, 2500000, 4, 'DAY', 'AVAILABLE', 'ROOM', N'Phòng Suite cao cấp, 2 giường đôi lớn, ban công rộng view biển toàn cảnh', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', GETDATE(), GETDATE(), 0),
('VL-0003', N'Royal Beach Villa', 250.0, 8000000, 8, 'DAY', 'AVAILABLE', 'VILLA', N'Villa cao cấp nhất, có hồ bơi riêng, nằm ngay sát bãi biển, 4 phòng ngủ', 'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', GETDATE(), GETDATE(), 0);

-- Insert Room specifics
INSERT INTO tbl_rooms (service_code, free_services, floor_number)
VALUES
('RM-0004', N'Ăn sáng miễn phí, Nước uống, Trái cây', 'Tầng 4'),
('RM-0005', N'Ăn sáng, Spa massage 30p, Xe đưa đón sân bay', 'Tầng 5');

-- Insert Villa specifics
INSERT INTO tbl_villas (service_code, standard_room, description, pool_area, floors)
VALUES
('VL-0003', N'Tuyệt đối sang trọng', N'Tiêu chuẩn 5 sao', 60.0, 2);

-- Insert Promotion Code (SUMMER2026 - 10% Off)
INSERT INTO tbl_promotions (promo_name, promo_code, discount_type, discount_value, start_date, end_date, min_nights, max_uses, used_count, applies_to, is_active)
VALUES 
(N'Khuyến mãi Hè Sôi Động', 'SUMMER2026', 'PERCENT', 10.00, '2026-03-01', '2026-09-30', 1, 100, 0, 'ALL', 1),
(N'Giảm giá 500k', 'GIAM500K', 'AMOUNT', 500000, '2026-03-01', '2026-12-31', 1, 50, 0, 'ALL', 1);
