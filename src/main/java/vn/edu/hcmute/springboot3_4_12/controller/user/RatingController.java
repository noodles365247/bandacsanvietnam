package vn.edu.hcmute.springboot3_4_12.controller.user;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.edu.hcmute.springboot3_4_12.service.IRatingService;
import vn.edu.hcmute.springboot3_4_12.util.SecurityUtils;

@Controller
@RequestMapping("/user/ratings")
@RequiredArgsConstructor
public class RatingController {

    private final IRatingService ratingService;

    @PostMapping("/add")
    public String addRating(
            @RequestParam("orderId") Long orderId,
            @RequestParam("productId") Long productId,
            @RequestParam("stars") Integer stars,
            @RequestParam("comment") String comment,
            RedirectAttributes redirectAttributes
    ) {
        String username = SecurityUtils.getCurrentUsername();
        if (username == null) {
            return "redirect:/login";
        }

        try {
            ratingService.addRating(username, orderId, productId, stars, comment);
            redirectAttributes.addFlashAttribute("message", "Đánh giá sản phẩm thành công!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/user/orders/" + orderId;
    }
}
