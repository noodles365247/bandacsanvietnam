<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="container-fluid py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header bg-warning text-dark">
                    <h3 class="mb-0">
                        <i class="fas fa-user-edit"></i> Chỉnh sửa Người dùng
                    </h3>
                </div>
                <div class="card-body">
                    <form:form method="post"
                               action="${pageContext.request.contextPath}/admin/users/save"
                               modelAttribute="user">

                        <!-- Username readonly -->
                        <div class="mb-3">
                            <label for="username" class="form-label">
                                <i class="fas fa-user"></i> Username
                            </label>
                            <form:input path="username"
                                        class="form-control"
                                        id="username"
                                        readonly="true"/>
                            <small class="form-text text-muted">
                                Username không thể thay đổi
                            </small>
                        </div>

                        <div class="row">
                            <!-- Password -->
                            <div class="col-md-12 mb-3">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock"></i> Mật khẩu mới
                                </label>
                                <form:password path="password"
                                               class="form-control"
                                               id="password"
                                               placeholder="Để trống nếu không đổi mật khẩu"/>
                                <small class="form-text text-muted">
                                    Chỉ nhập nếu muốn thay đổi mật khẩu (tối thiểu 6 ký tự)
                                </small>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Fullname -->
                            <div class="col-md-6 mb-3">
                                <label for="fullname" class="form-label">
                                    <i class="fas fa-id-card"></i> Họ và tên <span class="text-danger">*</span>
                                </label>
                                <form:input path="fullname"
                                            class="form-control"
                                            id="fullname"
                                            placeholder="Nhập họ và tên"
                                            required="true"/>
                            </div>

                            <!-- Email -->
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">
                                    <i class="fas fa-envelope"></i> Email <span class="text-danger">*</span>
                                </label>
                                <form:input path="email"
                                            type="email"
                                            class="form-control"
                                            id="email"
                                            placeholder="example@email.com"
                                            required="true"/>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Phone -->
                            <div class="col-md-6 mb-3">
                                <label for="phone" class="form-label">
                                    <i class="fas fa-phone"></i> Số điện thoại
                                </label>
                                <form:input path="phone"
                                            class="form-control"
                                            id="phone"
                                            placeholder="0987654321"/>
                            </div>

                            <!-- Images -->
                            <div class="col-md-6 mb-3">
                                <label for="images" class="form-label">
                                    <i class="fas fa-image"></i> URL Ảnh đại diện
                                </label>
                                <form:input path="images"
                                            class="form-control"
                                            id="images"
                                            placeholder="https://example.com/avatar.jpg"/>
                            </div>
                        </div>

                        <!-- Preview avatar -->
                        <c:if test="${not empty user.images}">
                            <div class="mb-3 text-center">
                                <label class="form-label d-block">
                                    <i class="fas fa-user-circle"></i> Ảnh đại diện hiện tại:
                                </label>
                                <img src="${user.images}"
                                     class="rounded-circle border border-3 border-primary"
                                     style="width: 120px; height: 120px; object-fit: cover;"
                                     alt="Avatar">
                            </div>
                        </c:if>

                        <!-- Checkboxes -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="admin"
                                                           class="form-check-input"
                                                           id="admin"/>
                                            <label class="form-check-label" for="admin">
                                                <i class="fas fa-user-shield text-danger"></i>
                                                <strong>Quyền Admin</strong>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <div class="form-check form-switch">
                                            <form:checkbox path="active"
                                                           class="form-check-input"
                                                           id="active"/>
                                            <label class="form-check-label" for="active">
                                                <i class="fas fa-check-circle text-success"></i>
                                                <strong>Tài khoản hoạt động</strong>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Info card -->
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>
                            <strong>Lưu ý:</strong>
                            <ul class="mb-0 mt-2">
                                <li>Username không thể thay đổi</li>
                                <li>Chỉ nhập mật khẩu mới nếu muốn thay đổi</li>
                                <li>Nếu tắt trạng thái hoạt động, người dùng sẽ không thể đăng nhập</li>
                            </ul>
                        </div>

                        <hr>

                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/admin/users"
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                            <div>
                                <button type="button" class="btn btn-danger me-2"
                                        onclick="confirmDelete('${user.username}')">
                                    <i class="fas fa-trash"></i> Xóa người dùng
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
<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/users/delete">
    <input type="hidden" name="username" id="deleteUsername">
</form>

<script>
    function confirmDelete(username) {
        if (confirm('Bạn có chắc chắn muốn xóa người dùng "' + username + '"?\n\nLưu ý: Thao tác này không thể hoàn tác và sẽ xóa tất cả dữ liệu liên quan!')) {
            document.getElementById('deleteUsername').value = username;
            document.getElementById('deleteForm').submit();
        }
    }

    // Validate password length if entered
    document.getElementById('password').addEventListener('input', function() {
        if (this.value.length > 0 && this.value.length < 6) {
            this.setCustomValidity('Mật khẩu phải có ít nhất 6 ký tự');
        } else {
            this.setCustomValidity('');
        }
    });

    // Preview image when URL changes
    document.getElementById('images').addEventListener('change', function() {
        const url = this.value;
        if (url) {
            // You can add image preview logic here if needed
            console.log('Image URL updated:', url);
        }
    });
</script>