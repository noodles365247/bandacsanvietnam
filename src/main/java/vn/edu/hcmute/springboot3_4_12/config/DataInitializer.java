package vn.edu.hcmute.springboot3_4_12.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;

import java.util.Optional;

/**
 * Class để tự động tạo dữ liệu user và admin khi ứng dụng khởi động
 * Chỉ tạo nếu chưa tồn tại
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Tạo ADMIN nếu chưa có
        createUserIfNotExists(
            "admin",
            "admin123",
            "admin@dacsan.com",
            "ADMIN"
        );

        // Tạo CUSTOMER mẫu nếu chưa có
        createUserIfNotExists(
            "user1",
            "user123",
            "user1@dacsan.com",
            "CUSTOMER"
        );

        // Tạo VENDOR mẫu nếu chưa có
        createUserIfNotExists(
            "vendor1",
            "vendor123",
            "vendor1@dacsan.com",
            "VENDOR"
        );

        System.out.println("=== Đã khởi tạo dữ liệu user mẫu ===");
        System.out.println("ADMIN - Username: admin, Password: admin123");
        System.out.println("CUSTOMER - Username: user1, Password: user123");
        System.out.println("VENDOR - Username: vendor1, Password: vendor123");
    }

    private void createUserIfNotExists(String username, String password, String email, String role) {
        Optional<User> existingUser = userRepository.findUserByUsername(username);
        
        if (existingUser.isEmpty()) {
            // Tạo user mới
            User user = new User();
            user.setUsername(username);
            user.setPassword(passwordEncoder.encode(password)); // Mã hóa password
            user.setEmail(email);
            user.setRole(role);
            
            userRepository.save(user);
            System.out.println("✓ Đã tạo user: " + username + " với role: " + role);
        } else {
            // User đã tồn tại - kiểm tra và cập nhật nếu cần
            User user = existingUser.get();
            boolean needUpdate = false;
            
            // Kiểm tra password có đúng không
            if (!passwordEncoder.matches(password, user.getPassword())) {
                user.setPassword(passwordEncoder.encode(password));
                needUpdate = true;
                System.out.println("⚠ Đã cập nhật password cho user: " + username);
            }
            
            // Kiểm tra role có đúng không
            if (!role.equals(user.getRole())) {
                user.setRole(role);
                needUpdate = true;
                System.out.println("⚠ Đã cập nhật role cho user: " + username + " -> " + role);
            }
            
            // Kiểm tra email có đúng không
            if (!email.equals(user.getEmail())) {
                user.setEmail(email);
                needUpdate = true;
                System.out.println("⚠ Đã cập nhật email cho user: " + username);
            }
            
            if (needUpdate) {
                userRepository.save(user);
            } else {
                System.out.println("✓ User " + username + " đã tồn tại và đúng thông tin.");
            }
        }
    }
}

