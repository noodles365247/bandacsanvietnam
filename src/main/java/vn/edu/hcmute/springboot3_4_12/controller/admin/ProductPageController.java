package vn.edu.hcmute.springboot3_4_12.controller.admin;
import vn.edu.hcmute.springboot3_4_12.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/products") // Đường dẫn để truy cập trên trình duyệt
public class ProductPageController {

    @Autowired
    private IProductService productService;

    // Trang danh sách sản phẩm
    @GetMapping
    public String listPage(Model model) {
        model.addAttribute("products", productService.getAll());
        return "admin/product/list";
    }

    // Trang thêm mới sản phẩm
    @GetMapping("/create")
    public String createPage() {
        return "admin/product/form"; // Trả về file form.html
    }
}