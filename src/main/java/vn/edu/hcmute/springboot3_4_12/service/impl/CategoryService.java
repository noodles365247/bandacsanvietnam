package vn.edu.hcmute.springboot3_4_12.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Category;
import vn.edu.hcmute.springboot3_4_12.mapper.CategoryMapper;
import vn.edu.hcmute.springboot3_4_12.repository.CategoryRepository;
import vn.edu.hcmute.springboot3_4_12.service.ICategoryService;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class CategoryService implements ICategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    // Lưu ý: Không cần @Autowired CategoryMapper nếu dùng .INSTANCE

    @Override
    @Transactional(readOnly = true)
    @Cacheable(value = "categories")
    public List<CategoryResponseDTO> getAll() {
        return categoryRepository.findAll().stream()
                .map(category -> CategoryMapper.INSTANCE.toResponseDTO(category))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    @CacheEvict(value = "categories", allEntries = true)
    public CategoryResponseDTO create(CategoryRequestDTO dto) {
        // DTO -> Entity (Dùng INSTANCE)
        Category category = CategoryMapper.INSTANCE.toEntity(dto);
        Category savedCategory = categoryRepository.save(category);
        // Entity -> ResponseDTO (Dùng INSTANCE)
        return CategoryMapper.INSTANCE.toResponseDTO(savedCategory);
    }

    @Override
    @Transactional
    @CacheEvict(value = "categories", allEntries = true)
    public CategoryResponseDTO update(Long id, CategoryRequestDTO dto) {
        Category existingCategory = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục với ID: " + id));

        // Update dữ liệu (Dùng INSTANCE)
        CategoryMapper.INSTANCE.updateEntityFromDto(dto, existingCategory);

        Category updatedCategory = categoryRepository.save(existingCategory);
        return CategoryMapper.INSTANCE.toResponseDTO(updatedCategory);
    }

    @Override
    @Transactional
    @CacheEvict(value = "categories", allEntries = true)
    public void delete(Long id) {
        if (!categoryRepository.existsById(id)) {
            throw new RuntimeException("Không tìm thấy danh mục để xóa");
        }
        categoryRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Category> findById(Long id) {
        return categoryRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Category> findAllByIds(Set<Long> categoryIds)
    {
        return categoryRepository.findAllById(categoryIds);
    }

    @Override
    @Transactional
    public <S extends Category> S save(S entity) {
        return categoryRepository.save(entity);
    }
}