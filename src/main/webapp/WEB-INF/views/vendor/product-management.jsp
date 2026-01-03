<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý sản phẩm</title>
</head>
<body>

<div class="container-fluid">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Quản lý sản phẩm</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="<c:url value='/vendor/products/add'/>" class="btn btn-sm btn-primary">
                <i class="bi bi-plus-lg"></i> Thêm sản phẩm mới
            </a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Hình ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Kho</th>
                <th>Danh mục</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="product" items="${products}">
                <tr>
                    <td>#${product.id}</td>
                    <td>
                        <c:if test="${not empty product.images}">
                            <img src="${product.images[0].url}" alt="${product.nameVi}" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;">
                        </c:if>
                        <c:if test="${empty product.images}">
                            <span class="text-muted"><i class="bi bi-image"></i> No image</span>
                        </c:if>
                    </td>
                    <td>
                        <div class="fw-bold">${product.nameVi}</div>
                        <small class="text-muted">${product.nameEn}</small>
                    </td>
                    <td>
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${product.stock == 0}">
                                <span class="badge bg-danger">Hết hàng</span>
                            </c:when>
                            <c:when test="${product.stock < 10}">
                                <span class="badge bg-warning text-dark">Sắp hết (${product.stock})</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success">${product.stock}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:forEach var="cat" items="${product.categories}" varStatus="status">
                            <span class="badge bg-secondary">${cat.nameVi}</span>
                        </c:forEach>
                    </td>
                    <td>
                        <a href="<c:url value='/vendor/products/edit/${product.id}'/>" class="btn btn-sm btn-outline-primary" title="Sửa">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <a href="<c:url value='/vendor/products/delete/${product.id}'/>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');" title="Xóa">
                            <i class="bi bi-trash"></i>
                        </a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty products}">
                <tr>
                    <td colspan="7" class="text-center py-4">
                        <i class="bi bi-box-seam fs-1 text-muted"></i>
                        <p class="mt-2 text-muted">Chưa có sản phẩm nào. Hãy thêm sản phẩm đầu tiên!</p>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
