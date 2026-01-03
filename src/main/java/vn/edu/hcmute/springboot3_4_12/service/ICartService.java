package vn.edu.hcmute.springboot3_4_12.service;

import vn.edu.hcmute.springboot3_4_12.dto.CartResponseDTO;

public interface ICartService {
    CartResponseDTO getCart(String username);
    void addToCart(String username, Long productId, Integer quantity);
    void updateCartItem(String username, Long cartItemId, Integer quantity);
    void removeCartItem(String username, Long cartItemId);
    void clearCart(String username);
    Integer getCartCount(String username);
}
