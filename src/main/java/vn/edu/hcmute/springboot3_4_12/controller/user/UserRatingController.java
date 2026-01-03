package vn.edu.hcmute.springboot3_4_12.controller.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import vn.edu.hcmute.springboot3_4_12.service.IRatingService;
import vn.edu.hcmute.springboot3_4_12.util.SecurityUtils;

@Controller
@RequestMapping("/rating")
public class UserRatingController {

    @Autowired
    private IRatingService ratingService;

    @PostMapping("/add")
    public String addRating(
            @RequestParam("productId") Long productId,
            @RequestParam("stars") Integer stars,
            @RequestParam("comment") String comment,
            RedirectAttributes redirectAttributes) {

        String username = SecurityUtils.getCurrentUsername();
        if (username == null || username.equals("anonymousUser")) {
            return "redirect:/login";
        }

        try {
            // Allow orderId to be null for now as per urgent request
            ratingService.addRating(username, null, productId, stars, comment);
            redirectAttributes.addFlashAttribute("message", "Đánh giá của bạn đã được ghi nhận!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi gửi đánh giá: " + e.getMessage());
            e.printStackTrace();
        }

        return "redirect:/product/detail/" + productId;
    }
}
