package vn.edu.hcmute.springboot3_4_12.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

// DTO dùng để đăng ký/cập nhật
@Data
public class UserRequestDTO {
    @NotBlank(message = "Username không được để trống")
    private String username;

    @Size(min = 6, message = "Mật khẩu ít nhất 6 ký tự")
    private String password;

    @Email(message = "Email không hợp lệ")
    private String email;

    private String fullname;
    private String phone;
    private String address;

    private String role; // Mặc định là CUSTOMER
    
    private Boolean active;
    private String images;
    private Boolean admin; // Helper to set role=ADMIN

    // Manual Getters/Setters
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
    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    public Boolean getAdmin() { return admin; }
    public void setAdmin(Boolean admin) { this.admin = admin; }
}
