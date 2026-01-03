package vn.edu.hcmute.springboot3_4_12.controller.user;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.edu.hcmute.springboot3_4_12.dto.ProductResponseDTO;
import vn.edu.hcmute.springboot3_4_12.service.IProductService;

@Controller(value = "userProductController")
@RequiredArgsConstructor
public class ProductController {

    private final IProductService productService;
    private final vn.edu.hcmute.springboot3_4_12.service.ICategoryService categoryService;
    private final vn.edu.hcmute.springboot3_4_12.service.IVendorService vendorService;
    private final vn.edu.hcmute.springboot3_4_12.service.IRatingService ratingService;

    @GetMapping("/products")
    public String list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) Long vendorId,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            Model model
    ) {
        try {
            org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(page, size);
            org.springframework.data.domain.Page<ProductResponseDTO> productPage = productService.filterProducts(keyword, minPrice, maxPrice, vendorId, categoryId, pageable);

            model.addAttribute("productPage", productPage);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", productPage.getTotalPages());
            model.addAttribute("keyword", keyword);
            model.addAttribute("minPrice", minPrice);
            model.addAttribute("maxPrice", maxPrice);
            model.addAttribute("vendorId", vendorId);
            model.addAttribute("categoryId", categoryId);

            model.addAttribute("categories", categoryService.getAll());
            model.addAttribute("vendors", vendorService.findAll());

            return "common/product-list";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error loading products: " + e.getMessage());
            model.addAttribute("exception", e.toString());
            return "error"; 
        }
    }

    @GetMapping("/api/products/search")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.List<String> searchSuggestions(@RequestParam String keyword) {
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        return productService.filterProducts(keyword, null, null, null, null, pageable)
                .getContent().stream()
                .map(ProductResponseDTO::getNameVi)
                .collect(java.util.stream.Collectors.toList());
    }

    @GetMapping("/product/detail/{id}")
    public String productDetail(@PathVariable Long id, Model model) {
        try {
            ProductResponseDTO product = productService.findById(id);
            if (product == null) {
                return "redirect:/products";
            }
            model.addAttribute("product", product);

            try {
                model.addAttribute("similarProducts", productService.getSimilarProducts(id));
            } catch (Exception e) {
                e.printStackTrace();
                model.addAttribute("similarProducts", java.util.Collections.emptyList());
            }

            try {
                model.addAttribute("ratings", ratingService.getRatingsByProduct(id));
            } catch (Exception e) {
                e.printStackTrace();
                model.addAttribute("ratings", java.util.Collections.emptyList());
            }

            try {
                Double avg = ratingService.getAverageRating(id);
                model.addAttribute("averageRating", avg != null ? avg : 0.0);
            } catch (Exception e) {
                e.printStackTrace();
                model.addAttribute("averageRating", 0.0);
            }

            return "common/product-detail";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/products";
        }
    }
}
