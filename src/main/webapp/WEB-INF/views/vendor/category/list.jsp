<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container mt-4">
    <h2>Vendor - Danh sách danh mục</h2>
    <ul class="list-group">
        <c:forEach var="c" items="${categories}">
            <li class="list-group-item">${c.nameVi}</li>
        </c:forEach>
    </ul>
</div>
