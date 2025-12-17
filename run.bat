@echo off
echo ============================================
echo   STEEL OS - AI Assistant Launcher
echo ============================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH.
    echo Please install Python 3.10+ from python.org
    pause
    exit /b 1
)

REM Check if .env exists
if not exist ".env" (
    echo [WARNING] .env file not found!
    echo Please copy .env.example to .env and add your GEMINI_API_KEY.
    pause
)

REM Navigate to app directory and run
cd app
echo [INFO] Starting Steel OS...
python main.py

pause
