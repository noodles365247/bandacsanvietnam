<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglib.jsp"%>

<div class="container py-5">
    <h2 class="mb-4">Giỏ hàng của bạn</h2>

    <c:choose>
        <c:when test="${empty cart.items}">
            <div class="alert alert-info text-center py-5">
                <i class="bi bi-cart-x display-1 d-block mb-3"></i>
                <h4>Giỏ hàng trống</h4>
                <p>Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                <a href="<c:url value='/products'/>" class="btn btn-primary mt-3">Tiếp tục mua sắm</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <!-- Cart Items List -->
                <div class="col-lg-8">
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="bg-light">
                                        <tr>
                                            <th scope="col" class="ps-4">Sản phẩm</th>
                                            <th scope="col" class="text-center">Đơn giá</th>
                                            <th scope="col" class="text-center" style="width: 150px;">Số lượng</th>
                                            <th scope="col" class="text-center">Thành tiền</th>
                                            <th scope="col" class="text-end pe-4">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cart.items}">
                                            <tr>
                                                <td class="ps-4">
                                                    <div class="d-flex align-items-center">
                                                        <img src="${item.productImage}" alt="${item.productName}" class="rounded me-3" style="width: 60px; height: 60px; object-fit: cover;">
                                                        <div>
                                                            <h6 class="mb-0"><a href="<c:url value='/products/${item.productId}'/>" class="text-decoration-none text-dark">${item.productName}</a></h6>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td class="text-center">
                                                    <form action="<c:url value='/cart/update'/>" method="post" class="d-flex justify-content-center align-items-center">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                        <input type="hidden" name="cartItemId" value="${item.id}">
                                                        <div class="input-group input-group-sm" style="width: 100px;">
                                                            <button class="btn btn-outline-secondary" type="button" onclick="this.parentNode.querySelector('input[type=number]').stepDown(); this.form.submit();">-</button>
                                                            <input type="number" name="quantity" class="form-control text-center" value="${item.quantity}" min="1" onchange="this.form.submit()">
                                                            <button class="btn btn-outline-secondary" type="button" onclick="this.parentNode.querySelector('input[type=number]').stepUp(); this.form.submit();">+</button>
                                                        </div>
                                                    </form>
                                                </td>
                                                <td class="text-center fw-bold text-primary">
                                                    <fmt:formatNumber value="${item.subTotal}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <a href="<c:url value='/cart/remove/${item.id}'/>" class="btn btn-link text-danger p-0" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                                        <i class="bi bi-trash"></i>
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

                <!-- Order Summary -->
                <div class="col-lg-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0">Tổng cộng</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-3">
                                <span>Tạm tính:</span>
                                <span><fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫"/></span>
                            </div>
                            <div class="d-flex justify-content-between mb-3">
                                <span>Phí vận chuyển:</span>
                                <span class="text-success">Miễn phí</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-4">
                                <span class="fw-bold fs-5">Tổng thanh toán:</span>
                                <span class="fw-bold fs-5 text-danger"><fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫"/></span>
                            </div>
                            <a href="<c:url value='/checkout'/>" class="btn btn-primary w-100 py-2 mb-2">Tiến hành thanh toán</a>
                            <a href="<c:url value='/products'/>" class="btn btn-outline-secondary w-100 py-2">Tiếp tục mua sắm</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
