package vn.edu.hcmute.springboot3_4_12.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

// DTO dùng để trả về thông tin người dùng
public record UserResponseDTO(Long id, String username, String email, String fullname, String phone, String address, String role, boolean active, String images, boolean admin) {
    public Long getId() { return id; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getFullname() { return fullname; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public String getRole() { return role; }
    public boolean isActive() { return active; }
    public String getImages() { return images; }
    public boolean isAdmin() { return admin; }
}

