package vn.edu.hcmute.springboot3_4_12.service;

import org.springframework.web.multipart.MultipartFile;
import vn.edu.hcmute.springboot3_4_12.dto.ProductRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.ProductResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Product;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Set;

public interface IProductService {


    List<ProductResponseDTO> getAll();

    Page<ProductResponseDTO> getAll(Pageable pageable);

    ProductResponseDTO findById(Long id);

    @Transactional
    ProductResponseDTO create(ProductRequestDTO dto, List<MultipartFile> files);

    @Transactional
    ProductResponseDTO update(Long id, ProductRequestDTO dto);

    void delete(Long id);

    // Hàm bổ trợ để map Entity sang DTO và xử lý danh sách ảnh
    ProductResponseDTO convertToResponseDTO(Product product);

    List<Product> getProductsByVendor(String vendorUsername);
    Product getProductByIdForVendor(Long id, String vendorUsername);
    void deleteProduct(Long id, String vendorUsername);
    
    long countOutOfStockProducts(String vendorUsername);
    long count();

    List<ProductResponseDTO> getFeaturedProducts();

    Page<ProductResponseDTO> filterProducts(String keyword, Double minPrice, Double maxPrice, Long vendorId, Long categoryId, Pageable pageable);

    List<ProductResponseDTO> getSimilarProducts(Long productId);
}
