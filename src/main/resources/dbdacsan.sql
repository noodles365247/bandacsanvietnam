-- ============================================================
-- SCRIPT KHỞI TẠO LẠI TOÀN BỘ DATABASE (FULL RESET & DEMO DATA)
-- Phiên bản: Demo Final (Compatible with Cloud/Railway)
-- ============================================================

-- 1. TẠO DATABASE (Commented out for Cloud compatibility where DB name is pre-assigned)
-- CREATE DATABASE IF NOT EXISTS dbdacsan CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE dbdacsan;

-- 2. XÓA SẠCH DỮ LIỆU CŨ (DROP TABLES)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `promotions`;
DROP TABLE IF EXISTS `vouchers`;
DROP TABLE IF EXISTS `addresses`;
DROP TABLE IF EXISTS `vendor_revenue`;
DROP TABLE IF EXISTS `chat_messages`;
DROP TABLE IF EXISTS `chat_rooms`;
DROP TABLE IF EXISTS `blog_product`;
DROP TABLE IF EXISTS `blogs`;
DROP TABLE IF EXISTS `ratings`;
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `cart_items`;
DROP TABLE IF EXISTS `cart`;
DROP TABLE IF EXISTS `images`;
DROP TABLE IF EXISTS `product_category`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `brands`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `vendors`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 3. TẠO CẤU TRÚC BẢNG (SCHEMA)
-- ============================================================

-- Bảng Users
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL, -- ADMIN, VENDOR, USER
  `active` bit(1) DEFAULT 1,
  `reset_password_token` varchar(64) DEFAULT NULL,
  `verification_code` varchar(64) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_username` (`username`),
  UNIQUE KEY `UK_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Vendors
CREATE TABLE `vendors` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `store_name` varchar(255) DEFAULT NULL,
  `description_vi` text,
  `description_en` text,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_user_id` (`user_id`),
  CONSTRAINT `FK_vendors_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Categories (Có phân cấp)
CREATE TABLE `categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name_vi` varchar(255) DEFAULT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Brands (Thương hiệu)
CREATE TABLE `brands` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `image_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Products
CREATE TABLE `products` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vendor_id` bigint DEFAULT NULL,
  `brand_id` bigint DEFAULT NULL,
  `name_vi` varchar(255) DEFAULT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `description_vi` text,
  `description_en` text,
  `price` double DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `sold_count` int DEFAULT 0,
  `unit` varchar(50) DEFAULT NULL,
  `shelf_life` varchar(100) DEFAULT NULL,
  `is_active` bit(1) DEFAULT 1,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(100) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_products_vendors` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`),
  CONSTRAINT `FK_products_brands` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Product_Category
