package vn.edu.hcmute.springboot3_4_12.dto;

import lombok.Data;

@Data
public class VendorRequestDTO {
    private String shopName;
    private String descriptionVi;
    private String descriptionEn;
    private String address;
    private String phone;
    private Long userId;

    // Manual Getters/Setters to bypass Lombok issues
    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }
    public String getDescriptionVi() { return descriptionVi; }
    public void setDescriptionVi(String descriptionVi) { this.descriptionVi = descriptionVi; }
    public String getDescriptionEn() { return descriptionEn; }
    public void setDescriptionEn(String descriptionEn) { this.descriptionEn = descriptionEn; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
}
