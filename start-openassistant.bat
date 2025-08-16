@echo off
cls
echo ========================================
echo     Open-Assistant Offline Starter
echo ========================================
echo.

REM Pruefen ob Docker installiert ist
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ FEHLER: Docker ist nicht installiert oder nicht im PATH!
    echo.
    echo Bitte installieren Sie Docker Desktop von:
    echo https://www.docker.com/products/docker-desktop/
    echo.
    pause
    exit /b 1
)

REM Pruefen ob Docker laeuft
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ FEHLER: Docker ist nicht gestartet!
    echo.
    echo Bitte starten Sie Docker Desktop und versuchen Sie es erneut.
    echo.
    pause
    exit /b 1
)

echo ✅ Docker gefunden und läuft!
echo.

REM Pruefen ob docker-compose.yaml existiert
if not exist "docker-compose.yaml" (
    echo ❌ FEHLER: docker-compose.yaml nicht gefunden!
    echo.
    echo Bitte stellen Sie sicher, dass diese Datei im
    echo Open-Assistant-main Ordner liegt.
    echo.
    pause
    exit /b 1
)

echo ✅ docker-compose.yaml gefunden!
echo.

REM Benutzer fragen welchen Modus sie wollen
echo Welchen Modus möchten Sie starten?
echo.
echo 1) Nur Web-Interface (Datensammlung)
echo 2) Vollständig mit AI-Chat (Inference)  
echo 3) Entwicklermodus (Backend only)
echo 4) Beenden
echo.
set /p choice="Ihre Wahl (1-4): "

if "%choice%"=="1" goto webonly
if "%choice%"=="2" goto fullai
if "%choice%"=="3" goto devmode  
if "%choice%"=="4" goto end
goto invalid

:webonly
echo.
echo 🚀 Starte Web-Interface (Datensammlung)...
echo 📋 Das kann beim ersten Mal 10-15 Minuten dauern...
echo.
echo Drücken Sie Ctrl+C um zu stoppen.
echo.
docker compose --profile ci up --build --attach-dependencies
goto end

:fullai
echo.
echo 🚀 Starte vollständiges System mit AI-Chat...
echo 📋 Das kann beim ersten Mal 15-30 Minuten dauern...
echo 💾 Benötigt viel RAM und Speicherplatz!
echo.
echo Drücken Sie Ctrl+C um zu stoppen.
echo.
docker compose --profile inference --profile frontend-dev up --build --attach-dependencies
goto end

:devmode
echo.
echo 🚀 Starte Entwicklermodus (Backend only)...
echo 📋 Das kann beim ersten Mal 5-10 Minuten dauern...
echo.
echo Drücken Sie Ctrl+C um zu stoppen.
echo.
docker compose --profile backend-dev up --build --attach-dependencies
goto end

:invalid
echo.
echo ❌ Ungültige Auswahl! Bitte wählen Sie 1-4.
echo.
pause
goto start

:end
echo.
echo 🏁 Script beendet.
echo.
echo Nützliche Links nach dem Start:
echo 🌐 Web-Interface: http://localhost:3000
echo 🔧 API Docs: http://localhost:8080/docs
echo 🗃️  Datenbank: http://localhost:8089
echo 📧 Email Debug: http://localhost:1080
echo.
echo Um alle Container zu stoppen, führen Sie aus:
echo docker compose down
echo.
pause