@echo off
rem Scrap & Sparks: start everything and open the game (Windows).
rem Double-click this file. The first time it also creates the .env file and downloads
rem n8n and the game (about 4 GB), which takes a while.
rem Waits use "ping -n N 127.0.0.1" (about N-1 seconds): "timeout" fails when there is no console window.
rem "start.bat /quiet" (used by the installer's shortcut, which shows no window) never pauses at the end.
setlocal EnableExtensions
cd /d "%~dp0"
title Scrap ^& Sparks
set "QUIET="
if /i "%~1"=="/quiet" set "QUIET=1"

echo.
echo   Scrap ^& Sparks
echo   ---------------
echo.

rem ---- 1. Is Docker installed? ----
rem Docker Desktop installs for all users (Program Files) or for one user (AppData, what the
rem installer does). Right after it is installed, this window may not know its folder yet: add it.
set "DD_ALL=%ProgramFiles%\Docker\Docker"
set "DD_USER=%LOCALAPPDATA%\Programs\DockerDesktop"
where docker >nul 2>nul
if not errorlevel 1 goto docker_installed
if exist "%DD_USER%\resources\bin\docker.exe" set "PATH=%DD_USER%\resources\bin;%PATH%"
if exist "%DD_ALL%\resources\bin\docker.exe" set "PATH=%DD_ALL%\resources\bin;%PATH%"
where docker >nul 2>nul
if not errorlevel 1 goto docker_installed
echo   Docker Desktop is not installed yet.
echo   The install page opens now. Install it, restart your computer,
echo   then double-click start.bat again.
start "" "https://docs.docker.com/desktop/setup/install/windows-install/"
goto fail

:docker_installed
rem ---- 2. Is Docker running? If not, start Docker Desktop and wait (up to 5 minutes). ----
docker info >nul 2>nul
if not errorlevel 1 goto docker_ok
echo   Starting Docker Desktop (this can take a minute)...
echo   The first time, Docker Desktop shows its agreement: read it and click Accept.
echo   You do not need a Docker account: you can skip signing in.
if exist "%DD_USER%\Docker Desktop.exe" (
  start "" "%DD_USER%\Docker Desktop.exe"
) else if exist "%DD_ALL%\Docker Desktop.exe" (
  start "" "%DD_ALL%\Docker Desktop.exe"
)
set /a tries=0
:wait_docker
ping -n 4 127.0.0.1 >nul
docker info >nul 2>nul
if not errorlevel 1 goto docker_ok
set /a tries+=1
if %tries% lss 100 goto wait_docker
echo   Docker Desktop did not start.
echo   Open Docker Desktop yourself, wait until it says "Engine running",
echo   then double-click start.bat again.
goto fail

:docker_ok
rem ---- 3. First time only: create .env (a random secret and your timezone) ----
if exist ".env" goto env_ok
set "TOKEN="
for /f "usebackq delims=" %%t in (`powershell -NoProfile -Command "[guid]::NewGuid().ToString('N') + [guid]::NewGuid().ToString('N')"`) do set "TOKEN=%%t"
if not defined TOKEN (
  echo   Could not create a random secret for the .env file.
  goto fail
)
set "TZNAME=Europe/Brussels"
for /f "usebackq delims=" %%z in (`powershell -NoProfile -Command "try { [Windows.Globalization.Calendar,Windows.Globalization,ContentType=WindowsRuntime]::new().GetTimeZone() } catch { 'Europe/Brussels' }"`) do set "TZNAME=%%z"
(
  echo # Created by start.bat. Keep this file private.
  echo N8N_RUNNERS_AUTH_TOKEN=%TOKEN%
  echo GENERIC_TIMEZONE=%TZNAME%
) > ".env"
echo   Created .env (timezone %TZNAME%).

:env_ok
set "PORT=8765"
for /f "usebackq eol=# tokens=1,* delims==" %%a in (".env") do if /i "%%a"=="COMPANION_PORT" set "PORT=%%b"
rem A port set in the shell wins, as it does for Docker Compose.
if defined COMPANION_PORT set "PORT=%COMPANION_PORT%"

rem ---- 4. Start n8n, its task runner and the companion ----
echo   Starting the game. The first time, Docker downloads about 4 GB: please wait...
docker compose up -d
if errorlevel 1 (
  echo.
  echo   Docker could not start the game. Read the message above.
  echo   A common cause: another program already uses port 5678, 8765 or 5688.
  goto fail
)

rem ---- 5. Wait until the game answers (up to 2 minutes), then open it ----
set /a tries=0
:wait_game
curl -sf -o nul "http://localhost:%PORT%/" >nul 2>nul
if not errorlevel 1 goto game_ok
set /a tries+=1
if %tries% geq 60 goto game_slow
ping -n 3 127.0.0.1 >nul
goto wait_game

:game_slow
echo   The game is taking long to start. Try opening http://localhost:%PORT% in your browser.
goto done

:game_ok
start "" "http://localhost:%PORT%/"
echo.
echo   The game is open in your browser: http://localhost:%PORT%
echo   To stop it later, double-click stop.bat. Your progress and your n8n stay saved.

:done
if defined QUIET exit /b 0
echo.
echo   You can close this window.
ping -n 16 127.0.0.1 >nul
exit /b 0

:fail
if defined QUIET exit /b 1
echo.
pause
exit /b 1
