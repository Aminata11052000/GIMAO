@echo off
chcp 65001 >nul
title Mise à jour GIMAO

echo.
echo  ╔══════════════════════════════════════════╗
echo  ║         MISE À JOUR GIMAO                ║
echo  ╚══════════════════════════════════════════╝
echo.

docker info >nul 2>&1
if errorlevel 1 (
    echo  ERREUR : Docker Desktop n'est pas lancé.
    pause
    exit /b 1
)

echo  Téléchargement de la nouvelle version...
docker compose -f docker-compose.prod.yml pull

echo.
echo  Redémarrage de l'application...
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d

echo.
echo  ╔══════════════════════════════════════════╗
echo  ║       MISE À JOUR TERMINÉE !             ║
echo  ╚══════════════════════════════════════════╝
echo.
timeout /t 3 /nobreak >nul
start http://localhost
pause
