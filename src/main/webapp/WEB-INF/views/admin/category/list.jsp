<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid py-4">
  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h3 class="mb-0">Quản lý Danh mục</h3>
          <a href="${pageContext.request.contextPath}/admin/categories/create" class="btn btn-primary">
            <i class="fas fa-plus"></i> Thêm mới
          </a>
        </div>
        <div class="card-body">
          <!-- Thông báo thành công -->
          <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <!-- Bảng danh sách -->
          <div class="table-responsive">
            <table class="table table-hover table-bordered">
              <thead class="table-dark">
              <tr>
                <th width="5%">ID</th>
                <th width="10%">Hình ảnh</th>
                <th width="25%">Tên danh mục (Vi)</th>
                <th width="25%">Tên danh mục (En)</th>
                <th width="10%">Trạng thái</th>
                <th width="15%">Thao tác</th>
              </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${empty categories}">
                  <tr>
                    <td colspan="6" class="text-center text-muted py-4">
                      <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                      Không có dữ liệu
                    </td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="cat" items="${categories}">
                    <tr>
                      <td>${cat.id}</td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty cat.image}">
                            <img src="/uploads/${cat.image}"
                                 class="img-thumbnail"
                                 style="width: 60px; height: 60px; object-fit: cover;"
                                 alt="${cat.nameVi}">
                          </c:when>
                          <c:otherwise>
                            <div class="bg-secondary text-white d-flex align-items-center justify-content-center"
                                 style="width: 60px; height: 60px;">
                              <i class="fas fa-image"></i>
                            </div>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td><strong>${cat.nameVi}</strong></td>
                      <td>${cat.nameEn}</td>
                      <td>
                        <c:choose>
                          <c:when test="${cat.status}">
                            <span class="badge bg-success">Hoạt động</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-secondary">Không hoạt động</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/categories/edit/${cat.id}"
                           class="btn btn-sm btn-warning" title="Sửa">
                          <i class="fas fa-edit"></i>
                        </a>
                        <button type="button" class="btn btn-sm btn-danger"
                                onclick="confirmDelete(${cat.id})" title="Xóa">
                          <i class="fas fa-trash"></i>
                        </button>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Form xóa ẩn -->
<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/categories/delete">
  <input type="hidden" name="id" id="deleteId">
</form>

<script>
  function confirmDelete(id) {
    if (confirm('Bạn có chắc chắn muốn xóa danh mục này?')) {
      document.getElementById('deleteId').value = id;
      document.getElementById('deleteForm').submit();
    }
  }
</script>
