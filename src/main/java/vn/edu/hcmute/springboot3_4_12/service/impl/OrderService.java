package vn.edu.hcmute.springboot3_4_12.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import vn.edu.hcmute.springboot3_4_12.dto.OrderRequestDTO;
import vn.edu.hcmute.springboot3_4_12.entity.*;
import vn.edu.hcmute.springboot3_4_12.repository.OrderRepository;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.repository.VendorRepository;
import vn.edu.hcmute.springboot3_4_12.service.IOrderService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.ArrayList;

@Service
@RequiredArgsConstructor
public class OrderService implements IOrderService {

    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    private final VendorRepository vendorRepository;
    private final vn.edu.hcmute.springboot3_4_12.repository.CartRepository cartRepository;

    @Override
    public Order createOrder(String username, OrderRequestDTO orderRequest) {
        User user = userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart empty"));

        if (cart.getItems().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        Order order = new Order();
        order.setUser(user);
        order.setRecipientName(orderRequest.getRecipientName());
        order.setRecipientPhone(orderRequest.getRecipientPhone());
        order.setShippingAddress(orderRequest.getShippingAddress());
        order.setNote(orderRequest.getNote());
        order.setPaymentMethod(orderRequest.getPaymentMethod());
        order.setStatus(OrderStatus.PENDING);
        
        List<OrderItem> orderItems = new ArrayList<>();
        double total = 0;

        for (CartItem cartItem : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setProduct(cartItem.getProduct());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(cartItem.getProduct().getPrice());
            
            orderItems.add(orderItem);
            total += cartItem.getQuantity() * cartItem.getProduct().getPrice();
        }
        
        order.setOrderItems(orderItems);
        order.setTotalAmount(total);
        
        Order savedOrder = orderRepository.save(order);

        // Clear Cart
        cart.getItems().clear();
        cart.setTotalPrice(0.0);
        cartRepository.save(cart);

        return savedOrder;
    }

    @Override
    public List<Order> getOrdersByUser(String username) {
        User user = userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return orderRepository.findByUserOrderByCreatedAtDesc(user);
    }

    @Override
    public Order getOrderById(Long id, String username) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        if (!order.getUser().getUsername().equals(username)) {
            throw new RuntimeException("Unauthorized");
        }
        return order;
    }

    @Override
    public List<Order> getOrdersByVendor(String vendorUsername) {
        User user = userRepository.findUserByUsername(vendorUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        return orderRepository.findOrdersByVendorId(vendor.getId());
    }

    @Override
    public List<OrderItem> getOrderItemsByVendor(Long orderId, String vendorUsername) {
        User user = userRepository.findUserByUsername(vendorUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        
        return orderRepository.findOrderItemsByOrderIdAndVendorId(orderId, vendor.getId());
    }

    @Override
    public Order getOrderByIdForVendor(Long id, String vendorUsername) {
        return orderRepository.findById(id).orElse(null);
    }

    @Override
    public long countOrdersByVendor(String vendorUsername) {
        User user = userRepository.findUserByUsername(vendorUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        return orderRepository.countOrdersByVendorId(vendor.getId());
    }

    @Override
    public double calculateRevenueByVendor(String vendorUsername) {
        User user = userRepository.findUserByUsername(vendorUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        Double revenue = orderRepository.calculateRevenueByVendorId(vendor.getId());
        return revenue != null ? revenue : 0.0;
    }

    @Override
    public List<Order> getRecentOrdersByVendor(String vendorUsername, int limit) {
        User user = userRepository.findUserByUsername(vendorUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        
        List<Order> allOrders = orderRepository.findOrdersByVendorId(vendor.getId());
        if (allOrders.size() > limit) {
            return allOrders.subList(0, limit);
        }
        return allOrders;
    }

    @Override
    public Map<LocalDate, Double> getDailyRevenue(String vendorUsername, int days) {
        User user = userRepository.findUserByUsername(vendorUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));

        LocalDateTime startDate = LocalDateTime.now().minusDays(days);
        List<Object[]> results = orderRepository.findDailyRevenueByVendorId(vendor.getId(), startDate);
        
        Map<LocalDate, Double> revenueMap = new TreeMap<>();
        for (int i = 0; i < days; i++) {
            revenueMap.put(LocalDate.now().minusDays(i), 0.0);
        }
        
        for (Object[] result : results) {
            Object dateObj = result[0];
            LocalDate date = null;
            if (dateObj instanceof java.sql.Date) {
                date = ((java.sql.Date) dateObj).toLocalDate();
            } else if (dateObj instanceof java.util.Date) {
                date = ((java.util.Date) dateObj).toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate();
            }
            
            Double revenue = (Double) result[1];
            if (date != null) {
                revenueMap.put(date, revenue);
            }
        }
        return revenueMap;
    }

    @Override
    public void updateOrderStatus(Long orderId, String status, String vendorUsername) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        
        try {
            OrderStatus newStatus = OrderStatus.valueOf(status);
            order.setStatus(newStatus);
            orderRepository.save(order);
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Invalid status: " + status);
        }
    }

    @Override
    public long count() {
        return orderRepository.count();
    }

    @Override
    public Double calculateTotalRevenue() {
        return orderRepository.calculateTotalRevenue();
    }

    @Override
    public Map<LocalDate, Double> getDailyRevenueForAdmin(int days) {
        LocalDateTime startDate = LocalDateTime.now().minusDays(days);
        List<Object[]> results = orderRepository.findDailyRevenue(startDate);
        
        Map<LocalDate, Double> revenueMap = new TreeMap<>();
        for (int i = 0; i < days; i++) {
            revenueMap.put(LocalDate.now().minusDays(i), 0.0);
        }
        
        for (Object[] result : results) {
            // Handle different Date types (java.sql.Date or java.util.Date)
            Object dateObj = result[0];
            LocalDate date = null;
            if (dateObj instanceof java.sql.Date) {
                date = ((java.sql.Date) dateObj).toLocalDate();
            } else if (dateObj instanceof java.util.Date) {
                date = ((java.util.Date) dateObj).toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate();
            }
            
            Double revenue = (Double) result[1];
            if (date != null) {
                revenueMap.put(date, revenue);
            }
        }
        return revenueMap;
    }

    @Override
    public void updateStatus(Long orderId, OrderStatus status) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new RuntimeException("Order not found"));
        order.setStatus(status);
        orderRepository.save(order);
    }

    @Override
    public org.springframework.data.domain.Page<Order> findAll(org.springframework.data.domain.Pageable pageable) {
        return orderRepository.findAll(pageable);
    }
}
