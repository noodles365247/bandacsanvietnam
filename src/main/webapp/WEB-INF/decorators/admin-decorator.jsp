<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản trị - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <sitemesh:write property='head'/>
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar-header {
            padding: 20px;
            background: rgba(0,0,0,0.2);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar-header h4 {
            margin: 0;
            font-weight: 600;
            color: white;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-menu li {
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .sidebar-menu a {
            display: block;
            padding: 15px 20px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }
        .sidebar-menu a:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            border-left-color: #3498db;
        }
        .sidebar-menu a.active {
            background: rgba(52, 152, 219, 0.2);
            color: white;
            border-left-color: #3498db;
        }
        .sidebar-menu i {
            width: 20px;
            margin-right: 10px;
        }
        .main-content {
            padding: 20px;
        }
        .top-navbar {
            background: white;
            padding: 15px 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-info span {
            color: #2c3e50;
            font-weight: 500;
        }
        footer {
            background: #2c3e50;
            color: white;
            padding: 20px;
            text-align: center;
            margin-top: 40px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="sidebar-header">
                    <h4><i class="bi bi-shield-check"></i> Admin Panel</h4>
                </div>
                <ul class="sidebar-menu">
                    <li>
                        <a href="<c:url value='/admin/dashboard'/>" class="<c:if test='${requestScope[\"javax.servlet.forward.request_uri\"].contains(\"/admin/dashboard\")}'>active</c:if>">
                            <i class="bi bi-speedometer2"></i> Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="<c:url value='/admin/users'/>" class="<c:if test='${requestScope[\"javax.servlet.forward.request_uri\"].contains(\"/admin/users\")}'>active</c:if>">
                            <i class="bi bi-people"></i> Quản lý người dùng
                        </a>
                    </li>
                    <li>
                        <a href="<c:url value='/admin/categories'/>" class="<c:if test='${requestScope[\"javax.servlet.forward.request_uri\"].contains(\"/admin/categories\")}'>active</c:if>">
                            <i class="bi bi-tags"></i> Danh mục sản phẩm
                        </a>
                    </li>
                    <li>
                        <a href="<c:url value='/admin/products'/>" class="<c:if test='${requestScope[\"javax.servlet.forward.request_uri\"].contains(\"/admin/products\")}'>active</c:if>">
                            <i class="bi bi-box-seam"></i> Sản phẩm
                        </a>
                    </li>
                    <li>
                        <a href="<c:url value='/admin/vendors'/>" class="<c:if test='${requestScope[\"javax.servlet.forward.request_uri\"].contains(\"/admin/vendors\")}'>active</c:if>">
                            <i class="bi bi-shop"></i> Nhà bán hàng
                        </a>
                    </li>
                    <li>
                        <a href="<c:url value='/admin/orders'/>" class="<c:if test='${requestScope[\"javax.servlet.forward.request_uri\"].contains(\"/admin/orders\")}'>active</c:if>">
                            <i class="bi bi-cart-check"></i> Đơn hàng
                        </a>
                    </li>
                    <li>
                        <a href="<c:url value='/admin/blogs'/>" class="<c:if test='${requestScope[\"javax.servlet.forward.request_uri\"].contains(\"/admin/blogs\")}'>active</c:if>">
                            <i class="bi bi-journal-text"></i> Blog
                        </a>
                    </li>
                    <li>
                        <a href="<c:url value='/'/>">
                            <i class="bi bi-house"></i> Về trang chủ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="top-navbar">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-0" style="color: #2c3e50;">
                                Admin Dashboard
                            </h5>
                        </div>
                        <div class="user-info">
                            <c:if test="${not empty sessionScope.user}">
                                <span>
                                    <i class="bi bi-person-circle"></i> 
                                    ${sessionScope.user.username}
                                </span>
                            </c:if>
                            <a href="<c:url value='/logout'/>" class="btn btn-danger btn-sm">
                                <i class="bi bi-box-arrow-right"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </div>

                <main class="main-content">
                    <sitemesh:write property='body'/>
                </main>
            </div>
        </div>
    </div>

    <footer>
        <div class="container">
            <p class="mb-0">
                &copy; <%= java.time.Year.now() %> Website Quảng bá và Kinh doanh Đặc sản Quê hương
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>