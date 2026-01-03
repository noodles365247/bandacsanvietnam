<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-white py-3">
        <div class="d-flex justify-content-between align-items-center">
            <h5 class="mb-0 text-primary fw-bold">
                <i class="bi bi-cart-check"></i> Quản lý đơn hàng
            </h5>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orderPage.content}" var="order">
                        <tr>
                            <td>#${order.id}</td>
                            <td>
                                <div class="fw-bold">${order.user.username}</div>
                                <small class="text-muted">${order.recipientPhone}</small>
                            </td>
                            <td>
                                <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td class="text-danger fw-bold">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td>
                                <span class="badge bg-${order.status.name() == 'PENDING' ? 'warning' : 
                                                      (order.status.name() == 'CONFIRMED' ? 'info' : 
                                                      (order.status.name() == 'SHIPPING' ? 'primary' : 
                                                      (order.status.name() == 'DELIVERED' ? 'success' : 'danger')))}">
                                    ${order.status}
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="post" class="d-flex gap-2">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <select name="status" class="form-select form-select-sm" onchange="this.form.submit()" style="width: auto;">
                                            <c:forEach items="${orderStatuses}" var="status">
                                                <option value="${status}" ${order.status == status ? 'selected' : ''}>
                                                    ${status}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </form>
                                    <a href="${pageContext.request.contextPath}/user/orders/${order.id}" target="_blank" class="btn btn-sm btn-outline-primary" title="Chi tiết">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orderPage.content}">
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                Chưa có đơn hàng nào
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}&sort=${sort}&direction=${direction}">Trước</a>
                    </li>
                    
                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&sort=${sort}&direction=${direction}">${i + 1}</a>
                        </li>
                    </c:forEach>

                    <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}&sort=${sort}&direction=${direction}">Sau</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>
