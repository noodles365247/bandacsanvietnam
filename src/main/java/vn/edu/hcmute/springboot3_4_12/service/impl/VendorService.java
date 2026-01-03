package vn.edu.hcmute.springboot3_4_12.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import vn.edu.hcmute.springboot3_4_12.dto.VendorRequestDTO;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.repository.VendorRepository;
import vn.edu.hcmute.springboot3_4_12.service.IStorageService;
import vn.edu.hcmute.springboot3_4_12.service.IVendorService;

import java.util.UUID;

import vn.edu.hcmute.springboot3_4_12.dto.VendorResponseDTO;
import vn.edu.hcmute.springboot3_4_12.mapper.VendorMapper;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VendorService implements IVendorService {

    private final VendorRepository vendorRepository;
    private final UserRepository userRepository;
    private final IStorageService storageService;
    private final VendorMapper vendorMapper;

    @Override
    @Transactional(readOnly = true)
    public Vendor getVendorByUsername(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return vendorRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
    }

    @Override
    @Transactional
    public Vendor updateVendor(String username, VendorRequestDTO dto, MultipartFile logo) {
        Vendor vendor = getVendorByUsername(username);

        vendor.setShopName(dto.getShopName());
        vendor.setDescriptionVi(dto.getDescriptionVi());
        vendor.setDescriptionEn(dto.getDescriptionEn());
        vendor.setAddress(dto.getAddress());
        vendor.setPhone(dto.getPhone());

        if (logo != null && !logo.isEmpty()) {
            String filename = storageService.getSorageFilename(logo, UUID.randomUUID().toString());
            storageService.store(logo, filename);
            vendor.setLogo(filename);
        }

        return vendorRepository.save(vendor);
    }

    @Override
    public List<VendorResponseDTO> findAll() {
        return vendorRepository.findAll().stream()
                .map(vendorMapper::toResponseDTO)
                .collect(Collectors.toList());
    }

    @Override
    public VendorResponseDTO findById(Long id) {
        Vendor vendor = vendorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        return vendorMapper.toResponseDTO(vendor);
    }

    @Override
    @Transactional
    public VendorResponseDTO create(VendorRequestDTO dto) {
        // Logic to create vendor, ensure user exists and is not already a vendor
        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (vendorRepository.findByUser(user).isPresent()) {
            throw new RuntimeException("User is already a vendor");
        }

        Vendor vendor = vendorMapper.toEntity(dto);
        vendor.setUser(user);
        // Map other fields manually if needed or ensure Mapper does it
        // mapper handles basic fields.
        
        vendor = vendorRepository.save(vendor);
        return vendorMapper.toResponseDTO(vendor);
    }

    @Override
    @Transactional
    public VendorResponseDTO update(Long id, VendorRequestDTO dto) {
        Vendor vendor = vendorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        
        vendorMapper.updateEntityFromDto(dto, vendor);
        vendor = vendorRepository.save(vendor);
        return vendorMapper.toResponseDTO(vendor);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!vendorRepository.existsById(id)) {
            throw new RuntimeException("Vendor not found");
        }
        vendorRepository.deleteById(id);
    }
}
