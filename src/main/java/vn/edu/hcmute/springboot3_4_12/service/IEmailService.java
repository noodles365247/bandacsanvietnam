package vn.edu.hcmute.springboot3_4_12.service;

public interface IEmailService {
    void sendSimpleMessage(String to, String subject, String text);
}
