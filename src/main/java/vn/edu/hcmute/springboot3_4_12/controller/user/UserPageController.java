package vn.edu.hcmute.springboot3_4_12.controller.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryResponseDTO;
import vn.edu.hcmute.springboot3_4_12.dto.ProductResponseDTO;
import vn.edu.hcmute.springboot3_4_12.service.ICategoryService;
import vn.edu.hcmute.springboot3_4_12.service.IProductService;

import java.util.Collections;
import java.util.List;

@Controller
public class UserPageController {

    @Autowired
    private IProductService productService;

    @Autowired
    private ICategoryService categoryService;

    @GetMapping({"/user", "/user/home"})
    public String home(Model model) {

        try {
            // Lấy 8 sản phẩm mới nhất
            Pageable pageable = PageRequest.of(0, 8, Sort.by("id").descending());
            Page<ProductResponseDTO> products = productService.getAll(pageable);

            if (products != null && !products.getContent().isEmpty()) {
                model.addAttribute("latestProducts", products.getContent());
            } else {
                model.addAttribute("latestProducts", Collections.emptyList());
            }

            // Lấy danh mục
            List<CategoryResponseDTO> categories = categoryService.getAll();
            if (categories != null && !categories.isEmpty()) {
                model.addAttribute("categories", categories);
            } else {
                model.addAttribute("categories", Collections.emptyList());
            }

        } catch (Exception e) {
            System.err.println("=== EXCEPTION trong UserPageController.home() ===");
            e.printStackTrace();

            model.addAttribute("latestProducts", Collections.emptyList());
            model.addAttribute("categories", Collections.emptyList());
        }

        return "user/home";
    }
}
