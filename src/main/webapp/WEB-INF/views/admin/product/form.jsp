<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container mt-4">
    <h2>Admin - Thêm / Sửa sản phẩm</h2>
    <form method="post" action="/admin/products/save" enctype="multipart/form-data">
        <!-- Simple form fields -->
        <div class="mb-3">
            <label class="form-label">Tên (VI)</label>
            <input type="text" name="nameVi" class="form-control" />
        </div>
        <div class="mb-3">
            <label class="form-label">Giá</label>
            <input type="number" name="price" class="form-control" />
        </div>
        <button class="btn btn-primary">Lưu</button>
    </form>
</div>
