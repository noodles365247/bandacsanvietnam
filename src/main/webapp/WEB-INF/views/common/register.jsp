<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký - Đặc Sản Quê Hương</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Site CSS -->
    <link href="<c:url value='/resources/css/site.css'/>" rel="stylesheet"/>
</head>
<body>

<div class="container d-flex justify-content-center align-items-center" style="min-height: 80vh;">
    <div class="card shadow-lg" style="width: 100%; max-width: 500px;">
        <div class="card-header bg-success text-white text-center py-3">
            <h4 class="mb-0">ĐĂNG KÝ TÀI KHOẢN</h4>
        </div>
        <div class="card-body p-4">
            
            <c:if test="${not empty message}">
                <div class="alert alert-danger" role="alert">
                    ${message}
                </div>
            </c:if>

            <form action="<c:url value='/register'/>" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="mb-3">
                    <label class="form-label">Tài khoản <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input class="form-control" type="text" name="username" placeholder="Nhập tên đăng nhập" required autofocus/>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input class="form-control" type="password" name="password" placeholder="Nhập mật khẩu" required/>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">Nhập lại mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                        <input class="form-control" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required/>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Họ và tên</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                        <input class="form-control" type="text" name="fullname" placeholder="Nhập họ và tên"/>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input class="form-control" type="email" name="email" placeholder="Nhập địa chỉ email"/>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Số điện thoại</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                        <input class="form-control" type="text" name="phone" placeholder="Nhập số điện thoại"/>
                    </div>
                </div>
                
                <div class="d-grid gap-2">
                    <button class="btn btn-success btn-lg" type="submit">Đăng ký</button>
                </div>
            </form>
        </div>
        <div class="card-footer text-center bg-light py-3">
            <span class="text-muted">Đã có tài khoản?</span>
            <a href="<c:url value='/login'/>" class="fw-bold text-success text-decoration-none">Đăng nhập ngay</a>
        </div>
    </div>
</div>

</body>
</html>
