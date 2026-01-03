# Windows PowerShell Run Script
# Wrapper for Python automation script

Write-Host "Starting Bandacsan Project..." -ForegroundColor Cyan

# Check if Python is available
if (Get-Command "python" -ErrorAction SilentlyContinue) {
    python run.py
} elseif (Get-Command "python3" -ErrorAction SilentlyContinue) {
    python3 run.py
} else {
    Write-Error "Python is not installed or not in PATH. Please install Python to run the automation script."
    Write-Host "Fallback: Attempting to run with Maven wrapper..." -ForegroundColor Yellow
    .\mvnw.cmd spring-boot:run
}
