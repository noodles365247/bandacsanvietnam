package vn.edu.hcmute.springboot3_4_12.service;

import jakarta.servlet.http.HttpServletRequest;

public interface IVNPayService {
    String createPaymentUrl(HttpServletRequest request, long amount, String orderInfo);
    int orderReturn(HttpServletRequest request);
}
