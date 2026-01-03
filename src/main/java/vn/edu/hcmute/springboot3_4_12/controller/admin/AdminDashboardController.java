package vn.edu.hcmute.springboot3_4_12.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import vn.edu.hcmute.springboot3_4_12.service.IUserService;
import vn.edu.hcmute.springboot3_4_12.service.IOrderService;
import vn.edu.hcmute.springboot3_4_12.service.IProductService;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminDashboardController {

    private final IUserService userService;
    private final IProductService productService;
    private final IOrderService orderService;
    
    @GetMapping({"", "/", "/home"})
    public String index() {
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("totalUsers", userService.count());
        model.addAttribute("totalProducts", productService.count());
        
        try {
            model.addAttribute("totalOrders", orderService.count());
            model.addAttribute("totalRevenue", orderService.calculateTotalRevenue());
            
            // Chart data
            java.util.Map<java.time.LocalDate, Double> revenueMap = orderService.getDailyRevenueForAdmin(7);
            java.util.List<String> labels = new java.util.ArrayList<>();
            java.util.List<Double> data = new java.util.ArrayList<>();
            
            if (revenueMap != null) {
                // Sort by date
                java.util.TreeMap<java.time.LocalDate, Double> sortedRevenue = new java.util.TreeMap<>(revenueMap);
                
                for (java.util.Map.Entry<java.time.LocalDate, Double> entry : sortedRevenue.entrySet()) {
                    labels.add(entry.getKey().toString());
                    data.add(entry.getValue());
                }
            }
            
            model.addAttribute("revenueLabels", labels);
            model.addAttribute("revenueData", data);
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("totalOrders", 0);
            model.addAttribute("totalRevenue", 0);
        }

        return "admin/dashboard";
    }
}
