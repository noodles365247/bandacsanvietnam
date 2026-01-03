<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html>
<head>
    <title>Thanh toán thất bại</title>
</head>
<body>
    <div class="container mt-5 mb-5">
        <div class="text-center">
            <i class="bi bi-x-circle-fill text-danger" style="font-size: 5rem;"></i>
            <h2 class="mt-3">Thanh toán thất bại</h2>
            <p class="lead">Giao dịch của bạn không thể thực hiện hoặc đã bị hủy.</p>
            
            <c:if test="${not empty message}">
                <div class="alert alert-warning d-inline-block">
                    ${message}
                </div>
            </c:if>
            
            <div class="mt-4">
                <a href="<c:url value='/checkout'/>" class="btn btn-primary me-2">
                    <i class="bi bi-arrow-repeat"></i> Thử lại
                </a>
                <a href="<c:url value='/'/>" class="btn btn-outline-secondary">
                    <i class="bi bi-house"></i> Về trang chủ
                </a>
            </div>
        </div>
    </div>
</body>
</html>