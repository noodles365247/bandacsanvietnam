# Hướng dẫn tạo User và Admin

## 📋 Tổng quan về Role trong hệ thống

Hệ thống có **3 role**:
1. **ADMIN** - Quản trị viên, có quyền truy cập `/admin/*` và `/api/*`
2. **VENDOR** - Nhà bán hàng, có quyền truy cập `/vendor/*`
3. **CUSTOMER** - Khách hàng, có quyền truy cập `/user/*`

## 🔐 Phân quyền

- ✅ **Đã có phân quyền ADMIN** - Kiểm tra trong `AuthInterceptor.java`
- ✅ Chưa đăng nhập → Redirect về `/login`
- ✅ ADMIN chỉ truy cập được `/admin/*` và `/api/*`
- ✅ VENDOR chỉ truy cập được `/vendor/*`
- ✅ CUSTOMER truy cập được `/user/*`

## 🚀 Cách tạo User và Admin

### Cách 1: Dùng Java Code (KHUYẾN NGHỊ)

File `DataInitializer.java` sẽ tự động tạo user khi ứng dụng khởi động:

1. **Chạy ứng dụng Spring Boot** - User sẽ tự động được tạo
2. **Thông tin đăng nhập mặc định:**
   - **ADMIN**: 
     - Username: `admin`
     - Password: `admin123`
   - **CUSTOMER**: 
     - Username: `user1`
     - Password: `user123`
   - **VENDOR**: 
     - Username: `vendor1`
     - Password: `vendor123`

### Cách 2: Dùng SQL Script

1. Mở MySQL và kết nối đến database `dbdacsan`
2. Chạy file `init_users.sql`
3. Hoặc copy và paste SQL vào MySQL Workbench/Command Line

```sql
-- Chạy file init_users.sql
source init_users.sql;
```

### Cách 3: Đăng ký qua giao diện

1. Truy cập `/register`
2. Đăng ký tài khoản mới (mặc định sẽ là CUSTOMER)
3. Để tạo ADMIN, cần chạy SQL hoặc dùng DataInitializer

## 📝 Thông tin User mẫu

| Username | Password | Email | Role |
|----------|----------|-------|------|
| admin | admin123 | admin@dacsan.com | ADMIN |
| user1 | user123 | user1@dacsan.com | CUSTOMER |
| vendor1 | vendor123 | vendor1@dacsan.com | VENDOR |

## ⚠️ Lưu ý

- Password được mã hóa bằng **BCrypt**
- Không thể xem password gốc từ database
- Để đổi password, cần mã hóa lại bằng BCrypt hoặc dùng chức năng đổi password trong ứng dụng
- File `DataInitializer.java` chỉ tạo user nếu chưa tồn tại (kiểm tra theo username)

## 🔧 Tùy chỉnh

Để thêm user mới hoặc đổi password, sửa file `DataInitializer.java`:

```java
createUserIfNotExists(
    "username_moi",
    "password_moi",
    "email@example.com",
    "ADMIN" // hoặc "CUSTOMER", "VENDOR"
);
```

