# BANDACSAN RUNBOOK - RENDER DEPLOYMENT GUIDE

## 1. Environment Configuration (Cấu hình môi trường)

Render yêu cầu các biến môi trường (Environment Variables) để ứng dụng hoạt động chính xác. Bạn cần cấu hình các biến sau trong phần **Environment** của Render Service:

### Required Variables (Bắt buộc)
| Variable Name | Description | Example Value |
|---------------|-------------|---------------|
| `MYSQL_URL` | JDBC URL kết nối Database | `jdbc:mysql://monorail.proxy.rlwy.net:12345/railway?useSSL=false` |
| `MYSQLUSER` | Database Username | `root` |
| `MYSQLPASSWORD` | Database Password | `your_secure_password` |
| `JWT_SECRET` | Secret key để ký JWT Token | `your_very_long_secret_key_at_least_256_bits` |
| `PORT` | Render tự động cấp, nhưng cần config trong app | (Render tự set, App đã config `server.port=${PORT:8081}`) |

### Optional Variables (Tùy chọn/Nâng cao)
| Variable Name | Description | Default if missing |
|---------------|-------------|--------------------|
| `MAIL_USERNAME` | Gmail gửi OTP/Thông báo | `your-email@gmail.com` |
| `MAIL_PASSWORD` | App Password của Gmail | `your-app-password` |
| `VNPAY_TMN_CODE`| Mã Website VNPay | `YOUR_TMN_CODE` |
| `VNPAY_HASH_SECRET`| Secret Key VNPay | `YOUR_HASH_SECRET` |
| `VNPAY_RETURN_URL`| URL redirect sau thanh toán | `https://your-app.onrender.com/payment/vnpay-return` |

**Lưu ý:**
- **Không** lưu credentials trong code (`application.properties` chỉ chứa fallback cho localhost).
- `package.json` không áp dụng cho dự án Spring Boot này (trừ khi có Frontend nodejs riêng). Quản lý dependency qua `pom.xml`.

## 2. Resource Management (Quản lý tài nguyên)

### RAM Limitations (Free Tier)
Render Free Tier giới hạn **512MB RAM**. Spring Boot mặc định có thể dùng nhiều hơn, dẫn đến Crash (OOMKilled).

**Giải pháp đã áp dụng:**
- **Dockerfile:** Đã cấu hình `JAVA_TOOL_OPTIONS="-Xmx350m -Xms350m"` để giới hạn Heap Size của Java Virtual Machine (JVM) ở mức an toàn (350MB), chừa lại ~150MB cho OS và Overhead.
- **Health Check:** Theo dõi log khởi động. Nếu app crash ngay khi start, cần xem xét giảm `-Xmx` xuống `300m`.

### Ephemeral Filesystem (Ổ cứng tạm thời)
**CẢNH BÁO:** Render (loại Web Service miễn phí) sử dụng ổ cứng tạm thời (Ephemeral).
- **Vấn đề:** Mọi file upload (ảnh sản phẩm, avatar) lưu vào thư mục `uploads/` hoặc `src/main/resources/static/images` sẽ bị **XÓA SẠCH** sau mỗi lần deploy hoặc restart.
- **Giải pháp:**
    1.  **Ngắn hạn:** Chấp nhận mất dữ liệu ảnh khi restart (chỉ dùng cho Demo).
    2.  **Dài hạn (Production):** Phải tích hợp Cloud Storage (AWS S3, Cloudinary, Firebase) để lưu ảnh.
    3.  **Code Action:** Kiểm tra `FileStorageService` để đảm bảo không crash app nếu thư mục không tồn tại (đã xử lý bằng `Files.createDirectories`).

## 3. Database Connectivity (Kết nối CSDL)

Database (Railway MySQL) nằm ngoài mạng nội bộ của Render, nên có thể gặp độ trễ hoặc ngắt kết nối.

**Giải pháp đã áp dụng (`application.properties`):**
- **HikariCP Pooling:**
    - `connection-timeout=20000`: Chờ tối đa 20s để lấy kết nối.
    - `minimum-idle=5`: Giữ 5 kết nối rảnh để sẵn sàng.
    - `maximum-pool-size=12`: Không mở quá nhiều kết nối (tránh lỗi "Too many connections" từ Railway Free Tier).
    - `max-lifetime=1800000`: Reset kết nối mỗi 30 phút để tránh kết nối "ma".
    - `validation-timeout=5000`: Kiểm tra kết nối còn sống không trước khi dùng.

## 4. Deployment & Monitoring (Triển khai & Giám sát)

### Build Process
- Sử dụng **Docker Multi-stage Build** (trong `Dockerfile`) để giảm kích thước image và không cần cài Maven trên Render.
- Lệnh build: `mvn clean package -DskipTests` (để tiết kiệm thời gian và tránh lỗi test môi trường CI).

### Health Checks
Render cần biết khi nào App sẵn sàng để điều hướng traffic.
- **Health Path:** `/actuator/health` (Đã thêm dependency `spring-boot-starter-actuator`).
- **Cấu hình Render:** Trong phần Settings -> Health Check Path, điền `/actuator/health`. Nếu trả về `{"status":"UP"}`, Render sẽ mark service là Healthy.

### CI/CD
- Render có tính năng "Auto Deploy" khi push lên nhánh `main`.
- **Quy trình:**
    1. Dev fix lỗi/thêm feature.
    2. Test local.
    3. Commit & Push `main`.
    4. Render tự động detect -> Build Docker -> Deploy.

## 5. Mitigation & Troubleshooting (Khắc phục sự cố)

### Logging
- Log được xuất ra `STDOUT` (Console). Xem trực tiếp tại tab **Logs** trên Render Dashboard.
- Đã cấu hình log level `DEBUG` cho các package quan trọng (`vn.edu.hcmute`, `org.springframework.web`) để dễ trace lỗi.

### Common Errors & Fixes
1.  **`OutOfMemoryError` / App Crash liên tục:**
    - *Nguyên nhân:* RAM không đủ.
    - *Fix:* Giảm `-Xmx` trong Dockerfile xuống `300m` hoặc `256m`.
2.  **`CommunicationsLinkFailure` (Database):**
    - *Nguyên nhân:* Railway MySQL ngủ đông hoặc mạng lag.
    - *Fix:* Kiểm tra lại biến môi trường `MYSQL_URL`. Đảm bảo URL có `useSSL=false`.
3.  **`404 Not Found` (JSP View):**
    - *Nguyên nhân:* Docker không copy đúng thư mục `WEB-INF`.
    - *Fix:* Kiểm tra Dockerfile lệnh `COPY src/main/webapp /app/src/main/webapp` (đã có trong Dockerfile hiện tại).
4.  **`Cannot find symbol` (Build fail):**
    - *Nguyên nhân:* Lombok không chạy trên CI.
    - *Fix:* Thêm Manual Getter/Setter (đã thực hiện cho các DTO/Entity quan trọng).

### Rollback Plan
Nếu deploy mới bị lỗi nghiêm trọng:
1. Vào Render Dashboard -> Deploys.
2. Tìm phiên bản thành công trước đó (có dấu tick xanh).
3. Bấm **Rollback** để revert về phiên bản đó ngay lập tức.
