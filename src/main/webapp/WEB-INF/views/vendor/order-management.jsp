<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý đơn hàng</title>
</head>
<body>

<div class="container-fluid">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Quản lý đơn hàng</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary">Xuất Excel</button>
            </div>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle">
            <thead class="table-dark">
            <tr>
                <th>Mã đơn</th>
                <th>Người đặt</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="order" items="${orders}">
                <tr>
                    <td>#${order.id}</td>
                    <td>${order.recipientName}</td>
                    <td>
                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                    </td>
                    <td>
                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${order.status == 'PENDING'}">
                                <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                            </c:when>
                            <c:when test="${order.status == 'CONFIRMED'}">
                                <span class="badge bg-info text-dark">Đã xác nhận</span>
                            </c:when>
                            <c:when test="${order.status == 'SHIPPING'}">
                                <span class="badge bg-primary">Đang giao</span>
                            </c:when>
                            <c:when test="${order.status == 'DELIVERED'}">
                                <span class="badge bg-success">Đã giao</span>
                            </c:when>
                            <c:when test="${order.status == 'CANCELLED'}">
                                <span class="badge bg-danger">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">${order.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="<c:url value='/vendor/orders/${order.id}'/>" class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-eye"></i> Chi tiết
                        </a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty orders}">
                <tr>
                    <td colspan="6" class="text-center py-4">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <p class="mt-2 text-muted">Chưa có đơn hàng nào.</p>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
