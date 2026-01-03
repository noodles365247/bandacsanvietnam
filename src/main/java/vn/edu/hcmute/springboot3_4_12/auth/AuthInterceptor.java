package vn.edu.hcmute.springboot3_4_12.auth;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import vn.edu.hcmute.springboot3_4_12.entity.User;

import java.util.Objects;

//@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler
    ) throws Exception {

        HttpSession session = request.getSession(false);
        User user = (session != null)
                ? (User) session.getAttribute("user")
                : null;

        String uri = request.getRequestURI();

        // Chưa đăng nhập - redirect về login
        if (user == null) {
            response.sendRedirect("/login");
            return false;
        }

        // Kiểm tra quyền truy cập theo role
        String userRole = user.getRole();
        
        // API và admin chỉ ADMIN được dùng
        if (uri.startsWith("/api/") || uri.startsWith("/admin/")) {
            if (!"ADMIN".equals(userRole)) {
                // Không phải ADMIN -> redirect về login
                response.sendRedirect("/login");
                return false;
            }
        }
        
        // Vendor routes chỉ VENDOR được dùng
        if (uri.startsWith("/vendor/")) {
            if (!"VENDOR".equals(userRole)) {
                // Không phải VENDOR -> redirect về login
                response.sendRedirect("/login");
                return false;
            }
        }

        return true;
    }
}
