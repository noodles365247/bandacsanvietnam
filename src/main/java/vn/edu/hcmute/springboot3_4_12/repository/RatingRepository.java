package vn.edu.hcmute.springboot3_4_12.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import vn.edu.hcmute.springboot3_4_12.entity.Order;
import vn.edu.hcmute.springboot3_4_12.entity.Product;
import vn.edu.hcmute.springboot3_4_12.entity.Rating;
import vn.edu.hcmute.springboot3_4_12.entity.User;

import java.util.List;
import java.util.Optional;

@Repository
public interface RatingRepository extends JpaRepository<Rating, Long> {
    List<Rating> findByProductOrderByCreatedAtDesc(Product product);
    Optional<Rating> findByUserAndProductAndOrder(User user, Product product, Order order);
    boolean existsByUserAndProductAndOrder(User user, Product product, Order order);

    @Query("SELECT AVG(r.stars) FROM Rating r WHERE r.product.id = :productId")
    Double getAverageRating(Long productId);
}
