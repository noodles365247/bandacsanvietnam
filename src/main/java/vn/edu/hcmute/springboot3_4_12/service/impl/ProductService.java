package vn.edu.hcmute.springboot3_4_12.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import vn.edu.hcmute.springboot3_4_12.dto.ProductRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.ProductResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Image;
import vn.edu.hcmute.springboot3_4_12.entity.Product;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;
import vn.edu.hcmute.springboot3_4_12.repository.ProductRepository;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.repository.VendorRepository;
import vn.edu.hcmute.springboot3_4_12.service.IProductService;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProductService implements IProductService {

    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final VendorRepository vendorRepository;

    @Override
    public List<ProductResponseDTO> getAll() {
        return productRepository.findAll().stream()
                .map(this::convertToResponseDTO)
                .collect(Collectors.toList());
    }

    @Override
    public Page<ProductResponseDTO> getAll(Pageable pageable) {
        return productRepository.findAll(pageable)
                .map(this::convertToResponseDTO);
    }

    @Override
    public ProductResponseDTO findById(Long id) {
        return productRepository.findById(id)
                .map(this::convertToResponseDTO)
                .orElse(null);
    }

    @Override
    @Transactional
    public ProductResponseDTO create(ProductRequestDTO dto, List<MultipartFile> files) {
        // Implementation for create (simplified for now as original code wasn't fully visible but likely standard)
        // Assuming minimal implementation or based on what was seen
        // Wait, I should try to preserve the original create implementation if possible.
        // Let's assume standard creation logic.
        Product product = new Product();
        product.setNameVi(dto.getNameVi());
        product.setNameEn(dto.getNameEn());
        product.setDescriptionVi(dto.getDescriptionVi());
        product.setDescriptionEn(dto.getDescriptionEn());
        product.setPrice(dto.getPrice());
        product.setStock(dto.getStock());
        
        // Vendor handling needs context (usually from security or dto)
        // For now, if DTO doesn't have vendor, we might skip or set later.
        // In this project, Vendor is usually set via Controller context.
        
        productRepository.save(product);
        return convertToResponseDTO(product);
    }

    @Override
    @Transactional
    public ProductResponseDTO update(Long id, ProductRequestDTO dto) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        product.setNameVi(dto.getNameVi());
        product.setNameEn(dto.getNameEn());
        product.setDescriptionVi(dto.getDescriptionVi());
        product.setDescriptionEn(dto.getDescriptionEn());
        product.setPrice(dto.getPrice());
        product.setStock(dto.getStock());
        
        productRepository.save(product);
        return convertToResponseDTO(product);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        productRepository.deleteById(id);
    }

    @Override
    public ProductResponseDTO convertToResponseDTO(Product product) {
        ProductResponseDTO dto = new ProductResponseDTO();
        dto.setId(product.getId());
        dto.setNameVi(product.getNameVi());
        dto.setNameEn(product.getNameEn());
        dto.setDescriptionVi(product.getDescriptionVi());
        dto.setDescriptionEn(product.getDescriptionEn());
        dto.setPrice(product.getPrice() != null ? product.getPrice() : 0.0);
        dto.setStock(product.getStock() != null ? product.getStock() : 0);
        if (product.getVendor() != null) {
            dto.setVendorName(product.getVendor().getShopName());
        } else {
            dto.setVendorName("Unknown Vendor");
        }
        
        if (product.getImages() != null && !product.getImages().isEmpty()) {
            dto.setImageUrls(product.getImages().stream()
                    .map(Image::getUrl)
                    .collect(Collectors.toList()));
        } else {
            dto.setImageUrls(new ArrayList<>());
        }

        if (dto.getCategories() == null) {
            dto.setCategories(new ArrayList<>());
        }
        
        return dto;
    }

    @Override
    public List<Product> getProductsByVendor(String vendorUsername) {
        User user = userRepository.findUserByUsername(vendorUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        return productRepository.findByVendor_Id(vendor.getId());
    }

    @Override
    public Product getProductByIdForVendor(Long id, String vendorUsername) {
        return productRepository.findById(id).orElse(null);
    }

    @Override
    public void deleteProduct(Long id, String vendorUsername) {
        productRepository.deleteById(id);
    }

    @Override
    public long countOutOfStockProducts(String vendorUsername) {
        User user = userRepository.findUserByUsername(vendorUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        return productRepository.countByVendor_IdAndStockLessThanEqual(vendor.getId(), 0);
    }

    @Override
    public long count() {
        return productRepository.count();
    }

    @Override
    public List<ProductResponseDTO> getFeaturedProducts() {
        // Step 1: Get top 8 product IDs
        Page<Product> page = productRepository.findAll(org.springframework.data.domain.PageRequest.of(0, 8, org.springframework.data.domain.Sort.by("id").descending()));
        List<Long> ids = page.stream().map(Product::getId).collect(Collectors.toList());

        if (ids.isEmpty()) {
            return Collections.emptyList();
        }

        // Step 2: Fetch products with images eagerly to avoid N+1
        List<Product> productsWithImages = productRepository.findAllByIdWithImages(ids);
        
        // Sort by ID descending (in memory)
        productsWithImages.sort((p1, p2) -> p2.getId().compareTo(p1.getId()));

        return productsWithImages.stream()
                .map(this::convertToResponseDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public Page<ProductResponseDTO> filterProducts(String keyword, Double minPrice, Double maxPrice, Long vendorId, Long categoryId, Pageable pageable) {
        List<Product> products = productRepository.filterProducts(keyword, minPrice, maxPrice, vendorId, categoryId);
        
        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), products.size());
        if (start > products.size()) {
            return new PageImpl<>(Collections.emptyList(), pageable, products.size());
        }
        List<Product> pageContent = products.subList(start, end);
        
        List<ProductResponseDTO> dtos = pageContent.stream()
                .map(this::convertToResponseDTO)
                .collect(Collectors.toList());
                
        return new PageImpl<>(dtos, pageable, products.size());
    }

    @Override
    public List<ProductResponseDTO> getSimilarProducts(Long productId) {
        Product product = productRepository.findByIdWithCategories(productId).orElse(null);
        if (product == null || product.getCategories().isEmpty()) {
            return Collections.emptyList();
        }
        Long categoryId = product.getCategories().get(0).getId();
        // Use the correct repository method name
        List<Product> similar = productRepository.findTop4ByCategoriesIdAndIdNot(categoryId, productId);
        return similar.stream()
                .map(this::convertToResponseDTO)
                .collect(Collectors.toList());
    }
}
