package vn.edu.hcmute.springboot3_4_12.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.util.StringUtils;

import java.util.Properties;

@Configuration
public class MailConfig {
    @Bean
    public JavaMailSender javaMailSender(
            @Value("${spring.mail.host:}") String host,
            @Value("${spring.mail.port:0}") int port,
            @Value("${spring.mail.username:}") String username,
            @Value("${spring.mail.password:}") String password,
            @Value("${spring.mail.properties.mail.smtp.auth:false}") boolean auth,
            @Value("${spring.mail.properties.mail.smtp.starttls.enable:false}") boolean starttls
    ) {
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        if (StringUtils.hasText(host)) {
            sender.setHost(host);
            sender.setPort(port > 0 ? port : 587);
            sender.setUsername(username);
            sender.setPassword(password);
            Properties props = sender.getJavaMailProperties();
            props.put("mail.transport.protocol", "smtp");
            props.put("mail.smtp.auth", String.valueOf(auth));
            props.put("mail.smtp.starttls.enable", String.valueOf(starttls));
            props.put("mail.debug", "false");
        }
        sender.setDefaultEncoding("UTF-8");
        return sender;
    }
}
