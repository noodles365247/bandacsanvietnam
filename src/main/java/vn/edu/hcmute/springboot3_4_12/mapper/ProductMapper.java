package vn.edu.hcmute.springboot3_4_12.mapper;
import org.mapstruct.factory.Mappers;
import vn.edu.hcmute.springboot3_4_12.dto.ProductRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.ProductResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Category;
import vn.edu.hcmute.springboot3_4_12.entity.Product;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface ProductMapper {
    ProductMapper INSTANCE = Mappers.getMapper(ProductMapper.class);
    @Mapping(target = "categories", expression = "java(mapCategoriesToNames(product.getCategories()))")
    @Mapping(target = "vendorName", source = "vendor.shopName")
    ProductResponseDTO toResponseDTO(Product product);

    default List<String> mapCategoriesToNames(List<Category> categories) {
        if (categories == null || categories.isEmpty()) {
            return new java.util.ArrayList<>(); // Trả về empty list thay vì null
        }
        return categories.stream()
                .map(cat -> cat != null && cat.getNameVi() != null ? cat.getNameVi() : "")
                .filter(name -> !name.isEmpty())
                .collect(Collectors.toList());
    }

    // --- Request DTO to Entity (Create) ---
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "vendor", ignore = true)     // Xử lý tại Service
    @Mapping(target = "categories", ignore = true) // Xử lý tại Service
    @Mapping(target = "blogs", ignore = true)      // Entity có blogs, DTO thường không tạo blog
    @Mapping(target = "images", ignore = true)     // Xử lý logic upload/map ảnh riêng
    Product toEntity(ProductRequestDTO dto);

    // --- Update Entity từ DTO ---
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "vendor", ignore = true)
    @Mapping(target = "categories", ignore = true)
    @Mapping(target = "blogs", ignore = true)
    @Mapping(target = "images", ignore = true)
    void updateEntityFromDto(ProductRequestDTO dto, @MappingTarget Product entity);
}
