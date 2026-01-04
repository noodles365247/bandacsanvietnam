package vn.edu.hcmute.springboot3_4_12.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.event.EventListener;
import org.springframework.security.authentication.event.AbstractAuthenticationFailureEvent;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationLoggingListener {

    private static final Logger logger = LoggerFactory.getLogger(AuthenticationLoggingListener.class);

    @EventListener
    public void onAuthenticationSuccess(AuthenticationSuccessEvent event) {
        logger.info("LOGIN SUCCESS: User [{}] logged in successfully. Authorities: {}", 
            event.getAuthentication().getName(), event.getAuthentication().getAuthorities());
    }

    @EventListener
    public void onAuthenticationFailure(AbstractAuthenticationFailureEvent event) {
        logger.error("LOGIN FAILED: User [{}] failed to login. Error: {}", 
            event.getAuthentication().getName(), event.getException().getMessage());
        
        if (event.getException().getCause() != null) {
            logger.error("LOGIN FAILURE CAUSE: ", event.getException().getCause());
        }
    }
}
