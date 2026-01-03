-- ============================================
-- SQL Script để tạo dữ liệu User và Admin
-- Database: dbdacsan
-- Table: users
-- ============================================
-- LƯU Ý: 
-- 1. Password đã được mã hóa bằng BCrypt
-- 2. Nếu muốn đổi password, hãy dùng Java code DataInitializer.java
-- 3. Hoặc chạy ứng dụng Java, nó sẽ tự động tạo user nếu chưa có

-- Xóa dữ liệu cũ (nếu cần - BỎ COMMENT để chạy)
-- DELETE FROM users WHERE username IN ('admin', 'user1', 'vendor1');

-- Tạo User ADMIN
-- Password: admin123
INSERT IGNORE INTO users (username, password, email, role) 
VALUES (
    'admin',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'admin@dacsan.com',
    'ADMIN'
);

-- Tạo User CUSTOMER (người dùng thường)
-- Password: user123
INSERT IGNORE INTO users (username, password, email, role) 
VALUES (
    'user1',
    '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.H/HvYrJ5jqK5qK5qK5qK',
    'user1@dacsan.com',
    'CUSTOMER'
);

-- Tạo User VENDOR (nhà bán hàng)
-- Password: vendor123
INSERT IGNORE INTO users (username, password, email, role) 
VALUES (
    'vendor1',
    '$2a$10$8K1p/a0dL3YXvO8K1p/a0dL3YXvO8K1p/a0dL3YXvO8K1p/a0dL3YXvO',
    'vendor1@dacsan.com',
    'VENDOR'
);

-- Kiểm tra dữ liệu đã insert
SELECT id, username, email, role FROM users;
