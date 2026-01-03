package vn.edu.hcmute.springboot3_4_12.controller.user;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import vn.edu.hcmute.springboot3_4_12.entity.Order;
import vn.edu.hcmute.springboot3_4_12.service.IOrderService;
import vn.edu.hcmute.springboot3_4_12.service.IRatingService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user/orders")
@RequiredArgsConstructor
public class UserOrderController {

    private final IOrderService orderService;
    private final IRatingService ratingService;

    @GetMapping
    public String listOrders(Model model) {
        String username = getCurrentUsername();
        List<Order> orders = orderService.getOrdersByUser(username);
        model.addAttribute("orders", orders);
        return "customer/order-history";
    }

    @GetMapping("/{id}")
    public String orderDetail(@PathVariable Long id, Model model) {
        String username = getCurrentUsername();
        try {
            Order order = orderService.getOrderById(id, username);
            model.addAttribute("order", order);

            // Check rated status for each product in order
            Map<Long, Boolean> ratedProducts = new HashMap<>();
            for (var item : order.getOrderItems()) {
                boolean hasRated = ratingService.hasUserRatedProductInOrder(username, order.getId(), item.getProduct().getId());
                ratedProducts.put(item.getProduct().getId(), hasRated);
            }
            model.addAttribute("ratedProducts", ratedProducts);

            return "customer/order-detail";
        } catch (RuntimeException e) {
            return "redirect:/user/orders?error=" + e.getMessage();
        }
    }

    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getPrincipal())) {
            return authentication.getName();
        }
        throw new RuntimeException("User not authenticated");
    }
}
