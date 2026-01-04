package vn.edu.hcmute.springboot3_4_12.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import vn.edu.hcmute.springboot3_4_12.dto.DbConnectionResult;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
@RequestMapping("/diagnosis")
public class DbDiagnosisController {

    @Autowired
    private DataSource dataSource;

    @Value("${app.diagnosis.enabled:false}")
    private boolean isDiagnosisEnabled;

    @GetMapping("/db-test")
    public String showDbTestPage() {
        if (!isDiagnosisEnabled) {
            return "redirect:/"; // Or 403 Page
        }
        // Trả về view JSP đơn giản, không sử dụng layout của SiteMesh (đã exclude trong filter)
        return "diagnosis/db-test";
    }

    @PostMapping("/api/check-connection")
    @ResponseBody
    public ResponseEntity<DbConnectionResult> checkConnection() {
        if (!isDiagnosisEnabled) {
            return ResponseEntity.status(403).body(DbConnectionResult.builder()
                    .success(false)
                    .message("Diagnosis feature is disabled on this environment.")
                    .build());
        }

        DbConnectionResult result = new DbConnectionResult();
        result.setTimestamp(LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));

        long startTime = System.currentTimeMillis();

        try (Connection connection = dataSource.getConnection()) {
            // 1. Measure basic connection time
            
            // 2. Execute simple query
            try (PreparedStatement stmt = connection.prepareStatement("SELECT 1")) {
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // Success
                    }
                }
            }

            long endTime = System.currentTimeMillis();
            result.setLatencyMs(endTime - startTime);
            result.setSuccess(true);
            result.setMessage("Connection successful!");

            // 3. Get Metadata
            DatabaseMetaData metaData = connection.getMetaData();
            result.setDatabaseProductName(metaData.getDatabaseProductName());
            result.setDatabaseProductVersion(metaData.getDatabaseProductVersion());
            result.setDriverName(metaData.getDriverName());
            result.setDriverVersion(metaData.getDriverVersion());
            
            // Mask URL
            String url = metaData.getURL();
            result.setUrl(maskUrl(url));

        } catch (Exception e) {
            long endTime = System.currentTimeMillis();
            result.setLatencyMs(endTime - startTime);
            result.setSuccess(false);
            result.setMessage("Connection failed: " + e.getMessage());
            // Do not expose detailed stack trace or credentials in production response
        }

        return ResponseEntity.ok(result);
    }

    private String maskUrl(String url) {
        if (url == null) return "null";
        // Simple masking logic to hide password if present in URL
        // JDBC URLs often look like jdbc:mysql://host:port/db?user=...&password=...
        // But usually password is in properties. If it is in URL, mask it.
        return url.replaceAll("password=.[^&]*", "password=******")
                  .replaceAll("user=.[^&]*", "user=******");
    }
}
