package vn.edu.hcmute.springboot3_4_12.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.factory.Mappers;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Category;

@Mapper(componentModel = "spring")
public interface CategoryMapper {

    // Khai báo INSTANCE để truy cập mapper mà không cần Spring DI
    CategoryMapper INSTANCE = Mappers.getMapper(CategoryMapper.class);

    Category toEntity(CategoryRequestDTO dto);

    CategoryResponseDTO toResponseDTO(Category category);

    void updateEntityFromDto(CategoryRequestDTO dto, @MappingTarget Category entity);
}