package vn.edu.hcmute.springboot3_4_12.controller.user;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.edu.hcmute.springboot3_4_12.dto.UserRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.UserResponseDTO;
import vn.edu.hcmute.springboot3_4_12.service.IUserService;
import vn.edu.hcmute.springboot3_4_12.util.SecurityUtils;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserAccountController {

    private final IUserService userService;

    @GetMapping("/profile")
    public String profile(Model model) {
        String username = SecurityUtils.getCurrentUsername();
        if (username == null) {
            return "redirect:/login";
        }
        UserResponseDTO user = userService.findByUsername(username);
        model.addAttribute("user", user);
        return "customer/profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute UserRequestDTO dto, RedirectAttributes redirectAttributes) {
        String username = SecurityUtils.getCurrentUsername();
        if (username == null) {
            return "redirect:/login";
        }
        try {
            UserResponseDTO currentUser = userService.findByUsername(username);
            userService.update(currentUser.id(), dto);
            redirectAttributes.addFlashAttribute("message", "Cập nhật thông tin thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/user/profile";
    }
}
