<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Connection Diagnosis</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding-top: 50px;
        }
        .card {
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .status-indicator {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 10px;
        }
        .status-success { background-color: #28a745; }
        .status-fail { background-color: #dc3545; }
        .status-pending { background-color: #ffc107; }
        
        pre {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 5px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">Database Connection Diagnosis</h4>
                    <span class="badge bg-light text-primary">Env: ${pageContext.request.serverName}</span>
                </div>
                <div class="card-body">
                    <p class="text-muted">
                        Công cụ này giúp kiểm tra kết nối từ Server đến Database. 
                        Nó thực hiện query <code>SELECT 1</code> và đo thời gian phản hồi.
                    </p>

                    <div class="d-grid gap-2 mb-4">
                        <button id="btnCheck" class="btn btn-primary btn-lg" onclick="checkConnection()">
                            <span id="spinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                            Kiểm tra Kết nối Ngay
                        </button>
                    </div>

                    <div id="resultArea" class="d-none">
                        <h5 class="border-bottom pb-2">Kết quả Kiểm tra</h5>
                        
                        <div class="alert" id="alertBox" role="alert">
                            <span id="statusIcon" class="status-indicator"></span>
                            <strong id="statusText">Processing...</strong>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered table-striped">
                                <tbody>
                                    <tr>
                                        <th style="width: 30%">Trạng thái</th>
                                        <td id="resSuccess"></td>
                                    </tr>
                                    <tr>
                                        <th>Thời gian (Latency)</th>
                                        <td id="resLatency"></td>
                                    </tr>
                                    <tr>
                                        <th>Database Product</th>
                                        <td id="resProduct"></td>
                                    </tr>
                                    <tr>
                                        <th>Version</th>
                                        <td id="resVersion"></td>
                                    </tr>
                                    <tr>
                                        <th>Driver</th>
                                        <td id="resDriver"></td>
                                    </tr>
                                    <tr>
                                        <th>URL (Masked)</th>
                                        <td id="resUrl" class="text-break"></td>
                                    </tr>
                                    <tr>
                                        <th>Message</th>
                                        <td id="resMessage"></td>
                                    </tr>
                                    <tr>
                                        <th>Timestamp</th>
                                        <td id="resTimestamp"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-muted text-center">
                    <small>Bandacsan System Diagnosis Tool &copy; 2026</small>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function checkConnection() {
        const btn = document.getElementById('btnCheck');
        const spinner = document.getElementById('spinner');
        const resultArea = document.getElementById('resultArea');
        const alertBox = document.getElementById('alertBox');
        
        // UI Reset
        btn.disabled = true;
        spinner.classList.remove('d-none');
        resultArea.classList.add('d-none');

        fetch('<c:url value="/diagnosis/api/check-connection"/>', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            // Show result area
            resultArea.classList.remove('d-none');
            
            // Update Alert Box
            alertBox.className = 'alert ' + (data.success ? 'alert-success' : 'alert-danger');
            document.getElementById('statusIcon').className = 'status-indicator ' + (data.success ? 'status-success' : 'status-fail');
            document.getElementById('statusText').innerText = data.success ? 'Kết nối Thành công' : 'Kết nối Thất bại';

            // Fill Table
            document.getElementById('resSuccess').innerHTML = data.success ? '<span class="badge bg-success">SUCCESS</span>' : '<span class="badge bg-danger">FAILED</span>';
            document.getElementById('resLatency').innerText = data.latencyMs + ' ms';
            document.getElementById('resProduct').innerText = data.databaseProductName || 'N/A';
            document.getElementById('resVersion').innerText = data.databaseProductVersion || 'N/A';
            document.getElementById('resDriver').innerText = (data.driverName || '') + ' ' + (data.driverVersion || '');
            document.getElementById('resUrl').innerText = data.url || 'N/A';
            document.getElementById('resMessage').innerText = data.message;
            document.getElementById('resTimestamp').innerText = data.timestamp;

        })
        .catch(error => {
            console.error('Error:', error);
            resultArea.classList.remove('d-none');
            alertBox.className = 'alert alert-danger';
            document.getElementById('statusText').innerText = 'Lỗi Gọi API: ' + error.message;
            document.getElementById('resMessage').innerText = 'Không thể gọi đến Backend API. Kiểm tra console log.';
        })
        .finally(() => {
            btn.disabled = false;
            spinner.classList.add('d-none');
        });
    }
</script>

</body>
</html>
