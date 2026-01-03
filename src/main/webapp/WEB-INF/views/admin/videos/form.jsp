<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<form action="" method="post">

    <div class="mb-3">
        <label>Video ID</label>
        <input type="text" name="videoId" class="form-control" value="${video.videoId}" required/>
    </div>

    <div class="mb-3">
        <label>Tiêu đề</label>
        <input type="text" name="title" class="form-control" value="${video.title}"/>
    </div>

    <div class="mb-3">
        <label>Poster</label>
        <input type="text" name="poster" class="form-control" value="${video.poster}"/>
    </div>

    <div class="mb-3">
        <label>Lượt xem</label>
        <input type="number" name="views" class="form-control" value="${video.views}"/>
    </div>

    <div class="mb-3">
        <label>Mô tả</label>
        <textarea name="description" class="form-control">${video.description}</textarea>
    </div>

    <div class="mb-3">
        <label>Trạng thái</label>
        <select name="active" class="form-control">
            <option value="true" ${video.active ? 'selected' : ''}>Active</option>
            <option value="false" ${!video.active ? 'selected' : ''}>Inactive</option>
        </select>
    </div>

    <div class="mb-3">
        <label>Danh mục</label>
        <select name="category" class="form-control">
            <c:forEach var="c" items="${categories}">
                <option value="${c.categoryId}"
                    ${c.categoryId == video.category.categoryId ? 'selected' : ''}>
                        ${c.categoryName}
                </option>
            </c:forEach>
        </select>
    </div>

    <button class="btn btn-success">Lưu</button>
    <a href="/admin/videos" class="btn btn-secondary">Quay lại</a>

</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
