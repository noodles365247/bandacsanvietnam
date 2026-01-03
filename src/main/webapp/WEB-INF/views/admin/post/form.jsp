<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="container-fluid py-4">
    <h3 class="mb-3">${post.id != null ? 'Cập nhật' : 'Thêm mới'} bài viết</h3>
    
    <form:form modelAttribute="post" action="${pageContext.request.contextPath}/admin/posts/save" method="post" enctype="multipart/form-data">
        <form:hidden path="id"/>
        
        <div class="mb-3">
            <label>Tiêu đề</label>
            <form:input path="title" cssClass="form-control" required="true"/>
        </div>

        <div class="mb-3">
            <label>Hình ảnh</label>
            <input type="file" name="imageFile" class="form-control" accept="image/*"/>
            <c:if test="${not empty post.image}">
                <div class="mt-2">
                    <img src="${pageContext.request.contextPath}/images/${post.image}" alt="Current Image" style="max-height: 150px;" class="img-thumbnail">
                </div>
            </c:if>
        </div>

        <div class="mb-3">
            <label>Mô tả ngắn</label>
            <form:textarea path="description" cssClass="form-control" rows="3"/>
        </div>
        
        <div class="mb-3">
            <label>Nội dung</label>
            <form:textarea path="content" cssClass="form-control" rows="10"/>
        </div>
        
        <button type="submit" class="btn btn-primary">Lưu</button>
        <a href="${pageContext.request.contextPath}/admin/posts" class="btn btn-secondary">Hủy</a>
    </form:form>
</div>
