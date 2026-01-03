package vn.edu.hcmute.springboot3_4_12.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "users")
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
    private String password;

    @Column(unique = true, nullable = false)
    private String email;

    private String fullname;
    private String phone;
    private String address;

    private String role; // ADMIN, VENDOR, CUSTOMER
    
    @Column(columnDefinition = "boolean default true")
    private boolean active = true;
    
    private String images;

    private String otp;
    private java.time.LocalDateTime otpExpiration;
            
    // Manual Getters and Setters to ensure Build Success (Lombok fallback)
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    public String getOtp() { return otp; }
    public void setOtp(String otp) { this.otp = otp; }
    public java.time.LocalDateTime getOtpExpiration() { return otpExpiration; }
    public void setOtpExpiration(java.time.LocalDateTime otpExpiration) { this.otpExpiration = otpExpiration; }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.role);
    }
}
