package vn.edu.hcmute.springboot3_4_12.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "users") // Đổi tên table thành 'users' vì 'user' là từ khóa của một số DB
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password; // Lưu password đã mã hóa (BCrypt)

    @Column(unique = true, nullable = false)
    private String email;

    private String fullname;
    private String phone;
    private String address;

    private String role; // Lưu: ADMIN, VENDOR, hoặc CUSTOMER
    
    @Column(columnDefinition = "boolean default true")
    private boolean active = true;
    
    private String images;

    private String otp;
    private java.time.LocalDateTime otpExpiration;
            
    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.role);
    }

    public boolean isActive() {
        return this.active;
    }
}