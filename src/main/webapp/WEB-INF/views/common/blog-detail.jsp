<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/blogs">Blog</a></li>
            <li class="breadcrumb-item active" aria-current="page">${post.title}</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <article>
                <header class="mb-4">
                    <h1 class="fw-bolder mb-1">${post.title}</h1>
                    <div class="text-muted fst-italic mb-2">
                        Đăng ngày <fmt:parseDate value="${post.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                        <c:if test="${not empty post.author}">
                            bởi <strong>${post.author}</strong>
                        </c:if>
                    </div>
                </header>

                <c:if test="${not empty post.image}">
                    <figure class="mb-4 text-center">
                        <img class="img-fluid rounded" src="${pageContext.request.contextPath}/images/${post.image}" alt="${post.title}" style="max-height: 500px; width: auto;" />
                    </figure>
                </c:if>

                <section class="mb-5 content-body">
                    ${post.content}
                </section>
            </article>
            
            <hr>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/blogs" class="btn btn-outline-primary"><i class="bi bi-arrow-left"></i> Quay lại danh sách</a>
            </div>
        </div>
    </div>
</div>

<style>
    .content-body img {
        max-width: 100%;
        height: auto;
        border-radius: 5px;
        margin: 10px 0;
    }
</style>
