<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="container-fluid py-4">
  <div class="row justify-content-center">
    <div class="col-lg-8">
      <div class="card">
        <div class="card-header bg-warning text-dark">
          <h3 class="mb-0">
            <i class="fas fa-edit"></i> Chỉnh sửa Danh mục
          </h3>
        </div>
        <div class="card-body">
           <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
          </c:if>
          
          <form:form method="post"
                     action="${pageContext.request.contextPath}/admin/categories/update/${categoryId}"
                     modelAttribute="category"
                     enctype="multipart/form-data">

            <!-- ID not in DTO but in path variable -->
            
            <div class="mb-3">
              <label class="form-label">ID</label>
              <input type="text" class="form-control-plaintext"
                     readonly value="${categoryId}">
            </div>

            <div class="mb-3">
              <label for="nameVi" class="form-label">
                Tên danh mục (Tiếng Việt) <span class="text-danger">*</span>
              </label>
              <form:input path="nameVi"
                          class="form-control"
                          id="nameVi"
                          required="true"/>
              <form:errors path="nameVi" cssClass="text-danger small"/>
            </div>

            <div class="mb-3">
              <label for="nameEn" class="form-label">
                Tên danh mục (Tiếng Anh)
              </label>
              <form:input path="nameEn"
                          class="form-control"
                          id="nameEn"/>
              <form:errors path="nameEn" cssClass="text-danger small"/>
            </div>

            <div class="mb-3">
              <label for="imageFile" class="form-label">Hình ảnh</label>
              <input type="file" name="imageFile" id="imageFile" class="form-control" accept="image/*">
              
              <!-- Preview hình ảnh nếu có -->
              <c:if test="${not empty currentImage}">
                <div class="mt-2">
                  <img src="/uploads/${currentImage}"
                       class="img-thumbnail"
                       style="max-width: 200px;"
                       alt="Preview">
                  <p class="text-muted small mt-1">Hình ảnh hiện tại</p>
                </div>
              </c:if>
            </div>

            <div class="mb-3">
              <div class="form-check form-switch">
                <form:checkbox path="status"
                               class="form-check-input"
                               id="status"/>
                <label class="form-check-label" for="status">
                  Trạng thái hoạt động
                </label>
              </div>
            </div>

            <hr>

            <div class="d-flex justify-content-between">
              <a href="${pageContext.request.contextPath}/admin/categories"
                 class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại
              </a>
              <div>
                <button type="submit" class="btn btn-warning">
                  <i class="fas fa-save"></i> Cập nhật
                </button>
              </div>
            </div>
          </form:form>
        </div>
      </div>
    </div>
  </div>
</div>
