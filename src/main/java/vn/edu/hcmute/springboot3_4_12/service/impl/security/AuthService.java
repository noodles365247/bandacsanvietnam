package vn.edu.hcmute.springboot3_4_12.service.impl.security;

import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import vn.edu.hcmute.springboot3_4_12.dto.LoginRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.UserResponseDTO;
import vn.edu.hcmute.springboot3_4_12.service.IUserService;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final IUserService userService; // Chứa hàm lấy thông tin User

    public UserResponseDTO login(LoginRequestDTO dto) {
        // Spring Security sẽ tự kiểm tra Username/Password tại đây
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(dto.getUsername(), dto.getPassword())
        );

        // Nếu authenticate không ném ra ngoại lệ, nghĩa là đăng nhập thành công
        SecurityContextHolder.getContext().setAuthentication(authentication);

        return userService.findByUsername(dto.getUsername());
    }
}