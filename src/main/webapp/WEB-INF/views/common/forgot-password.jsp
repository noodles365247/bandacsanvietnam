<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow border-0">
                <div class="card-body p-5">
                    <h3 class="text-center mb-4">Quên mật khẩu</h3>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    
                    <form action="<c:url value='/forgot-password'/>" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="mb-3">
                            <label for="email" class="form-label">Địa chỉ Email</label>
                            <input type="email" class="form-control" id="email" name="email" required placeholder="Nhập email đã đăng ký">
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Gửi mã OTP</button>
                        </div>
                    </form>
                    
                    <div class="text-center mt-3">
                        <a href="<c:url value='/login'/>" class="text-decoration-none">Quay lại Đăng nhập</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
