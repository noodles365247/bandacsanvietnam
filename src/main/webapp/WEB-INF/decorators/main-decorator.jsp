<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><sitemesh:write property="title"/></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Site CSS -->
    <link href="<c:url value='/resources/css/site.css'/>" rel="stylesheet"/>

    <sitemesh:write property="head"/>
    
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        main {
            flex: 1;
        }
        .navbar-brand {
            font-weight: bold;
            color: #28a745 !important;
        }
    </style>
</head>
<body>

<!-- Header / Navigation -->
<header>
    <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="<c:url value='/'/>">
                <i class="bi bi-shop"></i> ĐẶC SẢN QUÊ
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="mainNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/'/>">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/products'/>">Sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/blogs'/>">Blog văn hóa</a>
                    </li>
                </ul>
                
                <div class="d-flex align-items-center gap-3">
                    <!-- Cart -->
                    <a href="<c:url value='/cart'/>" class="btn btn-outline-secondary position-relative border-0">
                        <i class="bi bi-cart3 fs-5"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            0
                        </span>
                    </a>
                    
                    <!-- Auth -->
                    <c:choose>
                        <c:when test="${not empty pageContext.request.userPrincipal}">
                            <div class="dropdown">
                                <a class="btn btn-light dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle"></i> Tài khoản
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="<c:url value='/user/profile'/>">Hồ sơ</a></li>
                                    <li><a class="dropdown-item" href="<c:url value='/user/orders'/>">Đơn mua</a></li>
                                    
                                    <!-- Vendor Link -->
                                    <c:if test="${pageContext.request.isUserInRole('VENDOR')}">
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="<c:url value='/vendor/dashboard'/>">Kênh người bán</a></li>
                                    </c:if>
                                    
                                    <!-- Admin Link -->
                                    <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="<c:url value='/admin/dashboard'/>">Trang quản trị</a></li>
                                    </c:if>
                                    
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <form action="<c:url value='/logout'/>" method="post" class="m-0">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="dropdown-item text-danger">Đăng xuất</button>
                                        </form>
                                    </li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/login'/>" class="btn btn-outline-primary">Đăng nhập</a>
                            <a href="<c:url value='/register'/>" class="btn btn-primary">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
</header>

<!-- Main Content -->
<main>
    <sitemesh:write property="body"/>
</main>

<!-- Footer -->
<footer class="bg-dark text-white py-4 mt-auto">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5>ĐẶC SẢN QUÊ HƯƠNG</h5>
                <p>Mang hương vị quê hương đến mọi miền tổ quốc.</p>
            </div>
            <div class="col-md-4">
                <h5>Liên kết</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-white text-decoration-none">Về chúng tôi</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Chính sách bảo mật</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5>Liên hệ</h5>
                <p><i class="bi bi-envelope"></i> contact@dacsan.vn</p>
                <p><i class="bi bi-phone"></i> 1900 xxxx</p>
            </div>
        </div>
        <hr>
        <div class="text-center">
            &copy; <%= java.time.Year.now() %> Bản quyền thuộc về Nhóm Đồ Án.
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
