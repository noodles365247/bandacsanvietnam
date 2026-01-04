<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">
<head>
        <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><sitemesh:write property='title'/></title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <sitemesh:write property='head'/>
    <style>
        html, body {
            height: 100%;
            margin: 0;
        }
        body {
            display: flex;
            flex-direction: column;
        }
        main {
            flex: 1 0 auto;
        }
        footer {
            flex-shrink: 0;
        }
    </style>
</head>
<body>
<!-- Header -->
<header class="bg-light py-3 mb-4 border-bottom">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <h5>Thông tin sinh viên</h5>
            <p class="mb-0"> MSSV: 21144449</p>
        </div>
        <div>
            <nav>
                <a href="<c:url value='/'/>" class="btn btn-outline-primary">Trang chủ</a>
                <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary">Admin</a>
            </nav>
        </div>
    </div>
</header>

<!-- Main content -->
<main class="container mb-5">
    <sitemesh:write property='body'/>
</main>

<!-- Footer -->
<footer class="bg-dark text-white py-3">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            &copy; <%= java.time.Year.now() %> Bài tập: Quản lý Video
        </div>
        <div>
            <a class="text-white" href="https://github.com" target="_blank">
                GitHub Repo bài tập
            </a>
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>