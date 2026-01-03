<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <h2 class="mb-4"><i class="bi bi-speedometer2"></i> Vendor Dashboard</h2>
            
            <!-- Welcome Card -->
            <div class="card mb-4">
                <div class="card-body">
                    <h4 class="card-title">Chào mừng, <c:out value="${sessionScope.user != null ? sessionScope.user.username : 'Vendor'}"/>!</h4>
                    <p class="card-text">Đây là khu vực quản lý dành cho nhà bán hàng.</p>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-md-3 mb-3">
                    <div class="card text-white bg-primary">
                        <div class="card-body">
                            <h5 class="card-title"><i class="bi bi-box-seam"></i> Sản phẩm</h5>
                            <h3 class="mb-0">0</h3>
                            <small>Tổng sản phẩm</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-white bg-success">
                        <div class="card-body">
                            <h5 class="card-title"><i class="bi bi-cart-check"></i> Đơn hàng</h5>
                            <h3 class="mb-0">0</h3>
                            <small>Đơn hàng mới</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-white bg-warning">
                        <div class="card-body">
                            <h5 class="card-title"><i class="bi bi-cash-coin"></i> Doanh thu</h5>
                            <h3 class="mb-0">0 đ</h3>
                            <small>Tháng này</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-white bg-info">
                        <div class="card-body">
                            <h5 class="card-title"><i class="bi bi-chat-dots"></i> Tin nhắn</h5>
                            <h3 class="mb-0">0</h3>
                            <small>Chưa đọc</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-lightning"></i> Thao tác nhanh</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <a href="<c:url value='/vendor/products'/>" class="btn btn-outline-primary w-100">
                                <i class="bi bi-box-seam"></i><br>
                                Quản lý sản phẩm
                            </a>
                        </div>
                        <div class="col-md-3 mb-3">
                            <a href="<c:url value='/vendor/orders'/>" class="btn btn-outline-success w-100">
                                <i class="bi bi-cart-check"></i><br>
                                Xem đơn hàng
                            </a>
                        </div>
                        <div class="col-md-3 mb-3">
                            <a href="<c:url value='/vendor/shop'/>" class="btn btn-outline-warning w-100">
                                <i class="bi bi-building"></i><br>
                                Quản lý Shop
                            </a>
                        </div>
                        <div class="col-md-3 mb-3">
                            <a href="<c:url value='/vendor/revenue'/>" class="btn btn-outline-info w-100">
                                <i class="bi bi-cash-coin"></i><br>
                                Xem doanh thu
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
