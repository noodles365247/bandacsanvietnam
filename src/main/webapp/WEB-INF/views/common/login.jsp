<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - Đặc Sản Quê Hương</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Site CSS -->
    <link href="<c:url value='/resources/css/site.css'/>" rel="stylesheet"/>
</head>
<body>

<div class="container d-flex justify-content-center align-items-center" style="min-height: 80vh;">
    <div class="card shadow-lg" style="width: 100%; max-width: 400px;">
        <div class="card-header bg-success text-white text-center py-3">
            <h4 class="mb-0">ĐĂNG NHẬP</h4>
        </div>
        <div class="card-body p-4">
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger" role="alert">
                    Tên đăng nhập hoặc mật khẩu không đúng!
                </div>
            </c:if>
            
            <c:if test="${not empty param.logout}">
                <div class="alert alert-success" role="alert">
                    Đã đăng xuất thành công.
                </div>
            </c:if>
            
            <c:if test="${not empty param.registerSuccess}">
                <div class="alert alert-success" role="alert">
                    Đăng ký thành công! Vui lòng đăng nhập.
                </div>
            </c:if>

            <form action="<c:url value='/login'/>" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="mb-3">
                    <label class="form-label">Tài khoản</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input class="form-control" type="text" name="username" placeholder="Nhập username" required autofocus/>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input class="form-control" type="password" name="password" placeholder="Nhập mật khẩu" required/>
                    </div>
                </div>
                
                <div class="mb-3 d-flex justify-content-between align-items-center">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="remember-me" name="remember-me">
                        <label class="form-check-label" for="remember-me">Ghi nhớ đăng nhập</label>
                    </div>
                    <a href="#" class="text-decoration-none small">Quên mật khẩu?</a>
                </div>

                <div class="d-grid gap-2">
                    <button class="btn btn-success btn-lg" type="submit">Đăng nhập</button>
                </div>
            </form>
        </div>
        <div class="card-footer text-center bg-light py-3">
            <span class="text-muted">Chưa có tài khoản?</span>
            <a href="<c:url value='/register'/>" class="fw-bold text-success text-decoration-none">Đăng ký ngay</a>
        </div>
    </div>
</div>

</body>
</html>
