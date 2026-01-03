package vn.edu.hcmute.springboot3_4_12.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.CategoryResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Category;
import vn.edu.hcmute.springboot3_4_12.service.ICategoryService;
import vn.edu.hcmute.springboot3_4_12.service.IStorageService;

import java.io.IOException;
import java.util.UUID;

@Controller
@RequestMapping("/admin/categories")
@RequiredArgsConstructor
public class AdminCategoryController {

    private final ICategoryService categoryService;
    private final IStorageService storageService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("categories", categoryService.getAll());
        return "admin/category/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("category", new CategoryRequestDTO());
        return "admin/category/create";
    }

    @PostMapping("/save")
    public String save(@Valid @ModelAttribute("category") CategoryRequestDTO dto,
                       BindingResult result,
                       @RequestParam("imageFile") MultipartFile imageFile,
                       Model model) {
        if (result.hasErrors()) {
            return "admin/category/create";
        }

        try {
            if (!imageFile.isEmpty()) {
                String filename = UUID.randomUUID().toString() + "_" + imageFile.getOriginalFilename();
                storageService.store(imageFile, filename);
                dto.setImage(filename);
            }
            categoryService.create(dto);
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi lưu danh mục: " + e.getMessage());
            return "admin/category/create";
        }

        return "redirect:/admin/categories";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        Category category = categoryService.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));
        
        CategoryRequestDTO dto = new CategoryRequestDTO();
        dto.setNameVi(category.getNameVi());
        dto.setNameEn(category.getNameEn());
        dto.setImage(category.getImage());
        dto.setStatus(category.getStatus());

        model.addAttribute("category", dto);
        model.addAttribute("categoryId", id);
        model.addAttribute("currentImage", category.getImage());
        
        return "admin/category/edit";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable Long id,
                         @Valid @ModelAttribute("category") CategoryRequestDTO dto,
                         BindingResult result,
                         @RequestParam("imageFile") MultipartFile imageFile,
                         Model model) {
        if (result.hasErrors()) {
            model.addAttribute("categoryId", id);
            // Need to re-fetch current image for display if validation fails
             Category existing = categoryService.findById(id).orElse(new Category());
             model.addAttribute("currentImage", existing.getImage());
            return "admin/category/edit";
        }

        try {
            Category existing = categoryService.findById(id)
                    .orElseThrow(() -> new RuntimeException("Category not found"));

            if (!imageFile.isEmpty()) {
                // Upload new image
                String filename = UUID.randomUUID().toString() + "_" + imageFile.getOriginalFilename();
                storageService.store(imageFile, filename);
                dto.setImage(filename);
            } else {
                // Keep old image
                dto.setImage(existing.getImage());
            }

            categoryService.update(id, dto);
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi cập nhật danh mục: " + e.getMessage());
            model.addAttribute("categoryId", id);
            return "admin/category/edit";
        }

        return "redirect:/admin/categories";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("id") Long id) {
        categoryService.delete(id);
        return "redirect:/admin/categories";
    }
}
