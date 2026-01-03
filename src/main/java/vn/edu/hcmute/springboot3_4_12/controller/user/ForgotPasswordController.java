package vn.edu.hcmute.springboot3_4_12.controller.user;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.service.IEmailService;

import java.time.LocalDateTime;
import java.util.Random;

@Controller
@RequiredArgsConstructor
public class ForgotPasswordController {

    private final UserRepository userRepository;
    private final IEmailService emailService;
    private final PasswordEncoder passwordEncoder;

    @GetMapping("/forgot-password")
    public String forgotPasswordForm() {
        return "common/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Email không tồn tại trong hệ thống!");
            return "redirect:/forgot-password";
        }

        // Generate OTP
        String otp = String.format("%06d", new Random().nextInt(999999));
        user.setOtp(otp);
        user.setOtpExpiration(LocalDateTime.now().plusMinutes(15)); // 15 mins expiry
        userRepository.save(user);

        // LOG OTP TO CONSOLE FOR DEV/TESTING
        System.out.println(">>> OTP for " + email + ": " + otp);

        // Send Email
        try {
            emailService.sendSimpleMessage(email, "Mã xác thực quên mật khẩu", "Mã OTP của bạn là: " + otp);
            redirectAttributes.addFlashAttribute("success", "Mã OTP đã được gửi đến email của bạn.");
            redirectAttributes.addFlashAttribute("email", email); // Pass email to next step
            return "redirect:/verify-otp";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi gửi email: " + e.getMessage());
            return "redirect:/forgot-password";
        }
    }

    @GetMapping("/verify-otp")
    public String verifyOtpForm(@RequestParam(value = "email", required = false) String email, Model model) {
        if (email != null) {
            model.addAttribute("email", email);
        }
        return "common/verify-otp";
    }

    @PostMapping("/verify-otp")
    public String processVerifyOtp(@RequestParam("email") String email,
                                   @RequestParam("otp") String otp,
                                   @RequestParam("newPassword") String newPassword,
                                   RedirectAttributes redirectAttributes) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Email không hợp lệ!");
            return "redirect:/verify-otp?email=" + email;
        }

        if (user.getOtp() == null || !user.getOtp().equals(otp)) {
            redirectAttributes.addFlashAttribute("error", "Mã OTP không đúng!");
            return "redirect:/verify-otp?email=" + email;
        }

        if (user.getOtpExpiration().isBefore(LocalDateTime.now())) {
            redirectAttributes.addFlashAttribute("error", "Mã OTP đã hết hạn!");
            return "redirect:/verify-otp?email=" + email;
        }

        // Reset Password
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setOtp(null);
        user.setOtpExpiration(null);
        userRepository.save(user);

        redirectAttributes.addFlashAttribute("success", "Đổi mật khẩu thành công! Vui lòng đăng nhập.");
        return "redirect:/login";
    }
}