CREATE TABLE `product_category` (
  `product_id` bigint NOT NULL,
  `category_id` bigint NOT NULL,
  KEY `FK_pc_product` (`product_id`),
  KEY `FK_pc_category` (`category_id`),
  CONSTRAINT `FK_pc_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `FK_pc_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Images
CREATE TABLE `images` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `main` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_images_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Cart
CREATE TABLE `cart` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_cart_user` (`user_id`),
  CONSTRAINT `FK_cart_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng CartItems
CREATE TABLE `cart_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cart_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_cartitems_cart` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  CONSTRAINT `FK_cartitems_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Orders
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `shipping_fee` double DEFAULT 0,
  `status` varchar(50) DEFAULT NULL, -- PENDING, PROCESSING, SHIPPING, DELIVERED, CANCELLED
  `recipient_name` varchar(255) DEFAULT NULL,
  `recipient_phone` varchar(20) DEFAULT NULL,
  `shipping_address` varchar(255) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT 'COD',
  `note` text,
  `carrier` varchar(100) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng OrderItems
CREATE TABLE `order_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_orderitems_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FK_orderitems_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Payments
CREATE TABLE `payments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL, -- COD, VNPAY
  `status` varchar(50) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_payments_order` (`order_id`),
  CONSTRAINT `FK_payments_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Ratings
CREATE TABLE `ratings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `stars` int DEFAULT NULL,
  `comment` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_ratings_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `FK_ratings_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Blogs
CREATE TABLE `blogs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `author_id` bigint DEFAULT NULL,
  `title_vi` varchar(255) DEFAULT NULL,
  `title_en` varchar(255) DEFAULT NULL,
  `content_vi` text,
  `content_en` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_blogs_users` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Blog_Product
CREATE TABLE `blog_product` (
  `blog_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  KEY `FK_bp_blog` (`blog_id`),
  KEY `FK_bp_product` (`product_id`),
  CONSTRAINT `FK_bp_blog` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`),
  CONSTRAINT `FK_bp_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Addresses
CREATE TABLE `addresses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `recipient_name` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `city` varchar(100) NOT NULL,
  `district` varchar(100) NOT NULL,
  `ward` varchar(100) DEFAULT NULL,
  `specific_address` varchar(255) NOT NULL,
  `is_default` bit(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_addresses_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Chat
CREATE TABLE `chat_rooms` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint DEFAULT NULL,
  `vendor_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_chatrooms_customer` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FK_chatrooms_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `chat_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_id` bigint DEFAULT NULL,
  `sender_id` bigint DEFAULT NULL,
  `message` text,
  `timestamp` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_chatmessages_room` FOREIGN KEY (`room_id`) REFERENCES `chat_rooms` (`id`),
  CONSTRAINT `FK_chatmessages_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Doanh thu
CREATE TABLE `vendor_revenue` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vendor_id` bigint DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_revenue_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Vouchers
CREATE TABLE `vouchers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL UNIQUE,
  `discount_amount` double DEFAULT 0,
  `discount_percent` int DEFAULT 0,
  `min_order_amount` double DEFAULT 0,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `quantity` int DEFAULT 0,
  `vendor_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Promotions
CREATE TABLE `promotions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `discount_percent` int NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_promotions_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. NẠP DỮ LIỆU MẪU (SEEDING DATA)
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;

-- 4.1. USERS (Mật khẩu: 123456)
INSERT INTO `users` (`id`, `username`, `password`, `email`, `fullname`, `role`, `active`, `avatar`, `phone`) VALUES 
(1, 'admin', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'admin@gmail.com', 'Admin Hệ Thống', 'ADMIN', 1, 'https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff', '0909000111'),
(2, 'vendor_bac', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'bac@dacsan.com', 'Chủ Shop Bắc', 'VENDOR', 1, 'https://ui-avatars.com/api/?name=Vendor+Bac&background=E74C3C&color=fff', '0909000222'),
(3, 'vendor_nam', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'nam@dacsan.com', 'Chủ Shop Nam', 'VENDOR', 1, 'https://ui-avatars.com/api/?name=Vendor+Nam&background=F1C40F&color=fff', '0909000333'),
(4, 'khachhang1', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'khach1@gmail.com', 'Nguyễn Văn Mua', 'USER', 1, 'https://ui-avatars.com/api/?name=Nguyen+Mua&background=random', '0909000444'),
(5, 'khachhang2', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'khach2@gmail.com', 'Trần Thị Sắm', 'USER', 1, 'https://ui-avatars.com/api/?name=Tran+Sam&background=random', '0909000555');

-- 4.2. VENDORS
INSERT INTO `vendors` (`id`, `user_id`, `store_name`, `address`, `phone`, `description_vi`, `avatar`) VALUES 
(1, 2, 'Hương Vị Miền Bắc', 'Số 10, Phố Cổ, Hà Nội', '0901234567', 'Chuyên cung cấp đặc sản chuẩn vị Bắc Bộ, đảm bảo vệ sinh an toàn thực phẩm.', 'https://placehold.co/100x100/E74C3C/fff?text=Bac'),
(2, 3, 'Đặc Sản Phương Nam', 'Quận 1, TP. Hồ Chí Minh', '0909888777', 'Mang hương vị miền Tây sông nước đến mọi nhà.', 'https://placehold.co/100x100/F1C40F/fff?text=Nam');

-- 4.3. BRANDS
INSERT INTO `brands` (`id`, `name`, `description`) VALUES 
(1, 'Làng Nghề Truyền Thống', 'Các sản phẩm thủ công lâu đời'),
(2, 'Đặc Sản 3 Miền', 'Thương hiệu phân phối uy tín'),
(3, 'Nông Sản Việt', 'Sản phẩm OCOP chất lượng cao'),
(4, 'Quà Quê', 'Các món quà biếu tặng ý nghĩa');

-- 4.4. CATEGORIES
INSERT INTO `categories` (`id`, `name_vi`, `name_en`, `parent_id`) VALUES 
(1, 'Đặc sản Miền Bắc', 'Northern Specialties', NULL),
(2, 'Đặc sản Miền Trung', 'Central Specialties', NULL),
(3, 'Đặc sản Miền Nam', 'Southern Specialties', NULL),
(4, 'Đồ khô', 'Dried Food', NULL),
(5, 'Bánh kẹo', 'Cakes & Candies', NULL),
(6, 'Rượu & Đồ uống', 'Drinks & Wine', NULL);

-- 4.5. ADDRESSES (Địa chỉ khách hàng)
INSERT INTO `addresses` (`user_id`, `recipient_name`, `phone`, `city`, `district`, `ward`, `specific_address`, `is_default`) VALUES
(4, 'Nguyễn Văn Mua', '0909000444', 'TP. Hồ Chí Minh', 'Quận Thủ Đức', 'Phường Linh Chiểu', 'Số 1, Võ Văn Ngân', 1),
(5, 'Trần Thị Sắm', '0909000555', 'Hà Nội', 'Quận Cầu Giấy', 'Phường Dịch Vọng', 'Số 10, Xuân Thủy', 1);

-- 4.6. PRODUCTS (30 Sản phẩm đa dạng)
-- Vendor 1 (Bắc - Trung)
INSERT INTO `products` (`id`, `vendor_id`, `brand_id`, `name_vi`, `name_en`, `price`, `stock`, `sold_count`, `unit`, `is_active`, `slug`, `description_vi`, `description_en`) VALUES 
(1, 1, 1, 'Nem Chua Thanh Hóa', 'Fermented Pork Roll', 50000, 100, 50, 'Chục', 1, 'nem-chua-thanh-hoa', 'Nem chua giòn ngon, chuẩn vị xứ Thanh.', 'Delicious fermented pork roll.'),
(2, 1, 3, 'Thịt Trâu Gác Bếp', 'Smoked Buffalo Meat', 850000, 20, 5, 'Kg', 1, 'thit-trau-gac-bep', 'Thịt trâu tươi hun khói, gia vị mắc khén.', 'Smoked buffalo meat with spices.'),
(3, 1, 1, 'Cốm Làng Vòng', 'Young Green Rice', 200000, 50, 12, 'Gói', 1, 'com-lang-vong', 'Hạt cốm dẻo thơm hương vị mùa thu.', 'Fragrant young green rice.'),
(4, 1, 2, 'Chả Mực Hạ Long', 'Ha Long Squid Cake', 450000, 30, 8, 'Kg', 1, 'cha-muc-ha-long', 'Chả mực giã tay dai giòn.', 'Hand-pounded squid cake.'),
(5, 1, 1, 'Bánh Đậu Xanh HD', 'Mung Bean Cake', 45000, 500, 150, 'Hộp', 1, 'banh-dau-xanh', 'Bánh đậu xanh Rồng Vàng.', 'Golden Dragon mung bean cake.'),
(6, 1, 2, 'Ô Mai Sấu Hà Nội', 'Dracontomelon O Mai', 65000, 100, 40, 'Hộp', 1, 'o-mai-sau', 'Vị chua ngọt đặc trưng Hà Thành.', 'Sour and sweet taste.'),
(7, 1, 3, 'Chả Cá Lã Vọng', 'La Vong Fish Cake', 150000, 50, 20, 'Suất', 1, 'cha-ca-la-vong', 'Chả cá lăng nướng than hoa.', 'Grilled fish cake.'),
(8, 1, 4, 'Bánh Cáy Thái Bình', 'Cay Cake', 30000, 100, 30, 'Hộp', 1, 'banh-cay-thai-binh', 'Bánh cáy làng Nguyễn.', 'Traditional cake.'),
(9, 1, 1, 'Tương Bần', 'Ban Soy Sauce', 20000, 200, 80, 'Chai', 1, 'tuong-ban', 'Tương bần Hưng Yên ngon tuyệt.', 'Soy sauce.'),
(10, 1, 2, 'Rượu Mẫu Sơn', 'Mau Son Wine', 250000, 50, 10, 'Chai', 1, 'ruou-mau-son', 'Rượu đặc sản Lạng Sơn.', 'Specialty wine.'),
(11, 1, 3, 'Gà Đồi Yên Thế', 'Yen The Chicken', 180000, 40, 15, 'Kg', 1, 'ga-doi-yen-the', 'Gà thả đồi thịt chắc.', 'Hill chicken.'),
(12, 1, 4, 'Vải Thiều Lục Ngạn', 'Luc Ngan Lychee', 40000, 500, 200, 'Kg', 1, 'vai-thieu-luc-ngan', 'Vải thiều tươi ngon.', 'Fresh lychee.'),
(13, 1, 1, 'Măng Khô', 'Dried Bamboo Shoot', 250000, 30, 10, 'Kg', 1, 'mang-kho', 'Măng khô Tây Bắc.', 'Dried bamboo shoot.'),
(14, 1, 2, 'Thịt Lợn Mán', 'Man Pork', 200000, 40, 12, 'Kg', 1, 'thit-lon-man', 'Thịt lợn mán sạch.', 'Clean pork.'),
(15, 1, 3, 'Mật Ong Bạc Hà', 'Mint Honey', 300000, 60, 25, 'Lít', 1, 'mat-ong-bac-ha', 'Mật ong Hà Giang.', 'Ha Giang honey.'),
-- Vendor 2 (Nam - Trung)
(16, 2, 1, 'Mè Xửng Huế', 'Sesame Candy', 30000, 100, 40, 'Gói', 1, 'me-xung-hue', 'Mè xửng dẻo thơm.', 'Sesame candy.'),
(17, 2, 2, 'Mắm Tôm Chua', 'Sour Shrimp Paste', 50000, 80, 35, 'Hũ', 1, 'mam-tom-chua', 'Mắm tôm chua Huế.', 'Sour shrimp paste.'),
(18, 2, 3, 'Bánh Tráng Xoài', 'Mango Cake', 25000, 150, 60, 'Bịch', 1, 'banh-trang-xoai', 'Bánh tráng xoài Nha Trang.', 'Mango cake.'),
(19, 2, 4, 'Yến Sào Khánh Hòa', 'Salanganes Nest', 3000000, 10, 5, 'Hộp', 1, 'yen-sao-khanh-hoa', 'Yến sào cao cấp.', 'Premium nest.'),
(20, 2, 1, 'Rượu Bàu Đá', 'Bau Da Wine', 120000, 50, 20, 'Chai', 1, 'ruou-bau-da', 'Rượu Bàu Đá Bình Định.', 'Bau Da wine.'),
(21, 2, 2, 'Tỏi Lý Sơn', 'Ly Son Garlic', 150000, 100, 50, 'Kg', 1, 'toi-ly-son', 'Tỏi cô đơn Lý Sơn.', 'Lonely garlic.'),
(22, 2, 3, 'Bánh Pía Sóc Trăng', 'Durian Cake', 60000, 200, 100, 'Túi', 1, 'banh-pia-soc-trang', 'Bánh pía sầu riêng.', 'Durian cake.'),
(23, 2, 4, 'Kẹo Dừa Bến Tre', 'Coconut Candy', 40000, 300, 150, 'Hộp', 1, 'keo-dua-ben-tre', 'Kẹo dừa béo ngậy.', 'Coconut candy.'),
(24, 2, 1, 'Nem Lai Vung', 'Lai Vung Fermented Pork', 35000, 150, 70, 'Chục', 1, 'nem-lai-vung', 'Nem Lai Vung Đồng Tháp.', 'Fermented pork.'),
(25, 2, 2, 'Hủ Tiếu Mỹ Tho', 'My Tho Noodle', 30000, 100, 40, 'Gói', 1, 'hu-tieu-my-tho', 'Hủ tiếu dai ngon.', 'Noodle.'),
(26, 2, 3, 'Rượu Sim Phú Quốc', 'Sim Wine', 200000, 60, 30, 'Chai', 1, 'ruou-sim-phu-quoc', 'Rượu sim rừng.', 'Sim wine.'),
(27, 2, 4, 'Nước Mắm Phú Quốc', 'Fish Sauce', 100000, 100, 50, 'Chai', 1, 'nuoc-mam-phu-quoc', 'Nước mắm nhỉ cá cơm.', 'Fish sauce.'),
(28, 2, 1, 'Tôm Khô Cà Mau', 'Dried Shrimp', 800000, 20, 8, 'Kg', 1, 'tom-kho-ca-mau', 'Tôm khô tự nhiên.', 'Dried shrimp.'),
(29, 2, 2, 'Bánh Tét Trà Cuôn', 'Tra Cuon Cylindrical Cake', 120000, 50, 20, 'Đòn', 1, 'banh-tet-tra-cuon', 'Bánh tét Trà Vinh.', 'Cylindrical cake.'),
(30, 2, 3, 'Dừa Sáp Trà Vinh', 'Macapuno Coconut', 150000, 30, 10, 'Trái', 1, 'dua-sap-tra-vinh', 'Dừa sáp béo ngậy.', 'Macapuno coconut.');

-- 4.7. PRODUCT CATEGORY MAPPING (Map sản phẩm vào danh mục tương ứng)
INSERT INTO `product_category` (`product_id`, `category_id`) VALUES
-- Miền Bắc (Products 1-15)
(1, 1), (1, 4), -- Nem chua (Bắc, Khô)
(2, 1), (2, 4), -- Thịt trâu (Bắc, Khô)
(3, 1), (3, 5), -- Cốm (Bắc, Bánh)
(4, 1), (4, 4), -- Chả mực (Bắc, Khô)
(5, 1), (5, 5), -- Bánh đậu xanh (Bắc, Bánh)
(6, 1), (6, 5), -- Ô mai (Bắc, Bánh)
(7, 1), (7, 4), -- Chả cá (Bắc, Khô)
(8, 1), (8, 5), -- Bánh cáy (Bắc, Bánh)
(9, 1), (9, 4), -- Tương bần (Bắc, Khô)
(10, 1), (10, 6), -- Rượu Mẫu Sơn (Bắc, Rượu)
(11, 1), (11, 4), -- Gà đồi (Bắc, Khô)
(12, 1), (12, 4), -- Vải thiều (Bắc, Khô)
(13, 1), (13, 4), -- Măng khô (Bắc, Khô)
(14, 1), (14, 4), -- Thịt lợn (Bắc, Khô)
(15, 1), (15, 4), -- Mật ong (Bắc, Khô)

-- Miền Trung (Products 16-21)
(16, 2), (16, 5), -- Mè xửng (Trung, Bánh)
(17, 2), (17, 4), -- Mắm tôm chua (Trung, Khô)
(18, 2), (18, 5), -- Bánh tráng xoài (Trung, Bánh)
(19, 2), (19, 4), -- Yến sào (Trung, Khô)
(20, 2), (20, 6), -- Rượu Bàu Đá (Trung, Rượu)
(21, 2), (21, 4), -- Tỏi Lý Sơn (Trung, Khô)

-- Miền Nam (Products 22-30)
(22, 3), (22, 5), -- Bánh Pía (Nam, Bánh)
(23, 3), (23, 5), -- Kẹo dừa (Nam, Bánh)
(24, 3), (24, 4), -- Nem Lai Vung (Nam, Khô)
(25, 3), (25, 4), -- Hủ tiếu (Nam, Khô)
(26, 3), (26, 6), -- Rượu Sim (Nam, Rượu)
(27, 3), (27, 4), -- Nước mắm (Nam, Khô)
(28, 3), (28, 4), -- Tôm khô (Nam, Khô)
(29, 3), (29, 5), -- Bánh tét (Nam, Bánh)
(30, 3), (30, 4); -- Dừa sáp (Nam, Khô)

-- 4.8. IMAGES (Ảnh mẫu cho 30 sản phẩm)
INSERT INTO `images` (`product_id`, `url`, `main`) VALUES
-- SP 1: Nem Chua
(1, 'https://placehold.co/600x400/E74C3C/fff?text=Nem+Chua+1', 1),
(1, 'https://placehold.co/600x400/E74C3C/fff?text=Nem+Chua+2', 0),
-- SP 2: Thịt Trâu
(2, 'https://placehold.co/600x400/34495E/fff?text=Thit+Trau+1', 1),
-- SP 3: Cốm
(3, 'https://placehold.co/600x400/2ECC71/fff?text=Com+Vong', 1),
-- SP 4: Chả Mực
(4, 'https://placehold.co/600x400/F1C40F/fff?text=Cha+Muc', 1),
-- SP 5: Bánh Đậu Xanh
(5, 'https://placehold.co/600x400/F39C12/fff?text=Banh+Dau+Xanh', 1),
-- SP 6: Ô Mai
(6, 'https://placehold.co/600x400/D35400/fff?text=O+Mai+Sau', 1),
-- SP 7: Chả Cá
(7, 'https://placehold.co/600x400/E67E22/fff?text=Cha+Ca', 1),
-- SP 8: Bánh Cáy
(8, 'https://placehold.co/600x400/E74C3C/fff?text=Banh+Cay', 1),
-- SP 9: Tương Bần
(9, 'https://placehold.co/600x400/8E44AD/fff?text=Tuong+Ban', 1),
-- SP 10: Rượu Mẫu Sơn
(10, 'https://placehold.co/600x400/95A5A6/fff?text=Ruou+Mau+Son', 1),
-- SP 11: Gà Đồi
(11, 'https://placehold.co/600x400/D35400/fff?text=Ga+Doi', 1),
-- SP 12: Vải Thiều
(12, 'https://placehold.co/600x400/C0392B/fff?text=Vai+Thieu', 1),
-- SP 13: Măng Khô
(13, 'https://placehold.co/600x400/F1C40F/fff?text=Mang+Kho', 1),
-- SP 14: Thịt Lợn Mán
(14, 'https://placehold.co/600x400/E74C3C/fff?text=Thit+Lon+Man', 1),
-- SP 15: Mật Ong
(15, 'https://placehold.co/600x400/F39C12/fff?text=Mat+Ong', 1),
-- SP 16: Mè Xửng
(16, 'https://placehold.co/600x400/E67E22/fff?text=Me+Xung', 1),
-- SP 17: Mắm Tôm Chua
(17, 'https://placehold.co/600x400/C0392B/fff?text=Mam+Tom+Chua', 1),
-- SP 18: Bánh Tráng Xoài
(18, 'https://placehold.co/600x400/F1C40F/fff?text=Banh+Trang+Xoai', 1),
-- SP 19: Yến Sào
(19, 'https://placehold.co/600x400/ECF0F1/000?text=Yen+Sao', 1),
-- SP 20: Rượu Bàu Đá
(20, 'https://placehold.co/600x400/95A5A6/fff?text=Ruou+Bau+Da', 1),
-- SP 21: Tỏi Lý Sơn
(21, 'https://placehold.co/600x400/ECF0F1/000?text=Toi+Ly+Son', 1),
-- SP 22: Bánh Pía
(22, 'https://placehold.co/600x400/F1C40F/fff?text=Banh+Pia', 1),
-- SP 23: Kẹo Dừa
(23, 'https://placehold.co/600x400/27AE60/fff?text=Keo+Dua', 1),
-- SP 24: Nem Lai Vung
(24, 'https://placehold.co/600x400/E74C3C/fff?text=Nem+Lai+Vung', 1),
-- SP 25: Hủ Tiếu
(25, 'https://placehold.co/600x400/ECF0F1/000?text=Hu+Tieu', 1),
-- SP 26: Rượu Sim
(26, 'https://placehold.co/600x400/8E44AD/fff?text=Ruou+Sim', 1),
-- SP 27: Nước Mắm
(27, 'https://placehold.co/600x400/D35400/fff?text=Nuoc+Mam', 1),
-- SP 28: Tôm Khô
(28, 'https://placehold.co/600x400/E74C3C/fff?text=Tom+Kho', 1),
-- SP 29: Bánh Tét
(29, 'https://placehold.co/600x400/2ECC71/fff?text=Banh+Tet', 1),
-- SP 30: Dừa Sáp
(30, 'https://placehold.co/600x400/ECF0F1/000?text=Dua+Sap', 1);

SET FOREIGN_KEY_CHECKS = 1;
