package vn.edu.hcmute.springboot3_4_12.service;

import jakarta.validation.Valid;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Category;
import jakarta.validation.constraints.NotEmpty;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.List;
import java.util.Set;
import java.util.Optional;

public interface ICategoryService {
    Optional<Category> findById(Long aLong);

    <S extends Category> S save(S entity);




    List<Category> findAllByIds(@NotEmpty(message = "Danh mục không được rỗng") Set<Long> categoryIds);

    List<CategoryResponseDTO> getAll();

    void delete(Long id);

    CategoryResponseDTO update(Long id, @Valid CategoryRequestDTO dto);

    CategoryResponseDTO create(@Valid CategoryRequestDTO dto);
}
