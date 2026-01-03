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

    // Manual Getters/Setters to bypass Lombok build issues on Render
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNameVi() { return nameVi; }
    public void setNameVi(String nameVi) { this.nameVi = nameVi; }
    public String getNameEn() { return nameEn; }
    public void setNameEn(String nameEn) { this.nameEn = nameEn; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public Boolean getStatus() { return status; }
    public void setStatus(Boolean status) { this.status = status; }
}
