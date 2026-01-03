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
}
