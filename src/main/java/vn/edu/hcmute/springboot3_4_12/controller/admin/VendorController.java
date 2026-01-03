package vn.edu.hcmute.springboot3_4_12.controller.admin;


import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmute.springboot3_4_12.dto.VendorRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.VendorResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;
import vn.edu.hcmute.springboot3_4_12.service.IVendorService;


import java.util.List;
@RestController
@RequestMapping("/admin/api/vendors")
@RequiredArgsConstructor
public class VendorController {

    private final IVendorService vendorService;

    @GetMapping
    public ResponseEntity<List<VendorResponseDTO>> getAll() {
        return ResponseEntity.ok(vendorService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<VendorResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(vendorService.findById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<VendorResponseDTO> create(@RequestBody VendorRequestDTO dto) {
        return new ResponseEntity<>(vendorService.create(dto), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDOR')")
    public ResponseEntity<VendorResponseDTO> update(@PathVariable Long id, @RequestBody VendorRequestDTO dto) {
        return ResponseEntity.ok(vendorService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        vendorService.delete(id);
        return ResponseEntity.noContent().build();
    }
}