package vn.edu.hcmute.springboot3_4_12.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DbConnectionResult implements Serializable {
    private boolean success;
    private String message;
    private String databaseProductName;
    private String databaseProductVersion;
    private String driverName;
    private String driverVersion;
    private String url; // Masked URL
    private long latencyMs;
    private String timestamp;
}
