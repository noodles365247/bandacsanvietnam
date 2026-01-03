<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/common/taglib.jsp" %>
<html>
<head>
    <title>Vendor Dashboard - Tổng quan</title>
</head>
<body>
    <div class="container-fluid">
        <h1 class="h3 mb-4 text-gray-800 mt-3">Tổng quan kinh doanh</h1>

        <!-- Content Row -->
        <div class="row">

            <!-- Total Orders Card -->
            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2 border-primary border-3 border-start">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                    Tổng đơn hàng</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${totalOrders}</div>
                            </div>
                            <div class="col-auto">
                                <i class="bi bi-cart-fill fa-2x text-gray-300 fs-1"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Earnings (Monthly) Card Example -->
            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card border-left-success shadow h-100 py-2 border-success border-3 border-start">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                    Tổng doanh thu</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/>
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="bi bi-currency-dollar fa-2x text-gray-300 fs-1"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Requests Card Example -->
            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card border-left-warning shadow h-100 py-2 border-warning border-3 border-start">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                    Sản phẩm hết hàng</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${outOfStock}</div>
                            </div>
                            <div class="col-auto">
                                <i class="bi bi-exclamation-triangle-fill fa-2x text-gray-300 fs-1"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chart Row -->
        <div class="row">
            <div class="col-xl-12 col-lg-12">
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Biểu đồ doanh thu (7 ngày gần nhất)</h6>
                    </div>
                    <div class="card-body">
                        <div class="chart-area" style="height: 320px;">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Orders Row -->
        <div class="row">
            <div class="col-12">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">Đơn hàng gần đây</h6>
                        <a href="<c:url value='/vendor/orders'/>" class="btn btn-sm btn-primary">Xem tất cả</a>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Ngày đặt</th>
                                        <th>Khách hàng</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty recentOrders}">
                                        <tr>
                                            <td colspan="5" class="text-center">Chưa có đơn hàng nào.</td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="order" items="${recentOrders}">
                                        <tr>
                                            <td>#${order.id}</td>
                                            <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>${order.recipientName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.status == 'PENDING'}"><span class="badge bg-warning text-dark">Chờ xác nhận</span></c:when>
                                                    <c:when test="${order.status == 'CONFIRMED'}"><span class="badge bg-info text-dark">Đã xác nhận</span></c:when>
                                                    <c:when test="${order.status == 'SHIPPING'}"><span class="badge bg-primary">Đang giao</span></c:when>
                                                    <c:when test="${order.status == 'DELIVERED'}"><span class="badge bg-success">Đã giao</span></c:when>
                                                    <c:when test="${order.status == 'CANCELLED'}"><span class="badge bg-danger">Đã hủy</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">${order.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="<c:url value='/vendor/orders/${order.id}'/>" class="btn btn-sm btn-info text-white">
                                                    Chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            fetch('${pageContext.request.contextPath}/vendor/api/revenue-chart')
                .then(response => response.json())
                .then(data => {
                    const ctx = document.getElementById('revenueChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: data.labels,
                            datasets: [{
                                label: 'Doanh thu (VNĐ)',
                                data: data.data,
                                borderColor: '#4e73df',
                                backgroundColor: 'rgba(78, 115, 223, 0.05)',
                                pointRadius: 3,
                                pointBackgroundColor: '#4e73df',
                                pointBorderColor: '#4e73df',
                                pointHoverRadius: 3,
                                pointHoverBackgroundColor: '#4e73df',
                                pointHoverBorderColor: '#4e73df',
                                pointHitRadius: 10,
                                pointBorderWidth: 2,
                                fill: true,
                                tension: 0.3
                            }]
                        },
                        options: {
                            maintainAspectRatio: false,
                            layout: {
                                padding: {
                                    left: 10,
                                    right: 25,
                                    top: 25,
                                    bottom: 0
                                }
                            },
                            scales: {
                                x: {
                                    grid: {
                                        display: false,
                                        drawBorder: false
                                    },
                                    ticks: {
                                        maxTicksLimit: 7
                                    }
                                },
                                y: {
                                    ticks: {
                                        maxTicksLimit: 5,
                                        padding: 10,
                                        callback: function(value, index, values) {
                                            return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                                        }
                                    },
                                    grid: {
                                        color: "rgb(234, 236, 244)",
                                        zeroLineColor: "rgb(234, 236, 244)",
                                        drawBorder: false,
                                        borderDash: [2],
                                        zeroLineBorderDash: [2]
                                    }
                                }
                            },
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        label: function(context) {
                                            var label = context.dataset.label || '';
                                            if (label) {
                                                label += ': ';
                                            }
                                            if (context.parsed.y !== null) {
                                                label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                                            }
                                            return label;
                                        }
                                    }
                                }
                            }
                        }
                    });
                });
        });
    </script>
</body>
</html>