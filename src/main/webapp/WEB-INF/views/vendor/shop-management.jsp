<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/common/taglib.jsp" %>
<html>
<head>
    <title>Quản lý thông tin cửa hàng</title>
</head>
<body>
    <div class="container-fluid">
        <h1 class="h3 mb-4 text-gray-800 mt-3">Quản lý thông tin cửa hàng</h1>

        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Cập nhật thông tin</h6>
            </div>
            <div class="card-body">
                <c:if test="${param.success != null}">
                    <div class="alert alert-success">Cập nhật thông tin thành công!</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form:form modelAttribute="vendor" action="${pageContext.request.contextPath}/vendor/shop/update" method="post" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="mb-3">
                                <label for="shopName" class="form-label fw-bold">Tên cửa hàng</label>
                                <form:input path="shopName" cssClass="form-control" />
                                <form:errors path="shopName" cssClass="text-danger small"/>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label fw-bold">Số điện thoại</label>
                                <form:input path="phone" cssClass="form-control" />
                                <form:errors path="phone" cssClass="text-danger small"/>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label fw-bold">Địa chỉ kho hàng</label>
                                <form:input path="address" cssClass="form-control" />
                                <form:errors path="address" cssClass="text-danger small"/>
                            </div>

                            <div class="mb-3">
                                <label for="descriptionVi" class="form-label fw-bold">Mô tả (Tiếng Việt)</label>
                                <form:textarea path="descriptionVi" cssClass="form-control" rows="4"/>
                                <form:errors path="descriptionVi" cssClass="text-danger small"/>
                            </div>

                            <div class="mb-3">
                                <label for="descriptionEn" class="form-label fw-bold">Mô tả (Tiếng Anh)</label>
                                <form:textarea path="descriptionEn" cssClass="form-control" rows="4"/>
                                <form:errors path="descriptionEn" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header bg-light">
                                    <h6 class="m-0 fw-bold">Logo cửa hàng</h6>
                                </div>
                                <div class="card-body text-center">
                                    <c:if test="${not empty currentLogo}">
                                        <img src="/uploads/${currentLogo}" class="img-thumbnail mb-3" style="max-height: 200px; width: auto;" alt="Shop Logo">
                                    </c:if>
                                    <c:if test="${empty currentLogo}">
                                        <div class="alert alert-secondary">Chưa có logo</div>
                                    </c:if>
                                    
                                    <div class="mb-3">
                                        <label for="logoFile" class="form-label">Tải lên logo mới</label>
                                        <input type="file" name="logoFile" id="logoFile" class="form-control" accept="image/*">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> Lưu thay đổi
                        </button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</body>
</html>