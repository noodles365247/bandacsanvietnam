package vn.edu.hcmute.springboot3_4_12.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import vn.edu.hcmute.springboot3_4_12.entity.Order;
import vn.edu.hcmute.springboot3_4_12.entity.User;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUserOrderByCreatedAtDesc(User user);

    @Query("SELECT DISTINCT o FROM Order o JOIN o.orderItems oi WHERE oi.product.vendor.id = :vendorId ORDER BY o.createdAt DESC")
    List<Order> findOrdersByVendorId(@Param("vendorId") Long vendorId);

    @Query("SELECT COUNT(DISTINCT o) FROM Order o JOIN o.orderItems oi WHERE oi.product.vendor.id = :vendorId")
    long countOrdersByVendorId(@Param("vendorId") Long vendorId);

    @Query("SELECT SUM(oi.price * oi.quantity) FROM OrderItem oi WHERE oi.product.vendor.id = :vendorId")
    Double calculateRevenueByVendorId(@Param("vendorId") Long vendorId);

    @Query("SELECT DISTINCT o FROM Order o JOIN o.orderItems oi WHERE oi.product.vendor.id = :vendorId AND o.createdAt >= :startDate")
    List<Order> findOrdersByVendorIdAndCreatedAtAfter(@Param("vendorId") Long vendorId, @Param("startDate") java.time.LocalDateTime startDate);

    @Query("SELECT SUM(o.totalAmount) FROM Order o WHERE o.status = 'DELIVERED'")
    Double calculateTotalRevenue();

    @Query("SELECT CAST(o.createdAt AS date), SUM(o.totalAmount) FROM Order o WHERE o.status = 'DELIVERED' AND o.createdAt >= :startDate GROUP BY CAST(o.createdAt AS date) ORDER BY CAST(o.createdAt AS date)")
    List<Object[]> findDailyRevenue(@Param("startDate") java.time.LocalDateTime startDate);

    @Query("SELECT CAST(o.createdAt AS date), SUM(oi.price * oi.quantity) FROM Order o JOIN o.orderItems oi WHERE oi.product.vendor.id = :vendorId AND o.status = 'DELIVERED' AND o.createdAt >= :startDate GROUP BY CAST(o.createdAt AS date) ORDER BY CAST(o.createdAt AS date)")
    List<Object[]> findDailyRevenueByVendorId(@Param("vendorId") Long vendorId, @Param("startDate") java.time.LocalDateTime startDate);

    @Query("SELECT oi FROM OrderItem oi WHERE oi.order.id = :orderId AND oi.product.vendor.id = :vendorId")
    List<vn.edu.hcmute.springboot3_4_12.entity.OrderItem> findOrderItemsByOrderIdAndVendorId(@Param("orderId") Long orderId, @Param("vendorId") Long vendorId);
}
