package vn.edu.hcmute.springboot3_4_12.service;

import org.springframework.web.multipart.MultipartFile;
import vn.edu.hcmute.springboot3_4_12.dto.VendorRequestDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;

import java.util.List;
import vn.edu.hcmute.springboot3_4_12.dto.VendorResponseDTO;

public interface IVendorService {
    Vendor getVendorByUsername(String username);
    Vendor updateVendor(String username, VendorRequestDTO dto, MultipartFile logo);
    
    List<VendorResponseDTO> findAll();
    VendorResponseDTO findById(Long id);
    VendorResponseDTO create(VendorRequestDTO dto);
    VendorResponseDTO update(Long id, VendorRequestDTO dto);
    void delete(Long id);
}
