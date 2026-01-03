<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Đặc sản quê hương</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .error-container {
            max-width: 600px;
            width: 100%;
            padding: 20px;
        }
        .error-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            text-align: center;
            padding: 60px 40px;
        }
        .error-icon {
            font-size: 120px;
            color: #e74c3c;
            margin-bottom: 30px;
        }
        .error-code {
            font-size: 72px;
            font-weight: 700;
            color: #2c3e50;
            margin: 20px 0;
        }
        .error-message {
            font-size: 24px;
            color: #7f8c8d;
            margin-bottom: 30px;
        }
        .error-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 30px 0;
            text-align: left;
        }
        .error-details p {
            margin: 10px 0;
            color: #555;
        }
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            color: white;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <div class="error-icon">
                <i class="bi bi-exclamation-triangle"></i>
            </div>
            <div class="error-code">${status != null ? status : '500'}</div>
            <div class="error-message">
                ${error != null ? error : 'Có lỗi xảy ra'}
            </div>
            
            <c:if test="${not empty exception}">
                <div class="text-start bg-light p-3 mb-3 overflow-auto" style="max-height: 200px; font-size: 0.8rem;">
                    <pre>${exception}</pre>
                </div>
            </c:if>

            <c:if test="${not empty message || not empty path}">
                <div class="error-details">
                    <c:if test="${not empty message}">
                        <p><strong>Chi tiết:</strong> ${message}</p>
                    </c:if>
                    <c:if test="${not empty path}">
                        <p><strong>Đường dẫn:</strong> ${path}</p>
                    </c:if>
                </div>
            </c:if>
            
            <a href="<c:url value='/'/>" class="btn-home">
                <i class="bi bi-house"></i> Về trang chủ
            </a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
