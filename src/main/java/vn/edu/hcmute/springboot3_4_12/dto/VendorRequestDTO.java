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
}
