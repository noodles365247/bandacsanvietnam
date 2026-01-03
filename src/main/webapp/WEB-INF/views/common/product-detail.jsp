<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>${product.nameVi} - Đặc Sản Quê Hương</title>
</head>
<body>

<div class="container py-5">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-4">
            <li class="breadcrumb-item"><a href="<c:url value='/'/>" class="text-decoration-none text-muted">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="<c:url value='/products'/>" class="text-decoration-none text-muted">Sản phẩm</a></li>
            <li class="breadcrumb-item active" aria-current="page">${product.nameVi}</li>
        </ol>
    </nav>

    <div class="row">
        <!-- Product Images -->
        <div class="col-md-6 mb-4">
            <div id="productCarousel" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner rounded shadow-sm">
                    <c:choose>
                        <c:when test="${not empty product.imageUrls}">
                            <c:forEach items="${product.imageUrls}" var="img" varStatus="status">
                                <div class="carousel-item ${status.first ? 'active' : ''}">
                                    <img src="${img}" class="d-block w-100" alt="${product.nameVi}" style="height: 400px; object-fit: cover;">
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="carousel-item active">
                                <img src="https://placehold.co/600x400?text=No+Image" class="d-block w-100" alt="No Image" style="height: 400px; object-fit: cover;">
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${not empty product.imageUrls && fn:length(product.imageUrls) > 1}">
                    <button class="carousel-control-prev" type="button" data-bs-target="#productCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#productCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Product Info -->
        <div class="col-md-6">
            <h1 class="fw-bold mb-2">${product.nameVi}</h1>
            <p class="text-muted mb-3">
                Nhà cung cấp: 
                <a href="#" class="text-decoration-none fw-bold text-success">
                    ${product.vendorName}
                </a>
            </p>

            <div class="mb-4">
                <h2 class="text-success fw-bold d-inline me-3">
                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                </h2>
                <span class="badge ${product.stock > 0 ? 'bg-success' : 'bg-danger'} rounded-pill">
                    ${product.stock > 0 ? 'Còn hàng' : 'Hết hàng'}
                </span>
            </div>

            <p class="lead mb-4" style="font-size: 1rem;">
                ${product.descriptionVi}
            </p>

            <hr class="my-4">

            <form action="<c:url value='/cart/add'/>" method="post" class="d-flex align-items-center gap-3">
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>
                <input type="hidden" name="productId" value="${product.id}" />
                
                <div class="input-group" style="width: 140px;">
                    <button class="btn btn-outline-secondary" type="button" onclick="decreaseQty()">-</button>
                    <input type="number" class="form-control text-center" id="quantity" name="quantity" value="1" min="1" max="${product.stock > 0 ? product.stock : 1}">
                    <button class="btn btn-outline-secondary" type="button" onclick="increaseQty()">+</button>
                </div>

                <button type="submit" class="btn btn-success flex-grow-1" ${product.stock <= 0 ? 'disabled' : ''}>
                    <i class="bi bi-cart-plus me-2"></i> Thêm vào giỏ
                </button>
            </form>
        </div>
    </div>

    <!-- Similar Products -->
    <c:if test="${not empty similarProducts}">
        <div class="mt-5">
            <h3 class="fw-bold mb-4">Sản phẩm tương tự</h3>
            <div class="row row-cols-1 row-cols-md-4 g-4">
                <c:forEach items="${similarProducts}" var="sim">
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm product-card">
                             <c:choose>
                                <c:when test="${not empty sim.imageUrls}">
                                    <img src="${sim.imageUrls[0]}" class="card-img-top" alt="${sim.nameVi}" style="height: 200px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://placehold.co/300x200?text=No+Image" class="card-img-top" alt="No Image" style="height: 200px; object-fit: cover;">
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body">
                                <h6 class="card-title">
                                    <a href="<c:url value='/product/detail/${sim.id}'/>" class="text-decoration-none text-dark stretched-link">
                                        ${sim.nameVi}
                                    </a>
                                </h6>
                                <p class="card-text text-success fw-bold">
                                    <fmt:formatNumber value="${sim.price}" type="currency" currencySymbol="₫"/>
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

</div>

<script>
    function decreaseQty() {
        var input = document.getElementById('quantity');
        var value = parseInt(input.value);
        if (value > 1) {
            input.value = value - 1;
        }
    }

    function increaseQty() {
        var input = document.getElementById('quantity');
        var value = parseInt(input.value);
        var max = parseInt(input.getAttribute('max'));
        if (value < max) {
            input.value = value + 1;
        }
    }
</script>

</body>
</html>
