package vn.edu.hcmute.springboot3_4_12.controller.vendor;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.edu.hcmute.springboot3_4_12.entity.Post;
import vn.edu.hcmute.springboot3_4_12.service.IPostService;
import vn.edu.hcmute.springboot3_4_12.service.IStorageService;
import vn.edu.hcmute.springboot3_4_12.util.SecurityUtils;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/vendor/blogs")
@PreAuthorize("hasRole('VENDOR')")
@RequiredArgsConstructor
public class VendorBlogController {

    private final IPostService postService;
    private final IStorageService storageService;

    @GetMapping
    public String list(Model model) {
        String username = SecurityUtils.getCurrentUsername();
        // Filter posts by author = username
        // Note: Ideally service should have findByAuthor, but for now filtering in memory or adding method
        List<Post> vendorPosts = postService.findAll().stream()
                .filter(p -> username.equals(p.getAuthor()))
                .collect(Collectors.toList());
        model.addAttribute("posts", vendorPosts);
        return "vendor/blog/list";
    }

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("post", new Post());
        return "vendor/blog/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Post post, @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) {
        String username = SecurityUtils.getCurrentUsername();
        
        if (imageFile != null && !imageFile.isEmpty()) {
            String filename = storageService.getSorageFilename(imageFile, UUID.randomUUID().toString());
            storageService.store(imageFile, filename);
            post.setImage(filename);
        } else if (post.getId() != null) {
            Post oldPost = postService.findById(post.getId()).orElse(null);
            if (oldPost != null) {
                // Security check: ensure vendor owns this post
                if (!username.equals(oldPost.getAuthor())) {
                    throw new RuntimeException("Unauthorized access to this post");
                }
                post.setImage(oldPost.getImage());
                if (post.getCreatedAt() == null) {
                    post.setCreatedAt(oldPost.getCreatedAt());
                }
            }
        }
        
        // Always set author to current vendor
        post.setAuthor(username);
        
        postService.save(post);
        return "redirect:/vendor/blogs";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        String username = SecurityUtils.getCurrentUsername();
        Post post = postService.findById(id).orElseThrow(() -> new RuntimeException("Post not found"));
        
        if (!username.equals(post.getAuthor())) {
            return "redirect:/vendor/blogs?error=unauthorized";
        }
        
        model.addAttribute("post", post);
        return "vendor/blog/form";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("id") Long id) {
        String username = SecurityUtils.getCurrentUsername();
        Post post = postService.findById(id).orElse(null);
        
        if (post != null && username.equals(post.getAuthor())) {
            postService.delete(id);
        }
        
        return "redirect:/vendor/blogs";
    }
}
