<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Danh sách đặc sản - Đặc Sản Quê Hương</title>
    <style>
        .product-card:hover {
            transform: translateY(-5px);
            transition: transform 0.3s ease;
        }
        .product-card:hover .product-action {
            display: flex !important;
        }
        .autocomplete-items {
            position: absolute;
            border: 1px solid #d4d4d4;
            border-bottom: none;
            border-top: none;
            z-index: 99;
            top: 100%;
            left: 0;
            right: 0;
        }
        .autocomplete-items div {
            padding: 10px;
            cursor: pointer;
            background-color: #fff;
            border-bottom: 1px solid #d4d4d4;
        }
        .autocomplete-items div:hover {
            background-color: #e9e9e9;
        }
    </style>
</head>
<body>

<div class="container py-5">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="<c:url value='/'/>" class="text-decoration-none text-success">Trang chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Đặc sản</li>
        </ol>
    </nav>

    <div class="row">
        <!-- Sidebar Filters -->
        <div class="col-lg-3 mb-4">
            <form action="<c:url value='/products'/>" method="get" id="filterForm">
                <input type="hidden" name="keyword" value="${keyword}">
                <input type="hidden" name="sort" value="${param.sort}">
                <input type="hidden" name="direction" value="${param.direction}">

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white fw-bold">
                        <i class="bi bi-funnel"></i> Bộ lọc
                    </div>
                    <div class="card-body">
                        <!-- Categories -->
                        <h6 class="card-title mt-2">Danh mục</h6>
                        <div class="list-group list-group-flush mb-3">
                            <c:forEach var="cat" items="${categories}">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="categoryId" value="${cat.id}" id="cat${cat.id}" ${categoryId == cat.id ? 'checked' : ''} onchange="this.form.submit()">
                                    <label class="form-check-label" for="cat${cat.id}">
                                        ${cat.nameVi}
                                    </label>
                                </div>
                            </c:forEach>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="categoryId" value="" id="catAll" ${empty categoryId ? 'checked' : ''} onchange="this.form.submit()">
                                <label class="form-check-label" for="catAll">
                                    Tất cả
                                </label>
                            </div>
                        </div>

                        <hr>

                        <!-- Vendors -->
                        <h6 class="card-title mt-2">Nhà sản xuất</h6>
                        <div class="mb-3" style="max-height: 150px; overflow-y: auto;">
                            <c:forEach var="v" items="${vendors}">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="vendorId" value="${v.id}" id="ven${v.id}" ${vendorId == v.id ? 'checked' : ''} onchange="this.form.submit()">
                                    <label class="form-check-label" for="ven${v.id}">
                                        ${v.shopName}
                                    </label>
                                </div>
                            </c:forEach>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="vendorId" value="" id="venAll" ${empty vendorId ? 'checked' : ''} onchange="this.form.submit()">
                                <label class="form-check-label" for="venAll">
                                    Tất cả
                                </label>
                            </div>
                        </div>

                        <hr>

                        <!-- Price Range -->
                        <h6 class="card-title">Khoảng giá</h6>
                        <div class="d-flex align-items-center mb-2">
                            <input type="number" name="minPrice" value="${minPrice}" class="form-control form-control-sm" placeholder="Min">
                            <span class="mx-1">-</span>
                            <input type="number" name="maxPrice" value="${maxPrice}" class="form-control form-control-sm" placeholder="Max">
                        </div>
                        <button type="submit" class="btn btn-sm btn-success w-100">Áp dụng</button>
                        <a href="<c:url value='/products'/>" class="btn btn-sm btn-outline-secondary w-100 mt-2">Xóa bộ lọc</a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Product List -->
        <div class="col-lg-9">
            <!-- Search & Sort -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-4 gap-3">
                <!-- Search Bar -->
                <form action="<c:url value='/products'/>" method="get" class="d-flex position-relative flex-grow-1 w-100" autocomplete="off">
                    <input type="hidden" name="categoryId" value="${categoryId}">
                    <input type="hidden" name="vendorId" value="${vendorId}">
                    <input type="hidden" name="minPrice" value="${minPrice}">
                    <input type="hidden" name="maxPrice" value="${maxPrice}">
                    
                    <input class="form-control me-2" type="search" id="searchInput" name="keyword" value="${keyword}" placeholder="Tìm kiếm đặc sản..." aria-label="Search">
                    <button class="btn btn-success" type="submit"><i class="bi bi-search"></i></button>
                    <div id="autocomplete-list" class="autocomplete-items"></div>
                </form>

                <!-- Sorting -->
                <div class="dropdown flex-shrink-0">
                    <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="sortDropdown" data-bs-toggle="dropdown">
                        Sắp xếp
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="?sort=price&direction=asc&keyword=${keyword}&categoryId=${categoryId}&vendorId=${vendorId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Giá tăng dần</a></li>
                        <li><a class="dropdown-item" href="?sort=price&direction=desc&keyword=${keyword}&categoryId=${categoryId}&vendorId=${vendorId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Giá giảm dần</a></li>
                        <li><a class="dropdown-item" href="?sort=id&direction=desc&keyword=${keyword}&categoryId=${categoryId}&vendorId=${vendorId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Mới nhất</a></li>
                    </ul>
                </div>
            </div>

            <p class="mb-3 text-muted">Hiển thị <strong>${productPage.numberOfElements}</strong> trên <strong>${productPage.totalElements}</strong> sản phẩm</p>

            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <c:forEach var="product" items="${productPage.content}">
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm product-card">
                            <div class="position-relative overflow-hidden">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrls}">
                                        <img src="${product.imageUrls[0]}" class="card-img-top" alt="${product.nameVi}" style="height: 200px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://placehold.co/300x200?text=No+Image" class="card-img-top" alt="No Image" style="height: 200px; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                                <div class="product-action position-absolute top-50 start-50 translate-middle d-none">
                                    <a href="<c:url value='/product/detail/${product.id}'/>" class="btn btn-light rounded-circle shadow mx-1"><i class="bi bi-eye"></i></a>
                                    <form action="<c:url value='/cart/add'/>" method="post" class="d-inline">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <input type="hidden" name="productId" value="${product.id}" />
                                        <input type="hidden" name="quantity" value="1" />
                                        <button type="submit" class="btn btn-success rounded-circle shadow mx-1"><i class="bi bi-cart-plus"></i></button>
                                    </form>
                                </div>
                            </div>
                            <div class="card-body">
                                <small class="text-muted">${product.vendorName}</small>
                                <h5 class="card-title mt-1">
                                    <a href="<c:url value='/product/detail/${product.id}'/>" class="text-decoration-none text-dark stretched-link">${product.nameVi}</a>
                                </h5>
                                <p class="card-text text-success fw-bold">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav class="mt-5">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}&sort=${param.sort}&direction=${param.direction}&keyword=${keyword}&categoryId=${categoryId}&vendorId=${vendorId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Trước</a>
                        </li>
                        
                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&sort=${param.sort}&direction=${param.direction}&keyword=${keyword}&categoryId=${categoryId}&vendorId=${vendorId}&minPrice=${minPrice}&maxPrice=${maxPrice}">${i + 1}</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}&sort=${param.sort}&direction=${param.direction}&keyword=${keyword}&categoryId=${categoryId}&vendorId=${vendorId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Sau</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
            
            <c:if test="${empty productPage.content}">
                <div class="alert alert-info text-center mt-4">
                    Hiện chưa có sản phẩm nào phù hợp với tiêu chí tìm kiếm.
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    // Simple Autocomplete
    const searchInput = document.getElementById('searchInput');
    const autocompleteList = document.getElementById('autocomplete-list');

    searchInput.addEventListener('input', function() {
        const val = this.value;
        closeAllLists();
        if (!val) return false;
        
        // Call API
        fetch('<c:url value="/api/products/search"/>?keyword=' + val)
            .then(response => response.json())
            .then(data => {
                data.forEach(item => {
                    const div = document.createElement("div");
                    div.innerHTML = item;
                    div.addEventListener("click", function() {
                        searchInput.value = this.innerText;
                        closeAllLists();
                        // Optional: submit form immediately
                        // searchInput.form.submit();
                    });
                    autocompleteList.appendChild(div);
                });
            });
    });

    function closeAllLists(elmnt) {
        while (autocompleteList.firstChild) {
            autocompleteList.removeChild(autocompleteList.firstChild);
        }
    }

    document.addEventListener("click", function (e) {
        closeAllLists(e.target);
    });
</script>

</body>
</html>
