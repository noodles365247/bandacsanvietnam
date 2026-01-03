package vn.edu.hcmute.springboot3_4_12.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.stream.Collectors;

/**
 * Utility class to test database connection independently of Spring Boot.
 * Run this class's main method to verify your MYSQL_URL or local DB connection.
 */
public class DatabaseConnectionTester {

    public static void main(String[] args) {
        System.out.println("=== Database Connection Tester ===");

        // 0. Load .env.example manually since we are running standalone
        Map<String, String> envVars = loadEnvFile("d:\\desktop\\bandacsan\\.env.example");

        // 1. Try to get from Environment Variable or Loaded Env File
        String mysqlUrl = envVars.getOrDefault("MYSQL_URL", System.getenv("MYSQL_URL"));
        String publicUrl = envVars.getOrDefault("MYSQL_PUBLIC_URL", System.getenv("MYSQL_PUBLIC_URL"));
        
        // Prefer Public URL if available and valid
        if (publicUrl != null && !publicUrl.contains("${{")) {
            mysqlUrl = publicUrl;
        }

        String jdbcUrl = null;
        String user = null;
        String pass = null;

        // Check for placeholders in env vars
        if (mysqlUrl != null && mysqlUrl.contains("${{")) {
            System.err.println("WARNING: MYSQL_URL contains placeholders (" + mysqlUrl + "). Ignoring it.");
            mysqlUrl = null;
        }

        if (mysqlUrl != null && !mysqlUrl.isEmpty()) {
            System.out.println("Found MYSQL_URL: " + mysqlUrl);
            if (mysqlUrl.startsWith("mysql://")) {
                try {
                    URI uri = URI.create(mysqlUrl);
                    String host = uri.getHost();
                    int port = uri.getPort();
                    String path = uri.getPath();
                    String userInfo = uri.getUserInfo();

                    if (host.endsWith(".railway.internal")) {
                        System.err.println("WARNING: Detected internal Railway URL (" + host + ").");
                        System.err.println("This will fail if you are running outside of Railway (e.g. Localhost or Render).");
                    }

                    if (userInfo != null) {
                        String[] parts = userInfo.split(":");
                        user = parts[0];
                        if (parts.length > 1) {
                            pass = parts[1];
                        }
                    }
                    
                    // Handle default port
                    if (port == -1) port = 3306;
                    
                    // Handle missing path
                    if (path == null || path.isEmpty()) path = "/railway";

                    jdbcUrl = "jdbc:mysql://" + host + ":" + port + path + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                } catch (Exception e) {
                    System.err.println("Error parsing MYSQL_URL: " + e.getMessage());
                    return;
                }
            } else {
                jdbcUrl = mysqlUrl;
            }
        } else {
            // 2. Fallback to decomposed vars
            System.out.println("MYSQL_URL not found or invalid. Checking MYSQLUSER, MYSQLPASSWORD, PORT...");
            
            String dbUser = envVars.getOrDefault("MYSQLUSER", System.getenv("MYSQLUSER"));
            String dbPass = envVars.getOrDefault("MYSQL_ROOT_PASSWORD", envVars.getOrDefault("MYSQLPASSWORD", System.getenv("MYSQLPASSWORD"))); // Check ROOT PASS too
            String dbPort = envVars.getOrDefault("MYSQLPORT", System.getenv("MYSQLPORT"));
            String dbHost = envVars.getOrDefault("MYSQLHOST", System.getenv("MYSQLHOST"));
            String dbName = envVars.getOrDefault("MYSQLDATABASE", System.getenv("MYSQLDATABASE"));

            // Check validity
            if (dbHost != null && dbHost.contains("${{")) dbHost = null;
            if (dbPort != null && dbPort.contains("${{")) dbPort = null;
            if (dbUser != null && dbUser.contains("${{")) dbUser = null;
            if (dbPass != null && dbPass.contains("${{")) dbPass = null;
            if (dbName != null && dbName.contains("${{")) dbName = null;

            if (dbHost == null) {
                System.err.println("ERROR: Could not find valid MYSQLHOST or MYSQL_PUBLIC_URL in .env.example");
                return;
            }
            
            if (dbPort == null) dbPort = "3306";
            if (dbUser == null) dbUser = "root";
            if (dbName == null) dbName = "railway";
            
            user = dbUser;
            pass = dbPass;

            jdbcUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        }

        System.out.println("Testing Connection to:");
        System.out.println("URL: " + jdbcUrl);
        System.out.println("User: " + user);
        System.out.println("Pass: " + (pass != null ? "******" : "null"));

        try (Connection conn = DriverManager.getConnection(jdbcUrl, user, pass)) {
            System.out.println("\nSUCCESS! Connection established successfully.");
            System.out.println("Database Product Name: " + conn.getMetaData().getDatabaseProductName());
            System.out.println("Database Product Version: " + conn.getMetaData().getDatabaseProductVersion());

            System.out.println("\nRunning initialization script automatically...");
            runScript(conn);

        } catch (SQLException e) {
            System.err.println("\nFAILURE: Could not connect to database.");
            System.err.println("Error Message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
        } catch (Exception e) {
            System.err.println("\nERROR: Unexpected error.");
            e.printStackTrace();
        }
    }
    
    private static Map<String, String> loadEnvFile(String filePath) {
        Map<String, String> env = new HashMap<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(filePath), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] parts = line.split("=", 2);
                if (parts.length == 2) {
                    String key = parts[0].trim();
                    String value = parts[1].trim();
                    // Remove quotes if present
                    if (value.startsWith("\"") && value.endsWith("\"")) {
                        value = value.substring(1, value.length() - 1);
                    }
                    env.put(key, value);
                }
            }
        } catch (Exception e) {
            System.out.println("Could not load .env file: " + e.getMessage());
        }
        return env;
    }

    private static void runScript(Connection conn) {
        System.out.println("Loading dbdacsan.sql from classpath...");
        try (InputStream inputStream = DatabaseConnectionTester.class.getClassLoader().getResourceAsStream("dbdacsan.sql")) {
            if (inputStream == null) {
                System.err.println("ERROR: Could not find dbdacsan.sql in resources!");
                return;
            }
            
            String script = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))
                    .lines().collect(Collectors.joining("\n"));

            // Remove comments (simple approach) and split by semicolon
            // This is a naive splitter, but works for standard dumps
            String[] statements = script.split(";");
            
            try (Statement stmt = conn.createStatement()) {
                int count = 0;
                for (String sql : statements) {
                    String trimmedSql = sql.trim();
                    if (trimmedSql.isEmpty()) continue;
                    
                    try {
                        stmt.execute(trimmedSql);
                        count++;
                        // if (count % 10 == 0) System.out.print(".");
                        System.out.println("SUCCESS: " + (trimmedSql.length() > 50 ? trimmedSql.substring(0, 50) + "..." : trimmedSql));
                    } catch (SQLException e) {
                        System.err.println("\nError executing statement: " + trimmedSql);
                        System.err.println("Reason: " + e.getMessage());
                        // Continue or break? Let's continue for minor errors, but warn.
                    }
                }
                System.out.println("\nExecuted " + count + " statements successfully.");
                System.out.println("Database initialized!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
