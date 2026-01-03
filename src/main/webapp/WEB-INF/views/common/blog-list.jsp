<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <div class="row mb-4">
        <div class="col-12 text-center">
            <h2 class="display-4 fw-bold text-primary">Blog Văn Hóa & Ẩm Thực</h2>
            <p class="lead text-muted">Khám phá câu chuyện đằng sau những món đặc sản.</p>
        </div>
    </div>

    <div class="row g-4">
        <c:forEach var="post" items="${posts}">
            <div class="col-md-4">
                <div class="card h-100 shadow-sm hover-shadow transition-all">
                    <a href="${pageContext.request.contextPath}/blogs/${post.id}" class="text-decoration-none text-dark">
                        <c:choose>
                            <c:when test="${not empty post.image}">
                                <img src="${pageContext.request.contextPath}/images/${post.image}" class="card-img-top" alt="${post.title}" style="height: 200px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/400x200?text=No+Image" class="card-img-top" alt="No Image" style="height: 200px; object-fit: cover;">
                            </c:otherwise>
                        </c:choose>
                        <div class="card-body">
                            <h5 class="card-title fw-bold">${post.title}</h5>
                            <p class="card-text text-muted small">
                                <i class="bi bi-calendar3"></i> 
                                <fmt:parseDate value="${post.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                            </p>
                            <p class="card-text">${post.description}</p>
                        </div>
                        <div class="card-footer bg-white border-top-0">
                            <span class="text-primary fw-bold">Đọc thêm <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<style>
    .hover-shadow:hover {
        transform: translateY(-5px);
        box-shadow: 0 .5rem 1rem rgba(0,0,0,.15)!important;
    }
    .transition-all {
        transition: all 0.3s ease;
    }
</style>
