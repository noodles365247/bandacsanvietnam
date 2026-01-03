package vn.edu.hcmute.springboot3_4_12.repository;

import vn.edu.hcmute.springboot3_4_12.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Set;
public interface ProductRepository extends JpaRepository<Product,Long> {

    List<Product> findByNameViContaining(String keyword);

    List<Product> findByNameEnContaining(String keyword);

    List<Product> findByPriceBetween(Double min, Double max);

    List<Product> findByStockGreaterThan(Integer stock);

    List<Product> findByVendor_Id(Long vendorId);

    List<Product> findByCategories_Id(Long categoryId);

    long countByVendor_IdAndStockLessThanEqual(Long vendorId, Integer stock);

    @Query("""
        SELECT p FROM Product p
        WHERE p.nameVi LIKE %:keyword%
           OR p.nameEn LIKE %:keyword%
    """)
    List<Product> searchByName(@Param("keyword") String keyword);
    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.categories c WHERE " +
            "(:keyword IS NULL OR :keyword = '' OR p.nameVi LIKE %:keyword% OR p.nameEn LIKE %:keyword%) " +
            "AND (:minPrice IS NULL OR p.price >= :minPrice) " +
            "AND (:maxPrice IS NULL OR p.price <= :maxPrice) " +
            "AND (:vendorId IS NULL OR p.vendor.id = :vendorId) " +
            "AND (:categoryId IS NULL OR c.id = :categoryId)")
    List<Product> filterProducts(
            @Param("keyword") String keyword,
            @Param("minPrice") Double minPrice,
            @Param("maxPrice") Double maxPrice,
            @Param("vendorId") Long vendorId,
            @Param("categoryId") Long categoryId
    );

    // List<Product> findTop4ByCategoriesIdAndIdNot(Long categoryId, Long productId);
    @Query("SELECT p FROM Product p JOIN p.categories c WHERE c.id = :categoryId AND p.id <> :productId")
    List<Product> findTop4ByCategoriesIdAndIdNot(@Param("categoryId") Long categoryId, @Param("productId") Long productId);

    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.categories WHERE p.id = :id")
    java.util.Optional<Product> findByIdWithCategories(@Param("id") Long id);

}
