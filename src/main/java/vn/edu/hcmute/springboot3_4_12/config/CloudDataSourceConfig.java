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
    public DataSource dataSource(DataSourceProperties properties, @Value("${MYSQL_URL:}") String mysqlUrl) {
        if (StringUtils.hasText(mysqlUrl)) {
            String maskedUrl = mysqlUrl.replaceAll(":[^:@]+@", ":******@");
            System.out.println("CloudDataSourceConfig: Found MYSQL_URL env var: " + maskedUrl);
        } else {
            System.out.println("CloudDataSourceConfig: MYSQL_URL env var is empty or null.");
        }

        HikariDataSource ds;
        // Check if MYSQL_URL is present and starts with mysql:// (typical for Railway/Cloud)
        if (StringUtils.hasText(mysqlUrl) && mysqlUrl.startsWith("mysql://")) {
            try {
                URI uri = URI.create(mysqlUrl);
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
                
                // Build DataSource using default properties but override with parsed values
                ds = properties.initializeDataSourceBuilder().type(HikariDataSource.class).build();
                ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
                ds.setJdbcUrl(jdbcUrl);
                if (username != null) ds.setUsername(username);
                if (password != null) ds.setPassword(password);
                
                System.out.println("Configured DataSource from MYSQL_URL: " + jdbcUrl);
                
            } catch (Exception e) {
                System.err.println("Failed to parse MYSQL_URL, falling back to default: " + e.getMessage());
                ds = properties.initializeDataSourceBuilder().type(HikariDataSource.class).build();
            }
        } else {
            // Standard behavior using application.properties
            ds = properties.initializeDataSourceBuilder().type(HikariDataSource.class).build();
        }
        return ds;
    }
}
