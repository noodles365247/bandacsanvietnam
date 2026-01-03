package vn.edu.hcmute.springboot3_4_12.config;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.nio.charset.StandardCharsets;
import java.util.*;

@Configuration
public class VNPayConfig {
    @Value("${vnpay.url}")
    private String vnp_PayUrl;
    
    @Value("${vnpay.return_url}")
    private String vnp_ReturnUrl;
    
    @Value("${vnpay.tmn_code}")
    private String vnp_TmnCode;
    
    @Value("${vnpay.hash_secret}")
    private String secretKey;
    
    @Value("${vnpay.api_url:https://sandbox.vnpayment.vn/merchant_webapi/api/transaction}")
    private String vnp_ApiUrl;

    // Manual Getters to bypass Lombok issues
    public String getVnp_PayUrl() { return vnp_PayUrl; }
    public String getVnp_ReturnUrl() { return vnp_ReturnUrl; }
    public String getVnp_TmnCode() { return vnp_TmnCode; }
    public String getSecretKey() { return secretKey; }
    public String getVnp_ApiUrl() { return vnp_ApiUrl; }

    public static String hmacSHA512(String key, String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            final javax.crypto.Mac hmac512 = javax.crypto.Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes();
            final javax.crypto.spec.SecretKeySpec secretKey = new javax.crypto.spec.SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();

        } catch (Exception ex) {
            return "";
        }
    }

    public static String getIpAddress(HttpServletRequest request) {
        String ipAdress;
        try {
            ipAdress = request.getHeader("X-FORWARDED-FOR");
            if (ipAdress == null) {
                ipAdress = request.getRemoteAddr();
            }
        } catch (Exception e) {
            ipAdress = "Invalid IP:" + e.getMessage();
        }
        return ipAdress;
    }

    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
