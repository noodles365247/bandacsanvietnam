package vn.edu.hcmute.springboot3_4_12.service;

import vn.edu.hcmute.springboot3_4_12.entity.Rating;

import java.util.List;

public interface IRatingService {
    Rating addRating(String username, Long orderId, Long productId, Integer stars, String comment);
    List<Rating> getRatingsByProduct(Long productId);
    boolean hasUserRatedProductInOrder(String username, Long orderId, Long productId);
    Double getAverageRating(Long productId);
}
