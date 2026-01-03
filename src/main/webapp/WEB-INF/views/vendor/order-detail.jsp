<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/common/taglib.jsp" %>
<html>
<head>
    <title>Chi tiết đơn hàng #${order.id}</title>
</head>
<body>
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4 mt-3">
            <h2 class="h3 mb-0 text-gray-800">Chi tiết đơn hàng #${order.id}</h2>
            <a href="<c:url value='/vendor/orders'/>" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="row">
            <!-- Order Info -->
            <div class="col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-header py-3 bg-primary text-white">
                        <h6 class="m-0 font-weight-bold">Thông tin đơn hàng</h6>
                    </div>
                    <div class="card-body">
                        <p><strong>Ngày đặt:</strong> ${order.createdAt}</p>
                        <p><strong>Trạng thái:</strong> 
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}"><span class="badge bg-warning text-dark">Chờ xác nhận</span></c:when>
                                <c:when test="${order.status == 'CONFIRMED'}"><span class="badge bg-info text-dark">Đã xác nhận</span></c:when>
                                <c:when test="${order.status == 'SHIPPING'}"><span class="badge bg-primary">Đang giao</span></c:when>
                                <c:when test="${order.status == 'DELIVERED'}"><span class="badge bg-success">Đã giao</span></c:when>
                                <c:when test="${order.status == 'CANCELLED'}"><span class="badge bg-danger">Đã hủy</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">${order.status}</span></c:otherwise>
                            </c:choose>
                        </p>
                        <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
                        <p><strong>Ghi chú:</strong> ${order.note != null ? order.note : 'Không có'}</p>
                        
                        <hr>
                        <h6 class="font-weight-bold">Cập nhật trạng thái:</h6>
                        <form action="<c:url value='/vendor/orders/${order.id}/status'/>" method="post" class="d-flex gap-2 flex-wrap">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <c:if test="${order.status == 'PENDING'}">
                                <button type="submit" name="status" value="CONFIRMED" class="btn btn-info btn-sm text-white">
                                    <i class="bi bi-check-circle"></i> Xác nhận đơn
                                </button>
                                <button type="submit" name="status" value="CANCELLED" class="btn btn-danger btn-sm" onclick="return confirm('Bạn chắc chắn muốn hủy đơn này?');">
                                    <i class="bi bi-x-circle"></i> Hủy đơn
                                </button>
                            </c:if>
                            
                            <c:if test="${order.status == 'CONFIRMED'}">
                                <button type="submit" name="status" value="SHIPPING" class="btn btn-primary btn-sm">
                                    <i class="bi bi-truck"></i> Giao hàng
                                </button>
                            </c:if>
                            
                            <c:if test="${order.status == 'SHIPPING'}">
                                <button type="submit" name="status" value="DELIVERED" class="btn btn-success btn-sm">
                                    <i class="bi bi-check2-all"></i> Đã giao hàng
                                </button>
                            </c:if>
                            
                            <c:if test="${order.status == 'DELIVERED' || order.status == 'CANCELLED'}">
                                <span class="text-muted small">Đơn hàng đã hoàn tất/hủy, không thể thay đổi trạng thái.</span>
                            </c:if>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Customer Info -->
            <div class="col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-header py-3 bg-success text-white">
                        <h6 class="m-0 font-weight-bold">Thông tin khách hàng</h6>
                    </div>
                    <div class="card-body">
                        <p><strong>Người nhận:</strong> ${order.recipientName}</p>
                        <p><strong>Số điện thoại:</strong> ${order.recipientPhone}</p>
                        <p><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Items -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 bg-dark text-white">
                <h6 class="m-0 font-weight-bold">Sản phẩm cần chuẩn bị</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                        <thead class="table-light">
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Hình ảnh</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${vendorItems}">
                                <tr>
                                    <td>
                                        <div class="fw-bold">${item.product.nameVi}</div>
                                        <small class="text-muted">ID: ${item.product.id}</small>
                                    </td>
                                    <td>
                                        <c:if test="${not empty item.product.images}">
                                            <img src="${item.product.images[0].url}" alt="${item.product.nameVi}" class="img-thumbnail" style="width: 60px; height: 60px; object-fit: cover;">
                                        </c:if>
                                    </td>
                                    <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/></td>
                                    <td>${item.quantity}</td>
                                    <td class="fw-bold"><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr class="table-secondary">
                                <th colspan="4" class="text-end">Tổng cộng (Doanh thu của shop):</th>
                                <th class="text-danger fs-5"><fmt:formatNumber value="${vendorTotal}" type="currency" currencySymbol="₫"/></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
