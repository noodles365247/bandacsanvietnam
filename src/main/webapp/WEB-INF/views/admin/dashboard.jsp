<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">Dashboard</h1>
    <div class="btn-toolbar mb-2 mb-md-0">
        <div class="btn-group me-2">
            <button type="button" class="btn btn-sm btn-outline-secondary">Share</button>
            <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
        </div>
        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle">
            <span data-feather="calendar"></span>
            This week
        </button>
    </div>
</div>

<div class="row row-cols-1 row-cols-md-2 row-cols-xl-4 g-4 mb-4">
    <!-- Total Users -->
    <div class="col">
        <div class="card h-100 border-start border-0 border-4 border-primary shadow-sm">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-uppercase text-muted fw-bold mb-1">Total Users</p>
                        <h4 class="mb-0 fw-bold text-primary">${totalUsers}</h4>
                    </div>
                    <div class="text-primary fs-1 opacity-25">
                        <i class="bi bi-people-fill"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Total Products -->
    <div class="col">
        <div class="card h-100 border-start border-0 border-4 border-success shadow-sm">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-uppercase text-muted fw-bold mb-1">Total Products</p>
                        <h4 class="mb-0 fw-bold text-success">${totalProducts}</h4>
                    </div>
                    <div class="text-success fs-1 opacity-25">
                        <i class="bi bi-box-seam-fill"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Total Orders -->
    <div class="col">
        <div class="card h-100 border-start border-0 border-4 border-warning shadow-sm">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-uppercase text-muted fw-bold mb-1">Total Orders</p>
                        <h4 class="mb-0 fw-bold text-warning">${totalOrders}</h4>
                    </div>
                    <div class="text-warning fs-1 opacity-25">
                        <i class="bi bi-cart-fill"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Revenue -->
    <div class="col">
        <div class="card h-100 border-start border-0 border-4 border-danger shadow-sm">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-uppercase text-muted fw-bold mb-1">Revenue</p>
                        <h4 class="mb-0 fw-bold text-danger">
                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/>
                        </h4>
                    </div>
                    <div class="text-danger fs-1 opacity-25">
                        <i class="bi bi-currency-dollar"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <!-- Chart Placeholder -->
    <div class="col-md-8 mb-4">
        <div class="card shadow-sm h-100">
            <div class="card-header bg-transparent fw-bold py-3">
                <i class="bi bi-bar-chart-line me-2"></i> Revenue Overview
            </div>
            <div class="card-body">
                <canvas id="revenueChart" width="100%" height="40"></canvas>
            </div>
        </div>
    </div>

    <!-- Recent Activity Placeholder -->
    <div class="col-md-4 mb-4">
        <div class="card shadow-sm h-100">
            <div class="card-header bg-transparent fw-bold py-3">
                <i class="bi bi-activity me-2"></i> Recent Activity
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                        New Order #1234
                        <span class="badge bg-primary rounded-pill">Just now</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                        New User Registered
                        <span class="badge bg-secondary rounded-pill">5m ago</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                        Product Out of Stock
                        <span class="badge bg-danger rounded-pill">1h ago</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('revenueChart');
    if (ctx) {
        // Prepare data from server
        const labels = [
            <c:forEach items="${revenueLabels}" var="label" varStatus="status">
                '${label}'${!status.last ? ',' : ''}
            </c:forEach>
        ];
        const data = [
            <c:forEach items="${revenueData}" var="value" varStatus="status">
                ${value}${!status.last ? ',' : ''}
            </c:forEach>
        ];

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Revenue (VNĐ)',
                    data: data,
                    lineTension: 0.3,
                    backgroundColor: 'rgba(0, 123, 255, 0.1)',
                    borderColor: '#007bff',
                    borderWidth: 3,
                    pointBackgroundColor: '#007bff',
                    pointBorderColor: '#fff',
                    pointHoverBackgroundColor: '#fff',
                    pointHoverBorderColor: '#007bff',
                    fill: true
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value, index, values) {
                                return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
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
    }
</script>
