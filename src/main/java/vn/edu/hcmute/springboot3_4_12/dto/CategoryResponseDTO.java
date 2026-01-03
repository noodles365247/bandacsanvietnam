package vn.edu.hcmute.springboot3_4_12.dto;

import lombok.Data;

@Data
public class CategoryResponseDTO {
    private Long id;
    private String nameVi;
    private String nameEn;
    private String image;
    private Boolean status;
    // Không kèm danh sách Product để tránh đệ quy và nặng dữ liệu
}
