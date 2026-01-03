<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<table class="table table-bordered">
  <thead>
  <tr>
    <th>ID</th>
    <th>Tiêu đề</th>
    <th>Poster</th>
    <th>Lượt xem</th>
    <th>Active</th>
    <th>Chức năng</th>
  </tr>
  </thead>

  <tbody>
  <c:forEach var="v" items="${videos}">
    <tr>
      <td>${v.id}</td>
      <td>${v.title}</td>
      <td>
          <img src="${v.poster}" alt="" style="height: 50px;">
      </td>
      <td>${v.views}</td>
      <td>${v.active}</td>

      <td>
        <a href="/admin/videos/edit/${v.id}" class="btn btn-warning btn-sm">Sửa</a>
        <a href="/admin/videos/delete/${v.id}" class="btn btn-danger btn-sm"
           onclick="return confirm('Xóa video?')">Xóa</a>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<!-- PHÂN TRANG -->
<nav>
  <ul class="pagination">
    <c:forEach var="i" begin="0" end="${totalPages - 1}">
      <li class="page-item ${i == page ? 'active' : ''}">
        <a class="page-link" href="?page=${i}">${i + 1}</a>
      </li>
    </c:forEach>
  </ul>
</nav>

<a href="/admin/videos/create" class="btn btn-primary">Thêm Video</a>
