package vn.edu.hcmute.springboot3_4_12.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CategoryRequestDTO {
    @NotBlank(message = "Tên tiếng Việt không được để trống")
    private String nameVi;
    private String nameEn;
    private String image;
    private Boolean status;
}
