<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container mt-4">
    <h2>Vendor - Danh sách sản phẩm</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Giá</th>
            <th>Tồn kho</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.id}</td>
                <td>${p.nameVi}</td>
                <td>${p.price}</td>
                <td>${p.stock}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
