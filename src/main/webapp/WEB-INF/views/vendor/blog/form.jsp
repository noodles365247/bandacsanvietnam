<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid py-4">
    <h3 class="mb-3">${post.id != null ? 'Cập nhật' : 'Thêm mới'} bài viết</h3>
    
    <div class="card shadow mb-4">
        <div class="card-body">
            <form:form modelAttribute="post" action="${pageContext.request.contextPath}/vendor/blogs/save" method="post" enctype="multipart/form-data">
                <form:hidden path="id"/>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Tiêu đề</label>
                    <form:input path="title" cssClass="form-control" required="true"/>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Hình ảnh đại diện</label>
                    <input type="file" name="imageFile" class="form-control" accept="image/*"/>
                    <c:if test="${not empty post.image}">
                        <div class="mt-2">
                            <img src="${pageContext.request.contextPath}/images/${post.image}" alt="Current Image" style="max-height: 150px;" class="img-thumbnail">
                        </div>
                    </c:if>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Mô tả ngắn</label>
                    <form:textarea path="description" cssClass="form-control" rows="3"/>
                    <small class="text-muted">Hiển thị trên danh sách bài viết.</small>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Nội dung chi tiết</label>
                    <form:textarea path="content" cssClass="form-control" rows="15"/>
                </div>
                
                <button type="submit" class="btn btn-primary">Lưu bài viết</button>
                <a href="${pageContext.request.contextPath}/vendor/blogs" class="btn btn-secondary">Hủy bỏ</a>
            </form:form>
        </div>
    </div>
</div>
