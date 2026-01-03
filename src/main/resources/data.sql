-- ============================================================
-- SCRIPT KHỞI TẠO LẠI TOÀN BỘ DATABASE (FULL RESET & DEMO DATA)
-- Phiên bản: Demo Final
-- ============================================================

-- 1. TẠO DATABASE

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
(7, 1, 3, 'Chè Tân Cương', 'Tan Cuong Tea', 250000, 80, 25, 'Gói', 1, 'che-tan-cuong', 'Trà móc câu đặc biệt.', 'Special hook tea.'),
(8, 1, 1, 'Bánh Cáy Thái Bình', 'Cay Cake', 30000, 200, 60, 'Hộp', 1, 'banh-cay', 'Bánh cáy làng Nguyễn dẻo thơm.', 'Cay cake from Nguyen village.'),
(9, 1, 2, 'Chả Rươi Tứ Kỳ', 'Sandworm Omelet', 550000, 20, 10, 'Kg', 1, 'cha-ruoi', 'Đặc sản rươi Tứ Kỳ béo ngậy.', 'Tu Ky sandworm specialty.'),
(10, 1, 3, 'Măng Khô Tây Bắc', 'Dried Bamboo Shoots', 180000, 150, 45, 'Kg', 1, 'mang-kho', 'Măng lưỡi lợn phơi nắng tự nhiên.', 'Sun-dried bamboo shoots.'),
(11, 1, 4, 'Tương Bần Hưng Yên', 'Ban Soy Sauce', 25000, 300, 80, 'Chai', 1, 'tuong-ban', 'Tương bần hảo hạng chấm rau luộc.', 'Premium soy sauce.'),
(12, 1, 4, 'Rượu Mẫu Sơn', 'Mau Son Wine', 120000, 60, 15, 'Chai', 1, 'ruou-mau-son', 'Rượu chưng cất men lá người Dao.', 'Wine distilled from leaf yeast.'),
-- Vendor 2 (Trung - Nam)
(13, 2, 2, 'Tôm Chua Huế', 'Sour Shrimp', 70000, 90, 35, 'Hũ', 1, 'tom-chua-hue', 'Tôm chua Gò Nổi ăn kèm thịt luộc.', 'Go Noi sour shrimp.'),
(14, 2, 1, 'Kẹo Cu Đơ Hà Tĩnh', 'Cu Do Candy', 40000, 120, 55, 'Hộp', 1, 'keo-cu-do', 'Kẹo lạc kẹp bánh đa giòn tan.', 'Peanut candy in rice paper.'),
(15, 2, 2, 'Chả Bò Đà Nẵng', 'Da Nang Beef Sausage', 320000, 40, 20, 'Kg', 1, 'cha-bo', 'Chả bò nguyên chất cay tiêu đen.', 'Pure beef sausage.'),
(16, 2, 3, 'Yến Sào Khánh Hòa', 'Salanganes Nest', 3500000, 10, 2, 'Hộp', 1, 'yen-sao', 'Yến đảo thiên nhiên bổ dưỡng.', 'Natural bird nest.'),
(17, 2, 1, 'Mắm Tôm Chua', 'Sour Shrimp Paste', 55000, 100, 28, 'Hũ', 1, 'mam-tom-chua', 'Đặc sản Bình Định đậm đà.', 'Binh Dinh specialty.'),
(18, 2, 3, 'Tỏi Lý Sơn', 'Ly Son Garlic', 150000, 80, 40, 'Kg', 1, 'toi-ly-son', 'Tỏi cô đơn dược tính cao.', 'Lonely garlic.'),
(19, 2, 1, 'Bánh Ít Lá Gai', 'Ramie Leaf Cake', 5000, 500, 120, 'Cái', 1, 'banh-it', 'Bánh ít nhân dừa đậu xanh.', 'Coconut filling cake.'),
(20, 2, 2, 'Mực Rim Me', 'Tamarind Squid', 65000, 150, 90, 'Hũ', 1, 'muc-rim-me', 'Mực khô rim me chua ngọt.', 'Addictive snack.'),
(21, 2, 1, 'Bánh Pía Sóc Trăng', 'Durian Cake', 85000, 200, 120, 'Túi', 1, 'banh-pia', 'Bánh pía sầu riêng trứng muối.', 'Durian cake.'),
(22, 2, 3, 'Kẹo Dừa Bến Tre', 'Coconut Candy', 35000, 500, 300, 'Hộp', 1, 'keo-dua', 'Kẹo dừa nguyên chất béo ngậy.', 'Pure coconut candy.'),
(23, 2, 2, 'Rượu Sim Phú Quốc', 'Sim Wine', 350000, 40, 15, 'Chai', 1, 'ruou-sim', 'Rượu lên men từ trái sim rừng.', 'Sim fruit wine.'),
(24, 2, 1, 'Mắm Cá Linh', 'Fish Sauce', 60000, 100, 22, 'Hũ', 1, 'mam-ca-linh', 'Đặc sản mùa nước nổi miền Tây.', 'Floating season specialty.'),
(25, 2, 2, 'Cơm Cháy Chà Bông', 'Scorched Rice', 35000, 300, 200, 'Gói', 1, 'com-chay', 'Cơm cháy Sài Gòn giòn rụm.', 'Saigon scorched rice.'),
(26, 2, 1, 'Lạp Xưởng Cần Đước', 'Sausage', 180000, 70, 45, 'Kg', 1, 'lap-xuong', 'Lạp xưởng tươi tỉ lệ thịt cao.', 'Fresh sausage.'),
(27, 2, 3, 'Bánh Tráng Tây Ninh', 'Rice Paper', 15000, 1000, 500, 'Bịch', 1, 'banh-trang', 'Bánh tráng phơi sương muối nhuyễn.', 'Dew-dried rice paper.'),
(28, 2, 3, 'Hạt Điều Bình Phước', 'Cashew Nuts', 280000, 60, 30, 'Kg', 1, 'hat-dieu', 'Hạt điều rang củi nguyên lụa.', 'Wood-roasted cashew.'),
(29, 2, 1, 'Khô Cá Lóc', 'Dried Fish', 220000, 50, 18, 'Kg', 1, 'kho-ca-loc', 'Khô cá lóc đồng ướp gia vị.', 'Dried snakehead fish.'),
(30, 2, 2, 'Rượu Dừa', 'Coconut Wine', 110000, 80, 22, 'Trái', 1, 'ruou-dua', 'Rượu ủ trong trái dừa tươi.', 'Wine in coconut.');

