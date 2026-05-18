@echo off
chcp 65001 >nul
title Installation GIMAO

:: Verification Docker
docker info >nul 2>&1
if errorlevel 1 (
    echo  ERREUR : Docker Desktop n'est pas lance.
    echo  Lance Docker Desktop, attends que l'icone baleine soit stable,
    echo  puis double-clique a nouveau sur ce fichier.
    pause
    exit /b 1
)

echo  [1/4] Creation du fichier de configuration...
(
echo MYSQL_ROOT_PASSWORD=rootpass123
echo MYSQL_DATABASE=gimao
echo MYSQL_USER=gimao_user
echo MYSQL_PASSWORD=gimao_pass123
echo SECRET_KEY=django-insecure-tp-gimao-2026-xK8mP3qL9nR7vW2jH5tY1uA4sD6fG0cE
echo DJANGO_SUPERUSER_USERNAME=admin
echo DJANGO_SUPERUSER_PASSWORD=Admin1234!
echo DJANGO_SUPERUSER_EMAIL=admin@gimao.fr
) > .env.prod
copy .env.prod .env >nul

echo  [2/4] Telechargement des images
docker compose -f docker-compose.prod.yml pull
if errorlevel 1 goto erreur

echo.
echo  [3/4] Demarrage de l'application
docker compose -f docker-compose.prod.yml up -d
if errorlevel 1 goto erreur

echo.
echo  [4/4] Initialisation de la base de donnees (merci de patienter)
timeout /t 15 /nobreak >nul
docker compose -f docker-compose.prod.yml exec backend python manage.py migrate
docker compose -f docker-compose.prod.yml exec backend python manage.py init_data
docker compose -f docker-compose.prod.yml exec backend python manage.py seed_tp_data
if errorlevel 1 goto erreur

timeout /t 3 /nobreak >nul
start http://localhost
goto fin

:erreur
echo.
echo  Une erreur s'est produite. Contactez l'equipe GIMAO.
pause
exit /b 1

:fin
echo  L'application est prete sur http://localhost
pause
