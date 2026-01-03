package vn.edu.hcmute.springboot3_4_12.controller.user;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import vn.edu.hcmute.springboot3_4_12.entity.OrderStatus;
import vn.edu.hcmute.springboot3_4_12.service.IOrderService;
import vn.edu.hcmute.springboot3_4_12.service.IVNPayService;

@Controller
@RequestMapping("/payment")
@RequiredArgsConstructor
public class PaymentController {

    private final IVNPayService vnPayService;
    private final IOrderService orderService;

    @GetMapping("/vnpay-return")
    public String vnpayReturn(HttpServletRequest request, Model model) {
        int paymentStatus = vnPayService.orderReturn(request);

        String orderInfo = request.getParameter("vnp_OrderInfo");
        String paymentTime = request.getParameter("vnp_PayDate");
        String transactionId = request.getParameter("vnp_TransactionNo");
        String totalPrice = request.getParameter("vnp_Amount");

        model.addAttribute("orderId", orderInfo);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("paymentTime", paymentTime);
        model.addAttribute("transactionId", transactionId);

        // Extract Order ID from orderInfo (Format: "Thanh toan don hang {orderId}")
        Long orderId = null;
        try {
             if(orderInfo != null && orderInfo.contains("Thanh toan don hang ")) {
                 String idStr = orderInfo.replace("Thanh toan don hang ", "").trim();
                 // If there's a random string attached, handle it? 
                 // In VNPayServiceImpl: "Thanh toan don hang " + vnp_TxnRef
                 // Wait, vnp_TxnRef is random. 
                 // I need to pass the ACTUAL Order ID in orderInfo or somewhere else.
                 // Checking VNPayServiceImpl again...
             }
        } catch (NumberFormatException e) {
            // log error
        }

        // Wait, VNPayServiceImpl uses vnp_TxnRef as random string.
        // I need to persist the relationship between vnp_TxnRef and Order ID, OR pass Order ID in vnp_OrderInfo.
        // Currently VNPayServiceImpl: vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang " + vnp_TxnRef); if orderInfo is null.
        // In CheckoutController, I will pass "Thanh toan don hang " + orderId.
        
        if (paymentStatus == 1) {
            // Success
            // Parse Order ID
            try {
                if (orderInfo != null && orderInfo.startsWith("Thanh toan don hang ")) {
                    String idPart = orderInfo.substring("Thanh toan don hang ".length());
                    orderId = Long.parseLong(idPart);
                    orderService.updateStatus(orderId, OrderStatus.PROCESSING);
                    return "redirect:/checkout/success?orderId=" + orderId;
                }
            } catch (Exception e) {
                model.addAttribute("message", "Lỗi xử lý đơn hàng: " + e.getMessage());
                return "common/payment-fail";
            }
        } 
        
        // Fail
        return "common/payment-fail";
    }
}
