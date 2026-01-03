<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${not empty productId ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'}</title>
</head>
<body>

<div class="container">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">${not empty productId ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'}</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="<c:url value='/vendor/products'/>" class="btn btn-sm btn-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại danh sách
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card shadow-sm">
                <div class="card-body">
                    <c:url var="actionUrl" value="${not empty productId ? '/vendor/products/update/'.concat(productId) : '/vendor/products/save'}"/>
                    <form:form modelAttribute="product" action="${actionUrl}" method="post" enctype="multipart/form-data">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="nameVi" class="form-label fw-bold">Tên sản phẩm (Tiếng Việt) <span class="text-danger">*</span></label>
                                <form:input path="nameVi" id="nameVi" cssClass="form-control" placeholder="Nhập tên sản phẩm..."/>
                                <form:errors path="nameVi" cssClass="text-danger small"/>
                            </div>
                            <div class="col-md-6">
                                <label for="nameEn" class="form-label fw-bold">Tên sản phẩm (Tiếng Anh)</label>
                                <form:input path="nameEn" id="nameEn" cssClass="form-control" placeholder="Product name in English..."/>
                                <form:errors path="nameEn" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="price" class="form-label fw-bold">Giá bán (VNĐ) <span class="text-danger">*</span></label>
                                <form:input path="price" id="price" type="number" cssClass="form-control" min="0"/>
                                <form:errors path="price" cssClass="text-danger small"/>
                            </div>
                            <div class="col-md-6">
                                <label for="stock" class="form-label fw-bold">Số lượng tồn kho <span class="text-danger">*</span></label>
                                <form:input path="stock" id="stock" type="number" cssClass="form-control" min="0"/>
                                <form:errors path="stock" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="categoryIds" class="form-label fw-bold">Danh mục <span class="text-danger">*</span></label>
                            <form:select path="categoryIds" id="categoryIds" cssClass="form-select" multiple="true" style="height: 120px;">
                                <form:options items="${categories}" itemValue="id" itemLabel="nameVi"/>
                            </form:select>
                            <form:errors path="categoryIds" cssClass="text-danger small"/>
                            <div class="form-text">Giữ phím Ctrl (hoặc Command trên Mac) để chọn nhiều danh mục.</div>
                        </div>

                        <div class="mb-3">
                            <label for="descriptionVi" class="form-label fw-bold">Mô tả (Tiếng Việt) <span class="text-danger">*</span></label>
                            <form:textarea path="descriptionVi" id="descriptionVi" cssClass="form-control" rows="4"/>
                            <form:errors path="descriptionVi" cssClass="text-danger small"/>
                        </div>

                        <div class="mb-3">
                            <label for="descriptionEn" class="form-label fw-bold">Mô tả (Tiếng Anh)</label>
                            <form:textarea path="descriptionEn" id="descriptionEn" cssClass="form-control" rows="4"/>
                            <form:errors path="descriptionEn" cssClass="text-danger small"/>
                        </div>

                        <div class="mb-4">
                            <label for="images" class="form-label fw-bold">Hình ảnh sản phẩm</label>
                            <input type="file" name="images" id="images" class="form-control" multiple accept="image/*">
                            <div class="form-text">Bạn có thể chọn nhiều ảnh cùng lúc.</div>
                            
                            <c:if test="${not empty currentImages}">
                                <div class="mt-3">
                                    <label class="form-label">Ảnh hiện tại:</label>
                                    <div class="d-flex flex-wrap gap-2">
                                        <c:forEach var="img" items="${currentImages}">
                                            <div class="position-relative">
                                                <img src="${img.url}" class="img-thumbnail" style="width: 100px; height: 100px; object-fit: cover;">
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="<c:url value='/vendor/products'/>" class="btn btn-secondary me-md-2">Hủy bỏ</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save"></i> Lưu sản phẩm
                            </button>
                        </div>

                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
