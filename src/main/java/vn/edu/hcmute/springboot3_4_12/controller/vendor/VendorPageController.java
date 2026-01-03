package vn.edu.hcmute.springboot3_4_12.controller.vendor;

import org.springframework.security.access.prepost.PreAuthorize;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import vn.edu.hcmute.springboot3_4_12.entity.Order;
import vn.edu.hcmute.springboot3_4_12.service.IOrderService;
import vn.edu.hcmute.springboot3_4_12.util.SecurityUtils;

import java.util.List;
import org.springframework.stereotype.Controller;
import vn.edu.hcmute.springboot3_4_12.entity.OrderItem;
import vn.edu.hcmute.springboot3_4_12.entity.Product;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;
import vn.edu.hcmute.springboot3_4_12.dto.ProductRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.VendorRequestDTO;
import vn.edu.hcmute.springboot3_4_12.service.ICategoryService;
import vn.edu.hcmute.springboot3_4_12.service.IProductService;
import vn.edu.hcmute.springboot3_4_12.service.IVendorService;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.repository.VendorRepository;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.validation.BindingResult;
import jakarta.validation.Valid;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

@Controller
@RequestMapping("/vendor")
@PreAuthorize("hasRole('VENDOR')")
@RequiredArgsConstructor
public class VendorPageController {

    private final IOrderService orderService;
    private final IProductService productService;
    private final ICategoryService categoryService;
    private final IVendorService vendorService;
    private final UserRepository userRepository;
    private final VendorRepository vendorRepository;

    @GetMapping("/api/revenue-chart")
    @ResponseBody
    public Map<String, Object> getRevenueChartData() {
        String username = SecurityUtils.getCurrentUsername();
        Map<java.time.LocalDate, Double> dailyRevenue = orderService.getDailyRevenue(username, 7);
        
        List<String> labels = new ArrayList<>();
        List<Double> data = new ArrayList<>();
        
        for (Map.Entry<java.time.LocalDate, Double> entry : dailyRevenue.entrySet()) {
            labels.add(entry.getKey().toString());
            data.add(entry.getValue());
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("labels", labels);
        response.put("data", data);
        return response;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        String username = SecurityUtils.getCurrentUsername();
        
        long totalOrders = orderService.countOrdersByVendor(username);
        double totalRevenue = orderService.calculateRevenueByVendor(username);
        long outOfStock = productService.countOutOfStockProducts(username);
        List<Order> recentOrders = orderService.getRecentOrdersByVendor(username, 5);

        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("outOfStock", outOfStock);
        model.addAttribute("recentOrders", recentOrders);
        
        return "vendor/vendor-dashboard";
    }

    // --- Product Management ---

    @GetMapping("/products")
    public String products(Model model) {
        String username = SecurityUtils.getCurrentUsername();
        List<Product> products = productService.getProductsByVendor(username);
        model.addAttribute("products", products);
        return "vendor/product-management";
    }

    @GetMapping("/products/add")
    public String addProduct(Model model) {
        model.addAttribute("product", new ProductRequestDTO());
        model.addAttribute("categories", categoryService.getAll());
        return "vendor/product-form";
    }

    @PostMapping("/products/save")
    public String saveProduct(@Valid @ModelAttribute("product") ProductRequestDTO productDTO,
                              BindingResult result,
                              @RequestParam("images") List<MultipartFile> files,
                              Model model) {
        if (result.hasErrors()) {
            model.addAttribute("categories", categoryService.getAll());
            return "vendor/product-form";
        }

        String username = SecurityUtils.getCurrentUsername();
        User user = userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));

        productDTO.setVendorId(vendor.getId());
        productService.create(productDTO, files);

