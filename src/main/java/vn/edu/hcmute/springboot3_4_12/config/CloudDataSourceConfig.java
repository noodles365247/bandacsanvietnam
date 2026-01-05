package vn.edu.hcmute.springboot3_4_12.config;

import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.util.StringUtils;

import javax.sql.DataSource;
import java.net.URI;

@Configuration
public class CloudDataSourceConfig {

    @Bean
    @Primary
    @ConfigurationProperties("spring.datasource.hikari")
    public DataSource dataSource(DataSourceProperties properties, 
                                 @Value("${MYSQL_URL:}") String mysqlUrl,
                                 @Value("${DATABASE_URL:}") String databaseUrl) {
        
        String urlToUse = mysqlUrl;
        if (!StringUtils.hasText(urlToUse)) {
            urlToUse = databaseUrl;
        }

        if (StringUtils.hasText(urlToUse)) {
            String maskedUrl = urlToUse.replaceAll(":[^:@]+@", ":******@");
            System.out.println("CloudDataSourceConfig: Found DB URL env var: " + maskedUrl);
        } else {
            System.out.println("CloudDataSourceConfig: No MYSQL_URL or DATABASE_URL found. Checking properties...");
        }

        HikariDataSource ds;
        // Check if URL is present and starts with mysql:// (typical for Railway/Cloud)
        if (StringUtils.hasText(urlToUse) && urlToUse.startsWith("mysql://")) {
            try {
                URI uri = URI.create(urlToUse);
                String host = uri.getHost();
                int port = uri.getPort();
                String path = uri.getPath(); // e.g., /railway
                String userInfo = uri.getUserInfo();
                
                String username = null;
                String password = null;
                if (userInfo != null) {
                    String[] parts = userInfo.split(":");
                    username = parts[0];
                    if (parts.length > 1) {
                        password = parts[1];
                    }
                }

                // Check for internal Railway URL usage on non-Railway platforms
                if (host != null && host.endsWith(".railway.internal")) {
                    String errorMsg = """
                        
                        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        CRITICAL ERROR: You are using an internal Railway URL (%s)
                        This URL is NOT accessible from outside Railway (e.g., Render, Localhost).
                        Please update your MYSQL_URL environment variable to use the PUBLIC URL.
                        It usually looks like: mysql://root:password@roundhouse.proxy.rlwy.net:PORT/railway
                        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        """.formatted(host);
                    System.err.println(errorMsg);
                    throw new RuntimeException(errorMsg);
                }

                // Construct JDBC URL
                String jdbcUrl = "jdbc:mysql://" + host + ":" + port + path + 
                                 "?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
                
                // Build DataSource using Builder pattern to ensure Driver is set BEFORE build()
                // This prevents "Failed to determine a suitable driver class" error
                ds = properties.initializeDataSourceBuilder().type(HikariDataSource.class)
                        .driverClassName("com.mysql.cj.jdbc.Driver")
                        .url(jdbcUrl)
                        .username(username)
                        .password(password)
                        .build();
                
                System.out.println("Configured DataSource from URL: " + jdbcUrl);
                
            } catch (Exception e) {
                System.err.println("Failed to parse DB URL, falling back to default: " + e.getMessage());
                ds = properties.initializeDataSourceBuilder().type(HikariDataSource.class).build();
            }
        } else {
            // Standard behavior using application.properties
            System.out.println("CloudDataSourceConfig: Falling back to application.properties/spring.datasource.*");
            try {
                ds = properties.initializeDataSourceBuilder().type(HikariDataSource.class).build();
            } catch (Exception e) {
                 System.err.println("CRITICAL: Failed to configure DataSource from properties. " +
                        "Ensure 'spring.datasource.url' is set in application.properties OR 'MYSQL_URL' env var is provided.");
                 throw e;
            }
        }
        return ds;
    }
}