-- 4.7. PRODUCT CATEGORY MAPPING
INSERT INTO `product_category` (`product_id`, `category_id`) VALUES 
(1,1), (1,4), (2,1), (2,4), (3,1), (3,5), (4,1), (4,4), (5,1), (5,5),
(6,1), (6,5), (7,1), (7,6), (8,1), (8,5), (9,1), (9,4), (10,1), (10,4),
(11,1), (12,1), (12,6), -- Bắc
(13,2), (13,4), (14,2), (14,5), (15,2), (15,4), (16,2), (16,4), (17,2), (18,2), (19,2), (19,5), (20,2), (20,4), -- Trung
(21,3), (21,5), (22,3), (22,5), (23,3), (23,6), (24,3), (25,3), (25,4), (26,3), (26,4), (27,3), (27,4), (28,3), (29,3), (29,4), (30,3), (30,6); -- Nam

-- 4.8. IMAGES (Dùng Placehold.co với màu sắc đặc trưng vùng miền)
-- Bắc: Đỏ nhạt (FFCCCC), Trung: Cam nhạt (FFE5CC), Nam: Vàng nhạt (FFFFCC)
INSERT INTO `images` (`product_id`, `url`, `main`) VALUES 
(1, 'https://loremflickr.com/600/400/food?lock=1', 1),
(1, 'https://loremflickr.com/600/400/food?lock=101', 0),
(1, 'https://loremflickr.com/600/400/food?lock=201', 0),
(2, 'https://loremflickr.com/600/400/food?lock=2', 1),
(2, 'https://loremflickr.com/600/400/food?lock=102', 0),
(2, 'https://loremflickr.com/600/400/food?lock=202', 0),
(3, 'https://loremflickr.com/600/400/food?lock=3', 1),
(3, 'https://loremflickr.com/600/400/food?lock=103', 0),
(3, 'https://loremflickr.com/600/400/food?lock=203', 0),
(4, 'https://loremflickr.com/600/400/food?lock=4', 1),
(4, 'https://loremflickr.com/600/400/food?lock=104', 0),
(4, 'https://loremflickr.com/600/400/food?lock=204', 0),
(5, 'https://loremflickr.com/600/400/food?lock=5', 1),
(5, 'https://loremflickr.com/600/400/food?lock=105', 0),
(5, 'https://loremflickr.com/600/400/food?lock=205', 0),
(6, 'https://loremflickr.com/600/400/food?lock=6', 1),
(6, 'https://loremflickr.com/600/400/food?lock=106', 0),
(6, 'https://loremflickr.com/600/400/food?lock=206', 0),
(7, 'https://loremflickr.com/600/400/food?lock=7', 1),
(7, 'https://loremflickr.com/600/400/food?lock=107', 0),
(7, 'https://loremflickr.com/600/400/food?lock=207', 0),
(8, 'https://loremflickr.com/600/400/food?lock=8', 1),
(8, 'https://loremflickr.com/600/400/food?lock=108', 0),
(8, 'https://loremflickr.com/600/400/food?lock=208', 0),
(9, 'https://loremflickr.com/600/400/food?lock=9', 1),
(9, 'https://loremflickr.com/600/400/food?lock=109', 0),
(9, 'https://loremflickr.com/600/400/food?lock=209', 0),
(10, 'https://loremflickr.com/600/400/food?lock=10', 1),
(10, 'https://loremflickr.com/600/400/food?lock=110', 0),
(10, 'https://loremflickr.com/600/400/food?lock=210', 0),
(11, 'https://loremflickr.com/600/400/food?lock=11', 1),
(11, 'https://loremflickr.com/600/400/food?lock=111', 0),
(11, 'https://loremflickr.com/600/400/food?lock=211', 0),
(12, 'https://loremflickr.com/600/400/food?lock=12', 1),
(12, 'https://loremflickr.com/600/400/food?lock=112', 0),
(12, 'https://loremflickr.com/600/400/food?lock=212', 0),
(13, 'https://loremflickr.com/600/400/food?lock=13', 1),
(13, 'https://loremflickr.com/600/400/food?lock=113', 0),
(13, 'https://loremflickr.com/600/400/food?lock=213', 0),
(14, 'https://loremflickr.com/600/400/food?lock=14', 1),
(14, 'https://loremflickr.com/600/400/food?lock=114', 0),
(14, 'https://loremflickr.com/600/400/food?lock=214', 0),
(15, 'https://loremflickr.com/600/400/food?lock=15', 1),
(15, 'https://loremflickr.com/600/400/food?lock=115', 0),
(15, 'https://loremflickr.com/600/400/food?lock=215', 0),
(16, 'https://loremflickr.com/600/400/food?lock=16', 1),
(16, 'https://loremflickr.com/600/400/food?lock=116', 0),
(16, 'https://loremflickr.com/600/400/food?lock=216', 0),
(17, 'https://loremflickr.com/600/400/food?lock=17', 1),
(17, 'https://loremflickr.com/600/400/food?lock=117', 0),
(17, 'https://loremflickr.com/600/400/food?lock=217', 0),
(18, 'https://loremflickr.com/600/400/food?lock=18', 1),
(18, 'https://loremflickr.com/600/400/food?lock=118', 0),
(18, 'https://loremflickr.com/600/400/food?lock=218', 0),
(19, 'https://loremflickr.com/600/400/food?lock=19', 1),
(19, 'https://loremflickr.com/600/400/food?lock=119', 0),
(19, 'https://loremflickr.com/600/400/food?lock=219', 0),
(20, 'https://loremflickr.com/600/400/food?lock=20', 1),
(20, 'https://loremflickr.com/600/400/food?lock=120', 0),
(20, 'https://loremflickr.com/600/400/food?lock=220', 0),
(21, 'https://loremflickr.com/600/400/food?lock=21', 1),
(21, 'https://loremflickr.com/600/400/food?lock=121', 0),
(21, 'https://loremflickr.com/600/400/food?lock=221', 0),
(22, 'https://loremflickr.com/600/400/food?lock=22', 1),
(22, 'https://loremflickr.com/600/400/food?lock=122', 0),
(22, 'https://loremflickr.com/600/400/food?lock=222', 0),
(23, 'https://loremflickr.com/600/400/food?lock=23', 1),
(23, 'https://loremflickr.com/600/400/food?lock=123', 0),
(23, 'https://loremflickr.com/600/400/food?lock=223', 0),
(24, 'https://loremflickr.com/600/400/food?lock=24', 1),
(24, 'https://loremflickr.com/600/400/food?lock=124', 0),
(24, 'https://loremflickr.com/600/400/food?lock=224', 0),
(25, 'https://loremflickr.com/600/400/food?lock=25', 1),
(25, 'https://loremflickr.com/600/400/food?lock=125', 0),
(25, 'https://loremflickr.com/600/400/food?lock=225', 0),
(26, 'https://loremflickr.com/600/400/food?lock=26', 1),
(26, 'https://loremflickr.com/600/400/food?lock=126', 0),
(26, 'https://loremflickr.com/600/400/food?lock=226', 0),
(27, 'https://loremflickr.com/600/400/food?lock=27', 1),
(27, 'https://loremflickr.com/600/400/food?lock=127', 0),
(27, 'https://loremflickr.com/600/400/food?lock=227', 0),
(28, 'https://loremflickr.com/600/400/food?lock=28', 1),
(28, 'https://loremflickr.com/600/400/food?lock=128', 0),
(28, 'https://loremflickr.com/600/400/food?lock=228', 0),
(29, 'https://loremflickr.com/600/400/food?lock=29', 1),
(29, 'https://loremflickr.com/600/400/food?lock=129', 0),
(29, 'https://loremflickr.com/600/400/food?lock=229', 0),
(30, 'https://loremflickr.com/600/400/food?lock=30', 1),
(30, 'https://loremflickr.com/600/400/food?lock=130', 0),
(30, 'https://loremflickr.com/600/400/food?lock=230', 0);

