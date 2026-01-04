package vn.edu.hcmute.springboot3_4_12.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import vn.edu.hcmute.springboot3_4_12.auth.AuthInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public FilterRegistrationBean<CustomSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<CustomSiteMeshFilter> filterRegistrationBean = new FilterRegistrationBean<>();
        filterRegistrationBean.setFilter(new CustomSiteMeshFilter());
        filterRegistrationBean.addUrlPatterns("/*");
        return filterRegistrationBean;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/")
                .setCachePeriod(3600 * 24 * 7) // Cache 7 days
                .resourceChain(true);
        
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/")
                .setCachePeriod(3600 * 24 * 7);
                
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/")
                .setCachePeriod(3600 * 24 * 7);
                
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/")
                .setCachePeriod(3600 * 24 * 7);
    }

    //@Autowired
    //private AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // registry.addInterceptor(authInterceptor)
        //         .addPathPatterns("/**") // Áp dụng cho tất cả routes
        //         .excludePathPatterns(
        //                 "/login",              // Trang đăng nhập
        //                 "/register",           // Trang đăng ký
        //                 "/perform_login",      // Xử lý đăng nhập
        //                 "/logout",             // Đăng xuất
        //                 "/error",              // Trang lỗi
        //                 "/resources/**",       // Static resources (CSS, JS, images)
        //                 "/api/auth/**"         // API đăng nhập/đăng ký (nếu có)
        //         );
    }
}
