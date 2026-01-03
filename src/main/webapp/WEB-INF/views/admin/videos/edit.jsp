<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="container-fluid py-4">
  <div class="row justify-content-center">
    <div class="col-lg-8">
      <div class="card shadow">
        <div class="card-header bg-warning text-dark">
          <h3 class="mb-0">
            <i class="fas fa-edit"></i> Chỉnh sửa Video
          </h3>
        </div>
        <div class="card-body">
          <form:form method="post"
                     action="${pageContext.request.contextPath}/admin/videos/save"
                     modelAttribute="video">

            <form:hidden path="id"/>

            <!-- ID Display -->
            <div class="mb-3">
              <label class="form-label">ID</label>
              <input type="text" class="form-control-plaintext"
                     readonly value="${video.id}">
            </div>

            <!-- Title -->
            <div class="mb-3">
              <label for="title" class="form-label">
                <i class="fas fa-heading"></i> Tiêu đề <span class="text-danger">*</span>
              </label>
              <form:input path="title"
                          class="form-control"
                          id="title"
                          placeholder="Nhập tiêu đề video"
                          required="true"/>
            </div>

            <!-- Description -->
            <div class="mb-3">
              <label for="description" class="form-label">
                <i class="fas fa-align-left"></i> Mô tả
              </label>
              <form:textarea path="description"
                             class="form-control"
                             id="description"
                             rows="4"
                             placeholder="Nhập mô tả video"/>
            </div>

            <div class="row">
              <!-- Poster -->
              <div class="col-md-6 mb-3">
                <label for="poster" class="form-label">
                  <i class="fas fa-image"></i> URL Poster
                </label>
                <form:input path="poster"
                            class="form-control"
                            id="poster"
                            placeholder="https://example.com/poster.jpg"/>

                <!-- Preview poster -->
                <c:if test="${not empty video.poster}">
                  <div class="mt-2">
                    <img src="${video.poster}"
                         class="img-thumbnail"
                         style="max-width: 100%; height: 150px; object-fit: cover;"
                         alt="Poster Preview">
                  </div>
                </c:if>
              </div>

              <!-- Category -->
              <div class="col-md-6 mb-3">
                <label for="category" class="form-label">
                  <i class="fas fa-folder"></i> Danh mục <span class="text-danger">*</span>
                </label>
                <form:select path="category.id" class="form-select" id="category" required="true">
                  <option value="">-- Chọn danh mục --</option>
                  <c:forEach var="cat" items="${categories}">
                    <option value="${cat.id}"
                      ${video.category.id == cat.id ? 'selected' : ''}>
                        ${cat.nameVi}
                    </option>
                  </c:forEach>
                </form:select>
              </div>
            </div>

            <div class="row">
              <!-- Views -->
              <div class="col-md-6 mb-3">
                <label for="views" class="form-label">
                  <i class="fas fa-eye"></i> Lượt xem
                </label>
                <form:input path="views"
                            type="number"
                            class="form-control"
                            id="views"
                            min="0"/>
              </div>

              <!-- Active -->
              <div class="col-md-6 mb-3">
                <label class="form-label d-block">Trạng thái</label>
                <div class="form-check form-switch mt-2">
                  <form:checkbox path="active"
                                 class="form-check-input"
                                 id="active"/>
                  <label class="form-check-label" for="active">
                    <i class="fas fa-check-circle text-success"></i>
                    <strong>Hiển thị video</strong>
                  </label>
                </div>
              </div>
            </div>

            <!-- Stats card -->
            <div class="alert alert-info">
              <i class="fas fa-info-circle"></i>
              <strong>Thông tin:</strong>
              <ul class="mb-0 mt-2">
                <li>Video ID: <strong>${video.id}</strong></li>
                <li>Lượt xem hiện tại: <strong>${video.views}</strong></li>
                <li>Danh mục: <strong>${video.category.categoryName}</strong></li>
              </ul>
            </div>

            <hr>

            <div class="d-flex justify-content-between">
              <a href="${pageContext.request.contextPath}/admin/videos"
                 class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại
              </a>
              <div>
                <button type="button" class="btn btn-danger me-2"
                        onclick="confirmDelete(${video.id})">
                  <i class="fas fa-trash"></i> Xóa
                </button>
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

<!-- Form xóa ẩn -->
<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/videos/delete">
  <input type="hidden" name="id" id="deleteId">
</form>

<script>
  function confirmDelete(id) {
    if (confirm('Bạn có chắc chắn muốn xóa video này?\n\nThao tác này không thể hoàn tác!')) {
      document.getElementById('deleteId').value = id;
      document.getElementById('deleteForm').submit();
    }
  }
</script>