<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container mt-4">

    <h2 class="mb-4">Danh sách Category</h2>

    <c:forEach var="cat" items="${categories}">

        <!-- Category Title -->
        <h3 class="mt-4">
                ${cat.categoryName}
            (<c:out value="${cat.videos.size()}"/>)
        </h3>
        <hr/>

        <div class="row">
            <c:forEach var="v" items="${cat.videos}">
                <div class="col-md-4 mb-4">
                    <div class="card h-100">

                        <img src="${v.poster}" class="card-img-top"/>

                        <div class="card-body">
                            <h5 class="card-title">${v.title}</h5>

                            <p class="mb-1"><strong>Mã video:</strong> ${v.videoId}</p>
                            <p class="mb-1"><strong>Category:</strong> ${cat.categoryName}</p>
                            <p class="mb-1"><strong>Views:</strong> ${v.views}</p>

                            <p>
                                <strong>Share:</strong> ${v.shares != null ? v.shares.size() : 0}
                                &nbsp;&nbsp;
                                <strong>Like:</strong> ${v.favorites != null ? v.favorites.size() : 0}
                            </p>

                            <a href="/videos/${v.videoId}" class="btn btn-primary btn-sm">
                                Xem chi tiết
                            </a>

                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

    </c:forEach>

</div>
