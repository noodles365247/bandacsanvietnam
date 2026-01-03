package vn.edu.hcmute.springboot3_4_12.controller.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.edu.hcmute.springboot3_4_12.dto.UserRequestDTO;
import vn.edu.hcmute.springboot3_4_12.service.IUserService;

@Controller
public class HomeController {

    @Autowired
    private IUserService userService;
    @Autowired
    private vn.edu.hcmute.springboot3_4_12.service.IProductService productService;

    @GetMapping(value = {"/", "/home"})
    public String home(Model model) {
        model.addAttribute("featuredProducts", productService.getFeaturedProducts());
        return "common/index";
    }

    @GetMapping("/culture")
    public String culture() {
        return "common/culture";
    }

    @GetMapping("/login")
    public String login() {
        return "common/login";
    }

    @GetMapping("/register")
    public String register() {
        return "common/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute UserRequestDTO user, 
                           @RequestParam(value = "confirmPassword", required = false) String confirmPassword, 
                           Model model) {
        if (confirmPassword == null || !user.getPassword().equals(confirmPassword)) {
            model.addAttribute("message", "Mật khẩu nhập lại không khớp!");
            return "common/register";
        }
        
        try {
            userService.register(user);
            return "redirect:/login?registerSuccess=true";
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            return "common/register";
        }
    }
}
