package vn.edu.hcmute.springboot3_4_12.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.edu.hcmute.springboot3_4_12.entity.Video;
import vn.edu.hcmute.springboot3_4_12.service.IVideoService;
import vn.edu.hcmute.springboot3_4_12.service.IStorageService;
import org.springframework.web.multipart.MultipartFile;
import java.util.UUID;

@Controller
@RequestMapping("/admin/videos")
@RequiredArgsConstructor
public class AdminVideoController {

    private final IVideoService videoService;
    private final IStorageService storageService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("videos", videoService.findAll());
        return "admin/videos/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("video", new Video());
        return "admin/videos/create";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Video video, 
                       @RequestParam(value = "posterFile", required = false) MultipartFile posterFile,
                       RedirectAttributes redirectAttributes) {
        try {
            if (posterFile != null && !posterFile.isEmpty()) {
                String filename = storageService.getSorageFilename(posterFile, UUID.randomUUID().toString());
                storageService.store(posterFile, filename);
                video.setPoster(filename);
            } else if (video.getId() != null) {
                // Keep old poster if exists
                Video oldVideo = videoService.findById(video.getId()).orElse(null);
                if (oldVideo != null) {
                    video.setPoster(oldVideo.getPoster());
                }
            }
            
            videoService.save(video);
            redirectAttributes.addFlashAttribute("success", "Lưu video thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:/admin/videos/create";
        }
        return "redirect:/admin/videos";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        Video video = videoService.findById(id)
                .orElseThrow(() -> new RuntimeException("Video not found"));
        model.addAttribute("video", video);
        return "admin/videos/edit";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            videoService.delete(id);
            redirectAttributes.addFlashAttribute("success", "Xóa video thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/videos";
    }
}