-- 4.9. ORDERS & ORDER ITEMS (Dữ liệu Demo doanh thu 7 ngày)
-- ============================================================

-- NGÀY HÔM NAY (Day 0)
-- Order 3 (Có sẵn): Vendor 2 - 70k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(3, 5, 70000, 20000, 'PENDING', 'Trần Thị Sắm', '0909000555', 'Số 10, Xuân Thủy, Hà Nội', 'COD', NOW());
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (3, 22, 2, 35000);

-- Order 4: Vendor 1 - 100k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(4, 4, 100000, 15000, 'PROCESSING', 'Nguyễn Văn Mua', '0909000444', 'HCM', 'COD', NOW());
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (4, 1, 2, 50000);

-- Order 5: Vendor 2 - 70k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(5, 5, 70000, 15000, 'PROCESSING', 'Trần Thị Sắm', '0909000555', 'HN', 'VNPAY', NOW());
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (5, 13, 1, 70000);

-- HÔM QUA (Day 1)
-- Order 6: Vendor 1 - 450k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(6, 5, 450000, 20000, 'SHIPPING', 'Trần Thị Sắm', '0909000555', 'HN', 'COD', DATE_SUB(NOW(), INTERVAL 1 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (6, 4, 1, 450000);

-- Order 7: Vendor 2 - 200k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(7, 4, 200000, 15000, 'DELIVERED', 'Nguyễn Văn Mua', '0909000444', 'HCM', 'VNPAY', DATE_SUB(NOW(), INTERVAL 1 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (7, 14, 5, 40000);

-- 2 NGÀY TRƯỚC (Day 2)
-- Order 2 (Có sẵn): Vendor 1 - 850k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(2, 4, 850000, 30000, 'SHIPPING', 'Nguyễn Văn Mua', '0909000444', 'Số 1, Võ Văn Ngân, Thủ Đức', 'VNPAY', DATE_SUB(NOW(), INTERVAL 2 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (2, 2, 1, 850000);

-- Order 8: Vendor 2 - 320k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(8, 4, 320000, 20000, 'DELIVERED', 'Nguyễn Văn Mua', '0909000444', 'HCM', 'COD', DATE_SUB(NOW(), INTERVAL 2 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (8, 15, 1, 320000);

-- 3 NGÀY TRƯỚC (Day 3)
-- Order 9: Vendor 1 - 450k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(9, 5, 450000, 25000, 'DELIVERED', 'Trần Thị Sắm', '0909000555', 'HN', 'VNPAY', DATE_SUB(NOW(), INTERVAL 3 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (9, 5, 10, 45000);

-- Order 10: Vendor 2 - 3.5m
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(10, 4, 3500000, 50000, 'DELIVERED', 'Nguyễn Văn Mua', '0909000444', 'HCM', 'VNPAY', DATE_SUB(NOW(), INTERVAL 3 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (10, 16, 1, 3500000);

-- 4 NGÀY TRƯỚC (Day 4)
-- Order 11: Vendor 1 - 130k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(11, 4, 130000, 15000, 'DELIVERED', 'Nguyễn Văn Mua', '0909000444', 'HCM', 'COD', DATE_SUB(NOW(), INTERVAL 4 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (11, 6, 2, 65000);

-- Order 12: Vendor 2 - 220k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(12, 5, 220000, 20000, 'DELIVERED', 'Trần Thị Sắm', '0909000555', 'HN', 'COD', DATE_SUB(NOW(), INTERVAL 4 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (12, 17, 4, 55000);

-- 5 NGÀY TRƯỚC (Day 5)
-- Order 1 (Có sẵn): Vendor 2 - 170k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(1, 4, 170000, 15000, 'DELIVERED', 'Nguyễn Văn Mua', '0909000444', 'Số 1, Võ Văn Ngân, Thủ Đức', 'COD', DATE_SUB(NOW(), INTERVAL 5 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (1, 21, 2, 85000);

-- Order 13: Vendor 1 - 500k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(13, 5, 500000, 25000, 'DELIVERED', 'Trần Thị Sắm', '0909000555', 'HN', 'VNPAY', DATE_SUB(NOW(), INTERVAL 5 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (13, 7, 2, 250000);

-- 6 NGÀY TRƯỚC (Day 6)
-- Order 14: Vendor 1 - 150k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(14, 4, 150000, 15000, 'DELIVERED', 'Nguyễn Văn Mua', '0909000444', 'HCM', 'COD', DATE_SUB(NOW(), INTERVAL 6 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (14, 8, 5, 30000);

-- Order 15: Vendor 2 - 350k
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `shipping_fee`, `status`, `recipient_name`, `recipient_phone`, `shipping_address`, `payment_method`, `created_at`) VALUES 
(15, 5, 350000, 20000, 'DELIVERED', 'Trần Thị Sắm', '0909000555', 'HN', 'COD', DATE_SUB(NOW(), INTERVAL 6 DAY));
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price`) VALUES (15, 22, 10, 35000);


-- 4.10. RATINGS (Đánh giá sản phẩm đã mua)
-- INSERT INTO `ratings` (`user_id`, `product_id`, `stars`, `comment_vi`, `comment_en`, `created_at`) VALUES 
-- (4, 21, 5, 'Bánh ngon, trứng to, giao hàng nhanh.', 'Delicious cake, fast delivery.', DATE_SUB(NOW(), INTERVAL 1 DAY)),
-- (5, 4, 5, 'Chả mực dai ngon, đúng chuẩn Hạ Long.', 'Authentic Ha Long squid cake.', DATE_SUB(NOW(), INTERVAL 1 DAY)),
-- (4, 16, 5, 'Yến sào chất lượng, bao bì đẹp.', 'High quality bird nest.', DATE_SUB(NOW(), INTERVAL 2 DAY)),
-- (5, 7, 4, 'Trà thơm, nhưng hơi chát.', 'Fragrant tea but a bit acrid.', DATE_SUB(NOW(), INTERVAL 4 DAY));

-- 4.11. BLOGS (Bài viết)
INSERT INTO `blogs` (`author_id`, `title_vi`, `title_en`, `content_vi`, `content_en`, `created_at`) VALUES 
(2, 'Cách chọn Nem Chua ngon', 'How to choose good Nem Chua', 'Nem chua ngon phải có màu hồng tươi...', 'Good fermented pork roll must be fresh pink...', DATE_SUB(NOW(), INTERVAL 10 DAY)),
(3, 'Đặc sản mùa nước nổi', 'Specialties of floating season', 'Mùa nước nổi miền Tây có cá linh, bông điên điển...', 'Western floating season has Linh fish...', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(2, 'Top 5 món nhậu ngày Tết', 'Top 5 Tet snacks', 'Thịt trâu gác bếp, lạp xưởng...', 'Smoked buffalo meat, sausage...', DATE_SUB(NOW(), INTERVAL 2 DAY));

-- 4.12. VIDEOS (Video quảng bá)
INSERT INTO `videos` (`title`, `description`, `poster`, `views`) VALUES 
('Khám phá ẩm thực Tây Bắc', 'Hành trình tìm kiếm hương vị núi rừng...', 'https://placehold.co/800x450/2ecc71/fff?text=Tay+Bac', 1500),
('Du lịch miền Tây mùa nước nổi', 'Trải nghiệm cuộc sống người dân miền sông nước...', 'https://placehold.co/800x450/3498db/fff?text=Mien+Tay', 2300),
('Cách làm Nem Chua Thanh Hóa', 'Hướng dẫn chi tiết cách làm nem chua tại nhà...', 'https://placehold.co/800x450/e74c3c/fff?text=Nem+Chua', 5000);

-- Link blog với sản phẩm
INSERT INTO `blog_product` (`blog_id`, `product_id`) VALUES (1, 1), (2, 24);

-- 4.12. VOUCHERS (Mã giảm giá demo)
INSERT INTO `vouchers` (`code`, `discount_percent`, `min_order_amount`, `start_date`, `end_date`, `quantity`) VALUES 
('CHAO2025', 10, 100000, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 100),
('FREESHIP', 100, 500000, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 50);

-- Hoàn tất
COMMIT;
SET FOREIGN_KEY_CHECKS = 1;
