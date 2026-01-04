package vn.edu.hcmute.springboot3_4_12.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Autowired;
import vn.edu.hcmute.springboot3_4_12.security.JwtAuthenticationFilter;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
// @RequiredArgsConstructor
// @RequiredArgsConstructor
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Autowired
    private org.springframework.security.core.userdetails.UserDetailsService userDetailsService;

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public HttpFirewall httpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedSlash(true);
        firewall.setAllowBackSlash(true);
        firewall.setAllowUrlEncodedDoubleSlash(true);
        firewall.setAllowSemicolon(true); // Cho phép dấu chấm phẩy (thường dùng cho jsessionid)
        return firewall;
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.httpFirewall(httpFirewall());
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable) // Tắt cho API
                .authorizeHttpRequests(auth -> auth
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                        .requestMatchers(
                            new AntPathRequestMatcher("/"),
                            new AntPathRequestMatcher("/home"),
                            new AntPathRequestMatcher("/login"),
                            new AntPathRequestMatcher("/register"),
                            new AntPathRequestMatcher("/forgot-password"),
                            new AntPathRequestMatcher("/verify-otp"),
                            new AntPathRequestMatcher("/products/**"),
                            new AntPathRequestMatcher("/product/**"),
                            new AntPathRequestMatcher("/blogs/**"),
                            new AntPathRequestMatcher("/api/products/**"),
                            new AntPathRequestMatcher("/resources/**"),
                            new AntPathRequestMatcher("/css/**"),
                            new AntPathRequestMatcher("/js/**"),
                            new AntPathRequestMatcher("/images/**"),
                            new AntPathRequestMatcher("/static/**"),
                            new AntPathRequestMatcher("/assets/**"),
                            new AntPathRequestMatcher("/webjars/**"),
                            new AntPathRequestMatcher("/error"),
                            new AntPathRequestMatcher("/health"),
                            new AntPathRequestMatcher("/diagnosis/**")
                        ).permitAll() // Public resources and pages
                        .requestMatchers(new AntPathRequestMatcher("/admin/**")).hasRole("ADMIN") // Admin only
                        .requestMatchers(new AntPathRequestMatcher("/vendor/**")).hasAnyRole("VENDOR", "ADMIN") // Vendor only
                        .requestMatchers(new AntPathRequestMatcher("/user/**"), new AntPathRequestMatcher("/checkout/**"), new AntPathRequestMatcher("/cart/**")).hasAnyRole("CUSTOMER", "USER", "ADMIN") // User/Customer only
                        .requestMatchers(new AntPathRequestMatcher("/api/auth/**")).permitAll() // Auth APIs
                        .anyRequest().authenticated() // Others require login
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/home", true)
                        .permitAll()
                )
                .rememberMe(remember -> remember
                        .key("bandacsan-secure-key")
                        .tokenValiditySeconds(7 * 24 * 60 * 60) // 7 ngày
                        .userDetailsService(userDetailsService)
                )
                .logout(logout -> logout
                        .logoutSuccessUrl("/login")
                        .permitAll()
                );

        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
