@echo off
rem Scrap & Sparks: stop the game (Windows). Your progress and your n8n stay saved.
cd /d "%~dp0"
docker compose stop
echo.
echo   The game is stopped. Double-click start.bat to play again.
ping -n 11 127.0.0.1 >nul
