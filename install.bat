@echo off
chcp 65001 >nul
title Installation GIMAO

:: Vérification Docker
docker info >nul 2>&1
if errorlevel 1 (
    echo  ERREUR : Docker Desktop n'est pas lancé.
    echo  Lance Docker Desktop, attends que l'icône baleine soit stable,
    echo  puis double-clique à nouveau sur ce fichier.
    pause
    exit /b 1
)

echo  [1/4] Téléchargement des images
docker compose -f docker-compose.prod.yml pull
if errorlevel 1 goto erreur

echo.
echo  [2/4] Démarrage de l'application
docker compose -f docker-compose.prod.yml up -d
if errorlevel 1 goto erreur

echo.
echo  [3/4] Initialisation de la base de données (merci de patienter)
timeout /t 15 /nobreak >nul
docker compose -f docker-compose.prod.yml exec backend python manage.py migrate tasks --fake
docker compose -f docker-compose.prod.yml exec backend python manage.py migrate
docker compose -f docker-compose.prod.yml exec backend python manage.py init_data
if errorlevel 1 goto erreur

echo.
echo  [4/4] Chargement des données de démonstration
docker compose -f docker-compose.prod.yml exec backend python manage.py seed_tp_data
if errorlevel 1 goto erreur


timeout /t 3 /nobreak >nul
start http://localhost
goto fin

:erreur
echo.
echo  Une erreur s'est produite. Contactez l'équipe GIMAO.
pause
exit /b 1

:fin
echo  L'application est prête sur http://localhost
pause
