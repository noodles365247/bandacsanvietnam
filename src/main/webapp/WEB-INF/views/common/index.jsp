<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Trang chủ - Đặc Sản Quê Hương</title>
</head>
<body>

<!-- Hero Slider -->
<div id="heroCarousel" class="carousel slide mb-5" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
    </div>
    <div class="carousel-inner rounded shadow">
        <div class="carousel-item active">
            <img src="https://placehold.co/1200x400/28a745/FFF?text=Dac+San+Mien+Bac" class="d-block w-100" alt="Banner 1">
            <div class="carousel-caption d-none d-md-block">
                <h5>Hương vị Miền Bắc</h5>
                <p>Tinh hoa ẩm thực đất kinh kỳ.</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://placehold.co/1200x400/17a2b8/FFF?text=Dac+San+Mien+Trung" class="d-block w-100" alt="Banner 2">
            <div class="carousel-caption d-none d-md-block">
                <h5>Đậm đà Miền Trung</h5>
                <p>Nắng gió tạo nên hương vị khó quên.</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://placehold.co/1200x400/ffc107/000?text=Dac+San+Mien+Nam" class="d-block w-100" alt="Banner 3">
            <div class="carousel-caption d-none d-md-block">
                <h5>Phong phú Miền Nam</h5>
                <p>Sản vật trù phú từ vùng đất chín rồng.</p>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
    </button>
</div>

<!-- Featured Categories -->
<section class="mb-5">
    <h2 class="text-center mb-4 text-success fw-bold">KHÁM PHÁ VÙNG MIỀN</h2>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card bg-dark text-white border-0 hover-zoom">
                <img src="https://placehold.co/400x250/555/FFF?text=Mien+Bac" class="card-img" alt="Miền Bắc">
                <div class="card-img-overlay d-flex align-items-center justify-content-center bg-opacity-50 bg-dark">
                    <h3 class="card-title fw-bold">MIỀN BẮC</h3>
                </div>
                <a href="<c:url value='/category/mien-bac'/>" class="stretched-link"></a>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card bg-dark text-white border-0 hover-zoom">
                <img src="https://placehold.co/400x250/555/FFF?text=Mien+Trung" class="card-img" alt="Miền Trung">
                <div class="card-img-overlay d-flex align-items-center justify-content-center bg-opacity-50 bg-dark">
                    <h3 class="card-title fw-bold">MIỀN TRUNG</h3>
                </div>
                <a href="<c:url value='/category/mien-trung'/>" class="stretched-link"></a>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card bg-dark text-white border-0 hover-zoom">
                <img src="https://placehold.co/400x250/555/FFF?text=Mien+Nam" class="card-img" alt="Miền Nam">
                <div class="card-img-overlay d-flex align-items-center justify-content-center bg-opacity-50 bg-dark">
                    <h3 class="card-title fw-bold">MIỀN NAM</h3>
                </div>
                <a href="<c:url value='/category/mien-nam'/>" class="stretched-link"></a>
            </div>
        </div>
    </div>
</section>

<!-- Featured Products -->
<section class="mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-success fw-bold mb-0">SẢN PHẨM NỔI BẬT</h2>
        <a href="<c:url value='/products'/>" class="btn btn-outline-success">Xem tất cả <i class="bi bi-arrow-right"></i></a>
    </div>
    
    <div class="row row-cols-1 row-cols-md-4 g-4">
        <c:forEach var="p" items="${featuredProducts}">
            <div class="col">
                <div class="card h-100 shadow-sm border-0">
                    <div class="position-relative">
                        <a href="<c:url value='/product/detail/${p.id}'/>">
                            <img src="${p.imageUrls != null && !p.imageUrls.isEmpty() ? p.imageUrls[0] : 'https://placehold.co/300x300?text=No+Image'}" class="card-img-top" alt="${p.nameVi}" style="height: 200px; object-fit: cover;">
                        </a>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">
                            <a href="<c:url value='/product/detail/${p.id}'/>" class="text-decoration-none text-dark">
                                ${p.nameVi}
                            </a>
                        </h5>
                        <p class="card-text text-muted small text-truncate">${p.descriptionVi}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-danger fw-bold"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/></span>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-top-0">
                        <a href="<c:url value='/product/detail/${p.id}'/>" class="btn btn-outline-success w-100"><i class="bi bi-cart-plus"></i> Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<!-- Latest Blogs -->
<section>
    <h2 class="text-success fw-bold mb-4 text-center">GÓC VĂN HÓA</h2>
    <div class="row">
        <div class="col-md-6">
            <div class="card mb-3 border-0 shadow-sm">
                <div class="row g-0">
                    <div class="col-md-4">
                        <img src="https://placehold.co/200x200?text=Blog+1" class="img-fluid rounded-start h-100" style="object-fit: cover;" alt="...">
                    </div>
                    <div class="col-md-8">
                        <div class="card-body">
                            <h5 class="card-title">Hành trình tìm về cội nguồn Bánh Chưng</h5>
                            <p class="card-text text-muted">Câu chuyện về chiếc bánh chưng ngày Tết và ý nghĩa văn hóa...</p>
                            <a href="#" class="btn btn-sm btn-outline-secondary">Đọc tiếp</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card mb-3 border-0 shadow-sm">
                <div class="row g-0">
                    <div class="col-md-4">
                        <img src="https://placehold.co/200x200?text=Blog+2" class="img-fluid rounded-start h-100" style="object-fit: cover;" alt="...">
                    </div>
                    <div class="col-md-8">
                        <div class="card-body">
                            <h5 class="card-title">Mùa vải thiều Lục Ngạn</h5>
                            <p class="card-text text-muted">Về Bắc Giang thưởng thức vải thiều chín đỏ...</p>
                            <a href="#" class="btn btn-sm btn-outline-secondary">Đọc tiếp</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

</body>
</html>
