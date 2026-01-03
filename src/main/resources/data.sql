-- ============================================================
-- SCRIPT KHOI TAO LAI TOAN BO DATABASE (FULL RESET & DEMO DATA)
-- Phien ban: Demo Final
-- ============================================================

-- 1. XOA SACH DU LIEU CU (DROP TABLES)
-- Luu y: Thu tu xoa phai nguoc voi thu tu tao de tranh loi Foreign Key

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

-- ============================================================
-- 2. TAO CAU TRUC BANG (SCHEMA)
-- ============================================================

-- Bang Users
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `active` bit(1) DEFAULT 1,
  `reset_password_token` varchar(64) DEFAULT NULL,
  `verification_code` varchar(64) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_username` (`username`),
  UNIQUE KEY `UK_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Vendors
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

-- Bang Categories
CREATE TABLE `categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name_vi` varchar(255) DEFAULT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Brands
CREATE TABLE `brands` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `image_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Products
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

-- Bang Product_Category
CREATE TABLE `product_category` (
  `product_id` bigint NOT NULL,
  `category_id` bigint NOT NULL,
  KEY `FK_pc_product` (`product_id`),
  KEY `FK_pc_category` (`category_id`),
  CONSTRAINT `FK_pc_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `FK_pc_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Images
CREATE TABLE `images` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `main` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_images_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Cart
CREATE TABLE `cart` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_cart_user` (`user_id`),
  CONSTRAINT `FK_cart_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang CartItems
CREATE TABLE `cart_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cart_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_cartitems_cart` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  CONSTRAINT `FK_cartitems_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Orders
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `shipping_fee` double DEFAULT 0,
  `status` varchar(50) DEFAULT NULL,
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

-- Bang OrderItems
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

-- Bang Payments
CREATE TABLE `payments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_payments_order` (`order_id`),
  CONSTRAINT `FK_payments_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Ratings
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

-- Bang Blogs
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

-- Bang Blog_Product
CREATE TABLE `blog_product` (
  `blog_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  KEY `FK_bp_blog` (`blog_id`),
  KEY `FK_bp_product` (`product_id`),
  CONSTRAINT `FK_bp_blog` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`),
  CONSTRAINT `FK_bp_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Addresses
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

-- Bang Chat
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

