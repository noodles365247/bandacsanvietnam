<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglib.jsp"%>

<div class="container py-5 text-center">
    <div class="card border-0 shadow-sm mx-auto" style="max-width: 600px;">
        <div class="card-body py-5">
            <div class="mb-4 text-success">
                <i class="bi bi-check-circle-fill display-1"></i>
            </div>
            <h2 class="mb-3">Đặt hàng thành công!</h2>
            <p class="text-muted mb-4">
                Cảm ơn bạn đã mua sắm tại Đặc Sản Quê Hương. <br>
                Mã đơn hàng của bạn là: <strong>#${param.orderId}</strong>
            </p>
            <p class="mb-4">
                Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận đơn hàng.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="<c:url value='/'/>" class="btn btn-outline-primary">Về trang chủ</a>
                <a href="<c:url value='/products'/>" class="btn btn-primary">Tiếp tục mua sắm</a>
            </div>
        </div>
    </div>
</div>
