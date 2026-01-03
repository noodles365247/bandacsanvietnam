package vn.edu.hcmute.springboot3_4_12.service;

import vn.edu.hcmute.springboot3_4_12.dto.OrderRequestDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Order;

import java.util.List;

public interface IOrderService {
    Order createOrder(String username, OrderRequestDTO orderRequest);
    List<Order> getOrdersByUser(String username);
    Order getOrderById(Long id, String username);
    List<Order> getOrdersByVendor(String vendorUsername);
    List<vn.edu.hcmute.springboot3_4_12.entity.OrderItem> getOrderItemsByVendor(Long orderId, String vendorUsername);
    Order getOrderByIdForVendor(Long id, String vendorUsername);
    
    // Dashboard stats
    long countOrdersByVendor(String vendorUsername);
    double calculateRevenueByVendor(String vendorUsername);
    List<Order> getRecentOrdersByVendor(String vendorUsername, int limit);
    
    java.util.Map<java.time.LocalDate, Double> getDailyRevenue(String vendorUsername, int days);
    
    // Status update
    void updateOrderStatus(Long orderId, String status, String vendorUsername);

    long count();
    Double calculateTotalRevenue();
    java.util.Map<java.time.LocalDate, Double> getDailyRevenueForAdmin(int days);
    void updateStatus(Long orderId, vn.edu.hcmute.springboot3_4_12.entity.OrderStatus status);
    org.springframework.data.domain.Page<Order> findAll(org.springframework.data.domain.Pageable pageable);
}