-- Bang Doanh thu
CREATE TABLE `vendor_revenue` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vendor_id` bigint DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_revenue_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bang Vouchers
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

-- Bang Promotions
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
-- 3. NAP DU LIEU MAU (SEEDING DATA)
-- ============================================================

-- Users
INSERT INTO `users` (`id`, `username`, `password`, `email`, `fullname`, `role`, `active`, `avatar`, `phone`) VALUES 
(1, 'admin', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'admin@gmail.com', 'Admin He Thong', 'ADMIN', 1, 'https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff', '0909000111'),
(2, 'vendor_bac', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'bac@dacsan.com', 'Chu Shop Bac', 'VENDOR', 1, 'https://ui-avatars.com/api/?name=Vendor+Bac&background=E74C3C&color=fff', '0909000222'),
(3, 'vendor_nam', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'nam@dacsan.com', 'Chu Shop Nam', 'VENDOR', 1, 'https://ui-avatars.com/api/?name=Vendor+Nam&background=F1C40F&color=fff', '0909000333'),
(4, 'khachhang1', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'khach1@gmail.com', 'Nguyen Van Mua', 'USER', 1, 'https://ui-avatars.com/api/?name=Nguyen+Mua&background=random', '0909000444'),
(5, 'khachhang2', '$2b$12$ZxOyXV9VIyQ9LczZ1j1n0ulIpU2.rYoM5kC2GfFKZ1u3GZq0JTfW.', 'khach2@gmail.com', 'Tran Thi Sam', 'USER', 1, 'https://ui-avatars.com/api/?name=Tran+Sam&background=random', '0909000555');

-- Vendors
INSERT INTO `vendors` (`id`, `user_id`, `store_name`, `address`, `phone`, `description_vi`, `avatar`) VALUES 
(1, 2, 'Huong Vi Mien Bac', 'So 10, Pho Co, Ha Noi', '0901234567', 'Chuyen cung cap dac san chuan vi Bac Bo.', 'https://placehold.co/100x100/E74C3C/fff?text=Bac'),
(2, 3, 'Dac San Phuong Nam', 'Quan 1, TP. Ho Chi Minh', '0909888777', 'Mang huong vi mien Tay song nuoc den moi nha.', 'https://placehold.co/100x100/F1C40F/fff?text=Nam');

-- Brands
INSERT INTO `brands` (`id`, `name`, `description`) VALUES 
(1, 'Lang Nghe Truyen Thong', 'Cac san pham thu cong lau doi'),
(2, 'Dac San 3 Mien', 'Thuong hieu phan phoi uy tin'),
(3, 'Nong San Viet', 'San pham OCOP chat luong cao'),
(4, 'Qua Que', 'Cac mon qua bieu tang y nghia');

-- Categories
INSERT INTO `categories` (`id`, `name_vi`, `name_en`, `parent_id`) VALUES 
(1, 'Dac san Mien Bac', 'Northern Specialties', NULL),
(2, 'Dac san Mien Trung', 'Central Specialties', NULL),
(3, 'Dac san Mien Nam', 'Southern Specialties', NULL),
(4, 'Do kho', 'Dried Food', NULL),
(5, 'Banh keo', 'Cakes & Candies', NULL),
(6, 'Ruou & Do uong', 'Drinks & Wine', NULL);

-- Addresses
INSERT INTO `addresses` (`user_id`, `recipient_name`, `phone`, `city`, `district`, `ward`, `specific_address`, `is_default`) VALUES
(4, 'Nguyen Van Mua', '0909000444', 'TP. Ho Chi Minh', 'Quan Thu Duc', 'Phuong Linh Chieu', 'So 1, Vo Van Ngan', 1),
(5, 'Tran Thi Sam', '0909000555', 'Ha Noi', 'Quan Cau Giay', 'Phuong Dich Vong', 'So 10, Xuan Thuy', 1);

-- Products
INSERT INTO `products` (`id`, `vendor_id`, `brand_id`, `name_vi`, `name_en`, `price`, `stock`, `sold_count`, `unit`, `is_active`, `slug`, `description_vi`, `description_en`) VALUES 
(1, 1, 1, 'Nem Chua Thanh Hoa', 'Fermented Pork Roll', 50000, 100, 50, 'Chuc', 1, 'nem-chua-thanh-hoa', 'Nem chua gion ngon, chuan vi xu Thanh.', 'Delicious fermented pork roll.'),
(2, 1, 3, 'Thit Trau Gac Bep', 'Smoked Buffalo Meat', 850000, 20, 5, 'Kg', 1, 'thit-trau-gac-bep', 'Thit trau tuoi hun khoi, gia vi mac khen.', 'Smoked buffalo meat with spices.'),
(3, 1, 1, 'Com Lang Vong', 'Young Green Rice', 200000, 50, 12, 'Goi', 1, 'com-lang-vong', 'Hat com deo thom huong vi mua thu.', 'Fragrant young green rice.'),
(4, 1, 2, 'Cha Muc Ha Long', 'Ha Long Squid Cake', 450000, 30, 8, 'Kg', 1, 'cha-muc-ha-long', 'Cha muc gia tay dai gion.', 'Hand-pounded squid cake.'),
(5, 1, 1, 'Banh Dau Xanh HD', 'Mung Bean Cake', 45000, 500, 150, 'Hop', 1, 'banh-dau-xanh', 'Banh dau xanh Rong Vang.', 'Golden Dragon mung bean cake.'),
(6, 1, 2, 'O Mai Sau Ha Noi', 'Dracontomelon O Mai', 65000, 100, 40, 'Hop', 1, 'o-mai-sau', 'Vi chua ngot dac trung Ha Thanh.', 'Sour and sweet taste.'),
(7, 1, 3, 'Che Tan Cuong', 'Tan Cuong Tea', 250000, 80, 25, 'Goi', 1, 'che-tan-cuong', 'Tra moc cau dac biet.', 'Special hook tea.'),
(8, 1, 1, 'Banh Cay Thai Binh', 'Cay Cake', 30000, 200, 60, 'Hop', 1, 'banh-cay', 'Banh cay lang Nguyen deo thom.', 'Cay cake from Nguyen village.'),
(9, 1, 2, 'Cha Ruoi Tu Ky', 'Sandworm Omelet', 550000, 20, 10, 'Kg', 1, 'cha-ruoi', 'Dac san ruoi Tu Ky beo ngay.', 'Tu Ky sandworm specialty.'),
(10, 1, 3, 'Mang Kho Tay Bac', 'Dried Bamboo Shoots', 180000, 150, 45, 'Kg', 1, 'mang-kho', 'Mang luoi lon phoi nang tu nhien.', 'Sun-dried bamboo shoots.'),
(11, 1, 4, 'Tuong Ban Hung Yen', 'Ban Soy Sauce', 25000, 300, 80, 'Chai', 1, 'tuong-ban', 'Tuong ban hao hang cham rau luoc.', 'Premium soy sauce.'),
(12, 1, 4, 'Ruou Mau Son', 'Mau Son Wine', 120000, 60, 15, 'Chai', 1, 'ruou-mau-son', 'Ruou chung cat men la nguoi Dao.', 'Wine distilled from leaf yeast.'),
(13, 2, 2, 'Tom Chua Hue', 'Sour Shrimp', 70000, 90, 35, 'Hu', 1, 'tom-chua-hue', 'Tom chua Go Noi an kem thit luoc.', 'Go Noi sour shrimp.'),
(14, 2, 1, 'Keo Cu Do Ha Tinh', 'Cu Do Candy', 40000, 120, 55, 'Hop', 1, 'keo-cu-do', 'Keo lac kep banh da gion tan.', 'Peanut candy in rice paper.'),
(15, 2, 2, 'Cha Bo Da Nang', 'Da Nang Beef Sausage', 320000, 40, 20, 'Kg', 1, 'cha-bo', 'Cha bo nguyen chat cay tieu den.', 'Pure beef sausage.'),
(16, 2, 3, 'Yen Sao Khanh Hoa', 'Salanganes Nest', 3500000, 10, 2, 'Hop', 1, 'yen-sao', 'Yen dao thien nhien bo duong.', 'Natural bird nest.'),
(17, 2, 1, 'Mam Tom Chua', 'Sour Shrimp Paste', 55000, 100, 28, 'Hu', 1, 'mam-tom-chua', 'Dac san Binh Dinh dam da.', 'Binh Dinh specialty.'),
(18, 2, 3, 'Toi Ly Son', 'Ly Son Garlic', 150000, 80, 40, 'Kg', 1, 'toi-ly-son', 'Toi co don duoc tinh cao.', 'Lonely garlic.'),
(19, 2, 1, 'Banh It La Gai', 'Ramie Leaf Cake', 5000, 500, 120, 'Cai', 1, 'banh-it', 'Banh it nhan dua dau xanh.', 'Coconut filling cake.'),
(20, 2, 2, 'Muc Rim Me', 'Tamarind Squid', 65000, 150, 90, 'Hu', 1, 'muc-rim-me', 'Muc kho rim me chua ngot.', 'Addictive snack.'),
(21, 2, 1, 'Banh Pia Soc Trang', 'Durian Cake', 85000, 200, 120, 'Tui', 1, 'banh-pia', 'Banh pia sau rieng trung muoi.', 'Durian cake.'),
(22, 2, 3, 'Keo Dua Ben Tre', 'Coconut Candy', 35000, 500, 300, 'Hop', 1, 'keo-dua', 'Keo dua nguyen chat beo ngay.', 'Pure coconut candy.'),
(23, 2, 2, 'Ruou Sim Phu Quoc', 'Sim Wine', 350000, 40, 15, 'Chai', 1, 'ruou-sim', 'Ruou len men tu trai sim rung.', 'Sim fruit wine.'),
(24, 2, 1, 'Mam Ca Linh', 'Fish Sauce', 60000, 100, 22, 'Hu', 1, 'mam-ca-linh', 'Dac san mua nuoc noi mien Tay.', 'Floating season specialty.'),
(25, 2, 2, 'Com Chay Cha Bong', 'Scorched Rice', 35000, 300, 200, 'Goi', 1, 'com-chay', 'Com chay Sai Gon gion rum.', 'Saigon scorched rice.'),
(26, 2, 1, 'Lap Xuong Can Duoc', 'Sausage', 180000, 70, 45, 'Kg', 1, 'lap-xuong', 'Lap xuong tuoi ti le thit cao.', 'Fresh sausage.'),
(27, 2, 3, 'Banh Trang Tay Ninh', 'Rice Paper', 15000, 1000, 500, 'Bich', 1, 'banh-trang', 'Banh trang phoi suong muoi nhuyen.', 'Dew-dried rice paper.'),
(28, 2, 3, 'Hat Dieu Binh Phuoc', 'Cashew Nuts', 280000, 60, 30, 'Kg', 1, 'hat-dieu', 'Hat dieu rang cui nguyen lua.', 'Wood-roasted cashew.'),
(29, 2, 1, 'Kho Ca Loc', 'Dried Fish', 220000, 50, 18, 'Kg', 1, 'kho-ca-loc', 'Kho ca loc dong uop gia vi.', 'Dried snakehead fish.'),
(30, 2, 2, 'Ruou Dua', 'Coconut Wine', 110000, 80, 22, 'Trai', 1, 'ruou-dua', 'Ruou u trong trai dua tuoi.', 'Wine in coconut.');

-- Product Category Mapping
INSERT INTO `product_category` (`product_id`, `category_id`) VALUES 
(1,1), (1,4), (2,1), (2,4), (3,1), (3,5), (4,1), (4,4), (5,1), (5,5),
(6,1), (6,5), (7,1), (7,6), (8,1), (8,5), (9,1), (9,4), (10,1), (10,4),
(11,1), (12,1), (12,6),
(13,2), (13,4), (14,2), (14,5), (15,2), (15,4), (16,2), (16,4), (17,2), (18,2), (19,2), (19,5), (20,2), (20,4),
(21,3), (21,5), (22,3), (22,5), (23,3), (23,6), (24,3), (25,3), (25,4), (26,3), (26,4), (27,3), (27,4), (28,3), (29,3), (29,4), (30,3), (30,6);

-- Images
INSERT INTO `images` (`product_id`, `url`, `main`) VALUES 
(1, 'https://loremflickr.com/600/400/food?lock=1', 1),
(1, 'https://loremflickr.com/600/400/food?lock=101', 0),
(1, 'https://loremflickr.com/600/400/food?lock=201', 0),
(2, 'https://loremflickr.com/600/400/food?lock=2', 1),
(2, 'https://loremflickr.com/600/400/food?lock=102', 0),
(3, 'https://loremflickr.com/600/400/food?lock=3', 1),
(4, 'https://loremflickr.com/600/400/food?lock=4', 1),
(5, 'https://loremflickr.com/600/400/food?lock=5', 1),
(6, 'https://loremflickr.com/600/400/food?lock=6', 1),
(7, 'https://loremflickr.com/600/400/food?lock=7', 1),
(8, 'https://loremflickr.com/600/400/food?lock=8', 1),
(9, 'https://loremflickr.com/600/400/food?lock=9', 1),
(10, 'https://loremflickr.com/600/400/food?lock=10', 1),
(11, 'https://loremflickr.com/600/400/food?lock=11', 1),
(12, 'https://loremflickr.com/600/400/food?lock=12', 1),
(13, 'https://loremflickr.com/600/400/food?lock=13', 1),
(14, 'https://loremflickr.com/600/400/food?lock=14', 1),
(15, 'https://loremflickr.com/600/400/food?lock=15', 1),
(16, 'https://loremflickr.com/600/400/food?lock=16', 1),
(17, 'https://loremflickr.com/600/400/food?lock=17', 1),
(18, 'https://loremflickr.com/600/400/food?lock=18', 1),
(19, 'https://loremflickr.com/600/400/food?lock=19', 1),
(20, 'https://loremflickr.com/600/400/food?lock=20', 1),
(21, 'https://loremflickr.com/600/400/food?lock=21', 1),
(22, 'https://loremflickr.com/600/400/food?lock=22', 1),
(23, 'https://loremflickr.com/600/400/food?lock=23', 1),
(24, 'https://loremflickr.com/600/400/food?lock=24', 1),
(25, 'https://loremflickr.com/600/400/food?lock=25', 1),
(26, 'https://loremflickr.com/600/400/food?lock=26', 1),
(27, 'https://loremflickr.com/600/400/food?lock=27', 1),
(28, 'https://loremflickr.com/600/400/food?lock=28', 1),
(29, 'https://loremflickr.com/600/400/food?lock=29', 1),
(30, 'https://loremflickr.com/600/400/food?lock=30', 1);
