<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglib.jsp"%>

<div class="container py-5">
    <h2 class="mb-4">Lịch sử đơn hàng</h2>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="alert alert-info text-center py-5">
                <i class="bi bi-box-seam display-1 d-block mb-3"></i>
                <h4>Bạn chưa có đơn hàng nào</h4>
                <p>Hãy khám phá các đặc sản của chúng tôi và đặt hàng ngay!</p>
                <a href="<c:url value='/products'/>" class="btn btn-primary mt-3">Mua sắm ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th scope="col" class="ps-4">Mã đơn hàng</th>
                                <th scope="col">Ngày đặt</th>
                                <th scope="col">Tổng tiền</th>
                                <th scope="col">Trạng thái</th>
                                <th scope="col" class="text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td class="ps-4 fw-bold">#${order.id}</td>
                                    <td>
                                        <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="fw-bold text-primary">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                    </td>
                                    <td>
                                        <span class="badge 
                                            ${order.status == 'PENDING' ? 'bg-warning' : ''}
                                            ${order.status == 'PROCESSING' ? 'bg-info' : ''}
                                            ${order.status == 'SHIPPING' ? 'bg-primary' : ''}
                                            ${order.status == 'DELIVERED' ? 'bg-success' : ''}
                                            ${order.status == 'CANCELLED' ? 'bg-danger' : ''}
                                        ">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td class="text-end pe-4">
                                        <a href="<c:url value='/user/orders/${order.id}'/>" class="btn btn-sm btn-outline-primary">
                                            Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
