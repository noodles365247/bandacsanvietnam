# RUNBOOK: Triển khai & Khắc phục sự cố trên Render

Tài liệu này hướng dẫn chi tiết về cấu hình, giám sát và xử lý sự cố khi triển khai ứng dụng **Bandacsan** (Spring Boot + JSP) trên nền tảng Cloud Render.

---

## 1. Vấn đề về cấu hình môi trường

### 1.1. Biến môi trường (Environment Variables)
Cần thiết lập chính xác các biến sau trong **Render Dashboard > Environment**:

| Biến (Key) | Giá trị mẫu (Value) | Ý nghĩa | Quan trọng |
|------------|---------------------|---------|------------|
| `MYSQL_URL` | `jdbc:mysql://host:port/db?useSSL=false` | Chuỗi kết nối Database (Railway) | **Cực kỳ quan trọng** |
| `MYSQLUSER` | `root` | Username Database | **Cực kỳ quan trọng** |
| `MYSQLPASSWORD` | `******` | Password Database | **Cực kỳ quan trọng** |
| `JWT_SECRET` | `chuoi_bi_mat_dai_hon_256_bit` | Khóa bí mật ký token bảo mật | **Quan trọng** |
| `JAVA_TOOL_OPTIONS` | `-Xmx350m -Xms256m` | Giới hạn RAM cho JVM (Tránh Crash) | **Cực kỳ quan trọng** |
| `PORT` | (Render tự điền) | Cổng mạng (App tự nhận diện) | Tự động |

### 1.2. Quản lý Dependencies
*   **Lưu ý quan trọng:** Dự án này là **Java Spring Boot**, sử dụng `pom.xml` (Maven) để quản lý thư viện.
*   **Không dùng `package.json`:** File này chỉ dành cho Node.js. Mọi thay đổi thư viện Java phải thực hiện trong `pom.xml`.
*   **Version Control:** Dockerfile sử dụng `maven:3.8.5-openjdk-17` để build, đảm bảo tính nhất quán với môi trường dev.

---

## 2. Vấn đề về tài nguyên (RAM/CPU)

### 2.1. Giới hạn bộ nhớ (RAM Limit)
*   **Vấn đề:** Render Free Tier chỉ cung cấp **512MB RAM**. Nếu Spring Boot dùng quá mức này, Container sẽ bị Kill (OOMKilled).
*   **Giải pháp đã áp dụng:**
    *   Biến môi trường `JAVA_TOOL_OPTIONS="-Xmx350m -Xms256m"` đã được set cứng trong Dockerfile.
    *   Điều này ép buộc Java chỉ dùng tối đa 350MB Heap, để dành ~162MB cho OS và các tiến trình khác.

### 2.2. CPU & Auto-scaling
*   **CPU:** Free Tier dùng shared CPU. Tránh các tác vụ nặng (như xử lý ảnh/video quá lớn) trên server.
*   **Auto-scaling:** Render Free Tier **không hỗ trợ** auto-scaling.
    *   *Khuyến nghị:* Nếu lượng user tăng đột biến, cần nâng cấp lên gói Starter ($7/tháng) để scale manual hoặc auto.

### 2.3. Lưu trữ tạm thời (Ephemeral Storage)
*   **Cảnh báo:** Ổ cứng trên Render Free là tạm thời. Dữ liệu trong thư mục `uploads/` sẽ **mất sạch** khi Restart/Deploy.
*   **Giải pháp:**
    *   Hiện tại: Chấp nhận mất ảnh khi redeploy (phù hợp demo).
    *   Tương lai: Cần tích hợp AWS S3 hoặc Cloudinary để lưu file bền vững.

---

## 3. Vấn đề kết nối cơ sở dữ liệu

### 3.1. Connection Pooling (HikariCP)
Cấu hình trong `application.properties` đã được tối ưu cho môi trường Cloud hạn chế tài nguyên:

*   `spring.datasource.hikari.maximum-pool-size=12`: Giới hạn tối đa 12 kết nối (Railway Free giới hạn tổng connection, không nên set quá cao).
*   `spring.datasource.hikari.minimum-idle=5`: Giữ sẵn 5 kết nối để phản hồi nhanh.
*   `spring.datasource.hikari.connection-timeout=20000`: Timeout 20 giây (tránh treo app khi mạng lag).
*   `spring.datasource.hikari.max-lifetime=1800000`: Reset kết nối mỗi 30 phút.

### 3.2. Kiểm tra kết nối
*   Hệ thống sử dụng `spring.sql.init.mode=always` để tự động kiểm tra và khởi tạo dữ liệu khi khởi động.
*   Nếu app start thành công, nghĩa là kết nối DB ổn định.

---

## 4. Vấn đề triển khai (Deployment)

### 4.1. Quy trình CI/CD
*   **Source:** GitHub Repository (`main` branch).
*   **Trigger:** Tự động deploy khi có commit mới vào nhánh `main`.
*   **Build:** Docker Multi-stage build (giảm dung lượng image xuống < 300MB).
    *   Stage 1: Maven Build (`mvn clean package -DskipTests`)
    *   Stage 2: Run (`java -jar app.war`)

### 4.2. Health Check & Monitoring
*   **Endpoint:** `/actuator/health`
*   **Cấu hình Render:**
    *   Health Check Path: `/actuator/health`
    *   Nếu trả về `{"status":"UP"}`, Render mới điều hướng traffic vào.
*   **Lợi ích:** Tránh lỗi 502 Bad Gateway khi app đang khởi động (Spring Boot mất 30s-60s để start).

---

## 5. Biện pháp khắc phục sự cố (Troubleshooting)

### 5.1. Logging tập trung
*   Log được đẩy ra **STDOUT** và xem trực tiếp tại tab **Logs** trên Render.
*   Level log: `DEBUG` cho `vn.edu.hcmute` để dễ dàng trace lỗi logic.

### 5.2. Rollback Plan (Kế hoạch khôi phục)
Khi deploy phiên bản mới bị lỗi (Crash, lỗi logic nghiêm trọng):
1.  Truy cập **Render Dashboard** -> Chọn Service.
2.  Vào tab **Events** hoặc **History**.
3.  Tìm phiên bản deploy thành công gần nhất (có dấu tích xanh ✅).
4.  Nhấn **Rollback** (hoặc Redeploy commit đó).
5.  Thời gian rollback: ~2-3 phút.

### 5.3. Các lỗi thường gặp & Cách xử lý

| Triệu chứng | Nguyên nhân tiềm năng | Cách xử lý |
|-------------|-----------------------|------------|
| **App Crash ngay khi start** | Thiếu RAM hoặc sai biến môi trường DB | Kiểm tra Log. Nếu lỗi `OOMKilled` -> Giảm `-Xmx`. Nếu lỗi JDBC -> Check `MYSQL_URL`. |
| **Lỗi `Cannot find symbol`** | Lombok chưa chạy khi build | Thêm Manual Getter/Setter vào Entity/DTO tương ứng. |
| **Lỗi 502 Bad Gateway** | App chưa start xong hoặc Health check fail | Chờ 1-2 phút. Kiểm tra log xem có Exception nào chặn start không. |
| **Mất ảnh đã upload** | Do cơ chế Ephemeral Storage | Upload lại ảnh. Đây là đặc tính của Render Free. |

---
*Tài liệu này cần được cập nhật mỗi khi có thay đổi lớn về hạ tầng hoặc cấu hình.*
