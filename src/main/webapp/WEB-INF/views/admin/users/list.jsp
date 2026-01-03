<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h3 class="mb-0">Quản lý Người dùng</h3>
                    <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i> Thêm mới
                    </a>
                </div>
                <div class="card-body">
                    <!-- Thông báo thành công -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Form tìm kiếm -->
                    <form method="get" action="${pageContext.request.contextPath}/admin/users" class="mb-4">
                        <div class="row">
                            <div class="col-md-10">
                                <input type="text" name="q" class="form-control"
                                       placeholder="Tìm kiếm theo tên người dùng..."
                                       value="${q}">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-info w-100">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Bảng danh sách -->
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered">
                            <thead class="table-dark">
                            <tr>
                                <th width="15%">Username</th>
                                <th width="20%">Email</th>
                                <th width="15%">Họ tên</th>
                                <th width="12%">Số điện thoại</th>
                                <th width="10%">Admin</th>
                                <th width="10%">Trạng thái</th>
                                <th width="18%">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-4">
                                            <i class="fas fa-users fa-3x mb-3 d-block"></i>
                                            Không có dữ liệu
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>
                                                <strong><i class="fas fa-user"></i> ${user.username}</strong>
                                            </td>
                                            <td>
                                                <c:if test="${not empty user.email}">
                                                    <i class="fas fa-envelope text-muted"></i> ${user.email}
                                                </c:if>
                                            </td>
                                            <td>${user.fullname}</td>
                                            <td>
                                                <c:if test="${not empty user.phone}">
                                                    <i class="fas fa-phone text-muted"></i> ${user.phone}
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.admin}">
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-user-shield"></i> Admin
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <span class="badge bg-secondary">
                                                                <i class="fas fa-user"></i> User
                                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.active}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check"></i> Hoạt động
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <span class="badge bg-warning text-dark">
                                                                <i class="fas fa-times"></i> Ngưng
                                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/users/edit/${user.username}"
                                                   class="btn btn-sm btn-warning" title="Sửa">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </a>
                                                <button type="button" class="btn btn-sm btn-danger"
                                                        onclick="confirmDelete('${user.username}')" title="Xóa">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Thông tin tổng số -->
                    <c:if test="${not empty users}">
                        <div class="mt-3">
                            <p class="text-muted">
                                <i class="fas fa-info-circle"></i>
                                Tổng số: <strong>${users.size()}</strong> người dùng
                            </p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Form xóa ẩn -->
<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/users/delete">
    <input type="hidden" name="username" id="deleteUsername">
</form>

<script>
    function confirmDelete(username) {
        if (confirm('Bạn có chắc chắn muốn xóa người dùng "' + username + '"?\n\nLưu ý: Thao tác này không thể hoàn tác!')) {
            document.getElementById('deleteUsername').value = username;
            document.getElementById('deleteForm').submit();
        }
    }
</script>