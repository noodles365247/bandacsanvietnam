<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container mt-4">
    <h2>Admin - Danh sách sản phẩm</h2>
    <a href="/admin/products/create" class="btn btn-primary mb-3">Thêm sản phẩm</a>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Giá</th>
            <th>Tồn kho</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.id}</td>
                <td>${p.nameVi}</td>
                <td>${p.price}</td>
                <td>${p.stock}</td>
                <td>
                    <a href="/admin/products/${p.id}/edit" class="btn btn-sm btn-secondary">Sửa</a>
                    <a href="/admin/products/${p.id}/delete" class="btn btn-sm btn-danger">Xóa</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
