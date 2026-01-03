package vn.edu.hcmute.springboot3_4_12.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.edu.hcmute.springboot3_4_12.entity.*;
import vn.edu.hcmute.springboot3_4_12.repository.OrderRepository;
import vn.edu.hcmute.springboot3_4_12.repository.ProductRepository;
import vn.edu.hcmute.springboot3_4_12.repository.RatingRepository;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.service.IRatingService;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RatingService implements IRatingService {

    private final RatingRepository ratingRepository;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;

    @Override
    @Transactional
    public Rating addRating(String username, Long orderId, Long productId, Integer stars, String comment) {
        User user = userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Order order = null;
        if (orderId != null) {
            order = orderRepository.findById(orderId)
                    .orElseThrow(() -> new RuntimeException("Order not found"));

            // Check if order belongs to user
            if (!order.getUser().getUsername().equals(username)) {
                throw new RuntimeException("Unauthorized: Order does not belong to user");
            }

            // Check order status
            if (order.getStatus() != OrderStatus.DELIVERED) {
                throw new RuntimeException("Order must be delivered to rate products");
            }
        }

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        if (order != null) {
            // Check if product is in order
            boolean productInOrder = order.getOrderItems().stream()
                    .anyMatch(item -> item.getProduct().getId().equals(productId));
            if (!productInOrder) {
                throw new RuntimeException("Product not found in this order");
            }

            // Check if already rated
            if (ratingRepository.existsByUserAndProductAndOrder(user, product, order)) {
                throw new RuntimeException("You have already rated this product for this order");
            }
        }

        Rating rating = new Rating();
        rating.setUser(user);
        rating.setProduct(product);
        rating.setOrder(order);
        rating.setStars(stars);
        rating.setComment(comment);

        return ratingRepository.save(rating);
    }

    @Override
    public List<Rating> getRatingsByProduct(Long productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        return ratingRepository.findByProductOrderByCreatedAtDesc(product);
    }

    @Override
    public boolean hasUserRatedProductInOrder(String username, Long orderId, Long productId) {
        User user = userRepository.findUserByUsername(username).orElse(null);
        Order order = orderRepository.findById(orderId).orElse(null);
        Product product = productRepository.findById(productId).orElse(null);

        if (user == null || order == null || product == null) {
            return false;
        }

        return ratingRepository.existsByUserAndProductAndOrder(user, product, order);
    }

    @Override
    public Double getAverageRating(Long productId) {
        return ratingRepository.getAverageRating(productId);
    }
}
