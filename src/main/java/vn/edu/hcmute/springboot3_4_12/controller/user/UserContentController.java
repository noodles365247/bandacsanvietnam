package vn.edu.hcmute.springboot3_4_12.controller.user;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import vn.edu.hcmute.springboot3_4_12.service.ICategoryService;
import vn.edu.hcmute.springboot3_4_12.service.IProductService;

import java.util.List;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserContentController {

    private final ICategoryService categoryService;
    private final IProductService productService;

    @GetMapping("/categories")
    public String categories(Model model) {
        // Provide categories to the JSP view
        model.addAttribute("categories", categoryService.getAll());
        return "user/category/list";
    }

    @GetMapping("/products")
    public String products(Model model) {
        // No dedicated products list JSP exists; redirect to home which shows products
        return "redirect:/user/home";
    }
}
