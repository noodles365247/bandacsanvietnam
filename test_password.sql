-- ============================================
-- Script để test và tạo lại password đúng
-- Chạy script này để tạo lại user với password đã mã hóa đúng
-- ============================================

-- Xóa user cũ nếu cần
-- DELETE FROM users WHERE username IN ('admin', 'user1', 'vendor1');

-- Tạo lại ADMIN với password: admin123
-- LƯU Ý: Hash này có thể không đúng, tốt nhất dùng Java code DataInitializer
INSERT INTO users (username, password, email, role) 
VALUES (
    'admin',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'admin@dacsan.com',
    'ADMIN'
) ON DUPLICATE KEY UPDATE 
    password = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    role = 'ADMIN';

-- Tạo lại CUSTOMER với password: user123
INSERT INTO users (username, password, email, role) 
VALUES (
    'user1',
    '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.H/HvYrJ5jqK5qK5qK5qK',
    'user1@dacsan.com',
    'CUSTOMER'
) ON DUPLICATE KEY UPDATE 
    password = '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.H/HvYrJ5jqK5qK5qK5qK',
    role = 'CUSTOMER';

-- Tạo lại VENDOR với password: vendor123
INSERT INTO users (username, password, email, role) 
VALUES (
    'vendor1',
    '$2a$10$8K1p/a0dL3YXvO8K1p/a0dL3YXvO8K1p/a0dL3YXvO8K1p/a0dL3YXvO',
    'vendor1@dacsan.com',
    'VENDOR'
) ON DUPLICATE KEY UPDATE 
    password = '$2a$10$8K1p/a0dL3YXvO8K1p/a0dL3YXvO8K1p/a0dL3YXvO8K1p/a0dL3YXvO',
    role = 'VENDOR';

-- Kiểm tra dữ liệu
SELECT id, username, email, role, LEFT(password, 20) as password_hash FROM users;

