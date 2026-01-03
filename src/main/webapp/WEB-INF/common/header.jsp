<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4">
    <a class="navbar-brand fw-bold" href="<c:url value='/'/>">🎬 My Video Site</a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
        <!-- Left Menu -->
        <ul class="navbar-nav me-auto">
            <li class="nav-item"><a class="nav-link" href="<c:url value='/home'/>">🏠 Home</a></li>
            <li class="nav-item"><a class="nav-link" href="<c:url value='/videos'/>">🎥 Videos</a></li>
            <li class="nav-item"><a class="nav-link" href="<c:url value='/categories'/>">📂 Categories</a></li>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <li class="nav-item"><a class="nav-link" href="<c:url value='/admin/dashboard'/>">⚙ Admin Panel</a></li>
            </c:if>
        </ul>

        <!-- Right User Info -->
        <ul class="navbar-nav">
            <c:choose>
                <c:when test="${not empty sessionScope.username}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-white" href="#" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            👤 ${sessionScope.username}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="<c:url value='/profile'/>">Thông tin cá nhân</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="<c:url value='/logout'/>">🚪 Đăng xuất</a></li>
                        </ul>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="nav-item"><a class="btn btn-light" href="<c:url value='/login'/>">🔐 Đăng nhập</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

