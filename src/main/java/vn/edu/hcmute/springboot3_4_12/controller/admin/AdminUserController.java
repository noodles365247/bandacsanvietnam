package vn.edu.hcmute.springboot3_4_12.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.edu.hcmute.springboot3_4_12.dto.UserRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.UserResponseDTO;
import vn.edu.hcmute.springboot3_4_12.service.IUserService;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/users")
@RequiredArgsConstructor
public class AdminUserController {

    private final IUserService userService;

    @GetMapping
    public String list(@RequestParam(value = "q", required = false) String query, Model model) {
        List<UserResponseDTO> users = userService.getAllUsers();
        
        if (query != null && !query.trim().isEmpty()) {
            String q = query.toLowerCase();
            users = users.stream()
                    .filter(u -> u.username().toLowerCase().contains(q) || 
                               (u.email() != null && u.email().toLowerCase().contains(q)) ||
                               (u.fullname() != null && u.fullname().toLowerCase().contains(q)))
                    .collect(Collectors.toList());
            model.addAttribute("q", query);
        }
        
        model.addAttribute("users", users);
        return "admin/users/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("user", new UserRequestDTO());
        return "admin/users/create";
    }

    @PostMapping("/create")
    public String create(@ModelAttribute UserRequestDTO dto, RedirectAttributes redirectAttributes) {
        try {
            // Set default role if not provided or handle in service
            userService.register(dto);
            redirectAttributes.addFlashAttribute("success", "Tạo người dùng thành công!");
            return "redirect:/admin/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:/admin/users/create";
        }
    }

    @GetMapping("/edit/{username}")
    public String editForm(@PathVariable String username, Model model) {
        try {
            UserResponseDTO user = userService.findByUsername(username);
            
            // Map ResponseDTO to RequestDTO for form binding
            UserRequestDTO req = new UserRequestDTO();
            req.setUsername(user.getUsername());
            req.setEmail(user.getEmail());
            req.setFullname(user.getFullname());
            req.setPhone(user.getPhone());
            req.setAddress(user.getAddress());
            req.setRole(user.getRole());
            req.setActive(user.isActive());
            req.setImages(user.getImages());
            req.setAdmin(user.isAdmin());
            
            model.addAttribute("user", req);
            return "admin/users/edit";
        } catch (Exception e) {
            return "redirect:/admin/users?error=" + e.getMessage();
        }
    }

    @PostMapping("/save")
    public String save(@ModelAttribute UserRequestDTO dto, RedirectAttributes redirectAttributes) {
        try {
            // Need to find ID by username first because update service requires ID
            UserResponseDTO existing = userService.findByUsername(dto.getUsername());
            userService.update(existing.getId(), dto);
            
            redirectAttributes.addFlashAttribute("success", "Cập nhật người dùng thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:/admin/users/edit/" + dto.getUsername();
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("username") String username, RedirectAttributes redirectAttributes) {
        try {
            UserResponseDTO user = userService.findByUsername(username);
            userService.deleteUser(user.getId());
            redirectAttributes.addFlashAttribute("success", "Xóa người dùng thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }
}
