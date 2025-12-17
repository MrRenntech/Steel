@echo off
echo ============================================
echo   STEEL OS - Dependency Installer
echo ============================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed.
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [INFO] Installing Python dependencies...
pip install -r requirements.txt

if errorlevel 1 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)

echo.
echo [SUCCESS] All dependencies installed!
echo.
echo Next steps:
echo   1. Copy .env.example to .env
echo   2. Add your GEMINI_API_KEY to .env
echo   3. Run: run.bat
echo.
pause
