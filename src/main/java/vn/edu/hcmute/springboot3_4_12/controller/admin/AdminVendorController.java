package vn.edu.hcmute.springboot3_4_12.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import vn.edu.hcmute.springboot3_4_12.service.IVendorService;

@Controller
@RequestMapping("/admin/vendors")
@RequiredArgsConstructor
public class AdminVendorController {

    private final IVendorService vendorService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("vendors", vendorService.findAll());
        return "admin/vendors/list";
    }
}
