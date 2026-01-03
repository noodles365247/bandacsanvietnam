package vn.edu.hcmute.springboot3_4_12;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import vn.edu.hcmute.springboot3_4_12.config.CustomSiteMeshFilter;
import vn.edu.hcmute.springboot3_4_12.config.StorageProperties;
import vn.edu.hcmute.springboot3_4_12.service.IStorageService;
@EnableConfigurationProperties(StorageProperties.class)

@SpringBootApplication
public class Springboot3412Application {


    public static void main(String[] args) {

        SpringApplication.run(Springboot3412Application.class, args);
    }
    // Tạm thời tắt SiteMesh: nếu muốn bật lại, bỏ comment phần dưới
    // @Bean
    // public FilterRegistrationBean<CustomSiteMeshFilter> sitmeshFilter() {
    //     FilterRegistrationBean<CustomSiteMeshFilter> filterFilterRegistrationBean = new FilterRegistrationBean<CustomSiteMeshFilter>();
    //     filterFilterRegistrationBean.setFilter(new CustomSiteMeshFilter());
    //     filterFilterRegistrationBean.addUrlPatterns("/*");
    //     filterFilterRegistrationBean.setOrder(1);
    //     return filterFilterRegistrationBean;
    // }
    @Bean
    CommandLineRunner init(IStorageService storageService, vn.edu.hcmute.springboot3_4_12.repository.UserRepository userRepository, org.springframework.security.crypto.password.PasswordEncoder passwordEncoder) {
        return (args -> {
            try {
                storageService.init();
            } catch (Exception e) {
                System.err.println("WARNING: Cannot initialize storage service: " + e.getMessage());
            }
            
            try {
                // Auto-fix ALL users' passwords to '123456'
                java.util.List<vn.edu.hcmute.springboot3_4_12.entity.User> users = userRepository.findAll();
                for (vn.edu.hcmute.springboot3_4_12.entity.User user : users) {
                    if (!passwordEncoder.matches("123456", user.getPassword())) {
                        user.setPassword(passwordEncoder.encode("123456"));
                        userRepository.save(user);
                        System.out.println(">>> PASSWORD AUTO-FIXED for user: " + user.getUsername());
                    }
                }
            } catch (Exception e) {
                 System.err.println("WARNING: Cannot auto-fix passwords: " + e.getMessage());
            }
        });
    }
}
