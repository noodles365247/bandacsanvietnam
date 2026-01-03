package vn.edu.hcmute.springboot3_4_12.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// DTO dùng để trả về thông tin người dùng
@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserResponseDTO {
    private Long id;
    private String username;
    private String email;
    private String fullname;
    private String phone;
    private String address;
    private String role;
    private boolean active;
    private String images;
    private boolean admin;

    // Helper methods for JSP if needed, but @Data handles basic getters
    // Lombok generates isActive() for boolean active, isAdmin() for boolean admin
}