        return "redirect:/vendor/products";
    }

    @GetMapping("/products/edit/{id}")
    public String editProduct(@PathVariable Long id, Model model) {
        String username = SecurityUtils.getCurrentUsername();
        Product product = productService.getProductByIdForVendor(id, username);
        
        // Map Entity to DTO for form
        ProductRequestDTO dto = new ProductRequestDTO();
        dto.setNameVi(product.getNameVi());
        dto.setNameEn(product.getNameEn());
        dto.setDescriptionVi(product.getDescriptionVi());
        dto.setDescriptionEn(product.getDescriptionEn());
        dto.setPrice(product.getPrice());
        dto.setStock(product.getStock());
        dto.setCategoryIds(product.getCategories().stream().map(c -> c.getId()).toList());
        // Note: Images are handled separately or just shown

        model.addAttribute("product", dto);
        model.addAttribute("productId", id); // For update URL
        model.addAttribute("categories", categoryService.getAll());
        model.addAttribute("currentImages", product.getImages());
        return "vendor/product-form";
    }

    @PostMapping("/products/update/{id}")
    public String updateProduct(@PathVariable Long id,
                                @Valid @ModelAttribute("product") ProductRequestDTO productDTO,
                                BindingResult result,
                                Model model) {
        if (result.hasErrors()) {
            model.addAttribute("categories", categoryService.getAll());
            model.addAttribute("productId", id);
            return "vendor/product-form";
        }

        String username = SecurityUtils.getCurrentUsername();
        User user = userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findVendorByUser_Id(user.getId())
                .orElseThrow(() -> new RuntimeException("Vendor not found"));

        productDTO.setVendorId(vendor.getId());
        productService.update(id, productDTO);

        return "redirect:/vendor/products";
    }

    @GetMapping("/products/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        String username = SecurityUtils.getCurrentUsername();
        productService.deleteProduct(id, username);
        return "redirect:/vendor/products";
    }

    // --- Order Management ---

    @GetMapping("/orders")
    public String orders(Model model) {
        String username = SecurityUtils.getCurrentUsername();
        List<Order> orders = orderService.getOrdersByVendor(username);
        model.addAttribute("orders", orders);
        return "vendor/order-management";
    }

    @GetMapping("/orders/{id}")
    public String orderDetail(@PathVariable Long id, Model model) {
        String username = SecurityUtils.getCurrentUsername();
        try {
            Order order = orderService.getOrderByIdForVendor(id, username);
            List<OrderItem> vendorItems = orderService.getOrderItemsByVendor(id, username);

            // Calculate total for vendor
            double vendorTotal = vendorItems.stream()
                    .mapToDouble(item -> item.getPrice() * item.getQuantity())
                    .sum();

            model.addAttribute("order", order);
            model.addAttribute("vendorItems", vendorItems);
            model.addAttribute("vendorTotal", vendorTotal);

            return "vendor/order-detail";
        } catch (Exception e) {
            return "redirect:/vendor/orders?error=" + e.getMessage();
        }
    }

    @GetMapping("/shop")
    public String shop(Model model) {
        String username = SecurityUtils.getCurrentUsername();
        Vendor vendor = vendorService.getVendorByUsername(username);
        
        VendorRequestDTO dto = new VendorRequestDTO();
        dto.setShopName(vendor.getShopName());
        dto.setDescriptionVi(vendor.getDescriptionVi());
        dto.setDescriptionEn(vendor.getDescriptionEn());
        dto.setAddress(vendor.getAddress());
        dto.setPhone(vendor.getPhone());
        
        model.addAttribute("vendor", dto);
        model.addAttribute("currentLogo", vendor.getLogo());
        
        return "vendor/shop-management";
    }

    @PostMapping("/shop/update")
    public String updateShop(@Valid @ModelAttribute("vendor") VendorRequestDTO vendorDTO,
                             BindingResult result,
                             @RequestParam(value = "logoFile", required = false) MultipartFile logoFile,
                             Model model) {
        if (result.hasErrors()) {
            return "vendor/shop-management";
        }
        
        String username = SecurityUtils.getCurrentUsername();
        try {
            vendorService.updateVendor(username, vendorDTO, logoFile);
            return "redirect:/vendor/shop?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "vendor/shop-management";
        }
    }


}
