<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglib.jsp"%>

<div class="container py-5">
    <div class="text-center mb-5">
        <h2>Thanh Toán</h2>
        <p class="text-muted">Vui lòng kiểm tra thông tin giao hàng và đơn hàng của bạn.</p>
    </div>

    <div class="row">
        <!-- Shipping Information Form -->
        <div class="col-md-7 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0"><i class="bi bi-truck"></i> Thông tin giao hàng</h5>
                </div>
                <div class="card-body">
                    <form:form modelAttribute="orderRequest" action="${pageContext.request.contextPath}/checkout" method="post">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <div class="mb-3">
                            <label for="recipientName" class="form-label">Họ và tên người nhận <span class="text-danger">*</span></label>
                            <form:input path="recipientName" cssClass="form-control" id="recipientName" placeholder="Nhập họ tên"/>
                            <form:errors path="recipientName" cssClass="text-danger small"/>
                        </div>

                        <div class="mb-3">
                            <label for="recipientPhone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <form:input path="recipientPhone" cssClass="form-control" id="recipientPhone" placeholder="Nhập số điện thoại"/>
                            <form:errors path="recipientPhone" cssClass="text-danger small"/>
                        </div>

                        <div class="mb-3">
                            <label for="shippingAddress" class="form-label">Địa chỉ nhận hàng <span class="text-danger">*</span></label>
                            <form:textarea path="shippingAddress" cssClass="form-control" id="shippingAddress" rows="3" placeholder="Nhập địa chỉ chi tiết (Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành)"/>
                            <form:errors path="shippingAddress" cssClass="text-danger small"/>
                        </div>

                        <div class="mb-3">
                            <label for="note" class="form-label">Ghi chú đơn hàng (Tùy chọn)</label>
                            <form:textarea path="note" cssClass="form-control" id="note" rows="2" placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi giao..."/>
                        </div>

                        <h5 class="mt-4 mb-3"><i class="bi bi-credit-card"></i> Phương thức thanh toán</h5>
                        <div class="mb-3">
                            <div class="form-check">
                                <form:radiobutton path="paymentMethod" value="COD" cssClass="form-check-input" id="paymentCOD" checked="checked"/>
                                <label class="form-check-label" for="paymentCOD">
                                    Thanh toán khi nhận hàng (COD)
                                </label>
                            </div>
                            <div class="form-check">
                                <form:radiobutton path="paymentMethod" value="VNPAY" cssClass="form-check-input" id="paymentVNPAY"/>
                                <label class="form-check-label" for="paymentVNPAY">
                                    Thanh toán online qua VNPAY
                                </label>
                            </div>
                        </div>

                        <hr class="my-4">
                        <button class="btn btn-primary w-100 btn-lg" type="submit">Xác nhận đặt hàng</button>
                    </form:form>
                </div>
            </div>
        </div>

        <!-- Order Summary -->
        <div class="col-md-5">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0"><i class="bi bi-bag-check"></i> Đơn hàng của bạn</h5>
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush mb-3">
                        <c:forEach var="item" items="${cart.items}">
                            <li class="list-group-item d-flex justify-content-between lh-sm px-0">
                                <div>
                                    <h6 class="my-0">${item.productName}</h6>
                                    <small class="text-muted">SL: ${item.quantity} x <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/></small>
                                </div>
                                <span class="text-muted"><fmt:formatNumber value="${item.subTotal}" type="currency" currencySymbol="₫"/></span>
                            </li>
                        </c:forEach>
                        <li class="list-group-item d-flex justify-content-between px-0">
                            <span>Tạm tính</span>
                            <strong><fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫"/></strong>
                        </li>
                        <li class="list-group-item d-flex justify-content-between px-0">
                            <span>Phí vận chuyển</span>
                            <span class="text-success">Miễn phí</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between px-0 bg-light">
                            <span class="text-success">Tổng cộng (VND)</span>
                            <strong class="text-success"><fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫"/></strong>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
