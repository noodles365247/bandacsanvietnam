package vn.edu.hcmute.springboot3_4_12.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmute.springboot3_4_12.entity.Post;
import vn.edu.hcmute.springboot3_4_12.service.IPostService;

import java.util.List;

import vn.edu.hcmute.springboot3_4_12.service.IStorageService;
import org.springframework.web.multipart.MultipartFile;
import java.util.UUID;

@Controller
@RequestMapping("/admin/posts")
@RequiredArgsConstructor
public class PostController {

    private final IPostService postService;
    private final IStorageService storageService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("posts", postService.findAll());
        return "admin/post/list";
    }

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("post", new Post());
        return "admin/post/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Post post, @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) {
        if (imageFile != null && !imageFile.isEmpty()) {
            String filename = storageService.getSorageFilename(imageFile, UUID.randomUUID().toString());
            storageService.store(imageFile, filename);
            post.setImage(filename);
        } else if (post.getId() != null) {
            // Keep old image if not updating
            Post oldPost = postService.findById(post.getId()).orElse(null);
            if (oldPost != null) {
                post.setImage(oldPost.getImage());
                if (post.getCreatedAt() == null) {
                    post.setCreatedAt(oldPost.getCreatedAt());
                }
                if (post.getAuthor() == null) {
                    post.setAuthor(oldPost.getAuthor());
                }
            }
        }
        
        if (post.getAuthor() == null) {
            post.setAuthor("ADMIN");
        }
        
        postService.save(post);
        return "redirect:/admin/posts";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        Post post = postService.findById(id).orElseThrow(() -> new RuntimeException("Post not found"));
        model.addAttribute("post", post);
        return "admin/post/form";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("id") Long id) {
        postService.delete(id);
        return "redirect:/admin/posts";
    }
}
