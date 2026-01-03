package vn.edu.hcmute.springboot3_4_12.controller.user;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmute.springboot3_4_12.dto.CartResponseDTO;
import vn.edu.hcmute.springboot3_4_12.service.ICartService;

import java.util.Map;

@Controller
@RequestMapping("/cart")
@RequiredArgsConstructor
public class CartController {

    private final ICartService cartService;

    @GetMapping
    public String viewCart(Model model) {
        String username = getCurrentUsername();
        if (username == null) {
            return "redirect:/login";
        }
        CartResponseDTO cart = cartService.getCart(username);
        model.addAttribute("cart", cart);
        return "common/cart";
    }

    @PostMapping("/add")
    public String addToCart(@RequestParam Long productId, @RequestParam Integer quantity) {
        String username = getCurrentUsername();
        if (username == null) {
            return "redirect:/login";
        }
        cartService.addToCart(username, productId, quantity);
        return "redirect:/cart";
    }

    @PostMapping("/api/add")
    @ResponseBody
    public ResponseEntity<?> addToCartApi(@RequestParam Long productId, @RequestParam Integer quantity) {
        String username = getCurrentUsername();
        if (username == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
        }
        try {
            cartService.addToCart(username, productId, quantity);
            CartResponseDTO cart = cartService.getCart(username);
            return ResponseEntity.ok(Map.of("message", "Added to cart successfully", "cartSize", cart.getItems().size()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/update")
    public String updateCart(@RequestParam Long cartItemId, @RequestParam Integer quantity) {
        String username = getCurrentUsername();
        if (username != null) {
            cartService.updateCartItem(username, cartItemId, quantity);
        }
        return "redirect:/cart";
    }

    @GetMapping("/remove/{id}")
    public String removeCartItem(@PathVariable Long id) {
        String username = getCurrentUsername();
        if (username != null) {
            cartService.removeCartItem(username, id);
        }
        return "redirect:/cart";
    }

    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getPrincipal())) {
            return authentication.getName();
        }
        return null;
    }
}
