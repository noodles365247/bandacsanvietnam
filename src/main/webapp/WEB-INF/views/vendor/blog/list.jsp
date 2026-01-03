<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid py-4">
    <h3 class="mb-3">Quản lý bài viết (Blog)</h3>
    <a href="${pageContext.request.contextPath}/vendor/blogs/create" class="btn btn-primary mb-3">Thêm bài viết mới</a>
    
    <div class="card shadow mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
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
                                <td>
                                    <fmt:parseDate value="${post.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/vendor/blogs/edit/${post.id}" class="btn btn-warning btn-sm">Sửa</a>
                                    <form action="${pageContext.request.contextPath}/vendor/blogs/delete" method="post" class="d-inline" onsubmit="return confirm('Xóa bài viết này?');">
                                        <input type="hidden" name="id" value="${post.id}">
                                        <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
