<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid py-4">
    <h3 class="mb-3">Quản lý bài viết</h3>
    <a href="${pageContext.request.contextPath}/admin/posts/create" class="btn btn-primary mb-3">Thêm bài viết</a>
    
    <table class="table table-bordered">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Hình ảnh</th>
                <th>Tiêu đề</th>
                <th>Ngày tạo</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="post" items="${posts}">
                <tr>
                    <td>${post.id}</td>
                    <td>
                        <c:if test="${not empty post.image}">
                            <img src="${pageContext.request.contextPath}/images/${post.image}" alt="Post Image" style="width: 80px; height: 50px; object-fit: cover;">
                        </c:if>
                    </td>
                    <td>${post.title}</td>
                    <td>${post.createdAt}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/posts/edit/${post.id}" class="btn btn-warning btn-sm">Sửa</a>
                        <form action="${pageContext.request.contextPath}/admin/posts/delete" method="post" class="d-inline" onsubmit="return confirm('Xóa bài viết?');">
                            <input type="hidden" name="id" value="${post.id}">
                            <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
