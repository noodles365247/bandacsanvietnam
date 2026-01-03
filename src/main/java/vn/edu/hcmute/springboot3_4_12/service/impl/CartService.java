package vn.edu.hcmute.springboot3_4_12.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.edu.hcmute.springboot3_4_12.dto.CartItemResponseDTO;
import vn.edu.hcmute.springboot3_4_12.dto.CartResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Cart;
import vn.edu.hcmute.springboot3_4_12.entity.CartItem;
import vn.edu.hcmute.springboot3_4_12.entity.Product;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.repository.CartItemRepository;
import vn.edu.hcmute.springboot3_4_12.repository.CartRepository;
import vn.edu.hcmute.springboot3_4_12.repository.ProductRepository;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.service.ICartService;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class CartService implements ICartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    @Override
    public CartResponseDTO getCart(String username) {
        User user = getUserByUsername(username);
        Cart cart = getOrCreateCart(user);
        return mapToCartDTO(cart);
    }

    @Override
    public void addToCart(String username, Long productId, Integer quantity) {
        User user = getUserByUsername(username);
        Cart cart = getOrCreateCart(user);
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Optional<CartItem> existingItem = cart.getItems().stream()
                .filter(item -> item.getProduct().getId().equals(productId))
                .findFirst();

        if (existingItem.isPresent()) {
            CartItem item = existingItem.get();
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setProduct(product);
            newItem.setQuantity(quantity);
            cart.getItems().add(newItem);
        }

        updateCartTotal(cart);
        cartRepository.save(cart);
    }

    @Override
    public void updateCartItem(String username, Long cartItemId, Integer quantity) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));
        
        // Security check: ensure cart belongs to user
        if (!cartItem.getCart().getUser().getUsername().equals(username)) {
            throw new RuntimeException("Unauthorized access to cart item");
        }

        if (quantity <= 0) {
            removeCartItem(username, cartItemId);
            return;
        }

        cartItem.setQuantity(quantity);
        updateCartTotal(cartItem.getCart());
        cartRepository.save(cartItem.getCart());
    }

    @Override
    public void removeCartItem(String username, Long cartItemId) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));

        if (!cartItem.getCart().getUser().getUsername().equals(username)) {
            throw new RuntimeException("Unauthorized access to cart item");
        }

        Cart cart = cartItem.getCart();
        cart.getItems().remove(cartItem);
        cartItemRepository.delete(cartItem);
        
        updateCartTotal(cart);
        cartRepository.save(cart);
    }

    @Override
    public void clearCart(String username) {
        User user = getUserByUsername(username);
        Cart cart = getOrCreateCart(user);
        cart.getItems().clear();
        cart.setTotalPrice(0.0);
        cartRepository.save(cart);
    }

    @Override
    public Integer getCartCount(String username) {
        User user = getUserByUsername(username);
        Cart cart = getOrCreateCart(user);
        return cart.getItems().stream().mapToInt(CartItem::getQuantity).sum();
    }

    private User getUserByUsername(String username) {
        return userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    private Cart getOrCreateCart(User user) {
        return cartRepository.findByUser(user)
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    newCart.setTotalPrice(0.0);
                    return cartRepository.save(newCart);
                });
    }

    private void updateCartTotal(Cart cart) {
        double total = cart.getItems().stream()
                .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                .sum();
        cart.setTotalPrice(total);
    }

    private CartResponseDTO mapToCartDTO(Cart cart) {
        CartResponseDTO dto = new CartResponseDTO();
        dto.setId(cart.getId());
        dto.setTotalPrice(cart.getTotalPrice());
        
        List<CartItemResponseDTO> itemDTOs = cart.getItems().stream()
                .map(this::mapToCartItemDTO)
                .collect(Collectors.toList());
        
        dto.setItems(itemDTOs);
        return dto;
    }

    private CartItemResponseDTO mapToCartItemDTO(CartItem item) {
        CartItemResponseDTO dto = new CartItemResponseDTO();
        dto.setId(item.getId());
        dto.setProductId(item.getProduct().getId());
        dto.setProductName(item.getProduct().getNameVi()); // Prefer Vietnamese name
        dto.setPrice(item.getProduct().getPrice());
        dto.setQuantity(item.getQuantity());
        
        // Handle image: take first image if available, else placeholder
        if (item.getProduct().getImages() != null && !item.getProduct().getImages().isEmpty()) {
            dto.setProductImage(item.getProduct().getImages().get(0).getUrl());
        } else {
            dto.setProductImage("https://placehold.co/100x100?text=No+Image");
        }
        
        return dto;
    }
}
