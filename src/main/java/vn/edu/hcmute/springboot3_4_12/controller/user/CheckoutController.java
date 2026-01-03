package vn.edu.hcmute.springboot3_4_12.controller.user;

import jakarta.validation.Valid;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import vn.edu.hcmute.springboot3_4_12.dto.CartResponseDTO;
import vn.edu.hcmute.springboot3_4_12.dto.OrderRequestDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Order;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.enums.PaymentMethod;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.service.ICartService;
import vn.edu.hcmute.springboot3_4_12.service.IOrderService;
import vn.edu.hcmute.springboot3_4_12.service.IVNPayService;

@Controller
@RequestMapping("/checkout")
@RequiredArgsConstructor
public class CheckoutController {

    private final ICartService cartService;
    private final IOrderService orderService;
    private final UserRepository userRepository;
    private final IVNPayService vnPayService;

    @GetMapping
    public String checkoutPage(Model model) {
        String username = getCurrentUsername();
        if (username == null) {
            return "redirect:/login";
        }

        CartResponseDTO cart = cartService.getCart(username);
        if (cart.getItems().isEmpty()) {
            return "redirect:/cart";
        }

        // Pre-fill user info if available
        User user = userRepository.findUserByUsername(username).orElse(null);
        OrderRequestDTO orderRequest = new OrderRequestDTO();
        if (user != null) {
            orderRequest.setRecipientName(user.getFullname());
            orderRequest.setRecipientPhone(user.getPhone());
            // Assuming user might have address field or we just leave it blank
        }

        model.addAttribute("cart", cart);
        model.addAttribute("orderRequest", orderRequest);
        return "common/checkout";
    }

    @PostMapping
    public String placeOrder(@Valid @ModelAttribute("orderRequest") OrderRequestDTO orderRequest,
                             BindingResult bindingResult,
                             Model model,
                             HttpServletRequest request) {
        String username = getCurrentUsername();
        if (username == null) {
            return "redirect:/login";
        }

        if (bindingResult.hasErrors()) {
            CartResponseDTO cart = cartService.getCart(username);
            model.addAttribute("cart", cart);
            return "common/checkout";
        }

        try {
            Order order = orderService.createOrder(username, orderRequest);
            
            if (order.getPaymentMethod() == PaymentMethod.VNPAY) {
                long amount = order.getTotalAmount().longValue();
                String orderInfo = "Thanh toan don hang " + order.getId();
                String paymentUrl = vnPayService.createPaymentUrl(request, amount, orderInfo);
                return "redirect:" + paymentUrl;
            }
            
            return "redirect:/checkout/success?orderId=" + order.getId();
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            CartResponseDTO cart = cartService.getCart(username);
            model.addAttribute("cart", cart);
            return "common/checkout";
        }
    }

    @GetMapping("/success")
    public String orderSuccess() {
        return "common/order-success";
    }

    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getPrincipal())) {
            return authentication.getName();
        }
        return null;
    }
}
