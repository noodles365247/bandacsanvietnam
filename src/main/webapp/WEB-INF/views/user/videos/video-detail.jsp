<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container mt-4">

    <div class="row">
        <!-- Poster -->
        <div class="col-md-4">
            <img src="${video.poster}" alt="Poster" class="img-fluid rounded border"/>
        </div>

        <!-- Video Info -->
        <div class="col-md-8">

            <h2 class="mb-3">${video.title}</h2>

            <p><strong>Mã video:</strong> ${video.videoId}</p>
            <p><strong>Category name:</strong> ${video.category.categoryName}</p>
            <p><strong>Views:</strong> ${video.views}</p>

            <p>
                <strong>Share:</strong> ${shareCount}
                &nbsp;&nbsp;
                <strong>Like:</strong> ${likeCount}
            </p>

            <p><strong>Description:</strong></p>
            <p>${video.description}</p>

        </div>
    </div>

</div>
