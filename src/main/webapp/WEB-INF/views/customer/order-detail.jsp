<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html>
<head>
    <title>Chi tiết đơn hàng #${order.id}</title>
    <style>
        .rating-stars {
            font-size: 1.5rem;
            color: #ffc107;
            cursor: pointer;
        }
        .rating-stars i:hover {
            color: #ffdb58;
        }
    </style>
</head>
<body>
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Chi tiết đơn hàng #${order.id}</h2>
            <a href="<c:url value='/user/orders'/>" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>

        <!-- Order Info -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="mb-0">Thông tin đơn hàng</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Ngày đặt:</strong> 
                            <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </p>
                        <p><strong>Trạng thái:</strong> 
                            <span class="badge ${order.status == 'DELIVERED' ? 'bg-success' : 
                                               order.status == 'CANCELLED' ? 'bg-danger' : 
                                               order.status == 'PENDING' ? 'bg-warning' : 'bg-primary'}">
                                ${order.status}
                            </span>
                        </p>
                        <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Người nhận:</strong> ${order.recipientName}</p>
                        <p><strong>Số điện thoại:</strong> ${order.recipientPhone}</p>
                        <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Items -->
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="mb-0">Sản phẩm</h5>
            </div>
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th class="text-center">Số lượng</th>
                            <th class="text-end">Đơn giá</th>
                            <th class="text-end">Thành tiền</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${order.orderItems}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <c:set var="productImage" value="/assets/images/no-image.png" />
                                        <c:if test="${not empty item.product.images}">
                                            <c:set var="productImage" value="${item.product.images[0].url}" />
                                        </c:if>
                                        <img src="${productImage}" alt="${item.product.nameVi}" 
                                             style="width: 50px; height: 50px; object-fit: cover;" class="me-3 rounded">
                                        <div>
                                            <h6 class="mb-0">${item.product.nameVi}</h6>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">${item.quantity}</td>
                                <td class="text-end">
                                    <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                                </td>
                                <td class="text-end">
                                    <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫"/>
                                </td>
                                <td class="text-center">
                                    <c:if test="${order.status == 'DELIVERED'}">
                                        <c:choose>
                                            <c:when test="${ratedProducts[item.product.id]}">
                                                <span class="badge bg-secondary">Đã đánh giá</span>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-sm btn-outline-warning" 
                                                        onclick="openRatingModal(${order.id}, ${item.product.id}, '${item.product.name}')">
                                                    <i class="bi bi-star-fill"></i> Đánh giá
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" class="text-end fw-bold">Tổng tiền:</td>
                            <td class="text-end fw-bold text-danger">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

    <!-- Rating Modal -->
    <div class="modal fade" id="ratingModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="<c:url value='/user/ratings/add'/>" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title">Đánh giá sản phẩm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="orderId" id="modalOrderId">
                        <input type="hidden" name="productId" id="modalProductId">
                        
                        <div class="mb-3 text-center">
                            <h6 id="modalProductName" class="mb-3"></h6>
                            <div class="rating-stars">
                                <i class="bi bi-star" data-value="1"></i>
                                <i class="bi bi-star" data-value="2"></i>
                                <i class="bi bi-star" data-value="3"></i>
                                <i class="bi bi-star" data-value="4"></i>
                                <i class="bi bi-star" data-value="5"></i>
                            </div>
                            <input type="hidden" name="stars" id="ratingStars" value="0" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="comment" class="form-label">Nhận xét của bạn</label>
                            <textarea class="form-control" id="comment" name="comment" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Modal handling
        function openRatingModal(orderId, productId, productName) {
            document.getElementById('modalOrderId').value = orderId;
            document.getElementById('modalProductId').value = productId;
            document.getElementById('modalProductName').textContent = productName;
            
            // Reset form
            document.getElementById('ratingStars').value = 0;
            document.getElementById('comment').value = '';
            updateStars(0);
            
            const modal = new bootstrap.Modal(document.getElementById('ratingModal'));
            modal.show();
        }

        // Star rating interaction
        const stars = document.querySelectorAll('.rating-stars i');
        const ratingInput = document.getElementById('ratingStars');
        
        stars.forEach(star => {
            star.addEventListener('click', function() {
                const value = this.getAttribute('data-value');
                ratingInput.value = value;
                updateStars(value);
            });
            
            star.addEventListener('mouseover', function() {
                const value = this.getAttribute('data-value');
                highlightStars(value);
            });
            
            star.addEventListener('mouseout', function() {
                const value = ratingInput.value;
                updateStars(value);
            });
        });
        
        function updateStars(value) {
            stars.forEach(star => {
                const starValue = star.getAttribute('data-value');
                if (starValue <= value) {
                    star.classList.remove('bi-star');
                    star.classList.add('bi-star-fill');
                } else {
                    star.classList.remove('bi-star-fill');
                    star.classList.add('bi-star');
                }
            });
        }
        
        function highlightStars(value) {
            stars.forEach(star => {
                const starValue = star.getAttribute('data-value');
                if (starValue <= value) {
                    star.classList.remove('bi-star');
                    star.classList.add('bi-star-fill');
                } else {
                    star.classList.remove('bi-star-fill');
                    star.classList.add('bi-star');
                }
            });
        }
    </script>
</body>
</html>