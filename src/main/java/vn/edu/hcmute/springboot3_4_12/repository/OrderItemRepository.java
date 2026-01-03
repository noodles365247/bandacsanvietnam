package vn.edu.hcmute.springboot3_4_12.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import vn.edu.hcmute.springboot3_4_12.entity.OrderItem;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
}
