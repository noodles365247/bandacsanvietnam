package vn.edu.hcmute.springboot3_4_12.repository;

import vn.edu.hcmute.springboot3_4_12.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Set;

public interface CategoryRepository extends JpaRepository<Category,Long> {
     List<Category> findCategoriesByIdIn(Set<Long> ids);
}
